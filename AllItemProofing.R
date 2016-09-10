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

#Create subject/content area data frame
contentArea <- (c("Language Arts", "Writing", "Language Arts", "Media", 
"Language Arts", "Reading", "Math", "Mathematics", "Math", "Geometry", "Math",  
"Algebra I","Math", "Algebra II", "Science", "Biology", "Science", 
"Earth and Space Sciences", "Science", "Science", "Science", "Physical Sciences", "Science", "Chemistry",
"History/Social Sciences", "American History", "History/Social Sciences", 
"World History", "History/Social Sciences", "Economics", "History/Social Sciences",  
"Government", "History/Social Sciences", "Geography"))
contentArea <- as.data.frame(matrix(contentArea, nrow = 17, ncol = 2, byrow = TRUE))
colnames(contentArea) <- c("subject","contentArea")


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

#Create data frame that shows item code, blooms, and DOK + crosswalkDOK
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


#Prep error log for export by adding item subject
export <- merge(errorLog, currentReport, by.x= "Item.Code", by.y="Item.Code", all=FALSE)

#Export log file
write.xlsx(errorLog, "C:/Users/Melissa/Downloads/AllItemErrorLog.xlsx")

