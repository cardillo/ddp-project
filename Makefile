SHELL:=/bin/bash

.DEFAULT: all
.PHONY: all

all:


.PHONY: test
test:
		Rscript --vanilla \
			-e 'library(shiny)' \
			-e 'runApp("src/r", 8080)'


.PHONY: deploy
deploy:
		Rscript --vanilla \
			-e 'library(rsconnect)' \
			-e 'rsconnect::deployApp("src/r", appName="yieldcurve")'
