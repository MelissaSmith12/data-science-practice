#As part of a career development exercise, I solicited feedback on strengths from
#friends, family, and coworkers. I transferred their feedback to a google spreadsheet
#and downloaded this to a csv file. (will someday read from the actual email thread)

#Resource for script: https://www.r-bloggers.com/building-wordclouds-in-r/

library(tm)
library(SnowballC)
library(wordcloud)

#Read the two column data file that has been downloaded from Google Drive
dir <- "C:/Users/Melissa/Downloads"
setwd(dir)
file = "Strengths Spreadsheet - Reduced.csv"
strengthsFull <- read.csv(file, header = TRUE, sep = ",", stringsAsFactors = FALSE)

#First, we need to create a corpus.

strengthsCorpus <- Corpus(VectorSource(strengthsFull$Exact.Response))
#Next, we will convert the corpus to a plain text document.

strengthsCorpus <- tm_map(strengthsCorpus, PlainTextDocument)

#Then, we will remove all punctuation and stopwords. Stopwords are commonly 
#used words in the English language such as I, me, my, etc. You can see the full 
#list of stopwords using stopwords('english').

strengthsCorpus <- tm_map(strengthsCorpus, removePunctuation)
strengthsCorpus <- tm_map(strengthsCorpus, removeWords, stopwords('english'))

#Next, we will perform stemming. This means that all the words are converted to 
#their stem (Ex: learning -> learn, walked -> walk, etc.). This will ensure that 
#different forms of the word are converted to the same form and plotted only once 
#in the wordcloud.

strengthsCorpus <- tm_map(strengthsCorpus, stemDocument)

#Now, we will plot the wordcloud.

wordcloud(strengthsCorpus, max.words = 100, random.order = FALSE)