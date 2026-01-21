

SHELL=/bin/sh

.SUFFIXES: .tex .pdf

BASE=doc
TEX_SOURCE=$(BASE).tex
BIB_SOURCE=$(BASE).bib
TARGET=$(BASE).pdf

FILES_WC=$(wildcard $(BASE).*)
FILES_LS=$(shell ls $(BASE).*)
FILES=$(FILES_LS)

GENERATED_S=$(subst $(TEX_SOURCE), ,$(FILES))
GENERATED_S2=$(subst($(BIB_SOURCE), ,$(GENERATED_S))
GENERATED_FO=$(filter-out $(TEX_SOURCE),$(FILES))
GENERATED_FO2=$(filter-out $(BIB_SOURCE),$(GENERATED_FO))
GENERATED=$(GENERATED_FO2)

.PHONY: info

info:
	@echo    tex source: $(TEX_SOURCE)
	@echo    bib source: $(BIB_SOURCE)
	@echo        target: $(TARGET)
	@echo  all files wc: $(FILES_WC)
	@echo  all files ls: $(FILES_LS)
	@echo     all files: $(FILES)
	@echo   gen-files s:  $(GENERATED_S)
	@echo  gen-files s2: $(GENERATED_S2)
	@echo  gen-files fo: $(GENERATED_FO)
	@echo gen-files-fo2: $(GENERATED_FO2)
	@echo     gen-files: $(GENERATED)



.tex.pdf:
	@pdflatex $(basename $<)
	@pdflatex $(basename $<)
	@bibtex $(basename $<)
	@makeindex $(basename $<)
	@pdflatex $(basename $<)
	@pdflatex $(basename $<)

.PHONY: $(BASE)
	
$BASE): pdf
.PHONY: pdf
pdf: clean $(TARGET)

$(TARGET): $(SOURCE)

show:  $(BASE)
	@$(VIEWER) $(TARGET)

.PHONY: clean
clean:
	rm -f $(GENERATED)

