#This code reads the keywords from my peer-solicited strengths analysis and 
#graphs trends and displays a summary chart

library(dplyr)


#Set filenames and change working directory
dir <- "C:/Users/Melissa/Downloads"
directory <- "C:/Users/Melissa/Downloads"


file <- "strengths.txt"
strengths <- read.csv(file, header = FALSE, sep = ",")