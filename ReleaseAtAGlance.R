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

"Navigate Item BankT"
"At-A-Glance: " + Release_date + " Release"
Release_date + "Item Bank Summary"


Release_date + " Item Bank Summary"

"What was the development focus for the " Release_date " Release?" 

"How many items are in the bank after the Spring 2016 Release? "

"How many items were added in Spring 2016? "

"How many passages are in the bank after the Spring 2016 Release?"

"How many passages were added in Spring 2016? "

"How many TEIs are in the bank after the Spring 2016 Release? "


"How many TEIs were added in Spring 2016? "

"How many writing prompts are in the bank after the Spring 2016 Release? "

"How many writing prompts were added in Spring 2016? "

"How many constructed-response items (excluding writing prompts) are in the bank after the Spring 2016 Release? "

"How many constructed-response items (excluding writing prompts) were added in Spring 2016? "

"How many items translated/transadapted into Spanish are in the bank after the Spring 2016 Release? "

"How many items translated/transadapted into Spanish were added in Spring 2016? "

"How many passages translated/transadapted into Spanish are in the bank after the Spring 2016 Release? "

"How many passages translated/transadapted into Spanish were added in Spring 2016? "

"How many items are written or aligned to the Common Core as of the Spring 2016 Release? "

"Through the Spring 2016 Release, how many items have been written since the release of the CCSS standards in 2010? "

"How many items are written or aligned to the NGSS as of the Spring 2016 Release? "

"Through the Spring 2016 Release, how many items have been written since the release of the NGSS standards in April 2013? "

"Through the Spring 2016 Release, what is the breakdown of items by Depth of Knowledge (DOK)? "

"Through the Spring 2016 Release, what is the breakdown of items by Bloom's Revised Taxonomy? "


"Release Comparison: Fall 2015 and Spring 2016"

"1.	Total number of items comparison"

"*Items can be deleted for several reasons, including for things like content changing (e.g., Pluto no longer a planet) and losing the copyright for the stimulus the item(s) are tied to. "

"2.	Total number of passages comparison"

"3.	Total number of TEIs comparison"

"4.	Total number of writing prompts comparison"

"5.	Total number of constructed-response items comparison (excluding writing prompts)"

"6.	Total number of items translated/transadapted into Spanish comparison"

"7.	Total number of passages translated/transadapted into Spanish comparison"


