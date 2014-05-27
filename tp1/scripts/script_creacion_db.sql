
create table obra_social(
	nombre	CHAR(100) NOT NULL,	
	prepaga			BIT,
	PRIMARY KEY (nombre)
);	
	

create table procedimiento_medico(
	codigo CHAR(10) NOT NULL,	
	descripcion		CHAR(500),
	condiciones_paciente	CHAR(500),
	duracion		DECIMAL(10,2),
	monto			DECIMAL(10,2),
	PRIMARY KEY (codigo)

);	


create table plan(
	nombre_obra_social	CHAR(100) NOT NULL,	
	nombre			CHAR(100) NOT NULL,
	PRIMARY KEY (nombre_obra_social,nombre),
	FOREIGN KEY (nombre_obra_social) REFERENCES obra_social
);


create table especialidad(
	nombre	CHAR(100) NOT NULL,	
	descripcion		CHAR(200),
	PRIMARY KEY (nombre)
);

	
create table subespecialidad(
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre	CHAR(100) NOT NULL,	
	descripcion		CHAR(200) NOT NULL,
	PRIMARY KEY (nombre_especialidad, nombre),
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);


create table recurso(
	nombre		CHAR(100) NOT NULL,
	PRIMARY KEY (nombre)
);	
----- no
create table demanda(
	nombre_recurso			CHAR(100) NOT NULL,
	codigo_proced_medico CHAR(10) NOT NULL,	
	PRIMARY KEY (nombre_recurso,codigo_proced_medico),
	FOREIGN KEY (nombre_recurso) REFERENCES recurso,
	FOREIGN KEY (codigo_proced_medico) REFERENCES procedimiento_medico
);			
------	
create table persona(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,	
	nombre			CHAR(200),
	apellido		CHAR(200),
	email			CHAR(200),
	telefono		CHAR(20) NOT NULL,
	codigo_postal	CHAR(10) NOT NULL,	
	provincia	CHAR(20) NOT NULL,
	localidad	CHAR(100) NOT NULL,
	calle	CHAR(100) NOT NULL,
	numero	INTEGER NOT NULL,
	departamento	CHAR(10) DEFAULT '-',
	piso	CHAR(10) DEFAULT '-',
	PRIMARY KEY (tipo_documento, numero_documento)
);

create table profesional(
	tipo_documento_persona		CHAR(10) NOT NULL,
	numero_documento_persona	INTEGER NOT NULL,	
	matricula		INTEGER,
	nombre_especialidad 	CHAR(100) NOT NULL,	
	PRIMARY KEY (tipo_documento_persona, numero_documento_persona),
	FOREIGN KEY (tipo_documento_persona, numero_documento_persona) REFERENCES persona,
	FOREIGN KEY (nombre_especialidad) REFERENCES especialidad
);
--- no
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
	
----	
create table paciente(
	tipo_documento_persona		CHAR(10) NOT NULL,	
	numero_documento_persona	INTEGER NOT NULL,
	numero_afiliado		INTEGER NOT NULL,
    	apellido_materno	CHAR(200) NOT NULL,
    	apellido_paterno	CHAR(200) NOT NULL,
	lugar_nacimiento	CHAR(200),
	fecha_nacimiento	DATE,
    	titular			BIT,
	historia_clinica	INTEGER NOT NULL,	
	condicion_paciente	CHAR(500),
    	condicion_iva		CHAR(100),
    	nombre_plan		CHAR(100),
    	nombre_obra_social	CHAR(100),
	PRIMARY KEY (tipo_documento_persona , numero_documento_persona),
	FOREIGN KEY (tipo_documento_persona, numero_documento_persona) REFERENCES persona,
	FOREIGN KEY (nombre_plan, nombre_obra_social) REFERENCES plan
);	
	
		
--- no

