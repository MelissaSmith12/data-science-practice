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
CurrentDelivery <- "FAIB-allallItem04082016.csv"

currentReport <- read.csv2(CurrentDelivery, header = TRUE, sep = ",", quote = "\"", nrows = 500)

#Select Active Items
currentActive <- filter(currentReport, Item.Status == "Active")

#Select Active or in progress
currentNotRetired <- filter(currentReport, Item.Status == "Active" | Item.Status == "In Progress")




#Convert the Created.Date and Last.Modified.By columns


#Find item codes where the item code contains a space

