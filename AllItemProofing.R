#This program performs a range of content-specific data checks on data exported from
#an educational database, ranging from simple data scrubbing tasks to content
#validity. The final output is a flatlist that identifies the field which needs
#to be changed and a description of the change needed.

#It is also a project to reacquaint myself with R packages, one tiny line of code at a time
#It may contain silly exercises, just for testing out different functions, but
#this code *WILL* be used to QC data.

#To Do
#Load Edmodo items
#Add Edmodo search
#Add remaining items from trello board
#Add date search for edited Progress Check items
#Add date search for passages less than 9 months away from delivery
#Filter passage rights 1&2 to NULL, make sure there is no passage data
#Check passage codes 1&2 for D, R, and 9
#Use current active item list instead of test file


#load libraries     
library(plyr)
library(dplyr)
library(openxlsx)

#Set filenames and change working directory
directory <- "C:/Users/msmith/Documents/2017 Reports/Spring 2017/Pre-Snapshot/Metadata QC/"
setwd(directory) 

#Load allitem report, currently commented out during program creation and testing
currentDelivery <- "AllItemenglish_03222017_11.59.AM.xlsx"

#Instead load custom allItemReport with embedded errors for routine creation
#currentDelivery <- "FAIB-errorExamples.csv"

#Load allpassage report
currentPassageFile <- "AllPassageenglish_03222017_01.18.PM.xlsx"

#Load New item list
newItemFile <- "All Subjects Preliminary Active Item List SP17 3.21.17.xlsx"

#Load retired items from previous release
previouslyRetiredItems <- "Previous Delivery Retired Items.xlsx"

#Load item list from previous release
previousActiveList <- "Previous Delivery Active Items.xlsx"

#Load Edmodo and Progress Check Items to verify deletion or editing
edmodo <- "Edmodo Items.xlsx"
#progressChecks <- "Progress Check Items.xlsx"

#Need to adjust to read xlsx version, remember to tackle stringsAsFactors
currentReport <- read.xlsx(currentDelivery, sheet = 1)
newItems <- read.xlsx(newItemFile, sheet = 1)
currentPassages <- read.xlsx(currentPassageFile, sheet = 1)
previousRetiredItems <- read.xlsx(previouslyRetiredItems, sheet = 1)
PreviousActiveItems <- read.xlsx(previousActiveList, sheet = 1)
edmodoItems <- read.xlsx(edmodo, sheet = 1)

#Select Active items
currentNotRetired <- filter(currentReport, Item.Status == "Active")
currentNotActive <- filter(currentReport, Item.Status != "Active")

#Create data frame for Blooms: DOK crosswalk
DOK <- as.character(c("Remembering", "Understanding","Applying", "Analyzing", "Evaluating", "Creating"))
DOK <- as.data.frame(cbind(DOK, as.character(c("I","II","II", "III","III","IV"))),row.names=NULL)
colnames(DOK) <- c("Blooms", "DOK")

#Create data frame for log file
errorLog <- data.frame(itemCode=character(), errorType=character())

#Create a function to pass data frame (x) with offending item code and report error (y) to error log file
logItems <- function(x, y, z) {
  #get class of first argument
  argClass <- class(x)
  #find number of rows in inbound item code list
  if(argClass == "character") {
    nrows <- length(x)
  } else {
    nrows <- nrow(x)
  }
  if(nrows > 0) {
    #create [vector] of error messages matching length of inbound item code list
    errorMessage <- rep(y, nrows) 
    #append error messages to data frame
    x <- as.data.frame(cbind(x, errorMessage))    
    #append rows from item code data frame to error log
    errorLog <<- rbind(z, x)
  }
}

#Find item codes where the item code contains a space
itemCodeSpaces <- as.data.frame(grep(" ", currentNotRetired$Item.Code, value=TRUE))
colnames(itemCodeSpaces) <- c("Item.Code")
logItems(itemCodeSpaces, "space in item code", errorLog)

#Identify any active Miami Dade items
miamiDade <- as.data.frame(grep("^M", currentNotRetired$Item.Code, value=TRUE))
colnames(miamiDade) <- c("Item.Code")
logItems(miamiDade, "Miami Dade Item", errorLog)

#Identify any active Georgia items
georgia <- as.data.frame(grep("^1|^3", currentNotRetired$Item.Code, value=TRUE))
colnames(georgia) <- c("Item.Code")
logItems(georgia, "Georgia Item", errorLog)

