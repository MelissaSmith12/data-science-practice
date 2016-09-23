#This script interacts with the Beeminder API to get data about my writing goal

library("httr")
library("jsonlite")

french_goal_url <- "https://www.beeminder.com/api/v1/users/pjpants/goals/french.json?auth_token=YDAzugHfiQB3fQqx8XLY"
french_goal_data <- fromJSON(french_goal_url)

french_goal_data

names(french_goal_data)

french_goal_data$description
french_goal_data$fullroad