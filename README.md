# R client for the Pollster API #

[![Build Status](https://travis-ci.org/leeper/pollstR.png?branch=master)](https://travis-ci.org/leeper/pollstR)

The **pollstR** package provides access to the [Huffington Post](http://www.huffingtonpost.com/) [Pollster API](http://elections.huffingtonpost.com/pollster/api).

The package is released under GPL-2 and the API data it accesses is released under the [Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License](http://creativecommons.org/licenses/by-nc-sa/3.0/deed.en_US).

## Charts and Polls ##

The Pollster API has two primary data structures: charts and polls.

*Polls* are individual, dated topline results for a single set of candidates in a single race. The poll data structure consists of (generally) named candidates and percentage support for each, along with additional information (e.g., polling house, sampling frame, sample size, margin of error, state, etc.).

*Charts* aggregate polls for a particular race or topic (e.g., "2012-president" or "obama-job-approval". A chart reports aggregated survey estimates of support for the candidates in a given race and, possibly, daily estimates of support. Each chart is named, reports the number of aggregated polls it presents, a last-updated date, and a "slug" field. The "slug" identifies the chart both in the API and on the Pollster website.

## Functions ##

The package consists of three simple functions, described below.

### chartlist ###

To obtain a dataframe of available charts (and associated metadata), use the `chartlist` function. This returns a two-element list containing, (1) a dataframe of all charts, and (2) a list of aggregated estimates for those charts. This can be narrowed down to a particular topic or state, e.g.,

```
> chartlist(state='WY')
$charts
                                    title                                   slug              topic state                  short_title poll_count
2             Wyoming: Obama Job Approval             wyoming-obama-job-approval obama-job-approval    WY       WY: Obama Job Approval          2
21 2014 Wyoming Senate Republican Primary 2014-wyoming-senate-republican-primary        2014-senate    WY WY Senate Republican Primary          2
           last_updated                                                                                 url
2  2013-07-23T17:17:57Z             http://elections.huffingtonpost.com/pollster/wyoming-obama-job-approval
21 2013-07-23T17:17:57Z http://elections.huffingtonpost.com/pollster/2014-wyoming-senate-republican-primary

$estimates
$estimates$`wyoming-obama-job-approval`
data frame with 0 columns and 0 rows

$estimates$`2014-wyoming-senate-republican-primary`
data frame with 0 columns and 0 rows
```

In the above example, Wyoming has no state-level estimates associated with either available chart due to a lack of available polling data.

### getchart ###

To obtain a particular chart and its associated poll results, use the `getchart` function, e.g.,

```
> getchart('2012-general-election-romney-vs-obama', fmt='xml')
Title:       2012 General Election: Romney vs. Obama 
Chart Slug:  2012-general-election-romney-vs-obama 
Topic:       2012-president 
State:       US 
Polls:       589 
Updated:     2012-11-26T15:31:23Z 
URL:         http://elections.huffingtonpost.com/pollster/2012-general-election-romney-vs-obama 
Estimates:
  choice value lead_confidence first_name last_name party incumbent
1  Obama  48.2            true     Barack     Obama   Dem      true
2 Romney  46.7            true       Mitt    Romney   Rep     false


> getchart('2012-general-election-romney-vs-obama', fmt='json')
Title:       2012 General Election: Romney vs. Obama 
Chart Slug:  2012-general-election-romney-vs-obama 
Topic:       2012-president 
State:       US 
Polls:       589 
Updated:     2012-11-26T15:31:23Z 
URL:         http://elections.huffingtonpost.com/pollster/2012-general-election-romney-vs-obama 
Estimates:
  choice value lead_confidence first_name last_name party incumbent
1  Obama  48.2            NULL     Barack     Obama   Dem      TRUE
2 Romney  46.7            NULL       Mitt    Romney   Rep     FALSE

First 6 (of 309) estimates by date:
        date Obama Romney Other
1 2012-11-04  48.2   46.7   5.1
2 2012-11-03  48.2   46.7   5.1
3 2012-11-02  48.2   46.6   5.2
4 2012-11-01  48.1   46.6   5.3
5 2012-10-31  48.0   46.7   5.3
6 2012-10-30  47.8   46.8   5.4
```

Note: Requesting `fmt='xml'` only returns overall estimates, whereas requestion `fmt='json'` returns daily estimates, if available.

### getpolls ###

The last function in **pollstR** provides comprehensive access to the polling data underlying the Pollster charts. This function is adapted from [code originally written by Drew Linzer](https://github.com/dlinzer/pollstR).

```
> getpolls('2013-house')
## COMING SOON
```