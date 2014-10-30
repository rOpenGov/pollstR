PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

rmd_children = $(wildcard inst/vign-src/children/*.Rmd)

all: vignettes vignettes/introduction.Rmd README.md

README.md: README.Rmd $(rmd_chdildren)
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install(quick=TRUE);library(pollstR);library(knitr);knit("$<",output="$@")'

inst/vign-src/introduction.md: inst/vign-src/introduction.Rmd $(rmd_chdildren)
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install(".",quick=TRUE);library(pollstR);library(knitr);knit("$^",output="$@")'

inst/doc/introduction.html: inst/vign-src/introduction.Rmd $(rmd_chdildren)
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install(".",quick=TRUE);library(pollstR);library(knitr);knit2html("$^",output="$@")'

vignettes:
	-mkdir vignettes
	-mkdir vignettes/assets

vignettes/introduction.Rmd: inst/vign-src/introduction.md
	sed -e 's/(inst\/vign-src\/figures\//(assets\//' $< > $@
	cp inst/vign-src/figures/* vignettes/assets/

build:
	cd ..;\
	R CMD build --no-manual $(PKGSRC)

install: build
	cd ..;\
	R CMD INSTALL $(PKGNAME)_$(PKGVERS).tar.gz

check: build
	cd ..;\
	R CMD check $(PKGNAME)_$(PKGVERS).tar.gz --as-cran

clean:
	cd ..;\
	$(RM) -r $(PKGNAME).Rcheck/
