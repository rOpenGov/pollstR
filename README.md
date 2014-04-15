# R interface to the Huffpost Pollster API

This R package is an interface to the Huffington Post [Pollster API](http://elections.huffingtonpost.com/pollster/api), which provides access to opinion polls collected by the Huffington Post.

# Install

Currently this package is **unstable** and may change.

This package is not *yet* on CRAN.

You can install this with the function ``install_github`` in the **devtools** package.
```R
install.packages("devools")
library("devtools")
install_github("jrnold/pollster")
```

# Examples

To get a list of all the charts in the API use the function ``pollster_charts``,
```R
library("ggplot2")
charts <- pollster_charts()
str(charts)
```
This returns a ``list`` with two data frames.
The data frame ``charts`` has data on each chart,
while the data frame ``estimates`` has the current poll-tracking estimates from each chart.

The query can be filtered by state or topic.
For example, to get only charts related to national topics,
```R
us_charts <- pollster_charts(state = "US")
```

To get a particular chart use the function ``pollster_chart``.
For example, to get the chart for [Barack Obama's Favorable Rating](http://elections.huffingtonpost.com/pollster/obama-favorable-rating), specify its *slug*, ``obama-favorable-rating``.
```R
obama_favorable <- pollster_chart('obama-favorable-rating')
str(obama_favorable)
```
The slug can be found from the results of a ``pollster_charts`` query.
Alternatively the slug is the path of the url of a chart, http://elections.huffingtonpost.com/pollster/obama-favorable-rating.

The historical estimates of the Huffpost Pollster poll-tracking model are contained in the element ``"estimates_by_date"``,
```R
(ggplot(foo[["estimates_by_date"]], aes(x = date, y = value, color = choice))
 + geom_line())
```

To get the poll results for individual charts use the function ``pollster_polls`.
The polls can be filtered by topic, chart, state, or date.


By default, ``pollster_polls`` only returns 1 page of results (about 10 polls).
To have it return more polls, increase the value of ``max_pages``.
To have it return all polls, set the value of ``max_pages`` to a very high number.
For example, to return all the polls on the favorability of Bararck Obama after 
```R
obama_favorable_polls <- pollster_polls(max_pages = 10000, chart = 'obama-favorable-rating', after = "2014-3-1")
str(obama_favorable_polls)	
```


# Misc

Also see an earlier R interface by [Drew Linzer](https://github.com/dlinzer/pollstR/).

<!--  LocalWords:  Huffpost API Huffington CRAN github devtools str
 -->
<!--  LocalWords:  devools jrnold ggplot obama url aes favorability
 -->
<!--  LocalWords:  Bararck
 -->
