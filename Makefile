# Makefile to make all the PDF files needed

# Main Latex source file
MAIN = example.tex

# Lectures
LECTURES = 01

# Cleaning
CLEAN=.aux .log .nav .out .snm .toc .vrb .synctex.gz .pyc .bbl .blg .idx .fls .fdb_latexmk

# Latex to use
LATEX=lualatex

# Default target
default : current

# Current
current : $(MAIN)
	$(LATEX) "$(MAIN)"
	grep -q "rerunfilecheck Warning" "$@.log" && $(LATEX) "$(MAIN)"

# All
all : slides handouts

# All slides
slides : $(addprefix slides-, $(LECTURES))

# All handouts
handouts : $(addprefix handout-, $(LECTURES))

# Individual slides
slides-% : $(MAIN)
	$(LATEX) -jobname "$@" "\def\uselecture{$*}\input{$(MAIN)}"
	grep -q "rerunfilecheck Warning" "$@.log" && $(LATEX) -jobname "$@" "\def\uselecture{$*}\input{$(MAIN)}"
	@mkdir -p slides
	@mv -f "$@.pdf" slides
	@rm -f $(addprefix $@, $(CLEAN))

# Individual slides
handout-% : $(MAIN)
	$(LATEX) -jobname "$@" "\def\uselecture{$*}\PassOptionsToClass{handout}{beamer}\input{$(MAIN)}"
	grep -q "rerunfilecheck Warning" "$@.log" && $(LATEX) -jobname "$@" "\def\uselecture{$*}\PassOptionsToClass{handout}{beamer}\input{$(MAIN)}"
	@mkdir -p handouts
	@mv -f "$@.pdf" handouts
	@rm -f $(addprefix $@, $(CLEAN))

# Other targets
clean :
	@rm -f $(addprefix *, $(CLEAN))

remake : cleanpdf all

dummy : ;

.PHONY : default all lectures clean cleanpdf remake dummy
