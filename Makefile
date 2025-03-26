

SHELL=/bin/sh

.SUFFIXES: .tex .pdf

SOURCE="doc.tex"
FILES=$(wildcard doc.*)
GENERATED=$(patsubst doc.tex, , $(FILES))

.PHONY: info

info:
	@echo $(GENERATED)



.tex.pdf:
	@pdflatex $<
	
doc:pdf
.PHONY: pdf
pdf: clean doc.pdf

show: doc
	@$(VIEWER) doc.pdf

.PHONY: clean
clean:
	rm -f $(GENERATED) 

