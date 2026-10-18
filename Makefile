

SHELL=/bin/sh


CHECKMAKE_VERSION := v0.3.2
ACTIONLINT_VERSION := v1.7.12
MARKDOWNLINT_IMAGE_VERSION := v0.22.0
BLACK_VERSION := 26.5.1
CHECKMAKE := go run github.com/checkmake/checkmake/cmd/checkmake@$(CHECKMAKE_VERSION)
ACTIONLINT := go run github.com/rhysd/actionlint/cmd/actionlint@$(ACTIONLINT_VERSION)


# detect whether CONTAINER_CMD is set
ifeq ($(origin CONTAINER_CMD),undefined)
# try podman first
CONTAINER_CMD=$(shell podman version >/dev/null 2>&1 && echo podman)
ifeq ($(CONTAINER_CMD),)
#try docker if podman is not available
CONTAINER_CMD=$(shell docker version >/dev/null 2>&1 && echo docker)
endif
endif



.PHONY: check.container.runtime
check.container.runtime:
	$(if $(shell $(CONTAINER_CMD) version >/dev/null 2>&1 && echo available),,$(error no usable container runtime found. Install docker or podman, or set CONTAINER_CMD to a working command.))


LOCAL_MARKDOWNLINT := $(shell command -v markdownlint-cli2 2>/dev/null)
ifneq ($(LOCAL_MARKDOWNLINT),)
MARKDOWNLINT := $(LOCAL_MARKDOWNLINT)
else
MARKDOWNLINT := $(CONTAINER_CMD) run --rm -v $$PWD:/workdir --user $$(id -u):$$(id -g) --workdir /workdir davidanson/markdownlint-cli2:$(MARKDOWNLINT_IMAGE_VERSION)
MARKDOWNLINT_REQUIREMENTS := check.container.runtime
endif

LOCAL_BLACK := $(shell command -v black 2>/dev/null)
ifneq ($(LOCAL_BLACK),)
BLACK := $(LOCAL_BLACK)
else
BLACK := $(CONTAINER_CMD) run --rm --volume $$PWD:/src --user $$(id -u):$$(id -g) --workdir /src pyfound/black:$(BLACK_VERSION) black
BLACK_REQUIREMENTS := check.container.runtime
endif




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

.DEFAULT_GOAL := all
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
$(BASE): pdf
.PHONY: pdf
pdf: clean $(TARGET)

#$(TARGET): $(SOURCE) Makefile 

show:  $(TARGET)
	@$(VIEWER) $(TARGET)

.PHONY: clean
clean:
	rm -f $(GENERATED)


.PHONY: all
all: pdf


.PHONY: lint.make
lint.make: ## lint the makefile
	@echo "Checking the Makefile..."
	@$(CHECKMAKE) Makefile
	@echo "The Makefile is OK."


.PHONY: lint.workflows
lint.workflows:
	@echo "linting GitHub workflows..."
	@$(ACTIONLINT) --color
	@echo "all workflows are good."

.PHONY: lint.markdown
lint.markdown: $(MARKDOWNLINT_REQUIREMENTS)
	@echo "linting markdown files..."
	@$(MARKDOWNLINT) --verbose "**/**.md"
	@echo "all markdown files are good."

.PHONY: fix.markdown
fix.markdown: $(MARKDOWNLINT_REQUIREMENTS)
	@$(MARKDOWNLINT) --verbose --fix "**/**.md"


.PHONY: lint
lint: lint.make lint.workflows lint.markdown

.PHONY: test 
test: lint 
