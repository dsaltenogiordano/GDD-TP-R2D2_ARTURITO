USE GD1C2024
GO

IF EXISTS (SELECT 1 FROM SYS.OBJECTS WHERE schema_id = SCHEMA_ID('R2D2_ARTURITO'))
    BEGIN
--------------------------------------  E L I M I N A R   FUNCTIONS  --------------------------------------
        DECLARE @SQL_FN NVARCHAR(MAX) = N'';

        SELECT @SQL_FN += N'
		DROP FUNCTION R2D2_ARTURITO.' + name  + ';'
        FROM sys.objects WHERE type = 'FN'
                           AND schema_id = SCHEMA_ID('R2D2_ARTURITO')
                           AND name LIKE 'BI[_]%'
        EXECUTE(@SQL_FN)
--------------------------------------  E L I M I N A R   S P  --------------------------------------
        DECLARE @SQL_SP NVARCHAR(MAX) = N'';

        SELECT @SQL_SP += N'
		DROP PROCEDURE R2D2_ARTURITO.' + name  + ';'
        FROM sys.objects WHERE type = 'P'
                           AND schema_id = SCHEMA_ID('R2D2_ARTURITO')
                           AND name LIKE 'BI[_]%'
        EXECUTE(@SQL_SP)

--------------------------------------  E L I M I N A R   F K  --------------------------------------
        DECLARE @SQL_FK NVARCHAR(MAX) = N'';

        SELECT @SQL_FK += N'
		ALTER TABLE R2D2_ARTURITO.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
        FROM SYS.OBJECTS
        WHERE TYPE_DESC LIKE '%CONSTRAINT'
          AND type = 'F'
          AND schema_id = SCHEMA_ID('R2D2_ARTURITO')
          AND OBJECT_NAME(PARENT_OBJECT_ID) LIKE 'BI[_]%'
        EXECUTE(@SQL_FK)

--------------------------------------  E L I M I N A R   P K  --------------------------------------
        DECLARE @SQL_PK NVARCHAR(MAX) = N'';
        SELECT @SQL_PK += N'
		ALTER TABLE R2D2_ARTURITO.' + OBJECT_NAME(PARENT_OBJECT_ID) + ' DROP CONSTRAINT ' + OBJECT_NAME(OBJECT_ID) + ';'
        FROM SYS.OBJECTS
        WHERE TYPE_DESC LIKE '%CONSTRAINT'
          AND type = 'PK'
          AND schema_id = SCHEMA_ID('R2D2_ARTURITO')
          AND OBJECT_NAME(PARENT_OBJECT_ID) LIKE 'BI[_]%'
        EXECUTE(@SQL_PK)

------------------------------------  D R O P    T A B L E S   -----------------------------------
        DECLARE @SQL_DROP NVARCHAR(MAX) = N'';
        SELECT @SQL_DROP += N'
		DROP TABLE R2D2_ARTURITO.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'R2D2_ARTURITO'
          AND TABLE_TYPE = 'BASE TABLE'
          AND TABLE_NAME LIKE 'BI[_]%'
        EXECUTE(@SQL_DROP)

---------------------------------------- D R O P   V I E W S  -------------------------------------
        DECLARE @SQL_VIEW NVARCHAR(MAX) = N'';
        SELECT @SQL_VIEW += N'
		DROP VIEW R2D2_ARTURITO.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'R2D2_ARTURITO'
          AND TABLE_TYPE = 'VIEW'
          AND TABLE_NAME LIKE 'BI[_]%'
        EXECUTE(@SQL_VIEW)
    END
GO

/*************************************************
 *	CREACION DIMENSIONES BASICAS SEG�N ENUNCIADO
 *************************************************/

