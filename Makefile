assets/examples.png : assets/examples.pdf
	convert -fill white -opaque none -density 300 -quality 90 $< $@

assets/examples.pdf : assets/examples.tex
	xelatex --file-line-error --interaction=nonstopmode -output-directory assets $<
