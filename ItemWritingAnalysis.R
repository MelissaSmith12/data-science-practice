# This project will answer a number of analysis question surrounding the movement of 
# cards through a trello board that represents a semi-sequential process. Items are requested,
# developed, reviewed (which may contain multiple cycles), art provided, copy edited, entered 
# into to the system, checked, aligned, Senior Reviewed, post-Senior Reviewed, and have a final Review.
# This analysis seeks to ask the following questions: How long do cards stay in each phase? How many cycles
# does the average card go through? Are there any users at any stage in the process that are outliers?

# This project also provides an opportunity to play with APIs by playing with Trello
library("httr")
library("jsonlite")
library("trelloR")

token <- "a75a3e4d750fc6bdc912fd3de8c1f58c6fd706fab18dc54ce1072fb62fdf8e4d"

#initial data exploration on personal board
board = get_id_board("https://trello.com/b/HEgOoY9G/home-sprint-3")
cards = get_board_cards(board)

class(cards)
