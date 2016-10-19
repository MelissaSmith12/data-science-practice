#This program consumes assorted reports related to the Navigate Release and produces 
#summary statistics for marketing and support purposes


library(plyr)
library(dplyr)
library(xlsx)

#Set filenames and change working directory
directory <- "C:/Users/Melissa/Documents/Work/Metadata QC"
setwd(directory)

AllItem <- "AllItemenglish.csv"
AllItem <- read.csv(currentDelivery, header=TRUE, stringsAsFactors = FALSE)
AllItem <- filter(AllItem, Status == "Active")

Spanish <- "ActiveSpanish.xlsx"
Spanish <- read.xlsx2(Spanish, stringsAsFactors = FALSE)

Previous_date = "Spring 2016"
Release_date = "Fall 2016"

product_name <- "Navigate Item Bank"
document_title <- paste("At-A-Glance:", Release_date, "Release")
document_subtitle <- paste(Release_date, "Item Bank Summary")

section_heading <- paste("What was the development focus for the", Release_date, "Release?") 

section_heading <- paste("How many items are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many items were added in the", Release_date, "Release?") 

section_heading <- paste("How many passages are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many passages were added in the", Release_date, "Release?") 

section_heading <- paste("How many TEIs are in the bank after the", Release_date, "Release?") 


section_heading <- paste("How many TEIs were added in the", Release_date, "Release?") 

section_heading <- paste("How many writing prompts are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many writing prompts were added in the", Release_date, "Release?") 

section_heading <- paste("How many constructed-response items (excluding writing prompts) are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many constructed-response items (excluding writing prompts) were added in the", Release_date, "Release?") 

section_heading <- paste("How many items translated/transadapted into Spanish are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many items translated/transadapted into Spanish were added in the", Release_date, "Release?") 

section_heading <- paste("How many passages translated/transadapted into Spanish are in the bank after the", Release_date, "Release?") 

section_heading <- paste("How many passages translated/transadapted into Spanish were added in the", Release_date, "Release?") 

section_heading <- paste("How many items are written or aligned to the Common Core as of the", Release_date, "Release?") 

section_heading <- paste("Through the", Release_date, "Release, how many items have been written since the release of the CCSS standards in 2010?")

section_heading <- paste("How many items are written or aligned to the NGSS as of the", Release_date, "Release?") 

section_heading <- paste("Through the", Release_date, "Release, how many items have been written since the release of the NGSS standards in April 2013? ")

section_heading <- paste("Through the", Release_date, "Release, what is the breakdown of items by Depth of Knowledge (DOK)? ")

section_heading <- paste("Through the", Release_date, "Release, what is the breakdown of items by Bloom's Revised Taxonomy? ")


section_heading <- paste("Release Comparison:" Previous_date, "and", Release_date)

section_heading <- "Total number of items comparison"

disclaimer <- "Items can be deleted for several reasons, including for things like content changing (e.g., Pluto no longer a planet) and losing the copyright for the stimulus the item(s) are tied to."

section_heading <- "Total number of passages comparison"

section_heading <- "Total number of TEIs comparison"

section_heading <- "Total number of writing prompts comparison"

section_heading <- "Total number of constructed-response items comparison (excluding writing prompts)"

section_heading <- "Total number of items translated/transadapted into Spanish comparison"

section_heading <- "Total number of passages translated/transadapted into Spanish comparison"


