library("knitr")

wd <- "C:/Users/Melissa/Downloads"
setwd()

file <- "stroopdata.csv - stroopdata.csv.csv"
stroop <- read.csv(file, header = TRUE)

# Learn how to generate reports in knitr

#Copy in report structure

#1. What is our independent variable? What is our dependent variable?
#2. What is an appropriate set of hypotheses for this task? What kind of 
#   statistical test do you expect to perform? Justify your choices.
#3. Report some descriptive statistics regarding this dataset. Include at least 
#   one measure of central tendency and at least one measure of variability.
#4. Provide one or two visualizations that show the distribution of the sample 
#   data. Write one or two sentences noting what you observe about the plot or plots.
#5. Now, perform the statistical test and report your results. What is your 
#   confidence level and your critical statistic value? Do you reject the null 
#   hypothesis or fail to reject it? Come to a conclusion in terms of the 
#   experiment task. Did the results match up with your expectations?
#6. Optional: What do you think is responsible for the effects observed? Can you 
#   think of an alternative or similar task that would result in a similar 
#   effect? Some research about the problem will be helpful for thinking about 
#   these two questions!