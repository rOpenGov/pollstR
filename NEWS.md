# pollstR 2.0.0

* This is complete rewrite of the package for new Pollster API v2. It is new 
    API and backwards incompatible with previous verions of `PollstR`.
* Added `pkgdown` documentation
* Converted `NEWS` to `NEWS.md`

# pollstR 1.5.0

* `pollster_chart_data` and `pollster_house_effects` return data frames without additional pollster specific classes.
* Fix typos in documentation

# pollstR 1.4.0

* Renamed functions to start with `pollster_` since I kept misstyping them. However,
    the old function names beginnning with `pollstr_` still work.
* Renamed the classes returned by pollster functions to start with `pollster_`.
* Added function `pollster_chart_data` which returns all polls related to a chart.
* Added function `pollster_house_effects` which returns the pollster house effects for a chart.
* Pollster API changes: deprecated `topic` argument in `pollstr_polls` (#11);
  added `question` argument to `pollstr_polls` (#12)
* Edited and rewrote much of the vignette. The new example uses the 2016 General Election
    between Clinton and Trump.
* Miscellaneous non-user facing rewrites to code to make it more robust.

# pollstR 1.3.0

* Add `page` and `max_pages` arguments to `pollster_charts` function since the charts method in the API now takes a page argument. #10

# pollstR 1.2.2

* Add Drew Linzer as original author
* Bugfix: Removes polls where questions are incomplete so as not to cause errors. #8 (Thanks @olliemcdonald)

# pollstR 1.2.1

* Bugfix: fix R CMD check notes due to change in how it handles non-base default packages: http://developer.r-project.org/blosxom.cgi/R-devel/2015/06/29#n2015-06-29

# pollstR1.2.0

* Add showall argument to pollstr_charts and pollstr_polls

# pollstR 1.1.1

* Bugfix: ensure that character vectors do not get converted to factors
* Added section in documentation on errors in functions

# pollstR 1.1.0

* Bugfix: Update to new API # pollstR polls.
* Move testthat tests to inst

# pollstR 1.0.2

* Bugfix: fix test failures due to API change.
* Remove tests brittle to API changes so fewer CRAN check failures

# pollstR 1.0.1

* Bugfix: did not convert some election date fields

# pollstR 1.0.0

* submit to CRAN

# pollstR 0.2.0

Merge with http://github.com/jrnold/pollster. This is a complete rewrite of the client.

* ``getchart`` replaced with ``pollstr_charts``. Returns class ``pollstr_charts``.
* ``getchart`` replaced with ``pollstr_chart``. Returns class ``pollstr_chart``.
* ``getpolls`` replaced with ``pollstr_polls``. Returns class ``pollstr_polls``.
* ``xml`` API access no longer available.

# # pollstR 0.1

* Initial package release


