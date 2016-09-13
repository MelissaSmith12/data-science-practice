#This program performs a range of content-specific data checks on data exported from
#an educational database, ranging from simple data scrubbing tasks to content
#validity. The final output is a flatlist that identifies the field which needs
#to be changed and a description of the change needed.

#It is also a project to reacquaint myself with R packages, one tiny line of code at a time

#check whether packages are installed


#load libraries     
library(dplyr)
library(plyr)
library(xlsx)

#Set filenames and change working directory
directory <- "C:/Users/Melissa/Downloads"
setwd(directory) 

#Load allitem report, currently commented out during program creation and testing
currentDelivery <- "FAIB-allallItem04082016.xlsx"

#Instead load custom allItemReport with embedded errors for routine creation
currentDelivery <- "FAIB-errorExamples.csv"

#Load allpassage report
currentPassageFile <- "FAIB-allallPass04072016-sampleError.xlsx"

#Load New item list
newItemFile <- "Preliminary Active Item List.xlsx"

#Need to adjust to read xlsx version, remember to tackle stringsAsFactors
currentReport <- read.csv2(currentDelivery, header = TRUE, sep = ",", quote = "\"", stringsAsFactors = FALSE)
newItems <- read.xlsx(newItemFile, sheetName = "Sheet1")
currentPassages <- read.xlsx(currentPassageFile, sheetName = "Sheet1")

#Select Active or in progress
currentNotRetired <- filter(currentReport, Item.Status == "Active" | Item.Status == "In Progress")

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

#Throws error message, but ignoring
duplicateCode <- currentNotRetired %>% group_by(Item.Code) %>% filter(n()>1) %>% select(Item.Code) %>% as.data.frame()
logItems(duplicateCode, "Duplicate Code", errorLog)

missingBloom <- select(filter(currentReport, Bloom.s.Revised.Taxonomy == "NULL" | Bloom.s.Revised.Taxonomy == ""),Item.Code)
logItems(missingBloom, "Missing Bloom", errorLog)

missingDOK <- select(filter(currentReport, Depth.Of.Knowledge == "NULL" | Depth.Of.Knowledge == ""),Item.Code)
logItems(missingDOK, "Missing DOK", errorLog)

#Create data frame that shows item code, blooms, and DOK + crosswalkDOK. Identify bad DOK
crosswalkDOK <- merge(DOK, currentReport, by.x= "Blooms", by.y="Bloom.s.Revised.Taxonomy", all=FALSE)
crosswalkDOK <- select(filter(crosswalkDOK, DOK != Depth.Of.Knowledge),Item.Code)
logItems(crosswalkDOK, "Wrong DOK crosswalk", errorLog)

missingDifficulty <- select(filter(currentReport, Estimated.Difficulty.Level == "NULL" | Estimated.Difficulty.Level == ""),Item.Code)
logItems(missingDifficulty, "Missing Difficulty", errorLog)

newItemStatus <- select(filter(merge(currentReport, newItems, by.x="Item.Code", by.y="Item.Code", all=FALSE),Item.Status == "In Progress"),Item.Code)
logItems(newItemStatus, "New item should be active", errorLog)

#Find items with Passage Code 2 present and Passage Code 1 NULL
missingPassageOne <- select(filter(currentReport, Passage.2.Code != "NULL" & Passage.1.Code == "NULL"),Item.Code)
logItems(missingPassageOne, "Missing Passage One Code", errorLog)

#Find items with Passage Code 2 > Passage Code 1
passageTwoGreater <- select(filter(currentReport, Passage.2.Code < Passage.1.Code),Item.Code)
logItems(passageTwoGreater, "Passage Two Code Greater Than Passage Code One", errorLog)

#Find items with incorrect content area based on subject
ContentArea <- select(filter(currentReport, (Subject == "Language Arts" & (Content.Area != "Media" & Content.Area !="Reading" & Content.Area !="Writing"))),Item.Code)
logItems(ContentArea, "Wrong ELA content area", errorLog)

ContentArea <- select(filter(currentReport, (Subject == "Math" & (Content.Area != "Mathematics" & Content.Area !="Geometry" & Content.Area !="Algebra I", & Content.Area != "Algebra II"))),Item.Code)
logItems(ContentArea, "Wrong Math content area", errorLog)

ContentArea <- select(filter(currentReport, (Subject == "Science" & (Content.Area != "Biology", & Content.Area != "Earth and Space Sciences",  & Content.Area != "Science",  & Content.Area != "Physical Sciences",  & Content.Area != "Chemistry"))),Item.Code)
logItems(ContentArea, "Wrong Science content area", errorLog)

ContentArea <- select(filter(currentReport, (Subject == "History/Social Studies" & (Content.Area != "American History" & Content.Area !="World History" & Content.Area !="Geography", & Content.Area != "Government", & Content.Area != "Economics"))),Item.Code)
logItems(ContentArea, "Wrong Social Studies content area", errorLog)

badGrade <- select(filter(currentReport, (Subject == "Language Arts" & (Item.Grade == "Grades 09-12"))),Item.Code)
logItems(badGrade, "Wrong ELA HS Grade", errorLog)

badGrade <- select(filter(currentReport, (Subject != "Language Arts" & (Item.Grade == "Grade 09" | Item.Grade == "Grade 10" | Item.Grade == "Grade 11" | Item.Grade == "Grade 12"))),Item.Code)
logItems(badGrade, "Wrong non-ELA HS Grade", errorLog)

#Review Answer.Alignment column for MC items only
answerAlignment <- select(filter(currentReport, (Item.Type == "Multiple Choice" & Answer.Alignment == 5)),Item.Code)
logItems(answerAlignment, "Answer Alignment should be 3", errorLog)

#Review Answer.Alignment column for MC items only
answerAlignment <- select(filter(currentReport, (Item.Type == "Multiple Choice" & Answer.Alignment == 4)),Item.Code)
logItems(answerAlignment, "Answer Alignment should be 2", errorLog)


#Prep error log for export by adding item subject
export <- merge(errorLog, currentReport, by.x= "Item.Code", by.y="Item.Code", all=FALSE)

#Export log file
write.xlsx(errorLog, "C:/Users/Melissa/Downloads/AllItemErrorLog.xlsx")

