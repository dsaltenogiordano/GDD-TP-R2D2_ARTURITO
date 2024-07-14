USE GD1C2024
GO

CREATE SCHEMA BI_R2D2_ARTURITO
GO

/************************************************************************************
 *	CREACION DIMENSIONES BASICAS SEG�N ENUNCIADO
 ************************************************************************************/

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

CREATE TABLE BI_R2D2_ARTURITO.BI_CATEGORIZACION_PRODUCTOS(
	id_categorizacion INT PRIMARY KEY IDENTITY(0,1),
	descripcion_categoria VARCHAR(200) NULL,
	descripcion_subcategoria VARCHAR(200) NULL
);
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_MEDIO_PAGO(
	id_medio_pago INT PRIMARY KEY IDENTITY(0,1),
	descripcion VARCHAR(50)
);
GO

/************************************************************************************
 *	CREACION DIMENSIONES ADICIONALES PARA LAS VISTAS
 ************************************************************************************/

CREATE TABLE BI_R2D2_ARTURITO.BI_TIPO_CAJA(
	id_tipo_caja INT PRIMARY KEY IDENTITY(0,1),
	descripcion VARCHAR(50) NOT NULL
 );
GO

CREATE TABLE BI_R2D2_ARTURITO.BI_VENTA(
	total_venta DECIMAL(10,2),
	cantidad_items_vendidos INT NULL,
	id_sucursal INT NOT NULL,
	id_tiempo INT NOT NULL,
	id_turno INT NOT NULL,
	id_tipo_caja INT NOT NULL,
	id_rango_etario INT NOT NULL
	FOREIGN KEY (id_sucursal) REFERENCES BI_R2D2_ARTURITO.BI_SUCURSAL(id_sucursal),
	FOREIGN KEY (id_tiempo) REFERENCES BI_R2D2_ARTURITO.BI_TIEMPO(id_tiempo),
	FOREIGN KEY (id_turno) REFERENCES BI_R2D2_ARTURITO.BI_RANGO_TURNOS(id_turno),
	FOREIGN KEY (id_tipo_caja) REFERENCES BI_R2D2_ARTURITO.BI_TIPO_CAJA(id_tipo_caja),
	FOREIGN KEY (id_rango_etario) REFERENCES BI_R2D2_ARTURITO.BI_RANGO_ETARIO(id_rango_etario),
	PRIMARY KEY (id_sucursal,id_tiempo,id_turno,id_tipo_caja,id_rango_etario)
);
GO


/************************************************************************************
 *	MIGRACIONES DE DATOS DE DIMENSIONES OBLIGATORIAS
 ************************************************************************************/

CREATE FUNCTION BI_R2D2_ARTURITO.ObtenerCuatrimestre (@fecha DATE)
RETURNS INT
AS
BEGIN
    DECLARE @cuatrimestre INT;

    SET @cuatrimestre = 
	CASE
        WHEN MONTH(@fecha) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(@fecha) BETWEEN 5 AND 8 THEN 2
        WHEN MONTH(@fecha) BETWEEN 9 AND 12 THEN 3
        ELSE NULL
    END;
    RETURN @cuatrimestre;
END;
GO

CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_TIEMPO AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_TIEMPO (anio, cuatrimestre, mes)
	SELECT DISTINCT
		YEAR(V.fecha) AS anio,
		BI_R2D2_ARTURITO.ObtenerCuatrimestre(V.fecha) AS cuatrimestre,
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
	INSERT INTO BI_R2D2_ARTURITO.BI_SUCURSAL(nombre, id_ubicacion)
	SELECT 
		S.nombre AS nombre,
		U.id_ubicacion AS id_ubicacion
	FROM R2D2_ARTURITO.SUCURSAL S
		INNER JOIN R2D2_ARTURITO.DIRECCION D 
			ON S.id_direccion = D.id_direccion
		INNER JOIN R2D2_ARTURITO.LOCALIDAD L
			ON D.id_localidad = L.id_localidad
		INNER JOIN R2D2_ARTURITO.PROVINCIA P
			ON L.id_provincia = P.id_provincia
		INNER JOIN BI_R2D2_ARTURITO.BI_UBICACION U
			ON L.nombre = U.localidad
			AND P.nombre = U.provincia
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

CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_TIPO_CAJA AS
BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_TIPO_CAJA (descripcion)
	SELECT DISTINCT TC.descripcion
	FROM R2D2_ARTURITO.TIPO_CAJA AS TC
	WHERE TC.id_tipo_caja IS NOT NULL
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

/************************************************************************************
 *	MIGRACIONES DE DATOS DE DIMENSIONES ADICIONALES
 ************************************************************************************/

