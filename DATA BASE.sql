CREATE DATABASE  ControlIncidenciasDB
GO
USE ControlIncidenciasDB
GO

CREATE TABLE EDIFICIO(
	 ID INT IDENTITY,
	 Nombre NVARCHAR(30) NOT NULL, 
	 Ubicacion NVARCHAR(100) NOT NULL,
	 ID_Depto INT
)
GO
CREATE TABLE LOCALIZACION( 
	 ID INT IDENTITY,
	 Nombre NVARCHAR(40) NOT NULL,
	 NumPlanta INT,
	 ID_Edificio INT,
	 Ubicacion NVARCHAR(100) NOT NULL
)
GO
CREATE TABLE DEPARTAMENTO(
	ID INT IDENTITY,
	Nombre NVARCHAR(30) NOT NULL,
	ID_EmpEncar INT,
	Estatus BIT -- 0 INACTIVO / 1 ACTIVO --
)
GO
CREATE TABLE EMPLEADO(
	ID INT IDENTITY,
	Nombre NVARCHAR(50) NOT NULL,
	Email NVARCHAR(35) NOT NULL,
	Celular NVARCHAR(12) NOT NULL,
	Direccion NVARCHAR(30) NOT NULL,
	ID_Rol INT,
	Contrase�a NVARCHAR(20) NOT NULL,
	Estatus BIT -- 0 INACTIVO / 1 ACTIVO --
)
GO
CREATE TABLE EMPLEADO_DEPTO(
	ID_Empleado INT,
	ID_Depto INT
)
GO
CREATE TABLE ROL(
	ID INT IDENTITY,
	Nombre NVARCHAR(20) NOT NULL
)
GO
CREATE TABLE PROVEEDOR(
	ID INT IDENTITY,
	Nombre NVARCHAR(30) NOT NULL,
	RFC NVARCHAR(13) NOT NULL,
	Email NVARCHAR(20) NOT NULL,
	Telefono NVARCHAR(12) NOT NULL,
	Direccion NVARCHAR(40) NOT NULL
)
GO
CREATE TABLE CI(
	ID INT IDENTITY,
	Nombre NVARCHAR(50) NOT NULL,
	Descripcion NVARCHAR(350) NOT NULL,
	NumSerie NVARCHAR(30) NOT NULL,
	FechaAdquisicion DATE NOT NULL,
	ID_Localizacion INT,
	ID_Encargado INT,
	ID_Proveedor INT,
	Estatus BIT -- 0 INACTIVO / 1 ACTIVO --
)
GO
CREATE TABLE INCIDENCIA(
	ID INT IDENTITY,
	Descripcion NVARCHAR(90) NOT NULL,
	FechaInicio DATE,
	FechaTerminacion DATE,
	ID_Prioridad INT,
	ID_CI INT,
	ID_Tecnico INT,
	ID_Stat INT,
	ID_Tipo INT,
	Califiacion NVARCHAR(20),
	Comentario NVARCHAR(80),
	Ubicacion NVARCHAR(90),
	Tiempo_Respuesta NVARCHAR(50),
	ID_Usuario INT NOT NULL
)
GO
CREATE TABLE PRIORIDAD(
	ID INT IDENTITY,
	Descripcion NVARCHAR(20) NOT NULL
)
GO
CREATE TABLE ESTATUS_INCIDENCIA(
	ID INT IDENTITY,
	Descripcion NVARCHAR(15) NOT NULL
)
GO
CREATE TABLE TIPO_INCIDENCIA(
	ID INT IDENTITY,
	Descripcion NVARCHAR(15) NOT NULL
)
GO
CREATE TABLE PROBLEMAS_CONOCIDOS(
	ID INT IDENTITY,
	Descripcion NVARCHAR(100) NOT NULL,
	Solucion NVARCHAR(200) NOT NULL,
	Tiempo NVARCHAR(20) NOT NULL
)
GO
CREATE TABLE CAMBIOS_CI(
	ID INT IDENTITY,
	IDCI INT,
	Nombre NVARCHAR(50) NOT NULL,
	Descripcion NVARCHAR(350) NOT NULL,
	NumSerie NVARCHAR(30) NOT NULL,
	FechaAdquisicion DATE NOT NULL,
	ID_Localizacion INT,
	ID_Encargado INT,
	ID_Proveedor INT,
	Estatus BIT -- 0 INACTIVO / 1 ACTIVO --
)
GO
---------------------------------------- PRIMARY KEYS ----------------------------------------

