##' Example using R 
library("pollster")
library("dplyr")

# Name of chart to download
slug <- "obama-job-approval"


# Get Pollster's model 
chart <- pollster_chart(slug)

# Set max_pages to high number to download all polls
# This will take several minutes
polls <- pollster_polls(chart = slug, max_pages = 1000000)

# Subset question data to remove subpopulations that are only 
questions <-
    subset(polls$questions,
           chart == slug
           & subpopulation %in% c("Adults", "Likely Voters", "Registered Voters"))

# Recode choices into Approve / Disapprove / Undecided and aggregate
approvalcat <- c("Approve" = "Approve",
                 "Disapprove" = "Disapprove",
                 "Undecided" = "Undecided",
                 "Neither" = "Undecided",
                 "Mixed" = "Undecided",
                 "Don't Know" = "Undecided",
                 "Refused" = NA,
                 "Neutral" = "Undecided",
                 "Strongly Approve" = "Approve",
                 "Somewhat Approve" = "Approve", 
                 "Somewhat Disapprove" = "Disapprove",
                 "Strongly Disapprove" = "Disapprove")

questions2 <-
    (questions
     %.% mutate(approve = revalue(choice, approvalcat))
     %.% group_by(id, subpopulation, approve)
     %.% summarise(value = sum(value)))

# Merge question data back with poll metadata
polldata <- merge(polls$polls, questions2, by = "id")


# Plot raw polls + Huffpost Pollster model 
(ggplot()
 + geom_point(data = polldata,
              mapping = aes(y = value, x = end_date, color = approve),
              alpha = 0.3)
 + geom_line(data = chart[["estimates_by_date"]],
             mapping = aes(y = value, x = date, color = choice)))

