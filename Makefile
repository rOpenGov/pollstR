R = R
DOCKER = docker

PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

rmd_children = $(wildcard vignettes/children/*.Rmd)

all: README.md

README.md: README.Rmd $(rmd_chdildren)
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install(quick=TRUE);library(pollstR);library(knitr);knit("$<",output="$@")'

# Build using latest R-devel
build:
	$(R) CMD build .

install: build
	$(R) CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

check: build
	$(R) CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

check-devel: build
	$(DOCKER) run --rm -ti -v $(pwd):/mnt rocker/r-devel-ubsan-clang check.r --setwd /mnt --intall-deps $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

clean:
	$(RM) -r $(PKGNAME).Rcheck $(PKGNAME)*.tar.gz
