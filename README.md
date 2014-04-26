


[![Build Status](https://travis-ci.org/rOpenGov/pollstR.svg?branch=master)](https://travis-ci.org/rOpenGov/pollstR)

# R client for the Huffpost Pollster API

This R package is an interface to the Huffington Post [Pollster API](http://elections.huffingtonpost.com/pollster/api), which provides access to opinion polls collected by the Huffington Post.

The package is released under GPL-2 and the API data it accesses is released under the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US).


# Install

This package is not *yet* on CRAN.

You can install this with the function ``install_github`` in the **devtools** package.

```r
install.packages("devools")
library("devtools")
install_github("rOpenGov/pollstR")
```


```r
library("pollstR")
```


# API Overview

The Pollster API has two primary data structures: charts and polls.

*Polls* are individual, dated topline results for a single set of candidates in a single race.
The poll data structure consists of (generally) named candidates and percentage support for each, along with additional information (e.g., polling house, sampling frame, sample size, margin of error, state, etc.).

*Charts* aggregate polls for a particular race or topic (e.g., "2012-president" or "obama-job-approval".
A chart reports aggregated survey estimates of support for the candidates in a given race and, possibly, daily estimates of support.
Each chart is named, reports the number of aggregated polls it presents, a last-updated date, and a "slug" field. The "slug" identifies the chart both in the API and on the Pollster website.

In ``pollstR``, there are three functions in that provide access to the opinion polls and model estimates from Huffpost Pollster.

- ``pollstr_charts``: Get a list of all charts and the current model estimates.
- ``pollstr_chart``: Get a single chart along with historical model estimates.
- ``pollstr_polls``: Get opinion poll data.


# Examples

## Charts

To get a list of all the charts in the API use the function ``pollstr_charts``,

```r
charts <- pollstr_charts()
str(charts)
```

```
## List of 2
##  $ charts   :'data.frame':	444 obs. of  9 variables:
##   ..$ title        : Factor w/ 444 levels "2012 Iowa GOP Primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ slug         : Factor w/ 443 levels "2012-iowa-gop-primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ topic        : Factor w/ 27 levels "2012-president-gop-primary",..: 1 1 1 1 1 1 1 1 2 3 ...
##   ..$ state        : Factor w/ 51 levels "IA","NH","SC",..: 1 2 3 4 5 6 7 8 8 8 ...
##   ..$ short_title  : Factor w/ 444 levels "1/3 Iowa Caucus",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ election_date: Date[1:444], format: NA ...
##   ..$ poll_count   : num [1:444] 65 55 44 59 10 34 19 258 589 300 ...
##   ..$ last_updated : POSIXct[1:444], format: "2012-01-02 13:08:44" ...
##   ..$ url          : Factor w/ 443 levels "http://elections.huffingtonpost.com/pollster/2012-iowa-gop-primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ estimates:'data.frame':	1044 obs. of  8 variables:
##   ..$ choice         : Factor w/ 318 levels "Romney","Paul",..: 1 2 3 4 5 6 7 8 9 1 ...
##   ..$ value          : num [1:1044] 22.5 21.3 15.9 12.6 11.1 8.3 3.7 5.9 0.9 39.6 ...
##   ..$ lead_confidence: num [1:1044] NA NA NA NA NA NA NA NA NA NA ...
##   ..$ first_name     : chr [1:1044] "Mitt" "Ron" "Rick" "Newt" ...
##   ..$ last_name      : chr [1:1044] "Romney" "Paul" "Santorum" "Gingrich" ...
##   ..$ party          : chr [1:1044] "Rep" "Rep" "Rep" "Rep" ...
##   ..$ incumbent      : logi [1:1044] FALSE FALSE FALSE FALSE FALSE FALSE ...
##   ..$ slug           : chr [1:1044] "2012-iowa-gop-primary" "2012-iowa-gop-primary" "2012-iowa-gop-primary" "2012-iowa-gop-primary" ...
##  - attr(*, "class")= chr "pollstr_charts"
```

This returns a ``list`` with two data frames.
The data frame ``charts`` has data on each chart,
while the data frame ``estimates`` has the current poll-tracking estimates from each chart.

The query can be filtered by state or topic.
For example, to get only charts related to national topics,

```r
us_charts <- pollstr_charts(state = "US")
```


## Chart

To get a particular chart use the function ``pollstr_chart``.
For example, to get the chart for [Barack Obama's Favorable Rating](http://elections.huffingtonpost.com/pollster/obama-favorable-rating), specify its *slug*, ``obama-favorable-rating``.

```r
obama_favorable <- pollstr_chart("obama-favorable-rating")
print(obama_favorable)
```

```
## Title:       Barack Obama Favorable Rating 
## Chart Slug:  obama-favorable-rating 
## Topic:       favorable-ratings 
## State:       US 
## Polls:       804 
## Updated:     1.398e+09 
## URL:         http://elections.huffingtonpost.com/pollster/obama-favorable-rating 
## Estimates:
##             choice value lead_confidence first_name last_name party
## 1        Favorable  45.7              NA         NA        NA    NA
## 2      Unfavorable  49.0              NA         NA        NA    NA
## 3        Undecided   4.5              NA         NA        NA    NA
## 4 Not Heard Enough   0.2              NA         NA        NA    NA
##   incumbent
## 1        NA
## 2        NA
## 3        NA
## 4        NA
## 
## First 6 (of 2123) daily estimates:
##        choice value       date
## 1   Favorable  45.7 2014-04-21
## 2   Undecided   4.5 2014-04-21
## 3 Unfavorable  49.0 2014-04-21
## 4   Favorable  45.7 2014-04-15
## 5   Undecided   4.4 2014-04-15
## 6 Unfavorable  49.0 2014-04-15
```

The slug can be found from the results of a ``pollstr_charts`` query.
Also, the slug is the path of the url of a chart, http://elections.huffingtonpost.com/pollster/obama-favorable-rating.

The historical estimates of the Huffpost Pollster poll-tracking model are contained in the element ``"estimates_by_date"``,

```r
(ggplot(obama_favorable[["estimates_by_date"]], aes(x = date, y = value, color = choice)) + 
    geom_line())
```

![plot of chunk obama-favorable-chart](figures/obama-favorable-chart.png) 


## Polls

To get the opinion poll results use the function ``pollstr_polls`.
The polls returned can be filtered by topic, chart, state, or date.

By default, ``pollstr_polls`` only returns 1 page of results (about 10 polls).
To have it return more polls, increase the value of ``max_pages``.
To have it return all polls, set the value of ``max_pages`` to a very high number.
For example, to return all the polls on the favorability of Bararck Obama after March 1, 2014,

```r
obama_favorable_polls <- pollstr_polls(max_pages = 10000, chart = "obama-favorable-rating", 
    after = "2014-3-1")
str(obama_favorable_polls)
```

```
## List of 2
##  $ polls    :'data.frame':	15 obs. of  9 variables:
##   ..$ id           : num [1:15] 19316 19256 19261 19252 19239 ...
##   ..$ pollster     : Factor w/ 8 levels "YouGov/Economist",..: 1 2 1 3 1 1 1 4 5 6 ...
##   ..$ start_date   : Date[1:15], format: "2014-04-19" ...
##   ..$ end_date     : Date[1:15], format: "2014-04-21" ...
##   ..$ method       : Factor w/ 2 levels "Internet","Phone": 1 2 1 2 1 1 1 1 2 2 ...
##   ..$ source       : Factor w/ 15 levels "http://d25d2506sfb94s.cloudfront.net/cumulus_uploads/document/lx2kkwdvcu/econToplines.pdf",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ last_updated : POSIXct[1:15], format: "2014-04-25 14:45:08" ...
##   ..$ survey_houses: chr [1:15] "" "" "" "" ...
##   ..$ sponsors     : chr [1:15] "" "" "" "" ...
##  $ questions:'data.frame':	971 obs. of  14 variables:
##   ..$ question       : Factor w/ 33 levels "US Right Direction Wrong Track",..: 1 1 1 2 2 2 2 2 3 3 ...
##   ..$ chart          : chr [1:971] "us-right-direction-wrong-track" "us-right-direction-wrong-track" "us-right-direction-wrong-track" "mike-huckabee-favorable-rating" ...
##   ..$ topic          : chr [1:971] "" "" "" "favorable-ratings" ...
##   ..$ state          : chr [1:971] "US" "US" "US" "US" ...
##   ..$ subpopulation  : Factor w/ 12 levels "Adults","Adults - Democrat",..: 1 1 1 1 1 1 1 1 1 1 ...
##   ..$ observations   : num [1:971] 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 ...
##   ..$ margin_of_error: num [1:971] 4.1 4.1 4.1 4.1 4.1 4.1 4.1 4.1 4.1 4.1 ...
##   ..$ choice         : Factor w/ 77 levels "Right Direction",..: 1 2 3 4 5 6 7 3 4 5 ...
##   ..$ value          : num [1:971] 32 55 13 13 21 13 18 34 24 19 ...
##   ..$ first_name     : chr [1:971] NA NA NA NA ...
##   ..$ last_name      : chr [1:971] NA NA NA NA ...
##   ..$ party          : chr [1:971] NA NA NA NA ...
##   ..$ incumbent      : logi [1:971] NA NA NA NA NA NA ...
##   ..$ id             : num [1:971] 19316 19316 19316 19316 19316 ...
##  - attr(*, "class")= chr "pollstr_polls"
```



# Misc

Also see an earlier R interface by [Drew Linzer](https://github.com/dlinzer/pollstR/).

<!--  LocalWords:  Huffpost API Huffington CRAN github devtools str
 -->
<!--  LocalWords:  devools jrnold ggplot obama url aes favorability
 -->
<!--  LocalWords:  Bararck suppressPackageStartupMessages eval
 -->
<!-- -->
<!--  LocalWords:  rOpenGov pollstR pollstr Linzer
 -->
