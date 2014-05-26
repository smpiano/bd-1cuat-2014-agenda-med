
create table obra_social(
	nombre_obra_social	CHAR(100) NOT NULL,	
	prepaga			BOOLEAN,
	PRIMARY KEY (nombre_obra_social)
);	
	

create table plan(
	nombre_plan			CHAR(100) NOT NULL,
	nombre_obra_social	CHAR(100) NOT NULL,	
	PRIMARY KEY (nombre, nombre_obra_social),
	FOREIGN KEY (nombre_obra_social) REFERENCES obra_social
);


create table especialidad(
	nombre_especialidad	CHAR(100) NOT NULL,	
	descripcion		CHAR(200),
	PRIMARY KEY (nombre)
);

	
create table subespecialidad(
	nombre_subespecialidad	CHAR(100) NOT NULL,	
	nombre_especialidad	CHAR(100) NOT NULL,	
	descripcion		CHAR(200) NOT NULL,
	PRIMARY KEY (nombre, nombre_especialidad),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);


create table recurso(
	nombre_recurso			CHAR(100) NOT NULL,
	PRIMARY KEY (nombre_recurso)
);	

create table demanda(
	nombre_recurso			CHAR(100) NOT NULL,
	codigo_proced_medico CHAR(10) NOT NULL,	
	PRIMARY KEY (nombre_recurso,codigo_proced_medico),
	FOREIGN KEY (nombre_recurso) REFERENCES recurso,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);			
	
create table profesional(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,	
	nombre			CHAR(200),
	apellido		CHAR(200),
	email			CHAR(200),
	matricula		INTEGER,
	celular			CHAR(15),
	codigo_postal	CHAR(10) NOT NULL,	
	provincia	CHAR(20) NOT NULL,
	localidad	CHAR(100) NOT NULL,
	calle	CHAR(100) NOT NULL,
	numero	INTEGER NOT NULL,
	departamento	CHAR(10) DEFAULT '-',
	piso	CHAR(10) DEFAULT '-',
	PRIMARY KEY (tipo_documento, numero_documento)
);

create table profesional_tiene(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,	
	PRIMARY KEY (tipo_documento, numero_documento,nombre_especialidad),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
	
);


create table profesional_ejerce(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,	
	PRIMARY KEY (tipo_documento, numero_documento,nombre_especialidad,nombre_subespecialidad),
	FOREIGN KEY (nombre_especialidad,nombre_subespecialidad) REFERENCES subespecialidad
	
);




create table procedimiento_medico(
	codigo_proced_medico CHAR(10) NOT NULL,	
	descripcion		CHAR(500),
	condiciones_paciente	CHAR(500),
	duracion		DECIMAL(10,2),
	monto			DECIMAL(10,2),
	PRIMARY KEY (codigo_proced_medico)

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
	lugar_nacimiento	CHAR(200),
	fecha_nacimiento	DATE,
    	email			CHAR(200),
	titular			BOOLEAN,
	condicion_paciente	CHAR(500),
    	condicion_iva		CHAR(100),
    	telefono		CHAR(20) NOT NULL,
    	nombre_plan		CHAR(100),
    	nombre_obra_social	CHAR(100),
	codigo_postal	CHAR(10) NOT NULL,	
	provincia		CHAR(20) NOT NULL,
	localidad		CHAR(100) NOT NULL,
	calle	CHAR(100) NOT NULL,
	numero		INTEGER NOT NULL,
	departamento	CHAR(10) DEFAULT '-',
	piso		CHAR(10) DEFAULT '-',
	PRIMARY KEY (tipo_documento , numero_documento),
	FOREIGN KEY (nombre_plan, nombre_obra_social) REFERENCES plan
);	
	
		


create table autoriza(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_recurso			CHAR(100) NOT NULL,
	PRIMARY KEY (tipo_documento, numero_documento, codigo_proced_medico),
	FOREIGN KEY (tipo_documento, numero_documento) REFERENCES profesional,
	FOREIGN KEY (nombre_recurso) REFERENCES recurso
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
	codigo_block_horas	INTEGER NOT NULL,	
	acepta_sobreturno	BOOLEAN,
	semana			INTEGER NOT NULL,
	dia			CHAR(10) NOT NULL,
	hora_desde		INTEGER NOT NULL,
	hora_hasta		INTEGER NOT NULL,
    tipo_agenda		CHAR(100),
    bloqueado		BOOLEAN,
    cantidad_pacientes	INTEGER,
	codigo_turno			INTEGER NOT NULL,
    PRIMARY KEY (codigo_block_horas),
	FOREIGN KEY (codigo_turno) REFERENCES turno
);	

	
create table profesional_atiende(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,	
	codigo_block_horas	INTEGER NOT NULL,	
	PRIMARY KEY (tipo_documento, numero_documento,nombre_especialidad,nombre_subespecialidad,codigo_block_horas),
	FOREIGN KEY (nombre_especialidad,nombre_subespecialidad) REFERENCES subespecialidad,
	FOREIGN KEY (tipo_documento,numero_documento) REFERENCES profesional,
	FOREIGN KEY (codigo_block_horas) REFERENCES block_horas
);
	
	
	
	
create table turno(
	codigo_turno			INTEGER NOT NULL,
	horas			INTEGER NOT NULL,	
	sobreturno		BOOLEAN,
	observaciones		CHAR(500),
	fecha			DATE NOT NULL,
	lugar			CHAR(100),
    	anulado			BOOLEAN,
    	tipo			CHAR(100),
	codigo_proced_medico	CHAR(10),
	tipo_documento_prof		CHAR(10) NOT NULL,
	numero_documento_prof	INTEGER NOT NULL,
	tipo_documento_pac		CHAR(10) NOT NULL,
	numero_documento_pac	INTEGER NOT NULL,
    PRIMARY KEY (codigo_turno),
	FOREIGN KEY (tipo_documento_prof,numero_documento_prof) REFERENCES profesional,
	FOREIGN KEY (tipo_documento_pac	, numero_documento_pac) REFERENCES paciente,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
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
	codigo_turno	INTEGER NOT NULL,
	numero			INTEGER NOT NULL,	
	fecha			DATE NOT NULL,
	hora			TIME NOT NULL,
	nombre_usuario		CHAR(200),
	PRIMARY KEY (codigo_turno, numero),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (codigo_turno) REFERENCES turno
);

create table requiere(
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,	
	codigo_proced_medico CHAR(10) NOT NULL,	

	PRIMARY KEY (nombre_especialidad, nombre_subespecialidad, codigo_proced_medico),
	FOREIGN KEY (nombre_especialidad,nombre_subespecialidad) REFERENCES subespecialidad,
	FOREIGN KEY (codigo_proced_medico ) REFERENCES procedimiento_medico
);