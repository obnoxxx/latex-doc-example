

.SUFFIXES: .tex .pdf

.tex.pdf:
	@pdflatex $<
	
doc:pdf
.PHONY: pdf
pdf: doc.pdf

show: doc
	@$(VIEWER) doc.pdf


