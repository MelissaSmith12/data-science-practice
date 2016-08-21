#This code reads the keywords from my peer-solicited strengths analysis and 
#graphs trends and displays a summary chart and word cloud

library(plyr)
library(dplyr)
library(wordcloud)

#Set filenames and change working directory
dir <- "C:/Users/Melissa/Downloads"
setwd(dir)
file <- "strengths.txt"
Strengths <- read.csv(file, header = TRUE, sep = ",")
StrengthsCount <- count(Strengths, c("Theme.word"))
StrengthsCount

highstrength <- filter(StrengthsCount, freq > 1)
highstrength

wordcloud(StrengthCorpus, max.words = 100, random.order = FALSE)
wordcloud(StrengthsCount$Theme.word, StrengthsCount$freq, max.words=100, rot.per = .5, random.order = TRUE, random.color = TRUE)
