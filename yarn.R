#This program uses dplyr package to analyze the data in the ability.cov data sets 
#from the r package "datasets"


list.of.packages <- c("datasets","dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("datasets")
library("dplyr")

head(warpbreaks)

#convert to a data frame
df_warpbreaks <- tbl_df(warpbreaks)

df_warpbreaks

summary(df_warpbreaks)

#Sort by tension
arrange(df_warpbreaks, tension)

#filter to those with low tension
filter(df_warpbreaks, tension == 'L')

#average number of breaks
summarize(df_warpbreaks, mean(breaks))