ALTER TABLE EDIFICIO
ADD CONSTRAINT PK_Edificio PRIMARY KEY(ID)

ALTER TABLE LOCALIZACION
ADD CONSTRAINT PK_Localizacion PRIMARY KEY(ID)

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT PK_Departamento PRIMARY KEY(ID)

ALTER TABLE EMPLEADO
ADD CONSTRAINT PK_Empleado PRIMARY KEY(ID)

ALTER TABLE ROL
ADD CONSTRAINT PK_Rol PRIMARY KEY(ID)

ALTER TABLE PROVEEDOR
ADD CONSTRAINT PK_Proveedor PRIMARY KEY(ID)

ALTER TABLE CI
ADD CONSTRAINT PK_CI PRIMARY KEY(ID)

ALTER TABLE ESTATUS_INCIDENCIA
ADD CONSTRAINT PK_EstatusIncidencia PRIMARY KEY(ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT PK_Incidencia PRIMARY KEY(ID)

ALTER TABLE TIPO_INCIDENCIA
ADD CONSTRAINT PK_TipoIncidencia PRIMARY KEY(ID)

ALTER TABLE PROBLEMAS_CONOCIDOS
ADD CONSTRAINT PK_Problemas_conocidos PRIMARY KEY(ID)

ALTER TABLE CAMBIOS_CI
ADD CONSTRAINT PK_Cambios_CI PRIMARY KEY (ID)

GO

---------------------------------------- FOREIGN KEYS ----------------------------------------

ALTER TABLE EDIFICIO
ADD CONSTRAINT FK_Edificio_Depto FOREIGN KEY(ID_Depto) REFERENCES DEPARTAMENTO (ID)

ALTER TABLE LOCALIZACION
ADD CONSTRAINT FK_Localizacion_Edificio FOREIGN KEY(ID_Edificio) REFERENCES EDIFICIO (ID)

ALTER TABLE DEPARTAMENTO
ADD CONSTRAINT FK_Encargado_Depto FOREIGN KEY(ID_EmpEncar) REFERENCES EMPLEADO (ID)

ALTER TABLE EMPLEADO
ADD CONSTRAINT FK_Empleado_Rol FOREIGN KEY(ID_Rol) REFERENCES ROL (ID)

ALTER TABLE EMPLEADO_DEPTO
ADD CONSTRAINT FK_EmpleadoDepto_Empleado FOREIGN KEY(ID_Empleado) REFERENCES EMPLEADO (ID)

ALTER TABLE EMPLEADO_DEPTO
ADD CONSTRAINT FK_EmpleadoDepto_Depto FOREIGN KEY(ID_Depto) REFERENCES DEPARTAMENTO (ID)

ALTER TABLE CI
ADD CONSTRAINT FK_CI_Localizacion FOREIGN KEY(ID_Localizacion) REFERENCES LOCALIZACION (ID)

ALTER TABLE CI
ADD CONSTRAINT FK_CI_Encargado FOREIGN KEY(ID_Encargado) REFERENCES EMPLEADO (ID)

ALTER TABLE CI
ADD CONSTRAINT FK_CI_Provedor FOREIGN KEY(ID_Proveedor) REFERENCES PROVEEDOR (ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT FK_Indcidencia_CI FOREIGN KEY(ID_CI) REFERENCES CI (ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT FK_Indcidencia_Tecnico FOREIGN KEY(ID_Tecnico) REFERENCES EMPLEADO (ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT FK_Incidencia_Estatus FOREIGN KEY(ID_Stat) REFERENCES ESTATUS_INCIDENCIA (ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT FK_Incidencia_Tipo FOREIGN KEY(ID_Tipo) REFERENCES TIPO_INCIDENCIA (ID)

ALTER TABLE INCIDENCIA
ADD CONSTRAINT FK_Incidencia_Usuario FOREIGN KEY(ID_Usuario) REFERENCES EMPLEADO (ID)
GO

---------------------------------------- TRIGGERS ----------------------------------------
CREATE TRIGGER TG_UPDATE_CI ON CI FOR UPDATE
AS
	DECLARE @IDCI INT
	DECLARE @Name NVARCHAR(50)
	DECLARE @Desc NVARCHAR(50)
	DECLARE @NumSerie NVARCHAR(50)
	DECLARE @FechaAd DATE
	DECLARE @LocID INT
	DECLARE @EncID INT
	DECLARE @ProID INT
	DECLARE @Est BIT

	SELECT @IDCI=ID,@Name=Nombre,@Desc=Descripcion,@NumSerie=NumSerie,@FechaAd=FechaAdquisicion,@LocID=ID_Localizacion,@EncID=ID_Encargado,@ProID=ID_Proveedor,@Est=Estatus FROM inserted
	
	BEGIN
		INSERT INTO CAMBIOS_CI(IDCI,Nombre,Descripcion,NumSerie,FechaAdquisicion,ID_Localizacion,ID_Encargado,ID_Proveedor,Estatus) 
		VALUES(@IDCI,@Name,@Desc,@NumSerie,@FechaAd,@LocID,@EncID,@ProID,@Est) 

		PRINT 'MAPEO REALIZADO CORRECTAMENTE A LA TABLA CAMBIOS_CI'
	END
GO
---------------------------------------- POBLACION ----------------------------------------
INSERT INTO ROL(Nombre) 
VALUES ('ADMINISTRADOR') 
INSERT INTO ROL (Nombre) 
VALUES ('JEFE DE TALLER') 
INSERT INTO ROL (Nombre) 
VALUES ('TECNICO') 
INSERT INTO ROL (Nombre) 
VALUES ('DOCENTE') 
SELECT * FROM ROL

INSERT INTO PRIORIDAD(Descripcion)
VALUES('ALTA')
INSERT INTO PRIORIDAD(Descripcion)
VALUES('MEDIA')
INSERT INTO PRIORIDAD(Descripcion)
VALUES('BAJA')
SELECT * FROM PRIORIDAD

INSERT INTO ESTATUS_INCIDENCIA(Descripcion)
VALUES('RESUELTA')
INSERT INTO ESTATUS_INCIDENCIA(Descripcion)
VALUES('POR CHECAR')
INSERT INTO ESTATUS_INCIDENCIA(Descripcion)
VALUES('ACEPTADA')
INSERT INTO ESTATUS_INCIDENCIA(Descripcion)
VALUES('EN PROCESO')
INSERT INTO ESTATUS_INCIDENCIA(Descripcion)
VALUES('RECHAZADA')
SELECT * FROM ESTATUS_INCIDENCIA

INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('MARCO ANTONIO RODRIGUEZ AVILES','Marco@itculiacan.edu.mx','6671234567','Villa Alegria',1,'12345',1)
INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('JORGE GUILLERMO MOYA PALAZUELOS','Jorge@itculiacan.edu.mx','6672567032','Los Cascaveles',2,'12345',1)
INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('NOEL GARCIA INZUNZA','Noel@itculiacan.edu.mx','6670987654','Rancho Contento',3,'12345',1)
INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('ELIZABETH BARRAZA GARCIA','Elizabeth@itculiacan.edu.mx','6610293845','Los Pinos',4,'12345',1)
INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('MARIA DEL ROSARIO GONZALEZ ALVAREZ','Rosario@itculiacan.edu.mx','6610200826','Las lomas',4,'12345',1)
INSERT INTO  EMPLEADO(Nombre,Email,Celular,Direccion,ID_Rol,Contrase�a,Estatus)
VALUES('JUAN LOPEZ PEREZ','Juan@itculiacan.edu.mx','6670937524','Aguaruto',3,'12345',1)
SELECT * FROM EMPLEADO

INSERT INTO DEPARTAMENTO(Nombre,ID_EmpEncar,Estatus)
VALUES('SISTEMAS',1,1)
INSERT INTO DEPARTAMENTO(Nombre,ID_EmpEncar,Estatus)
VALUES('CIENCIAS BASICAS',4,1)
INSERT INTO DEPARTAMENTO(Nombre,ID_EmpEncar,Estatus)
VALUES('FINANZAS',5,1)
SELECT * FROM DEPARTAMENTO

INSERT INTO EDIFICIO(Nombre,Ubicacion,ID_Depto)
VALUES('A','CERCA DE LA ENTRADA PRINCIPAL AUN LADO DEL ESTANQUE',1)
INSERT INTO EDIFICIO(Nombre,Ubicacion,ID_Depto)
VALUES('B','SEGUNDO EDIFICIO DESPUES DE ENTRAR POR LA PUERTA PRINCIPAL',1)
INSERT INTO EDIFICIO(Nombre,Ubicacion,ID_Depto)
VALUES('UP','EDIFICIO QUE ESTA ATRAS DEL SEGUNDO ESTACIONAMIENTO, DE COLOR LILA',1)
SELECT * FROM EDIFICIO

INSERT INTO LOCALIZACION(Nombre,NumPlanta,ID_Edificio,Ubicacion)
VALUES('CUBICULO 4',1,1,'DENTRO DEL EDIFICIO GIRAR A LA IZQUIERDA Y CAMINAR HASTA EL FONDO')
SELECT * FROM LOCALIZACION

INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(1,1)
INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(2,1)
INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(3,1)
INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(4,2)
INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(5,3)
INSERT INTO EMPLEADO_DEPTO(ID_Empleado,ID_Depto)
VALUES(6,1)
SELECT * FROM EMPLEADO_DEPTO

INSERT INTO PROVEEDOR(Nombre,RFC,Email,Telefono,Direccion)
VALUES('VISION COMPUTERS','ABCDFG9871BQ','Vision@computer.mx','6677172032','R�o Suchiate, Los Pinos 80128')
INSERT INTO PROVEEDOR(Nombre,RFC,Email,Telefono,Direccion)
VALUES('MICROSOFT','ABCDEF6542AX','Microsoft@team.mx','6657184740','Albuquerque, Nuevo M�xico')
SELECT * FROM PROVEEDOR

INSERT INTO CI(Nombre,Descripcion,NumSerie,FechaAdquisicion,ID_Localizacion,ID_Encargado,ID_Proveedor,Estatus)
VALUES('COMPUTADORA','COMPUTADORA HP','12345678','2020/01/16',1,2,2,1)
INSERT INTO CI(Nombre,Descripcion,NumSerie,FechaAdquisicion,ID_Localizacion,ID_Encargado,ID_Proveedor,Estatus)
VALUES('IMPRESORA','IMPRESORA COLOR NEGRO','87654321','2021/03/20',1,2,1,1)
SELECT * FROM CI

INSERT INTO CAMBIOS_CI(IDCI,Nombre,Descripcion,NumSerie,FechaAdquisicion,ID_Localizacion,ID_Encargado,ID_Proveedor,Estatus)
VALUES(1,'COMPUTADORA','COMPUTADORA HP','12345678','2020/01/16',1,2,2,1)
INSERT INTO CAMBIOS_CI(IDCI,Nombre,Descripcion,NumSerie,FechaAdquisicion,ID_Localizacion,ID_Encargado,ID_Proveedor,Estatus)
VALUES(2,'IMPRESORA','IMPRESORA COLOR NEGRO','12345678','2021/03/20',1,2,1,1)
SELECT * FROM CAMBIOS_CI

INSERT INTO TIPO_INCIDENCIA(Descripcion)
VALUES('CI')
INSERT INTO TIPO_INCIDENCIA(Descripcion)
VALUES('RED')
SELECT * FROM TIPO_INCIDENCIA

--USE master
--DROP DATABASE ControlIncidenciasDB

