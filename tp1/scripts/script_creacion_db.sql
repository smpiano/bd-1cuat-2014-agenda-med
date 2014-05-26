create table domicilio(
	codigo_postal		CHAR(10) NOT NULL,	
	provincia		CHAR(20) NOT NULL,
	localidad		CHAR(100) NOT NULL,
	calle			CHAR(100) NOT NULL,
	numero			INTEGER NOT NULL,
	departamento		CHAR(10) DEFAULT '-',
	piso			CHAR(10) DEFAULT '-',
	PRIMARY KEY (codigo_postal, provincia, localidad, calle, numero, departamento, piso)
);
	

create table obra_social(
	nombre			CHAR(100) NOT NULL,	
	prepaga			BOOLEAN,
	PRIMARY KEY (nombre)
);	
	

create table plan(
	nombre			CHAR(100) NOT NULL,
	nombre_obra_social	CHAR(100) NOT NULL,	
	PRIMARY KEY (nombre, nombre_obra_social),
	FOREIGN KEY (nombre_obra_social) REFERENCES obra_social
);


create table especialidad(
	nombre			CHAR(100) NOT NULL,	
	descripcion		CHAR(200),
	PRIMARY KEY (nombre)
);

	
create table subespecialidad(
	nombre			CHAR(100) NOT NULL,	
	nombre_especialidad	CHAR(100) NOT NULL,	
	descripcion		CHAR(200) NOT NULL,
	PRIMARY KEY (nombre, nombre_especialidad),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);


create table recurso(
	nombre			CHAR(100) NOT NULL,
	PRIMARY KEY (nombre)
);	
		
	
create table profesional(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,	
	nombre			CHAR(200),
	apellido		CHAR(200),
	email			CHAR(200),
	matricula		INTEGER,
	celular			INTEGER,
	nombre_especialidad	CHAR(100) NOT NULL,
	nombre_subespecialidad	CHAR(100) NOT NULL,
	codigo_postal_dom	CHAR(10) NOT NULL,	
	provincia_dom		CHAR(20) NOT NULL,
	localidad_dom		CHAR(100) NOT NULL,
	calle_dom		CHAR(100) NOT NULL,
	numero_dom		INTEGER NOT NULL,
	departamento_dom	CHAR(10) DEFAULT '-',
	piso_dom		CHAR(10) DEFAULT '-',
	PRIMARY KEY (tipo_documento, numero_documento),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad,
	FOREIGN KEY (nombre_especialidad, nombre_subespecialidad) REFERENCES subespecialidad,
	FOREIGN KEY (codigo_postal_dom, provincia_dom, localidad_dom, calle_dom, numero_dom, departamento_dom, piso_dom) REFERENCES domicilio
);


create table procedimiento_medico(
	codigo			CHAR(10) NOT NULL,	
	descripcion		CHAR(500),
	condiciones_paciente	CHAR(500),
	duracion		DECIMAL(10,2),
	monto			DECIMAL(10,2),
	recurso			CHAR(100),
	PRIMARY KEY (codigo),
	FOREIGN KEY (recurso) REFERENCES recurso
);	

create table cubre(
	nombre_plan		CHAR(100) NOT NULL,	
	nombre_obra_social	CHAR(100) NOT NULL,
	codigo_proced_medico	CHAR(10) NOT NULL,
	documentacion		CHAR(100),
	porcentaje_exencion	DECIMAL(10,2),
	PRIMARY KEY (nombre_plan , nombre_obra_social, codigo_proced_medico),
	FOREIGN KEY (nombre_plan, nombre_obra_social) REFERENCES plan,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);	
	
	
