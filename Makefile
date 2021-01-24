.PHONY : clean

assets/examples.png : assets/examples.pdf
	convert -fill white -opaque none -density 300 -quality 90 $< $@

assets/examples.pdf : assets/examples.tex
	xelatex --file-line-error --interaction=nonstopmode -output-directory assets $<

clean :
	$(RM) assets/examples.aux assets/examples.log assets/examples.pdf
