-- entidades
create table persona(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,	
	nombre			CHAR(200) NOT NULL,
	apellido		CHAR(200) NOT NULL,
	email			CHAR(200),
	telefono		CHAR(20) NOT NULL,
	codigo_postal		CHAR(10),	
	provincia		CHAR(20),
	localidad		CHAR(100),
	calle			CHAR(100),
	numero			INTEGER,
	departamento		CHAR(10),
	piso			CHAR(10),
	PRIMARY KEY (tipo_documento, numero_documento)
);


create table especialidad(
	nombre			CHAR(100) NOT NULL,	
	descripcion		CHAR(200),
	PRIMARY KEY (nombre)
);

	
create table subespecialidad(
	nombre			CHAR(100) NOT NULL,	
	descripcion		CHAR(200),
	nombre_especialidad	CHAR(100) NOT NULL,	
	PRIMARY KEY (nombre, nombre_especialidad),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);


create table profesional(
	tipo_documento_persona		CHAR(10) NOT NULL,
	numero_documento_persona	INTEGER NOT NULL,	
	matricula			INTEGER NOT NULL,
	nombre_especialidad		CHAR(100) NOT NULL,	
	PRIMARY KEY (tipo_documento_persona, numero_documento_persona),
	FOREIGN KEY (tipo_documento_persona, numero_documento_persona) REFERENCES persona,
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);


create table obra_social(
	nombre			CHAR(100) NOT NULL,	
	prepaga			BIT NOT NULL,
	PRIMARY KEY (nombre)
);

	
create table plan(
	nombre_obra_social	CHAR(100) NOT NULL,	
	nombre			CHAR(100) NOT NULL,
	PRIMARY KEY (nombre_obra_social,nombre),
	FOREIGN KEY (nombre_obra_social) REFERENCES obra_social
);


create table procedimiento_medico(
	codigo			CHAR(10) NOT NULL,	
	descripcion		CHAR(500),
	condiciones_paciente	CHAR(500),
	duracion		DECIMAL(10,2),
	monto			DECIMAL(10,2),
	PRIMARY KEY (codigo)
);


create table paciente(
	tipo_documento_persona		CHAR(10) NOT NULL,	
	numero_documento_persona	INTEGER NOT NULL,
	numero_afiliado			INTEGER NOT NULL,
    	apellido_materno		CHAR(200),
    	apellido_paterno		CHAR(200),
	lugar_nacimiento		CHAR(200),
	fecha_nacimiento		DATE,
    	titular				BIT,
	historia_clinica		INTEGER,	
	condicion_paciente		CHAR(500),
    	condicion_iva			CHAR(100) DEFAULT 'Consumidor final',
    	nombre_plan			CHAR(100) NOT NULL,
    	nombre_obra_social		CHAR(100) NOT NULL,
	PRIMARY KEY (tipo_documento_persona , numero_documento_persona),
	FOREIGN KEY (tipo_documento_persona, numero_documento_persona) REFERENCES persona,
	FOREIGN KEY (nombre_plan, nombre_obra_social) REFERENCES plan
);	


create table recurso(
	nombre		CHAR(100) NOT NULL,
	PRIMARY KEY (nombre)
);


create table block_horas(
	codigo				INTEGER NOT NULL,
	anio				INTEGER NOT NULL,	
	semana				INTEGER NOT NULL,
	dia				CHAR(10) NOT NULL,
	hora_inicio			TIME NOT NULL,
	hora_fin			TIME NOT NULL,
	acepta_sobreturno		BIT,	
	tipo_agenda			CHAR(100),
	bloqueado			BIT,
	cantidad_pacientes		INTEGER,    
	PRIMARY KEY (codigo)
);


