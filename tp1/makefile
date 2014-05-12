doc: build/informe.pdf

build:
	-mkdir -p build/images

build/informe.pdf: build build/images/der.jpeg
	pdflatex --output-directory build doc/informe.tex
	pdflatex --output-directory build doc/informe.tex
	pdflatex --output-directory build doc/informe.tex

build/images/der.jpeg:
	dia --export=build/images/der.jpeg --filter=jpeg doc/diagramas/der.dia

clean:
	rm -rf build
	rm -f informe.pdf

doc-preview: doc build/informe.pdf
	cp build/informe.pdf .
	evince informe.pdf &
