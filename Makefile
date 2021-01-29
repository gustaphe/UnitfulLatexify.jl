.PHONY : clean

docs/examples.png : docs/examples.pdf
	convert -fill white -opaque none -density 300 -quality 90 $< $@

docs/examples.pdf : docs/examples.tex
	xelatex --file-line-error --interaction=nonstopmode -output-directory docs $<

docs/examples.tex : docs/makedocs.jl
	pushd docs; julia --project makedocs.jl

clean :
	$(RM) docs/examples.aux docs/examples.log docs/examples.pdf
