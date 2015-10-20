# Set TRG to the name of your document (without the ".tex").
TRG = report
BIBS := $(wildcard *.bib) $(wildcard ../../bibtex/*.bib)
TEXS := $(wildcard *.tex)

# You should not need to change anything below this line.
TEX = latex
BIB = bibtex
PDF = dvipdf
PS = dvips
RM = rm -f
GS = gs -sDEVICE=pdfwrite -q -dBATCH -dNOPAUSE -dSAFER -dPDFX -dPDFSETTINGS=/prepress -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dAutoFilterGrayImages=false -dGrayImageFilter=/FlateEncode -sOutputFile=$(TRG).pdf -c '<</NeverEmbed []>> setdistillerparams'  -f $(TRG).tmp.pdf -c quit

all: $(TRG).bbl makedvi $(TRG).pdf 

print: all
	$(PS) $(TRG).dvi

$(TRG).bbl: $(TEXS) $(BIBS)
	$(TEX) $(TRG)
	$(BIB) $(TRG)

makedvi: $(TRG).tex
	$(TEX) $(TRG) 
	$(TEX) $(TRG) 

$(TRG).pdf: $(TRG).dvi
	$(PDF) $(TRG).dvi $(TRG).pdf
# Mon Mar 14 16:48:18 PDT 2011
# Chen - I'm abandoning the following commands for generating the final pdf, due to 1.4 PDF compatibility issue for IEEE digital library
#        Do the following instead: (i) make print for a ps file, and then 
#        (ii) ps2pdf -dCompatibilityLevel=1.4 -dPDFSETTINGS=/prepress icme11.ps icme11.pdf
#
# Final version requires font embedded, comment the above line, and uncomment the following 3 lines 
	#$(PDF) $(TRG).dvi $(TRG).tmp.pdf
	#$(GS) 
	#$(RM) $(TRG).tmp.pdf

clean:
	$(RM) $(TRG).aux
	$(RM) $(TRG).dvi
	$(RM) $(TRG).log
	$(RM) $(TRG).tmp.pdf
	$(RM) $(TRG).pdf
	$(RM) $(TRG).bbl
	$(RM) $(TRG).blg

