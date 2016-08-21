#All Item Report Statistics Report
#Loads a FAIB All Item Report and generates counts and summary statistics

#Load the all item report as a data frame

#Generate and save a summary table


head(currentReport)

#Generate summary statistics

#Total number of items per item writer
TotalPerItemWriter <- count(currentReport, c("Item.Writer"))

#Average number of item edits per item writer


#Item writers with the most retired items (minus an ELA passages that are retired)

