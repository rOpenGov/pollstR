PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)

rmd_children = $(wildcard inst/vign/children/*.Rmd)

all: vignettes vignettes/introduction.Rmd README.md

README.md: README.Rmd $(rmd_chdildren)
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install(quick=TRUE);library(pollstR);library(knitr);knit("$<",output="$@")'

inst/vign/introduction.md: inst/vign/introduction.Rmd $(rmd_chdildren)
	cd $(dir $@) ; \
	Rscript -e 'library(devtools);dev_mode(on=TRUE,path=tempdir());install("../../",quick=TRUE);library(pollstR);library(knitr);knit("$(notdir $^)",output="$(notdir $@)")'

vignettes:
	-mkdir vignettes
	-mkdir vignettes/assets

vignettes/introduction.Rmd: inst/vign/introduction.md
	sed -e 's/(figures\//(assets\//' $< > $@
	cp inst/vign/figures/* vignettes/assets/

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
