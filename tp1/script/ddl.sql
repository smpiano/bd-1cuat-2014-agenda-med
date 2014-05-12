create table domicilio(
	codigo_domicilio	INTEGER NOT NULL,	
	provincia		CHAR(10),
	localidad		CHAR(10),
	calle			CHAR(10),
	numero		CHAR(10),
	piso			CHAR(10),
	PRIMARY KEY (codigo_domicilio)
	);
	

create table obra_social(
	razon_social		CHAR(30) NOT NULL,	
	tipo_entidad		CHAR(30),
	PRIMARY KEY (razon_social)
	);	
	

create table plan(
	razon_social		CHAR(30) NOT NULL,
	nombre_plan		CHAR(10) NOT NULL,	
	PRIMARY KEY (razon_social, nombre_plan),
	FOREIGN KEY (razon_social) REFERENCES obra_social
	);		


create table especialidad(
	codigo_especialidad	INTEGER NOT NULL,	
	descripcion		CHAR(50),
	PRIMARY KEY (codigo_especialidad)
	);		

	
create table subespecialidad(
	codigo_especialidad		INTEGER NOT NULL,	
	descripcion_subespecialidad	CHAR(50) NOT NULL,
	PRIMARY KEY (codigo_especialidad, descripcion_subespecialidad),
	FOREIGN KEY (codigo_especialidad) REFERENCES especialidad
	);

	
create table accion_medica(
	codigo_accion_medica		CHAR(10) NOT NULL,	
	unidades			INTEGER
	condiciones_paciente		CHAR(50),
	descripcion			CHAR(100),
	PRIMARY KEY (codigo_accion_medica)
	);	

create table convenio(
	nombre_plan			CHAR(10) NOT NULL,	
	razon_social			CHAR(30) NOT NULL,
	codigo_accion_medica		CHAR(10) NOT NULL,
	documentacion_requerida	CHAR(100),
	monto				DECIMAL(10,2),
	porcentaje_exencion		DECIMAL(10,2),
	PRIMARY KEY (nombre_plan , razon_social, codigo_accion_medica),
	FOREIGN KEY (razon_social , nombre_plan) REFERENCES plan,
	FOREIGN KEY (codigo_accion_medica) REFERENCES accion_medica
	);	
		
	
create table profesional(
	tipo_doc_profesional		CHAR(10) NOT NULL,
	numero_doc_profesional  	INTEGER NOT NULL,	
	apellido_nombre		CHAR(50),
	email				CHAR(20),
	numero_matricula		INTEGER,
	celular				CHAR(10),
	codigo_especialidad		INTEGER,
    	codigo_domicilio 		INTEGER,
	PRIMARY KEY (tipo_doc_profesional, numero_doc_profesional),
	FOREIGN KEY (codigo_especialidad) REFERENCES especialidad,
	FOREIGN KEY (codigo_domicilio)	REFERENCES domicilio
	);
	
	
create table paciente(
	tipo_doc_paciente   		CHAR(10) NOT NULL,	
	numero_doc_paciente		INTEGER NOT NULL,
	numero_afiliado		INTEGER NOT NULL,
	fecha_nacimiento		CHAR(10),
	lugar_nacimiento		CHAR(30),
	tipo_beneficiario		CHAR(10),
    	telefono		 	CHAR(10) NOT NULL,
    	email			 	CHAR(20),
    	condicion_iva	 		CHAR(10),
	condicion_paciente 		CHAR(10),
	numero_historia_clinica	INTEGER NOT NULL,
    	apellido_nombre	 	CHAR(50) NOT NULL,
    	nombre_plan	 		CHAR(10),
    	razon_social	 		CHAR(30),
	codigo_domicilio		INTEGER,
	PRIMARY KEY (tipo_documento ,  numero_doc_paciente),
	FOREIGN KEY (razon_social , nombre_plan) REFERENCES plan,
	FOREIGN KEY (codigo_domicilio) REFERENCES domicilio
	);	
	
		
create table tiene_especialidad(
	tipo_doc_profesional		CHAR(10) NOT NULL,
	numero_doc_profesional  	INTEGER NOT NULL,
	codigo_especialidad		INTEGER NOT NULL,	
	descripcion_subespecialidad	CHAR(50) NOT NULL,
	PRIMARY KEY (tipo_doc_profesional, numero_doc_profesional, codigo_especialidad, descripcion_subespecialidad),
	FOREIGN KEY (tipo_doc_profesional, numero_doc_profesional)     REFERENCES profesional,
	FOREIGN KEY (codigo_especialidad, descripcion_subespecialidad) REFERENCES subespecialidad
	);
	