create table autoriza(
	tipo_documento		CHAR(10) NOT NULL,
	numero_documento	INTEGER NOT NULL,
	nombre_recurso			CHAR(100) NOT NULL,
	PRIMARY KEY (tipo_documento, numero_documento, nombre_recurso),
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

---
create table block_horas(
	
	anio			INTEGER NOT NULL,	
	semana			INTEGER NOT NULL,
	dia			CHAR(10) NOT NULL,
	hora_inicio		INTEGER NOT NULL,
	hora_fin		INTEGER NOT NULL,
	acepta_sobreturno	BIT,	
	tipo_agenda		CHAR(100),
	bloqueado		BIT,
	cantidad_pacientes	INTEGER,
	tipo_documento_profesional		CHAR(10) NOT NULL,	
	numero_documento_profesional	INTEGER NOT NULL,
	nombre_especialidad		CHAR(100) NOT NULL,
	nombre_subespecialidad		CHAR(100) NOT NULL,
    	PRIMARY KEY (anio,semana,dia,hora_inicio,hora_fin,tipo_documento_profesional, numero_documento_profesional,nombre_especialidad, nombre_subespecialidad),
	FOREIGN KEY (tipo_documento_profesional, numero_documento_profesional) REFERENCES profesional,
	FOREIGN KEY (nombre_especialidad, nombre_subespecialidad) REFERENCES subespecialidad
);		
create table turno(
	codigo			INTEGER NOT NULL,
	sobreturno		BIT,
	tipo			CHAR(100),
	observaciones		CHAR(500),
    	anulado			BIT,
	fecha			DATE NOT NULL,
	lugar			CHAR(100),
	hora			INTEGER NOT NULL,	
	codigo_procedimiento_medico	CHAR(10),
	anio_block_horas	INTEGER NOT NULL,
	semana_block_horas	INTEGER NOT NULL,
	dia_block_horas	CHAR(20),
	hora_inicio_block_horas	INTEGER NOT NULL,	
	hora_fin_block_horas	INTEGER NOT NULL,
	tipo_documento_profesional		CHAR(10) NOT NULL,	
	numero_documento_profesional	INTEGER NOT NULL,
	tipo_documento_paciente		CHAR(10) NOT NULL,	
	numero_documento_paciente	INTEGER NOT NULL,	
	PRIMARY KEY (codigo),
	FOREIGN KEY (tipo_documento_profesional, numero_documento_profesional) REFERENCES profesional,
	FOREIGN KEY (tipo_documento_paciente, numero_documento_paciente) REFERENCES paciente,
	FOREIGN KEY (codigo_procedimiento_medico) REFERENCES procedimiento_medico
	FOREIGN KEY (anio_block_horas,semana_block_horas,dia_block_horas,hora_inicio_block_horas,hora_fin_block_horas) REFERENCES block_horas
);	

--no

	
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
-----	
	

create table rol(
	tipo			CHAR(10),
	descripcion		CHAR(100),
	PRIMARY KEY (tipo)
);


create table usuario(
	nombre			CHAR(200),
	clave			CHAR(200),
	PRIMARY KEY (nombre)
);

-- no
create table usuario_rol(
	nombre_usuario		CHAR(200),
	tipo_rol		CHAR(10),
	PRIMARY KEY (nombre_usuario, tipo_rol),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (tipo_rol) REFERENCES rol
);

---
create table comprobante(
	codigo_turno	INTEGER NOT NULL,
	numero			INTEGER NOT NULL,	
	fecha			DATE NOT NULL,
	hora			TIME NOT NULL,
	nombre_usuario		CHAR(200),
	PRIMARY KEY (codigo_turno),
	FOREIGN KEY (nombre_usuario) REFERENCES usuario,
	FOREIGN KEY (codigo_turno) REFERENCES turno
);
--no
create table requiere(
	nombre_especialidad	CHAR(100) NOT NULL,	
	nombre_subespecialidad	CHAR(100) NOT NULL,	
	codigo_proced_medico CHAR(10) NOT NULL,	
	PRIMARY KEY (nombre_especialidad, nombre_subespecialidad, codigo_proced_medico),
	FOREIGN KEY (nombre_especialidad,nombre_subespecialidad) REFERENCES subespecialidad,
	FOREIGN KEY (codigo_proced_medico ) REFERENCES procedimiento_medico
);
---
