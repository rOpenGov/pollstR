all: vignettes vignettes/introduction.Rmd README.md

RMD_CHILDREN = $(wildcard inst/vign/children/*.Rmd)

README.md: README.Rmd
	Rscript -e 'library(knitr);knit("$<",output="$@")'

inst/vign/introduction.md: inst/vign/introduction.Rmd $(RMD_CHDILDREN)
	cd $(dir $@) ; \
	Rscript -e 'library(knitr);knit("$(notdir $^)",output="$(notdir $@)")'

vignettes:
	-mkdir vignettes

vignettes/introduction.Rmd: inst/vign/introduction.md
	sed -e 's/inst\/vign\/figures/figures/' $^ > $@
	cp -r inst/vign/figures/ vignettes/
