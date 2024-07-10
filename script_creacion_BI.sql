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
        --PRINT @SQL_FK
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

        --PRINT @SQL_PK
        EXECUTE(@SQL_PK)

------------------------------------  D R O P    T A B L E S   -----------------------------------
        DECLARE @SQL_DROP NVARCHAR(MAX) = N'';

        SELECT @SQL_DROP += N'
	DROP TABLE R2D2_ARTURITO.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'R2D2_ARTURITO'
          AND TABLE_TYPE = 'BASE TABLE'
          AND TABLE_NAME LIKE 'BI[_]%'

        --PRINT @SQL_DROP
        EXECUTE(@SQL_DROP)

---------------------------------------- D R O P   V I E W S  -------------------------------------
        DECLARE @SQL_VIEW NVARCHAR(MAX) = N'';

        SELECT @SQL_VIEW += N'
	DROP VIEW R2D2_ARTURITO.' + TABLE_NAME + ';'
        FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'R2D2_ARTURITO'
          AND TABLE_TYPE = 'VIEW'
          AND TABLE_NAME LIKE 'BI[_]%'

        --PRINT @SQL_VIEW
        EXECUTE(@SQL_VIEW)

    END
GO

----------------------------------------- C R E A C I O N  T A B L A S -------------------------------------

--------------------------------------------- D I M E N S I O N E S ----------------------------------------
BEGIN TRANSACTION

--Tiempo
CREATE TABLE R2D2_ARTURITO.BI_TIEMPO(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	anio integer NOT NULL,
	cuatrimestre integer NOT NULL,
	mes integer NOT NULL
)


-- CLIENTE Ubicacion
CREATE TABLE R2D2_ARTURITO.BI_CLIENTE_UBICACION(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	localidad nvarchar(50),
	provincia nvarchar(50) 

)

--Sucursal
CREATE TABLE R2D2_ARTURITO.BI_SUCURSAL(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	nombre  varchar(50) NOT NULL
)

--Rango Etario
CREATE TABLE R2D2_ARTURITO.BI_RANGO_ETARIO(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	rango_etario nvarchar(50) NOT NULL
)

--Turnos
CREATE TABLE R2D2_ARTURITO.BI_RANGO_TURNOS(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	rango_turno nvarchar(50) NOT NULL
)

--Medio Pago
CREATE TABLE R2D2_ARTURITO.BI_MEDIO_PAGO(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	descripcion varchar(50)
)

--Categoria Productos
CREATE TABLE R2D2_ARTURITO.BI_CATEGORIA_PRODUCTOS(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	descripcion varchar(50)
)

/*
-- Cuotas
CREATE TABLE R2D2_ARTURITO.BI_CUOTAS(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	nro_cuotas integer NOT NULL
)

--Tipo Caja
CREATE TABLE R2D2_ARTURITO.BI_CUOTAS(
	id decimal(18, 0) IDENTITY PRIMARY KEY,
	descripcion varchar(50)
)

*/


COMMIT TRANSACTION

--------------------------------------------- H E C H O S ----------------------------------------
BEGIN TRANSACTION

COMMIT TRANSACTION


--------------------------------------- C R E A C I O N   F K ---------------------------------------

BEGIN TRANSACTION
COMMIT TRANSACTION

--------------------------------------- C R E A C I O N  SP DE MIGRACION ---------------------------------------
GO
--------------------------------------------- D I M E N S I O N E S ----------------------------------------

--Turnos
CREATE PROCEDURE R2D2_ARTURITO.BI_migrar_TURNOS
AS
BEGIN
	--SET IDENTITY_INSERT R2D2_ARTURIT.BI_Rango_Horario ON
	INSERT INTO R2D2_ARTURITO.BI_RANGO_TURNOS(rango_turno) 
	VALUES	('8:00-12:00'), 
			('12:00-16:00'), 
			('16:00-20:00')	
END
GO

--Rango Etario
CREATE PROCEDURE R2D2_ARTURITO.BI_migrar_rango_etario
AS
BEGIN
	SET IDENTITY_INSERT R2D2_ARTURITO.BI_RANGO_ETARIO ON
	INSERT INTO R2D2_ARTURITO.BI_RANGO_ETARIO (id, rango_etario)
	VALUES (1, '< 25'),
			(2, '25 - 35'),
			(3, '35 - 50'),
			(4,'> 50')
END
GO

CREATE PROCEDURE R2D2_ARTURITO.BI_migrar_tiempo
AS
BEGIN
	INSERT INTO R2D2_ARTURITO.BI_TIEMPO (anio, cuatrimestre, mes)
	SELECT DISTINCT
		YEAR(fecha),
		DATEPART(quarter, fecha),
		MONTH(fecha)
	FROM R2D2_ARTURITO.VENTA
END



GO

--------------------------------------- C R E A C I O N   F U N C I O N E S ---------------------------------------

--------------------------------------- M I G R A C I O N   B I ---------------------------------------


--------------------------------------- C R E A C I O N   V I S T A S ---------------------------------------
