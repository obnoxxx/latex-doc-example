

SHELL=/bin/sh

.SUFFIXES: .tex .pdf

BASE=doc
SOURCE=$(BASE).tex
TARGET=$(BASE).pdf

FILES_WC=$(wildcard $(BASE).*)
FILES_LS=$(shell ls $(BASE).*)
FILES=$(FILES_LS)

GENERATED_S=$(subst $(SOURCE), ,$(FILES))
GENERATED_FO=$(filter-out $(SOURCE),$(FILES))
GENERATED=$(GENERATED_FO)

.PHONY: info

info:
	@echo       source: $(SOURCE)
	@echo       target: $(TARGET)
	@echo all files wc: $(FILES_WC)
	@echo all files ls: $(FILES_LS)
	@echo    all files: $(FILES)
	@echo  gen-files-s:  $(GENERATED_S)
	@echo gen-files-fo: $(GENERATED_FO)
	@echo    gen-files: $(GENERATED)



.tex.pdf:
	@pdflatex $<
	@makeindex $<
	@pdflatex $<
	@pdflatex $<

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