#Identify any active deleted items
activeDeletedItems <- as.data.frame(grep("^D", currentNotRetired$Item.Code, value=TRUE))
colnames(activeDeletedItems) <- c("Item.Code")
logItems(activeDeletedItems, "Active deleted items", errorLog)

#Identify any active HOLD items
activeHoldItems <- as.data.frame(grep("^H", currentNotRetired$Item.Code, value=TRUE))
colnames(activeHoldItems) <- c("Item.Code")
logItems(activeHoldItems, "Active deleted items", errorLog)

#Identify any active test items
activeTestItem <- as.data.frame(grep("^8", currentNotRetired$Item.Code, value=TRUE))
colnames(activeTestItem) <- c("Item.Code")
logItems(activeTestItem, "Active test item", errorLog)

#identify previously deleted items that are now active
activePreviouslyDeletedItems <- merge(previousRetiredItems, currentNotRetired, by.x="Internal.ID", by.y="Internal.Id")
activePreviouslyDeletedItems <- select(activePreviouslyDeletedItems, Item.Code)
logItems(activePreviouslyDeletedItems, "Previously deleted active items", errorLog)

#identify previously active items that are now retired
noLongerActiveItems <- merge(PreviousActiveItems, currentNotActive, by.x ="Internal.ID", by.y="Internal.Id" )
noLongerActiveItems <- select(noLongerActiveItems, itemcode)
names(noLongerActiveItems) <- c("Item.Code")
logItems(noLongerActiveItems, "Was active, now not active", errorLog)


#Note duplicate codes
duplicateCode <- currentNotRetired %>% group_by(Item.Code) %>% filter(n()>1) %>% select(Item.Code) %>% as.data.frame()
logItems(duplicateCode, "Duplicate Code", errorLog)

bloomfilter = "Bloom's.Revised.Taxonomy"
missingBloom <- select(filter(currentNotRetired, bloomfilter== "NULL" | bloomfilter == ""),Item.Code)
logItems(missingBloom, "Missing Bloom", errorLog)

missingDOK <- select(filter(currentNotRetired, Depth.Of.Knowledge == "NULL" | Depth.Of.Knowledge == ""),Item.Code)
logItems(missingDOK, "Missing DOK", errorLog)

#Create data frame that shows item code, blooms, and DOK + crosswalkDOK. Identify bad DOK
crosswalkDOK <- merge(DOK, currentNotRetired, by.x= "Blooms", by.y=bloomfilter, all=FALSE)
crosswalkDOK <- select(filter(crosswalkDOK, DOK != Depth.Of.Knowledge),Item.Code)
logItems(crosswalkDOK, "Wrong DOK crosswalk", errorLog)

missingDifficulty <- select(filter(currentNotRetired, Estimated.Difficulty.Level == "NULL" | Estimated.Difficulty.Level == ""),Item.Code)
logItems(missingDifficulty, "Missing Difficulty", errorLog)

newItemStatus <- select(filter(merge(currentNotRetired, newItems, by.x="Item.Code", by.y="Item.Code", all=FALSE),Item.Status != "Active"),Item.Code)
logItems(newItemStatus, "New item should be active", errorLog)

#Find items with Passage Code 2 present and Passage Code 1 NULL
missingPassageOne <- select(filter(currentNotRetired, Passage.2.Code != "NULL" & Passage.1.Code == "NULL"),Item.Code)
logItems(missingPassageOne, "Missing Passage One Code", errorLog)

#Find items with Passage Code 2 > Passage Code 1
passageTwoGreater <- select(filter(currentNotRetired, Passage.2.Code < Passage.1.Code),Item.Code)
logItems(passageTwoGreater, "Passage Two Code Greater Than Passage Code One", errorLog)

#Find items with incorrect content area based on subject
ContentArea <- select(filter(currentNotRetired, (Subject == "Language Arts" & (Content.Area != "Media" & Content.Area !="Reading" & Content.Area !="Writing"))),Item.Code)
logItems(ContentArea, "Wrong ELA content area", errorLog)

ContentArea <- select(filter(currentNotRetired, (Subject == "Math" & (Content.Area != "Mathematics" & Content.Area !="Geometry" & Content.Area !="Algebra I" & Content.Area != "Algebra II"))),Item.Code)
logItems(ContentArea, "Wrong Math content area", errorLog)

