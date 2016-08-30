#This program performs a range of content-specific data checks on data exported from
#an educational database, ranging from simple data scrubbing tasks to content
#validity. The final output is a flatlist that identifies the field which needs
#to be changed and a description of the change needed.

#check whether packages are installed


#load libraries
library(dplyr)
library(plyr)

#Set filenames and change working directory
directory <- "C:/Users/Melissa/Downloads"
setwd(directory) 

#Load allitem report, currently commented out during program creation and testing
CurrentDelivery <- "FAIB-allallItem04082016.csv"

#Instead load custom allItemReport with embedded errors for routine creation
currentDelivery <- "FAIB-errorExamples.csv"

currentReport <- read.csv2(currentDelivery, header = TRUE, sep = ",", quote = "\"")

#Select Active or in progress
currentNotRetired <- filter(currentReport, Item.Status == "Active" | Item.Status == "In Progress")

#Create data frame for Blooms: DOK crosswalk
DOK <- c("Remembering", "Understanding","Applying", "Analyzing", "Evaluating", "Creating")
DOK <- as.data.frame(cbind(DOK, c("I","II","II", "III","III","IV")),row.names=NULL)
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

#Find item codes where the item code contains a space -- not developed yet, dummy code while testing out logItems Function
currentNotRetired <- select(filter(currentReport, Item.Status == "Active"),Item.Code)

itemCodeSpaces <- grep(" ", currentNotRetired$Item.Code, value=TRUE)
logItems(problemItems, "space in item code", errorLog)

missingBloom <- select(filter(currentReport, Bloom.s.Revised.Taxonomy == "NULL" | Bloom.s.Revised.Taxonomy == ""),Item.Code)
logItems(missingBloom, "Missing Bloom", errorLog)


#Prep error log for export by adding item subject


#Export log file