CREATE SCHEMA BI_R2D2_ARTURITO
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_TIEMPO(
	id_tiempo INT PRIMARY KEY IDENTITY(0,1),
	anio INT NULL,
	cuatrimestre INT NULL,
	mes INT NULL
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_UBICACION(
	id_ubicacion INT PRIMARY KEY IDENTITY(0,1),
	localidad VARCHAR(200) NULL,
	provincia VARCHAR(200) NULL
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_SUCURSAL(
	id_sucursal INT PRIMARY KEY IDENTITY(0,1),
	nombre VARCHAR(200) NULL,
	id_ubicacion INT NOT NULL,
	FOREIGN KEY (id_ubicacion) REFERENCES BI_R2D2_ARTURITO.BI_UBICACION (id_ubicacion)
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_RANGO_ETARIO(
	id_rango_etario INT PRIMARY KEY IDENTITY(0,1),
	rango_etario VARCHAR(50) NULL
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_RANGO_TURNOS(
	id_turno INT PRIMARY KEY IDENTITY(0,1),
	inicio TIME NULL,
	fin TIME NULL
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_MEDIO_PAGO(
	id_medio_pago INT PRIMARY KEY IDENTITY(0,1),
	descripcion VARCHAR(50)
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_CATEGORIZACION_PRODUCTOS(
	id_categorizacion INT PRIMARY KEY IDENTITY(0,1),
	descripcion_categoria VARCHAR(200) NULL,
	descripcion_subcategoria VARCHAR(200) NULL
);
GO

/*************************************************
 *	CREACION TABLAS NECESARIAS PARA VISTAS 1,2,3 y 4
 *************************************************/

CREATE TABLE BI_R2D2_ARTURITO.BI_VENTA(
	id_venta INT PRIMARY KEY IDENTITY(0,1),
	total_venta DECIMAL(10,2),
	total_items_vendidos INT NULL,
	id_sucursal INT NULL,
	id_tiempo INT NULL,
	id_turno INT NULL,
	FOREIGN KEY (id_sucursal) REFERENCES BI_R2D2_ARTURITO.BI_SUCURSAL(id_sucursal),
	FOREIGN KEY (id_tiempo) REFERENCES BI_R2D2_ARTURITO.BI_TIEMPO(id_tiempo),
	FOREIGN KEY (id_turno) REFERENCES BI_R2D2_ARTURITO.BI_RANGO_TURNOS(id_turno)
)

/*************************************************
 *	MIGRACIONES DE DATOS DE DIMENSIONES OBLIGATORIAS
 *************************************************/

CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_TIEMPO AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_TIEMPO (anio, cuatrimestre, mes)
	SELECT DISTINCT
		YEAR(V.fecha) AS anio,
		CASE
			WHEN MONTH(V.fecha) BETWEEN 1 AND 4 THEN 1
			WHEN MONTH(V.fecha) BETWEEN 5 AND 8 THEN 2
			WHEN MONTH(V.fecha) BETWEEN 9 AND 12 THEN 3
			ELSE NULL
		END AS cuatrimestre,
		MONTH(V.fecha) AS mes
	FROM R2D2_ARTURITO.VENTA V
END
GO

--Ubicacion
CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_UBICACION AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_UBICACION(localidad,provincia)
	SELECT 
		L.nombre AS localidad,
		P.nombre AS provincia
	FROM R2D2_ARTURITO.LOCALIDAD L INNER JOIN R2D2_ARTURITO.PROVINCIA P
		ON L.id_provincia = P.id_provincia
END
GO

--Sucursal
CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_SUCURSAL AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_SUCURSAL(nombre)
	SELECT S.nombre FROM R2D2_ARTURITO.SUCURSAL S
END
GO

--Rango Etario
CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_ETARIO AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_RANGO_ETARIO (rango_etario)
		VALUES ('< 25'), ('25 - 35'), ('35 - 50'), ('> 50')
END
GO

--Turnos
CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_TURNOS AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_RANGO_TURNOS(inicio,fin) 
		VALUES ('08:00','12:00'), ('12:00','16:00'), ('16:00','20:00')
END
GO

CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_MEDIO_PAGO AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_MEDIO_PAGO(descripcion)
	SELECT MP.descripcion FROM R2D2_ARTURITO.MEDIO_PAGO MP
END
GO

CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_CATEGORIZACION_PRODUCTOS AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_CATEGORIZACION_PRODUCTOS(descripcion_categoria,descripcion_subcategoria)
	SELECT
		C.descripcion AS descripcion_categoria,
		S.descripcion AS descripcion_subcategoria
	FROM R2D2_ARTURITO.SUBCATEGORIA S
		INNER JOIN R2D2_ARTURITO.SUBCATEGORIA_X_CATEGORIA SXC
			ON S.id_subcategoria = SXC.id_subcategoria
		INNER JOIN R2D2_ARTURITO.CATEGORIA C
			ON SXC.id_categoria = C.id_categoria
END
GO

EXEC BI_R2D2_ARTURITO.BI_MIGRAR_TIEMPO;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_UBICACION;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_SUCURSAL;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_ETARIO;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_TURNOS;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_MEDIO_PAGO;
EXEC BI_R2D2_ARTURITO.BI_MIGRAR_CATEGORIZACION_PRODUCTOS;