create table autorizacion(
	tipo_doc_profesional		CHAR(10) NOT NULL,
	numero_doc_profesional  	INTEGER NOT NULL,
	codigo_accion_medica		CHAR(10) NOT NULL,	
	PRIMARY KEY (tipo_doc_profesional, numero_doc_profesional, codigo_accion_medica),
	FOREIGN KEY (tipo_doc_profesional, numero_doc_profesional)     REFERENCES profesional,
	FOREIGN KEY (codigo_accion_medica) REFERENCES accion_medica
	);	
	
create table realiza_accion(
	codigo_especialidad		INTEGER NOT NULL,	
	descripcion_subespecialidad	CHAR(50) NOT NULL,
	codigo_accion_medica		CHAR(10) NOT NULL,	
	PRIMARY KEY (codigo_especialidad, descripcion_subespecialidad, codigo_accion_medica),
	FOREIGN KEY (codigo_especialidad, descripcion_subespecialidad)     REFERENCES subespecialidad,
	FOREIGN KEY (codigo_accion_medica) REFERENCES accion_medica
	);		
	
create table block_horas(
	codigo_block_horas   		INTEGER NOT NULL,	
	dia				CHAR(10) NOT NULL,
	semana				CHAR(10) NOT NULL,
	hora_desde			CHAR(10) NOT NULL,
	hora_hasta			CHAR(10) NOT NULL,
	acepta_sobreturno		CHAR(1),
    	acepta_fuera_agenda		CHAR(10),
    	bloqueado		 	CHAR(1),
    	unidades		 	CHAR(10),
	tipo_turno			CHAR(10),
    	cantidad_pacientes 		INTEGER,
	tipo_doc_profesional		CHAR(10) NOT NULL,
	numero_doc_profesional  	INTEGER NOT NULL,
	codigo_especialidad		INTEGER NOT NULL,	
	descripcion_subespecialidad	CHAR(50) NOT NULL,
    	PRIMARY KEY (codigo_block_horas),
	FOREIGN KEY (tipo_doc_profesional, numero_doc_profesional,  codigo_especialidad, descripcion_subespecialidad) REFERENCES tiene_especialidad
	);	
	
	
create table turno(
	codigo_turno	   		INTEGER NOT NULL,	
	fecha_turno			DATETIME NOT NULL,
	hora_turno			DATETIME NOT NULL,
	observaciones			CHAR(100),
	lugar				CHAR(100),
	sobreturno			CHAR(1),
    	bloqueado	 		CHAR(1),
    	codigo_block_horas		INTEGER,
	codigo_accion_medica		CHAR(10),
    	PRIMARY KEY (codigo_turno),
	FOREIGN KEY (codigo_block_horas) REFERENCES block_horas,
	FOREIGN KEY (codigo_accion_medica) REFERENCES accion_medica
	);	
	
	
create table se_atiende(
	tipo_doc_paciente		CHAR(10) NOT NULL,
	numero_doc_paciente		INTEGER NOT NULL,
	codigo_turno			INTEGER NOT NULL,
	PRIMARY KEY (tipo_doc_paciente, numero_doc_paciente, codigo_turno),
	FOREIGN KEY (tipo_doc_paciente, numero_doc_paciente) REFERENCES paciente,
	FOREIGN KEY (codigo_turno) REFERENCES turno
	);


create table turno_asignado(
	tipo_doc_profesional		CHAR(10) NOT NULL,
	numero_doc_profesional  	INTEGER NOT NULL,
	codigo_turno			INTEGER NOT NULL,
	PRIMARY KEY (tipo_doc_profesional, numero_doc_profesional, codigo_turno),
	FOREIGN KEY (tipo_doc_profesional, numero_doc_profesional) REFERENCES profesional,
	FOREIGN KEY (codigo_turno) REFERENCES turno
	);

create table comprobante(
	codigo_turno			INTEGER NOT NULL,
	numero_comprobante		INTEGER NOT NULL,	
	fecha_alta			DATETIME NOT NULL,
	usuario				CHAR(20),
	PRIMARY KEY (codigo_turno, numero_comprobante),
	FOREIGN KEY (codigo_turno) REFERENCES turno
	);
