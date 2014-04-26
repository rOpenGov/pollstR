all: vignettes vignettes/introduction.Rmd README.md

%.md: %.Rmd
	Rscript -e 'library(knitr);knit("$<",output="$@")'

README.md: README.Rmd

inst/vign/introduction.md: inst/vign/introduction.Rmd

vignettes:
	-mkdir vignettes

vignettes/introduction.Rmd: inst/vign/introduction.md
	sed -e 's/inst\/vign\/figures/figures/' $^ > $@
	cp -r inst/vign/figures/ vignettes/
