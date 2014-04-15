


# R interface to the Huffpost Pollster API

This R package is an interface to the Huffington Post [Pollster API](http://elections.huffingtonpost.com/pollster/api), which provides access to opinion polls collected by the Huffington Post.

# Install

Currently this package is **unstable** and may change.

This package is not *yet* on CRAN.

You can install this with the function ``install_github`` in the **devtools** package.

```r
install.packages("devools")
library("devtools")
install_github("jrnold/pollster")
```


```r
library("pollster")
```


# Examples

## Charts

To get a list of all the charts in the API use the function ``pollster_charts``,

```r
charts <- pollster_charts()
str(charts)
```

```
## List of 2
##  $ charts   :'data.frame':	467 obs. of  8 variables:
##   ..$ title       : Factor w/ 467 levels "2012 Iowa GOP Primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ slug        : Factor w/ 466 levels "2012-iowa-gop-primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ topic       : Factor w/ 15 levels "2012-gop-primary",..: 1 1 1 1 1 1 1 1 2 3 ...
##   ..$ state       : Factor w/ 51 levels "IA","NH","SC",..: 1 2 3 4 5 6 7 8 8 8 ...
##   ..$ short_title : Factor w/ 467 levels "1/3 Iowa Caucus",..: 1 2 3 4 5 6 7 8 9 10 ...
##   ..$ poll_count  : num [1:467] 65 55 44 59 10 34 19 258 127 589 ...
##   ..$ last_updated: POSIXct[1:467], format: "2012-01-02 13:08:44" ...
##   ..$ url         : Factor w/ 466 levels "http://elections.huffingtonpost.com/pollster/2012-iowa-gop-primary",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ estimates:'data.frame':	1110 obs. of  8 variables:
##   ..$ choice         : Factor w/ 311 levels "Romney","Paul",..: 1 2 3 4 5 6 7 8 9 1 ...
##   ..$ value          : num [1:1110] 22.5 21.3 15.9 12.6 11.1 8.3 3.7 5.9 0.9 39.6 ...
##   ..$ lead_confidence: num [1:1110] NA NA NA NA NA NA NA NA NA NA ...
##   ..$ first_name     : chr [1:1110] "Mitt" "Ron" "Rick" "Newt" ...
##   ..$ last_name      : chr [1:1110] "Romney" "Paul" "Santorum" "Gingrich" ...
##   ..$ party          : chr [1:1110] "Rep" "Rep" "Rep" "Rep" ...
##   ..$ incumbent      : logi [1:1110] FALSE FALSE FALSE FALSE FALSE FALSE ...
##   ..$ slug           : chr [1:1110] "2012-iowa-gop-primary" "2012-iowa-gop-primary" "2012-iowa-gop-primary" "2012-iowa-gop-primary" ...
```

This returns a ``list`` with two data frames.
The data frame ``charts`` has data on each chart,
while the data frame ``estimates`` has the current poll-tracking estimates from each chart.

The query can be filtered by state or topic.
For example, to get only charts related to national topics,

```r
us_charts <- pollster_charts(state = "US")
```


## Charts

To get a particular chart use the function ``pollster_chart``.
For example, to get the chart for [Barack Obama's Favorable Rating](http://elections.huffingtonpost.com/pollster/obama-favorable-rating), specify its *slug*, ``obama-favorable-rating``.

```r
obama_favorable <- pollster_chart("obama-favorable-rating")
str(obama_favorable)
```

```
## List of 10
##  $ title            : chr "Barack Obama Favorable Rating"
##  $ slug             : chr "obama-favorable-rating"
##  $ topic            : chr ""
##  $ state            : chr "US"
##  $ short_title      : chr "Obama Favorability"
##  $ poll_count       : num 800
##  $ last_updated     : POSIXct[1:1], format: "2014-04-14 16:45:21"
##  $ url              : chr "http://elections.huffingtonpost.com/pollster/obama-favorable-rating"
##  $ estimates        :'data.frame':	3 obs. of  7 variables:
##   ..$ choice         : Factor w/ 3 levels "Favorable","Unfavorable",..: 1 2 3
##   ..$ value          : num [1:3] 45.7 48.8 4.4
##   ..$ lead_confidence: logi [1:3] NA NA NA
##   ..$ first_name     : logi [1:3] NA NA NA
##   ..$ last_name      : logi [1:3] NA NA NA
##   ..$ party          : logi [1:3] NA NA NA
##   ..$ incumbent      : logi [1:3] NA NA NA
##  $ estimates_by_date:'data.frame':	2110 obs. of  3 variables:
##   ..$ choice: Factor w/ 6 levels "Favorable","Undecided",..: 1 2 3 1 2 3 1 2 3 4 ...
##   ..$ value : num [1:2110] 45.7 4.4 48.8 45.6 4.4 48.8 45.6 4.4 48.9 1.4 ...
##   ..$ date  : Date[1:2110], format: "2014-04-07" ...
```

The slug can be found from the results of a ``pollster_charts`` query.
Alternatively the slug is the path of the url of a chart, http://elections.huffingtonpost.com/pollster/obama-favorable-rating.

The historical estimates of the Huffpost Pollster poll-tracking model are contained in the element ``"estimates_by_date"``,

```r
(ggplot(obama_favorable[["estimates_by_date"]], aes(x = date, y = value, color = choice)) + 
    geom_line())
```

![plot of chunk obama-favorable-chart](inst/figure/obama-favorable-chart.png) 


## Polls

To get the opinion poll results use the function ``pollster_polls`.
The polls returned can be filtered by topic, chart, state, or date.

By default, ``pollster_polls`` only returns 1 page of results (about 10 polls).
To have it return more polls, increase the value of ``max_pages``.
To have it return all polls, set the value of ``max_pages`` to a very high number.
For example, to return all the polls on the favorability of Bararck Obama after March 1, 2014,

```r
obama_favorable_polls <- pollster_polls(max_pages = 10000, chart = "obama-favorable-rating", 
    after = "2014-3-1")
str(obama_favorable_polls)
```

```
## List of 2
##  $ polls    :'data.frame':	10 obs. of  9 variables:
##   ..$ id           : num [1:10] 19239 19169 19132 19137 19172 ...
##   ..$ pollster     : Factor w/ 6 levels "YouGov/Economist",..: 1 1 1 2 3 4 1 1 5 6
##   ..$ start_date   : Date[1:10], format: "2014-04-05" ...
##   ..$ end_date     : Date[1:10], format: "2014-04-07" ...
##   ..$ method       : Factor w/ 2 levels "Internet","Phone": 1 1 1 1 2 2 1 1 2 2
##   ..$ source       : Factor w/ 10 levels "http://d25d2506sfb94s.cloudfront.net/cumulus_uploads/document/sh204vkzrt/econToplines.pdf",..: 1 2 3 4 5 6 7 8 9 10
##   ..$ last_updated : POSIXct[1:10], format: "2014-04-14 16:51:49" ...
##   ..$ survey_houses: chr [1:10] "" "" "" "" ...
##   ..$ sponsors     : chr [1:10] "" "" "" "" ...
##  $ questions:'data.frame':	616 obs. of  14 variables:
##   ..$ question       : chr [1:616] "US Right Direction Wrong Track" "US Right Direction Wrong Track" "US Right Direction Wrong Track" "Rand Paul Favorable Rating" ...
##   ..$ chart          : chr [1:616] "us-right-direction-wrong-track" "us-right-direction-wrong-track" "us-right-direction-wrong-track" "rand-paul-favorable-rating" ...
##   ..$ topic          : chr [1:616] "" "" "" "" ...
##   ..$ state          : chr [1:616] "US" "US" "US" "US" ...
##   ..$ subpopulation  : chr [1:616] "Adults" "Adults" "Adults" "Adults" ...
##   ..$ observations   : num [1:616] 1000 1000 1000 1000 1000 1000 1000 1000 1000 1000 ...
##   ..$ margin_of_error: num [1:616] 4.2 4.2 4.2 4.2 4.2 4.2 4.2 4.2 4.2 4.2 ...
##   ..$ choice         : chr [1:616] "Right Direction" "Wrong Track" "Undecided" "Very Favorable" ...
##   ..$ value          : num [1:616] 28 59 13 14 21 15 19 31 24 20 ...
##   ..$ first_name     : chr [1:616] NA NA NA NA ...
##   ..$ last_name      : chr [1:616] NA NA NA NA ...
##   ..$ party          : chr [1:616] NA NA NA NA ...
##   ..$ incumbent      : logi [1:616] NA NA NA NA NA NA ...
##   ..$ id             : num [1:616] 19239 19239 19239 19239 19239 ...
```



# Misc

Also see an earlier R interface by [Drew Linzer](https://github.com/dlinzer/pollstR/).

<!--  LocalWords:  Huffpost API Huffington CRAN github devtools str
 -->
<!--  LocalWords:  devools jrnold ggplot obama url aes favorability
 -->
<!--  LocalWords:  Bararck
 -->
