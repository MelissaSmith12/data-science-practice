#This reviews recurring data and reports to produce a simple summary used to inform product users

#Topics include:
#Total new items
#Total CC items
#Total NGSS items
#Total new passages
#Total passages
#Total new Spanish
#Total Spanish
#TEI distribution

library(plyr)
library(dplyr)
library(xlsx)

#Set filenames and change working directory
directory <- "C:/Users/Melissa/Documents/Work/Metadata QC"
setwd(directory)

AllItem <- "AllItemenglish.csv"
AllItem <- read.csv(currentDelivery, header=TRUE, stringsAsFactors = FALSE)
AllItem <- filter(AllItem, Status == "Active")
