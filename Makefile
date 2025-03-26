

.SUFFIXES: .tex .pdf

.tex.pdf:
	@pdflatex $<

.PHONY: pdf
pdf: doc.pdf

