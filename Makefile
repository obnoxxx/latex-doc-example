

SHELL=/bin/sh

.SUFFIXES: .md .tex .pdf

BASE=doc
TEX_SOURCE=$(BASE).tex
BIB_SOURCE=$(BASE).bib
MK_SOURCE=Makefile
MD_SOURCE=README.md
LI_SOURCE=LICENSE

TARGET=$(BASE).pdf

FILES_WC=$(wildcard $(BASE).*)
FILES_WC=$(wildcard *)
FILES_LS=$(shell ls $(BASE).*)
FILES_LS=$(shell ls *)
FILES=$(FILES_LS)

GENERATED_S=$(subst $(TEX_SOURCE), ,$(FILES))
GENERATED_S2=$(subst($(BIB_SOURCE), ,$(GENERATED_S))
GENERATED_S3=$(subst($(MK_SOURCE), ,$(GENERATED_S2))
GENERATED_S4=$(subst($(MD_SOURCE), ,$(GENERATED_S2))
GENERATED_S5=$(subst($(LI_SOURCE), ,$(GENERATED_S4))
GENERATED_FO=$(filter-out $(TEX_SOURCE),$(FILES))
GENERATED_FO2=$(filter-out $(BIB_SOURCE),$(GENERATED_FO))
GENERATED_FO3=$(filter-out $(MK_SOURCE),$(GENERATED_FO2))
GENERATED_FO4=$(filter-out $(MD_SOURCE),$(GENERATED_FO3))
GENERATED_FO5=$(filter-out $(LI_SOURCE),$(GENERATED_FO4))
GENERATED=$(GENERATED_FO5)

.PHONY: info

info:
	@echo    tex source: $(TEX_SOURCE)
	@echo    bib source: $(BIB_SOURCE)
	@echo     mk source: $(MK_SOURCE)
	@echo     md source: $(MD_SOURCE)
	@echo     li source: $(LI_SOURCE)
	@echo        target: $(TARGET)
	@echo  all files wc: $(FILES_WC)
	@echo  all files ls: $(FILES_LS)
	@echo     all files: $(FILES)
	@echo   gen-files s: $(GENERATED_S)
	@echo  gen-files s2: $(GENERATED_S2)
	@echo  gen-files s3: $(GENERATED_S3)
	@echo  gen-files s4: $(GENERATED_S4)
	@echo  gen-files s5: $(GENERATED_S5)
	@echo  gen-files fo: $(GENERATED_FO)
	@echo gen-files fo2: $(GENERATED_FO2)
	@echo gen-files fo3: $(GENERATED_FO3)
	@echo gen-files fo4: $(GENERATED_FO4)
	@echo gen-files fo5: $(GENERATED_FO5)
	@echo gen-files: $(GENERATED)



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

