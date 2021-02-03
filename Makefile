.PHONY : clean, all

all : docs/examples.png docs/allunits.png

docs/%.png : docs/%.pdf
	convert -fill white -opaque none -density 600 -quality 90 $< $@

docs/%.pdf : docs/%.tex
	- xelatex --file-line-error --interaction=nonstopmode -output-directory docs $<

docs/examples.tex docs/allunits.tex : docs/makedocs.jl
	pushd docs; julia --project makedocs.jl

clean :
	$(RM) docs/*.aux docs/*.log docs/examples.pdf docs/examples.tex docs/allunits.pdf docs/allunits.tex