CREATE FUNCTION BI_R2D2_ARTURITO.ObtenerRangoEtario (@fecha_nacimiento DATE)
RETURNS VARCHAR
AS
BEGIN
	DECLARE @rango_etario VARCHAR;
    DECLARE @edad INT;
    
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
    
    IF 
		(MONTH(@fecha_nacimiento) > MONTH(GETDATE())) 
		OR (MONTH(@fecha_nacimiento) = MONTH(GETDATE()) 
		AND DAY(@fecha_nacimiento) > DAY(GETDATE()))
    BEGIN
        SET @edad = @edad - 1;
    END

	IF (@edad < 25) BEGIN SET @rango_etario = '< 25' END
	ELSE IF (@edad BETWEEN 25 AND 35) BEGIN SET @rango_etario = '25 - 35' END
	ELSE IF (@edad BETWEEN 35 AND 50) BEGIN SET @rango_etario = '35 - 50' END
	ELSE IF (@edad < 25) BEGIN SET @rango_etario = '> 50' END
    
    RETURN @rango_etario;
END
GO 

CREATE FUNCTION BI_R2D2_ARTURITO.ObtenerHora (@fecha SMALLDATETIME)
RETURNS TIME
AS
BEGIN 
    RETURN CAST(@fecha AS TIME);
END
GO

 CREATE PROCEDURE BI_R2D2_ARTURITO.BI_MIGRAR_VENTAS AS
 BEGIN
	INSERT INTO BI_R2D2_ARTURITO.BI_VENTA(
		total_venta,
		cantidad_items_vendidos,
		id_sucursal,
		id_tiempo,
		id_turno,
		id_tipo_caja,
		id_rango_etario
	)
	SELECT
		V.total_venta AS total_venta,
		SUM(IV.cantidad) AS cantidad_items_vendidos,
		BI_S.id_sucursal AS id_sucursal,
		BI_TI.id_tiempo AS id_tiempo,
		BI_RTU.id_turno AS id_turno,
		BI_TC.id_tipo_caja AS id_tipo_caja,
		BI_RE.id_rango_etario AS id_rango_etario
	FROM R2D2_ARTURITO.VENTA V
		INNER JOIN R2D2_ARTURITO.ITEM_VENTA IV
			ON V.id_venta = IV.id_venta
		INNER JOIN R2D2_ARTURITO.SUCURSAL S
			ON V.id_sucursal = S.id_sucursal
		INNER JOIN BI_R2D2_ARTURITO.BI_SUCURSAL BI_S
			ON S.nombre = BI_S.nombre
		INNER JOIN BI_R2D2_ARTURITO.BI_TIEMPO BI_TI
			ON YEAR(V.fecha) = BI_TI.anio
			AND BI_R2D2_ARTURITO.ObtenerCuatrimestre(V.fecha) = BI_TI.cuatrimestre
			AND MONTH(V.fecha) = BI_TI.mes
		INNER JOIN R2D2_ARTURITO.CAJA C
			ON V.id_caja = C.id_caja
		INNER JOIN R2D2_ARTURITO.TIPO_CAJA TC
			ON C.id_tipo_caja = TC.id_tipo_caja
		INNER JOIN BI_R2D2_ARTURITO.BI_TIPO_CAJA BI_TC
			ON TC.descripcion = BI_TC.descripcion
		INNER JOIN R2D2_ARTURITO.EMPLEADO E
			ON V.id_empleado = E.id_empleado
		INNER JOIN BI_R2D2_ARTURITO.BI_RANGO_ETARIO BI_RE
			ON BI_R2D2_ARTURITO.ObtenerRangoEtario(E.fecha_nacimiento) = BI_RE.rango_etario
		INNER JOIN BI_R2D2_ARTURITO.BI_RANGO_TURNOS BI_RTU
			ON BI_R2D2_ARTURITO.ObtenerHora(V.fecha) BETWEEN BI_RTU.inicio AND BI_RTU.fin
	GROUP BY 
		V.total_venta, 
		BI_S.id_sucursal,
		BI_TI.id_tiempo,
		BI_TC.id_tipo_caja,
		BI_RE.id_rango_etario,
		BI_RTU.id_turno
 END
 GO

 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_TIEMPO;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_UBICACION;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_SUCURSAL;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_ETARIO;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_RANGO_TURNOS;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_TIPO_CAJA;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_MEDIO_PAGO;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_CATEGORIZACION_PRODUCTOS;
 EXEC BI_R2D2_ARTURITO.BI_MIGRAR_VENTAS;


/************************************************************************************
 * VISTA 1:
 * Ticket Promedio mensual. Valor promedio de las ventas (en $) seg�n la
 * localidad, a�o y mes. Se calcula en funci�n de la sumatoria del importe de las
 * ventas sobre el total de las mismas.
 ************************************************************************************/