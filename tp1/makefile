DB_NAME=agenda_medica
DB_SERVER=localhost
DB_USER=postgres
DB_DRIVER=tools/postgresql-9.3-1100.jdbc41.jar
DB_TYPE=pgsql

doc: build/informe.pdf

build:
	@echo ''
	@echo 'Creando los directorios necesarios para generar las salidas'
	@echo ''
	-mkdir -p build/images
	-mkdir -p build/schema

build/informe.pdf: build build/images/der.jpeg
	@echo ''
	@echo 'Convirtiendo el informe de TEX >> PDF'
	@echo ''
	pdflatex --output-directory build doc/informe.tex
	pdflatex --output-directory build doc/informe.tex
	pdflatex --output-directory build doc/informe.tex

build/images/der.jpeg:
	@echo ''
	@echo 'Exportando imagen del DER desde DIA >> JPEG'
	@echo ''
	dia --export=build/images/der.jpeg --filter=jpeg doc/diagramas/der.dia

clean:
	@echo ''
	@echo 'Borrando los directorios de resultados'
	@echo ''
	rm -rf build
	rm -f informe.pdf

doc-preview: doc build/informe.pdf
	@echo ''
	@echo 'Compilar el informe y mostrarme el resultado'
	@echo ''
	cp build/informe.pdf .
	evince informe.pdf &

psql: build scripts/script_creacion_db.sql
	@echo ''
	@echo 'Crear base de datos $(DB_NAME). Insertando script de creación sobre la base de datos.'
	@echo ''
	dropdb -h $(DB_SERVER) -U $(DB_USER) $(DB_NAME)
	createdb -h $(DB_SERVER) -U $(DB_USER) $(DB_NAME)
	$@ -h $(DB_SERVER) -U $(DB_USER) -d $(DB_NAME) < scripts/script_creacion_db.sql
	
relacional: psql tools/schemaSpy_5.0.0.jar
	@echo ''
	@echo 'Generando los escquemas del diagrama relacional a partir de la información alojada en la base de datos.'
	@echo ''
	java -jar tools/schemaSpy_5.0.0.jar -t $(DB_TYPE) -dp $(DB_DRIVER) -host $(DB_SERVER) -db $(DB_NAME) -s public -u $(DB_USER) -o build/schema