ContentArea <- select(filter(currentNotRetired, (Subject == "Science" & (Content.Area != "Biology" & Content.Area != "Earth and Space Sciences"  & Content.Area != "Science"  & Content.Area != "Physical Sciences"  & Content.Area != "Chemistry"))),Item.Code)
logItems(ContentArea, "Wrong Science content area", errorLog)

ContentArea <- select(filter(currentNotRetired, (Subject == "History/Social Studies" & (Content.Area != "American History" & Content.Area !="World History" & Content.Area !="Geography" & Content.Area != "Government" & Content.Area != "Economics"))),Item.Code)
logItems(ContentArea, "Wrong Social Studies content area", errorLog)

badGrade <- select(filter(currentNotRetired, (Subject == "Language Arts" & (Item.Grade == "Grades 09-12"))),Item.Code)
logItems(badGrade, "Wrong ELA HS Grade", errorLog)

badGrade <- select(filter(currentNotRetired, (Subject != "Language Arts" & (Item.Grade == "Grade 09" | Item.Grade == "Grade 10" | Item.Grade == "Grade 11" | Item.Grade == "Grade 12"))),Item.Code)
logItems(badGrade, "Wrong non-ELA HS Grade", errorLog)

#Review Answer.Alignment column for MC items only
answerAlignment <- select(filter(currentNotRetired, (Item.Type == "Multiple Choice" & Answer.Alignment == 5)),Item.Code)
logItems(answerAlignment, "Answer Alignment should be 3", errorLog)

#Review Answer.Alignment column for MC items only
answerAlignment <- select(filter(currentNotRetired, (Item.Type == "Multiple Choice" & Answer.Alignment == 4)),Item.Code)
logItems(answerAlignment, "Answer Alignment should be 2", errorLog)

#Review for item has no correct answer
correctAnswer <- select(filter(currentNotRetired, Correct.Answer == ""),Item.Code)
logItems(correctAnswer, "Correct answer is null", errorLog)

#Review for CR items with column span of 2
columnSpan <- select(filter(currentNotRetired, ((Item.Type != "Grid-In" & Item.Type != "Choice Multiple" & Item.Type != "Multiple Choice")& Column.Count == 2)),Item.Code)
logItems(columnSpan, "Column span should be 1 for item type", errorLog)

#Find active items associated with Retired passages
retiredPassages <- filter(currentPassages, Status == "Retired" & Passage.Code != "NULL")
itemsWithRetiredPassages <- merge(currentNotRetired, retiredPassages, by.x="Passage.1.Code", by.y="Passage.Code")
itemsWithRetiredPassages <- rbind(itemsWithRetiredPassages, merge(currentNotRetired, retiredPassages, by.x="Passage.2.Code", by.y="Passage.Code"))
itemsWithRetiredPassages <- select(itemsWithRetiredPassages, Item.Code)
logItems(itemsWithRetiredPassages, "Active Item to Retired Passage", errorLog)

#Find active passages, then find items where item grade doesn't equal passage grade
activePassages <- filter(currentPassages, Status == "Active" & Passage.Code != "NULL")
itemsWithActivePassages <- merge(currentNotRetired, activePassages, by.x="Passage.1.Code", by.y="Passage.Code")
itemsWithActivePassages <- rbind(itemsWithActivePassages, merge(currentNotRetired, activePassages, by.x="Passage.2.Code", by.y="Passage.Code"))
itemsWithActivePassages <- select(filter(itemsWithActivePassages, Item.Grade!=Grade.Level ), Item.Code)
logItems(itemsWithActivePassages, "Item and passage grade mismatch", errorLog)

#Find Edmodo items that have been retired
noLongerActiveEdmodoItems <- merge(edmodoItems, currentNotActive, by.x ="Internal.ID", by.y="Internal.Id" )
noLongerActiveEdmodoItems <- select(noLongerActiveEdmodoItems, Item.Code.x)
logItems(noLongerActiveEdmodoItems, "Edmodo Item now retired", errorLog)


#Prep error log for export by adding item metadata back in 
export <- merge(errorLog, currentReport, by.x= "Item.Code", by.y="Item.Code", all=FALSE)


#Export log file
filename <- "C:/AccessReports/AllItemErrorLog.xlsx"
writeWorksheetToFile(filename, export, sheet = "Sheet1")

