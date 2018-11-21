DOCTYPE = DMTN
DOCNUMBER = 101
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)

GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

export TEXMFHOME = lsst-texmf/texmf

$(DOCNAME).pdf: $(DOCNAME).tex meta.tex
	xelatex $(DOCNAME)
	bibtex $(DOCNAME)
	xelatex $(DOCNAME)
	xelatex $(DOCNAME)

.PHONY: clean
clean:
	rm -f $(DOCNAME).aux
	rm -f $(DOCNAME).bbl
	rm -f $(DOCNAME).blg
	rm -f $(DOCNAME).log
	rm -f $(DOCNAME).out
	rm -f $(DOCNAME).pdf
	rm -f $(DOCNAME).rec
	rm -f $(DOCNAME).toc
	rm -f meta.tex

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	echo '% GENERATED FILE -- edit this in the Makefile' >>$@
	/bin/echo '\newcommand{\lsstDocType}{$(DOCTYPE)}' >>$@
	/bin/echo '\newcommand{\lsstDocNum}{$(DOCNUMBER)}' >>$@
	/bin/echo '\newcommand{\vcsRevision}{$(GITVERSION)$(GITDIRTY)}' >>$@
	/bin/echo '\newcommand{\vcsDate}{$(GITDATE)}' >>$@
