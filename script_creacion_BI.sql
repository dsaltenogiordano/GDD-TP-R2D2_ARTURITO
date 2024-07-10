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
 *	CREACION TABLAS DE DIMENSIONES BASICAS SEGÚN ENUNCIADO
 *************************************************/

CREATE SCHEMA BI_R2D2_ARTURITO
GO

--Tiempo
CREATE TABLE R2D2_ARTURITO.BI_TIEMPO(
	id_tiempo INT PRIMARY KEY IDENTITY(0,1),
	anio INT NULL,
	cuatrimestre INT NULL,
	mes INT NULL
);
GO

--Ubicacion
CREATE TABLE R2D2_ARTURITO.BI_UBICACION(
	id_ubicacion INT PRIMARY KEY IDENTITY(0,1),
	id_localidad INT NULL,
	localidad VARCHAR(50) NULL,
	id_provincia INT NULL,
	provincia VARCHAR(50) NULL
);
GO

--Sucursal
CREATE TABLE R2D2_ARTURITO.BI_SUCURSAL(
	id_sucursal INT PRIMARY KEY IDENTITY(0,1),
	nombre VARCHAR(50) NULL
);
GO

--Rango Etario
CREATE TABLE R2D2_ARTURITO.BI_RANGO_ETARIO(
	id_rango_etario INT PRIMARY KEY IDENTITY(0,1),
	rango_etario VARCHAR(50) NULL
);
GO

--Turnos
CREATE TABLE R2D2_ARTURITO.BI_RANGO_TURNOS(
	id_rango_turnos INT PRIMARY KEY IDENTITY(0,1),
	rango_turno VARCHAR(50) NULL
);
GO

--Medio Pago
CREATE TABLE R2D2_ARTURITO.BI_MEDIO_PAGO(
	id_medio_pago INT PRIMARY KEY IDENTITY(0,1),
	descripcion VARCHAR(50)
);
GO

--Categoria Productos
CREATE TABLE R2D2_ARTURITO.BI_CATEGORIA_PRODUCTOS(
	id INT PRIMARY KEY IDENTITY(0,1),
	id_categoria INT NULL,
	descripcion_categoria VARCHAR(50) NULL,
	id_subcategoria INT NULL,
	descripcion_subcategoria VARCHAR(50) NULL
);
GO


/*************************************************
 *	MIGRACIONES DE DATOS
 *************************************************/

--Turnos
CREATE PROCEDURE R2D2_ARTURITO.BI_MIGRAR_RANGO_TURNOS AS
BEGIN
	INSERT INTO R2D2_ARTURITO.BI_RANGO_TURNOS(rango_turno) 
		VALUES ('8:00-12:00'), ('12:00-16:00'), ('16:00-20:00')	
END
GO

--Rango Etario
CREATE PROCEDURE R2D2_ARTURITO.BI_MIGRAR_RANGO_ETARIO
AS
BEGIN
	INSERT INTO R2D2_ARTURITO.BI_RANGO_ETARIO (rango_etario)
		VALUES ('< 25'),('25 - 35'),('35 - 50'),('> 50')
END
GO

CREATE PROCEDURE R2D2_ARTURITO.BI_MIGRAR_TIEMPO
AS
BEGIN
	INSERT INTO R2D2_ARTURITO.BI_TIEMPO (anio, cuatrimestre, mes)
	SELECT DISTINCT
		YEAR(fecha) AS anio,
		DATEPART(quarter, fecha) AS cuatrimestre,
		MONTH(fecha) AS mes
	FROM R2D2_ARTURITO.VENTA
END



GO