create table paciente(
	tipo_documento		CHAR(10) NOT NULL,	
	numero_documento	INTEGER NOT NULL,
	numero_afiliado		INTEGER NOT NULL,
    	nombre			CHAR(200) NOT NULL,
    	apellido_materno	CHAR(200) NOT NULL,
    	apellido_paterno	CHAR(200) NOT NULL,
	numero_historia_clinica	INTEGER,
	lugar_nacimiento	CHAR(200),
	fecha_nacimiento	DATE,
    	email			CHAR(200),
	titular			BOOLEAN,
	condicion_paciente	CHAR(500),
    	condicion_iva		CHAR(100),
    	telefono		CHAR(20) NOT NULL,
    	nombre_plan		CHAR(100),
    	nombre_obra_social	CHAR(100),
	codigo_postal_dom	CHAR(10) NOT NULL,	
	provincia_dom		CHAR(20) NOT NULL,
	localidad_dom		CHAR(100) NOT NULL,
	calle_dom		CHAR(100) NOT NULL,
	numero_dom		INTEGER NOT NULL,
	departamento_dom	CHAR(10) DEFAULT '-',
	piso_dom		CHAR(10) DEFAULT '-',
	PRIMARY KEY (tipo_documento ,  numero_documento),
	FOREIGN KEY (nombre_plan, nombre_obra_social) REFERENCES plan,
	FOREIGN KEY (codigo_postal_dom, provincia_dom, localidad_dom, calle_dom, numero_dom, departamento_dom, piso_dom) REFERENCES domicilio
);	
	
		
create table tiene_especialidad(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,
	PRIMARY KEY (tipo_documento, numero_documento, nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (tipo_documento, numero_documento) REFERENCES profesional,
	FOREIGN KEY (nombre_especialidad, nombre_subespecialidad) REFERENCES subespecialidad
);
	

create table autoriza(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	codigo_proced_medico	CHAR(10) NOT NULL,	
	PRIMARY KEY (tipo_documento, numero_documento, codigo_proced_medico),
	FOREIGN KEY (tipo_documento, numero_documento) REFERENCES profesional,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);	
	

create table requiere(
	codigo_proced_medico	CHAR(10) NOT NULL,	
	nombre_especialidad	CHAR(100) NOT NULL,
	nombre_subespecialidad	CHAR(100) NOT NULL,
	PRIMARY KEY (codigo_proced_medico, nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (nombre_especialidad, nombre_subespecialidad) REFERENCES subespecialidad,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);		

	
create table block_horas(
	codigo			INTEGER NOT NULL,	
	acepta_sobreturno	BOOLEAN,
	semana			INTEGER NOT NULL,
	dia			CHAR(10) NOT NULL,
	hora_desde		INTEGER NOT NULL,
	hora_hasta		INTEGER NOT NULL,
    	tipo_agenda		CHAR(100),
    	bloqueado		BOOLEAN,
    	cantidad_pacientes	INTEGER,
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,
    	PRIMARY KEY (codigo),
	FOREIGN KEY (tipo_documento, numero_documento, nombre_especialidad, nombre_subespecialidad) REFERENCES tiene_especialidad
);	
	
	
create table turno(
	codigo			INTEGER NOT NULL,	
	sobreturno		BOOLEAN,
	observaciones		CHAR(500),
	fecha			DATE NOT NULL,
	lugar			CHAR(100),
    	anulado			BOOLEAN,
    	tipo			CHAR(100),
    	codigo_block_horas	INTEGER,
	codigo_proced_medico	CHAR(10),
    	PRIMARY KEY (codigo),
	FOREIGN KEY (codigo_block_horas) REFERENCES block_horas,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);	
	
	
create table atendido_por(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	codigo_turno		INTEGER NOT NULL,
	PRIMARY KEY (tipo_documento, numero_documento, codigo_turno),
	FOREIGN KEY (tipo_documento, numero_documento) REFERENCES paciente,
	FOREIGN KEY (codigo_turno) REFERENCES turno
);


create table turno_asignado(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	codigo_turno		INTEGER NOT NULL,
	PRIMARY KEY (tipo_documento, numero_documento, codigo_turno),
	FOREIGN KEY (tipo_documento, numero_documento) REFERENCES profesional,
	FOREIGN KEY (codigo_turno) REFERENCES turno
);


create table rol(
	tipo			CHAR(10),
	descripcion		CHAR(100),
	PRIMARY KEY (tipo)
);


create table usuario(
	nombre			CHAR(200),
	PRIMARY KEY (nombre)
);


create table usuario_rol(
	nombre_usuario		CHAR(200),
	tipo_rol		CHAR(10),
	PRIMARY KEY (nombre_usuario, tipo_rol),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (tipo_rol) REFERENCES rol
);


create table comprobante(
	codigo_turno		INTEGER NOT NULL,
	numero			INTEGER NOT NULL,	
	fecha			DATE NOT NULL,
	hora			TIME NOT NULL,
	usuario			CHAR(20),
	PRIMARY KEY (codigo_turno, numero),
	FOREIGN KEY (codigo_turno) REFERENCES turno
);