create table turno(
	codigo				INTEGER NOT NULL,
	sobreturno			BIT,
	tipo				CHAR(100),
	observaciones			CHAR(500),
    	anulado				BIT,
	fecha				DATE NOT NULL,
	lugar				CHAR(100),
	hora				INTEGER NOT NULL,	
	codigo_procedimiento_medico	CHAR(10),
	codigo_block_hora			INTEGER NOT NULL,
	tipo_documento_paciente		CHAR(10) NOT NULL,	
	numero_documento_paciente	INTEGER NOT NULL,	
	PRIMARY KEY (codigo),
	FOREIGN KEY (tipo_documento_profesional, numero_documento_profesional) REFERENCES profesional,
	FOREIGN KEY (tipo_documento_paciente, numero_documento_paciente) REFERENCES paciente,
	FOREIGN KEY (codigo_procedimiento_medico) REFERENCES procedimiento_medico,
	FOREIGN KEY (codigo_block_hora) REFERENCES block_horas
);	


create table usuario(
	nombre			CHAR(200) NOT NULL,
	clave			CHAR(200),
	PRIMARY KEY (nombre)
);


create table comprobante(
	codigo_turno		INTEGER NOT NULL,
	numero			INTEGER NOT NULL,	
	fecha			DATE NOT NULL,
	hora			TIME NOT NULL,
	nombre_usuario		CHAR(200),
	PRIMARY KEY (codigo_turno),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (codigo_turno) REFERENCES turno
);


create table rol(
	tipo			CHAR(20) NOT NULL,
	descripcion		CHAR(100),
	PRIMARY KEY (tipo)
);


-- interrelaciones
create table autoriza(
	tipo_documento_profesional	CHAR(10) NOT NULL,
	numero_documento_profesional	INTEGER NOT NULL,
	nombre_recurso			CHAR(100) NOT NULL,
	PRIMARY KEY (tipo_documento_profesional, numero_documento_profesional, nombre_recurso),
	FOREIGN KEY (tipo_documento_profesional, numero_documento_profesional) REFERENCES profesional,
	FOREIGN KEY (nombre_recurso) REFERENCES recurso
);


create table demanda(
	nombre_recurso		CHAR(100) NOT NULL,
	codigo_proced_medico	CHAR(10) NOT NULL,	
	PRIMARY KEY (nombre_recurso, codigo_proced_medico),
	FOREIGN KEY (nombre_recurso) REFERENCES recurso,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);


create table ejerce(
	tipo_documento_profesional	CHAR(10) NOT NULL,
	numero_documento_profesional	INTEGER NOT NULL,
	nombre_especialidad		CHAR(100) NOT NULL,	
	nombre_subespecialidad		CHAR(100) NOT NULL,	
	PRIMARY KEY (tipo_documento_profesional, numero_documento_profesional, nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (nombre_subespecialidad, nombre_especialidad) REFERENCES subespecialidad
	
);


create table realiza(
	codigo_proced_medico	CHAR(10) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,
	nombre_especialidad	CHAR(100) NOT NULL,
	PRIMARY KEY (codigo_proced_medico, nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (nombre_subespecialidad, nombre_especialidad) REFERENCES subespecialidad,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
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


create table tiene(
	nombre_usuario		CHAR(200) NOT NULL,
	tipo_rol		CHAR(20) NOT NULL,
	PRIMARY KEY (nombre_usuario, tipo_rol),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (tipo_rol) REFERENCES rol
);


create table atiende(
	codigo_block_hora		INTEGER NOT NULL,
	tipo_documento_profesional	CHAR(10) NOT NULL,	
	numero_documento_profesional	INTEGER NOT NULL,
	nombre_especialidad		CHAR(100) NOT NULL,
	nombre_subespecialidad		CHAR(100) NOT NULL,
	PRIMARY KEY (codigo_block_hora, tipo_documento_profesional, numero_documento_profesional, nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (codigo_block_hora) REFERENCES block_horas,
	FOREIGN KEY (tipo_documento_profesional, numero_documento_profesional) REFERENCES profesional,
	FOREIGN KEY (nombre_subespecialidad, nombre_especialidad) REFERENCES subespecialidad
);
