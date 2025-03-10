USE GD1C2024;
GO

CREATE SCHEMA R2D2_ARTURITO;
GO

/*************************************************
 *	CREACION DE TABLAS INDEPENDIENTES (ATOMICAS)
 *************************************************/

-- Tabla CATEGORIA_PRODUCTO
CREATE TABLE R2D2_ARTURITO.CATEGORIA (
    id_categoria BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla ESTADO_ENVIO
CREATE TABLE R2D2_ARTURITO.ESTADO_ENVIO (
    id_estado_envio INT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(50)NOT NULL
);
GO

-- Tabla ESTADO_FISCAL
CREATE TABLE R2D2_ARTURITO.ESTADO_FISCAL (
    id_estado_fiscal INT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(255) NULL
);
GO

-- Tabla MARCA
CREATE TABLE R2D2_ARTURITO.MARCA (
    id_marca BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla PRODUCTO
CREATE TABLE R2D2_ARTURITO.PRODUCTO (
    id_producto BIGINT PRIMARY KEY,
    descripcion VARCHAR(255) NULL,
    precio DECIMAL(10,2) NULL
);
GO

-- Tabla PROMOCION
CREATE TABLE R2D2_ARTURITO.PROMOCION (
    id_promocion INT PRIMARY KEY,
    descripcion VARCHAR(50) NULL,
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL
);
GO

-- Tabla PROVINCIA
CREATE TABLE R2D2_ARTURITO.PROVINCIA (
    id_provincia INT PRIMARY KEY IDENTITY(0,1),
    nombre VARCHAR(50) NULL
);
GO

-- Tabla SUBCATEGORIA
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA (
    id_subcategoria BIGINT PRIMARY KEY,
    descripcion VARCHAR(50) NULL,
);
GO

-- Tabla TARJETA
CREATE TABLE R2D2_ARTURITO.TARJETA (
    id_tarjeta INT PRIMARY KEY IDENTITY(0,1),
    numero CHAR(16) NULL,
    fecha_vencimiento DATE NULL
);
GO

-- Tabla TIPO_CAJA
CREATE TABLE R2D2_ARTURITO.TIPO_CAJA (
    id_tipo_caja SMALLINT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla TIPO_COMPROBANTE
CREATE TABLE R2D2_ARTURITO.TIPO_COMPROBANTE (
    id_tipo_comprobante SMALLINT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla TIPO_MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.TIPO_MEDIO_PAGO (
    id_tipo_medio_pago INT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(50) NULL
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA VENTA
 *************************************************/

-- Tabla LOCALIDAD
CREATE TABLE R2D2_ARTURITO.LOCALIDAD (
    id_localidad INT PRIMARY KEY IDENTITY(0,1),
    nombre VARCHAR(50) NULL,
    id_provincia INT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES R2D2_ARTURITO.PROVINCIA(id_provincia)
);
GO

-- Tabla DIRECCION
CREATE TABLE R2D2_ARTURITO.DIRECCION (
    id_direccion INT PRIMARY KEY IDENTITY(0,1),
    domicilio VARCHAR(255) NULL,
    id_localidad INT NOT NULL,
    FOREIGN KEY (id_localidad) REFERENCES R2D2_ARTURITO.LOCALIDAD(id_localidad)
);
GO

-- Tabla MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.MEDIO_PAGO (
    id_medio_pago INT PRIMARY KEY IDENTITY(0,1),
	descripcion VARCHAR(50) NOT NULL,
    id_tipo_medio_pago INT NOT NULL,
    FOREIGN KEY (id_tipo_medio_pago) REFERENCES R2D2_ARTURITO.TIPO_MEDIO_PAGO(id_tipo_medio_pago)
);
GO

-- Tabla SUPERMERCADO
CREATE TABLE R2D2_ARTURITO.SUPERMERCADO (
    id_supermercado INT PRIMARY KEY IDENTITY(0,1),
	nombre VARCHAR(50) NULL,
    razon_social VARCHAR(50) NULL,
	cuit VARCHAR(20) NULL,
    ingresos_brutos VARCHAR(50) NULL,
    id_direccion INT NOT NULL,
    inicio_actividad SMALLDATETIME NULL,
    id_estado_fiscal INT NOT NULL,
    FOREIGN KEY (id_direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion),
    FOREIGN KEY (id_estado_fiscal) REFERENCES R2D2_ARTURITO.ESTADO_FISCAL(id_estado_fiscal)
);
GO

-- Tabla SUCURSAL
CREATE TABLE R2D2_ARTURITO.SUCURSAL (
    id_sucursal INT PRIMARY KEY IDENTITY(0,1),
    nombre VARCHAR(50) NULL,
    id_direccion INT NOT NULL,
    id_supermercado INT NOT NULL,
    FOREIGN KEY (id_direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion),
    FOREIGN KEY (id_supermercado) REFERENCES R2D2_ARTURITO.SUPERMERCADO(id_supermercado)
);
GO

-- Tabla CAJA
CREATE TABLE R2D2_ARTURITO.CAJA (
    id_caja INT PRIMARY KEY IDENTITY(0,1),
    numero SMALLINT NOT NULL,
    id_tipo_caja SMALLINT NOT NULL,
	id_sucursal INT NOT NULL,
    FOREIGN KEY (id_tipo_caja) REFERENCES R2D2_ARTURITO.TIPO_CAJA(id_tipo_caja),
	FOREIGN KEY (id_sucursal) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal)
);
GO

-- Tabla EMPLEADO
CREATE TABLE R2D2_ARTURITO.EMPLEADO (
	id_empleado INT PRIMARY KEY IDENTITY(0,1),
    nombre VARCHAR(50) NULL,
    apellido VARCHAR(50) NULL,
	dni VARCHAR(18) NULL,
    fecha_nacimiento DATE NULL,
    telefono VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
	fecha_registro DATE NULL,
    id_sucursal_empleado INT NOT NULL,
    FOREIGN KEY (id_sucursal_empleado) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal)
);
GO

-- Tabla VENTA
CREATE TABLE R2D2_ARTURITO.VENTA (
    id_venta BIGINT PRIMARY KEY IDENTITY(0,1),
	numero_venta BIGINT NOT NULL,
    fecha SMALLDATETIME NULL,
	subtotal DECIMAL(10,2) NULL,
    total_descuento_promociones DECIMAL(10,2) NULL,
	total_descuento_aplicado_mp DECIMAL(10,2) NULL,
	total_envio DECIMAL(10,2) NULL,
	total_venta DECIMAL(10,2) NULL,
    id_sucursal INT NOT NULL,
    id_empleado INT NOT NULL,
    id_caja INT NOT NULL,
	id_tipo_comprobante SMALLINT NOT NULL,
    FOREIGN KEY (id_sucursal) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal),
    FOREIGN KEY (id_empleado) REFERENCES R2D2_ARTURITO.EMPLEADO(id_empleado),
    FOREIGN KEY (id_caja) REFERENCES R2D2_ARTURITO.CAJA(id_caja),
	FOREIGN KEY (id_tipo_comprobante) REFERENCES R2D2_ARTURITO.TIPO_COMPROBANTE(id_tipo_comprobante)
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA ENVIO
 *************************************************/

-- Tabla CLIENTE
CREATE TABLE R2D2_ARTURITO.CLIENTE (
    id_cliente INT PRIMARY KEY IDENTITY(0,1),
    nombre VARCHAR(50) NULL,
    apellido VARCHAR(50) NULL,
    dni VARCHAR(18) NULL,
    fecha_nacimiento DATE NULL,
    telefono VARCHAR(20) NULL,
    email VARCHAR(255) NULL,
	fecha_registro DATE NULL,
    id_direccion INT NOT NULL,
    FOREIGN KEY (id_direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion)
);
GO

-- Tabla ENVIO
CREATE TABLE R2D2_ARTURITO.ENVIO (
    id_envio INT PRIMARY KEY IDENTITY(0,1),
    fecha_programada DATE NULL,
    hora_inicio SMALLINT NULL,
    hora_fin SMALLINT NULL,
    fecha_entrega DATE NULL,
    costo DECIMAL(10,2) NULL,
    id_estado_envio INT NOT NULL,
    id_cliente INT NOT NULL,
	id_venta BIGINT NOT NULL,
    FOREIGN KEY (id_estado_envio) REFERENCES R2D2_ARTURITO.ESTADO_ENVIO(id_estado_envio),
    FOREIGN KEY (id_cliente) REFERENCES R2D2_ARTURITO.CLIENTE(id_cliente),
	FOREIGN KEY (id_venta) REFERENCES R2D2_ARTURITO.VENTA(id_venta)
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA REPRESENTAR PRODUCTOS
 *************************************************/

-- Tabla MARCA_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.MARCA_X_PRODUCTO (
    id_marca BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    FOREIGN KEY (id_marca) REFERENCES R2D2_ARTURITO.MARCA(id_marca),
    PRIMARY KEY (id_producto, id_marca)
);
GO

-- Tabla SUBCATEGORIA_X_CATEGORIA
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA_X_CATEGORIA (
    id_categoria BIGINT NOT NULL,
    id_subcategoria BIGINT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES R2D2_ARTURITO.CATEGORIA(id_categoria),
    FOREIGN KEY (id_subcategoria) REFERENCES R2D2_ARTURITO.SUBCATEGORIA(id_subcategoria),
    PRIMARY KEY (id_categoria, id_subcategoria)
);
GO

-- Tabla SUBCATEGORIA_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA_X_PRODUCTO (
    id_subcategoria BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    FOREIGN KEY (id_producto) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    FOREIGN KEY (id_subcategoria) REFERENCES R2D2_ARTURITO.SUBCATEGORIA(id_subcategoria),
    PRIMARY KEY (id_subcategoria, id_producto)
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA REPRESENTAR PROMOCIONES
 *************************************************/

-- Tabla PROMOCION_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.PROMOCION_X_PRODUCTO (
    id_promocion INT NOT NULL,
    id_producto BIGINT NOT NULL,
    FOREIGN KEY (id_promocion) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion),
    FOREIGN KEY (id_producto) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    PRIMARY KEY (id_promocion, id_producto)
);
GO

-- Tabla REGLA_PROMOCION
CREATE TABLE R2D2_ARTURITO.REGLA_PROMOCION (
    id_regla INT PRIMARY KEY IDENTITY(0,1),
    descripcion VARCHAR(50) NULL,
    cantidad_descuento SMALLINT NULL,
	porcentaje_descuento SMALLINT NULL,
    cantidad_productos SMALLINT NULL,
	cantidad_maxima SMALLINT NULL,
    misma_marca BIT NULL,
    mismo_producto BIT NULL,
	id_promocion INT NOT NULL,
	FOREIGN KEY (id_promocion) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion)
);
GO

-- Tabla ITEM_VENTA
CREATE TABLE R2D2_ARTURITO.ITEM_VENTA (
    id_item_venta BIGINT PRIMARY KEY IDENTITY(0,1),
    cantidad SMALLINT NULL,
    precio DECIMAL(10,2) NULL,
	total DECIMAL(10,2) NULL,
	id_venta BIGINT NOT NULL,
	id_producto BIGINT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES R2D2_ARTURITO.VENTA(id_venta),
    FOREIGN KEY (id_producto) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto)
);
GO

-- Tabla PROMOCION_APLICADA
CREATE TABLE R2D2_ARTURITO.PROMOCION_APLICADA (
    id_promocion INT NOT NULL,
    id_item_venta BIGINT NOT NULL,
    promocion_aplicada DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_promocion) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion),
    FOREIGN KEY (id_item_venta) REFERENCES R2D2_ARTURITO.ITEM_VENTA(id_item_venta),
    PRIMARY KEY (id_promocion, id_item_venta)
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA REPRESENTAR PAGOS
 *************************************************/

-- Tabla DETALLE_PAGO
CREATE TABLE R2D2_ARTURITO.DETALLE_PAGO (
    id_detalle_pago INT PRIMARY KEY IDENTITY(0,1),
    cuotas SMALLINT NOT NULL,
	id_tarjeta INT NOT NULL,
    id_cliente INT NULL,
    FOREIGN KEY (id_tarjeta) REFERENCES R2D2_ARTURITO.TARJETA(id_tarjeta),
    FOREIGN KEY (id_cliente) REFERENCES R2D2_ARTURITO.CLIENTE(id_cliente)
);
GO

-- Tabla PAGO
CREATE TABLE R2D2_ARTURITO.PAGO (
    id_pago INT PRIMARY KEY IDENTITY(0,1),
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    id_venta BIGINT NOT NULL,
    id_medio_pago INT NOT NULL,
    id_detalle_pago INT NULL,
    FOREIGN KEY (id_venta) REFERENCES R2D2_ARTURITO.VENTA(id_venta),
    FOREIGN KEY (id_medio_pago) REFERENCES R2D2_ARTURITO.MEDIO_PAGO(id_medio_pago),
    FOREIGN KEY (id_detalle_pago) REFERENCES R2D2_ARTURITO.DETALLE_PAGO(id_detalle_pago)
);
GO

-- Tabla DESCUENTO
CREATE TABLE R2D2_ARTURITO.DESCUENTO (
    id_descuento INT PRIMARY KEY,
    descripcion VARCHAR(50) NULL,
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL,
    porcentaje_descuento SMALLINT NULL,
	maximo_descuento DECIMAL(10,2) NULL,
    id_medio_pago INT NOT NULL,
    FOREIGN KEY (id_medio_pago) REFERENCES R2D2_ARTURITO.MEDIO_PAGO(id_medio_pago)
);
GO

-- Tabla DESCUENTO_X_PAGO
CREATE TABLE R2D2_ARTURITO.DESCUENTO_X_PAGO (
    id_pago INT NOT NULL,
    id_descuento INT NOT NULL,
    descuento_aplicado DECIMAL(10,2) NULL,
    FOREIGN KEY (id_pago) REFERENCES R2D2_ARTURITO.PAGO(id_pago),
    FOREIGN KEY (id_descuento) REFERENCES R2D2_ARTURITO.DESCUENTO(id_descuento),
    PRIMARY KEY (id_pago, id_descuento)
);
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES TABLAS ATOMICAS
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_CATEGORIA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.CATEGORIA (id_categoria,descripcion)
		SELECT DISTINCT
			SUBSTRING(M.PRODUCTO_CATEGORIA,13,7) AS id_categoria,
			M.PRODUCTO_CATEGORIA
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.PRODUCTO_CATEGORIA IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_ESTADO_ENVIO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.ESTADO_ENVIO(descripcion)
		SELECT DISTINCT
			M.ENVIO_ESTADO
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.ENVIO_ESTADO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_ESTADO_FISCAL AS
BEGIN
	INSERT INTO R2D2_ARTURITO.ESTADO_FISCAL(descripcion)
		SELECT DISTINCT
			M.SUPER_CONDICION_FISCAL
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.SUPER_CONDICION_FISCAL IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_MARCA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.MARCA(id_marca,descripcion)
		SELECT DISTINCT
			SUBSTRING(M.PRODUCTO_MARCA,9,11) AS id_marca,
			M.PRODUCTO_MARCA
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.PRODUCTO_MARCA IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PRODUCTO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PRODUCTO(id_producto,descripcion,precio)
		SELECT DISTINCT
			SUBSTRING(M.PRODUCTO_NOMBRE,8,12) AS id_producto,
			M.PRODUCTO_DESCRIPCION AS descripcion,
			(
				SELECT TOP 1 PRODUCTO_PRECIO
				FROM GD1C2024.gd_esquema.Maestra
				WHERE 
					PRODUCTO_NOMBRE = M.PRODUCTO_NOMBRE
					AND PRODUCTO_DESCRIPCION = M.PRODUCTO_DESCRIPCION
				ORDER BY PRODUCTO_PRECIO DESC
			) AS precio
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.PRODUCTO_NOMBRE IS NOT NULL
		GROUP BY M.PRODUCTO_NOMBRE, M.PRODUCTO_DESCRIPCION
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PROMOCION AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PROMOCION(id_promocion,descripcion,fecha_inicio,fecha_fin)
		SELECT DISTINCT
			M.PROMO_CODIGO,
			M.PROMOCION_DESCRIPCION,
			M.PROMOCION_FECHA_INICIO,
			M.PROMOCION_FECHA_FIN
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.PROMO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PROVINCIA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PROVINCIA(nombre)
	SELECT DISTINCT 
		CASE 
			WHEN M.CLIENTE_PROVINCIA IS NOT NULL THEN M.CLIENTE_PROVINCIA 
			WHEN M.SUPER_PROVINCIA IS NOT NULL THEN M.SUPER_PROVINCIA 
			WHEN M.SUCURSAL_PROVINCIA IS NOT NULL THEN M.SUCURSAL_PROVINCIA 
		END AS nombre
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE 
		M.CLIENTE_PROVINCIA IS NOT NULL OR 
		M.SUPER_PROVINCIA IS NOT NULL OR 
		M.SUCURSAL_PROVINCIA IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_SUBCATEGORIA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.SUBCATEGORIA (id_subcategoria,descripcion)
	SELECT DISTINCT
		SUBSTRING(M.PRODUCTO_SUB_CATEGORIA,16,7) AS id_subcategoria,
		M.PRODUCTO_SUB_CATEGORIA AS descripcion
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE M.PRODUCTO_SUB_CATEGORIA IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_TARJETA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.TARJETA(numero,fecha_vencimiento)
		SELECT DISTINCT
			M.PAGO_TARJETA_NRO,
			M.PAGO_TARJETA_FECHA_VENC
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE 
			M.PAGO_TARJETA_NRO IS NOT NULL
			AND M.PAGO_TARJETA_FECHA_VENC IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_TIPO_CAJA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.TIPO_CAJA(descripcion)
		SELECT DISTINCT
			M.CAJA_TIPO
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.CAJA_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_TIPO_COMPROBANTE AS
BEGIN
	INSERT INTO R2D2_ARTURITO.TIPO_COMPROBANTE(descripcion)
		SELECT DISTINCT
			M.TICKET_TIPO_COMPROBANTE
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.TICKET_TIPO_COMPROBANTE IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_TIPO_MEDIO_PAGO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.TIPO_MEDIO_PAGO(descripcion)
		SELECT DISTINCT
			M.PAGO_TIPO_MEDIO_PAGO
		FROM GD1C2024.gd_esquema.Maestra M
		WHERE M.PAGO_TIPO_MEDIO_PAGO IS NOT NULL
END
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES PARA VENTA
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_LOCALIDAD AS
BEGIN
	INSERT INTO R2D2_ARTURITO.LOCALIDAD (id_provincia,nombre)
	SELECT DISTINCT 
		P.id_provincia AS id_provincia,
        M.SUPER_LOCALIDAD AS nombre
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA P ON P.nombre = M.SUPER_PROVINCIA
    WHERE M.SUPER_LOCALIDAD IS NOT NULL
    UNION
    SELECT DISTINCT
		P.id_provincia AS id_provincia,
        M.SUCURSAL_LOCALIDAD AS nombre
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA P ON P.nombre = M.SUCURSAL_PROVINCIA
    WHERE M.SUCURSAL_LOCALIDAD IS NOT NULL
    UNION
    SELECT DISTINCT 
		P.id_provincia AS id_provincia,
        M.CLIENTE_LOCALIDAD AS nombre
    FROM 
       GD1C2024.gd_esquema.Maestra M
       INNER JOIN R2D2_ARTURITO.PROVINCIA P ON P.nombre = M.CLIENTE_PROVINCIA
    WHERE M.CLIENTE_LOCALIDAD IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_DIRECCION AS
BEGIN
	INSERT INTO R2D2_ARTURITO.DIRECCION (id_localidad,domicilio)
	SELECT DISTINCT
		L.id_localidad AS id_localidad,
		M.SUPER_DOMICILIO AS domicilio
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.PROVINCIA P ON M.SUPER_PROVINCIA = P.nombre
		INNER JOIN R2D2_ARTURITO.LOCALIDAD L ON M.SUPER_LOCALIDAD = L.nombre
		AND L.id_provincia = P.id_provincia
	UNION
	SELECT DISTINCT
		L.id_localidad AS id_localidad,
		M.CLIENTE_DOMICILIO AS domicilio
	FROM GD1C2024.gd_esquema.Maestra M
	INNER JOIN R2D2_ARTURITO.PROVINCIA P ON M.CLIENTE_PROVINCIA = P.nombre
	INNER JOIN R2D2_ARTURITO.LOCALIDAD L ON M.CLIENTE_LOCALIDAD = L.nombre
	AND L.id_provincia = P.id_provincia
	UNION
	SELECT DISTINCT
		L.id_localidad AS id_localidad,
		M.SUCURSAL_DIRECCION AS domicilio
	FROM GD1C2024.gd_esquema.Maestra M
	INNER JOIN R2D2_ARTURITO.PROVINCIA P ON M.SUCURSAL_PROVINCIA = P.nombre
	INNER JOIN R2D2_ARTURITO.LOCALIDAD L ON M.SUCURSAL_LOCALIDAD = L.nombre
	AND L.id_provincia = P.id_provincia
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_MEDIO_PAGO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.MEDIO_PAGO (descripcion,id_tipo_medio_pago)
	SELECT DISTINCT
		M.PAGO_MEDIO_PAGO AS descripcion,
		TMP.id_tipo_medio_pago AS id_tipo_medio_pago
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.TIPO_MEDIO_PAGO TMP ON M.PAGO_TIPO_MEDIO_PAGO = TMP.descripcion
	WHERE M.PAGO_MEDIO_PAGO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_SUPERMERCADO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.SUPERMERCADO (
		id_direccion,
		id_estado_fiscal,
		ingresos_brutos,
		inicio_actividad,
		nombre,
		razon_social,
		cuit
	)
	SELECT DISTINCT
		D.id_direccion AS id_direccion,
		E.id_estado_fiscal AS id_estado_fiscal,
		M.SUPER_IIBB AS ingresos_brutos,
		M.SUPER_FECHA_INI_ACTIVIDAD AS inicio_actividad,
		M.SUPER_NOMBRE AS nombre,
		M.SUPER_RAZON_SOC AS razon_social,
		M.SUPER_CUIT AS cuit
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.DIRECCION D ON M.SUPER_DOMICILIO = D.domicilio
		INNER JOIN R2D2_ARTURITO.ESTADO_FISCAL E ON M.SUPER_CONDICION_FISCAL = E.descripcion
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_SUCURSAL AS
BEGIN
	INSERT INTO R2D2_ARTURITO.SUCURSAL (id_direccion,id_supermercado,nombre)
	SELECT DISTINCT
		D.id_direccion AS id_direccion,
		S.id_supermercado AS id_supermercado,
		M.SUCURSAL_NOMBRE AS nombre
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.DIRECCION D ON M.SUCURSAL_DIRECCION = D.domicilio
		INNER JOIN R2D2_ARTURITO.SUPERMERCADO S ON M.SUPER_CUIT = S.cuit
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_CAJA AS
BEGIN
	INSERT INTO CAJA (id_sucursal,id_tipo_caja,numero)
	SELECT DISTINCT
		S.id_sucursal AS id_sucursal,
		TC.id_tipo_caja AS id_tipo_caja,
		M.CAJA_NUMERO AS numero
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.SUCURSAL S ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.TIPO_CAJA TC ON M.CAJA_TIPO = TC.descripcion
	WHERE
		M.CAJA_NUMERO IS NOT NULL 
		AND M.CAJA_TIPO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_EMPLEADO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.EMPLEADO (
		apellido,
		nombre,
		dni,
		email,
		fecha_nacimiento,
		fecha_registro,
		telefono,
		id_sucursal_empleado
	)
	SELECT DISTINCT
		M.EMPLEADO_APELLIDO AS apellido,
		M.EMPLEADO_NOMBRE AS nombre,
		M.EMPLEADO_DNI AS dni,
		M.EMPLEADO_MAIL AS email,
		M.EMPLEADO_FECHA_NACIMIENTO AS fecha_nacimiento,
		M.EMPLEADO_FECHA_REGISTRO AS fecha_registro,
		M.EMPLEADO_TELEFONO AS telefono,
		S.id_sucursal AS id_sucursal_empleado
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.SUCURSAL S ON M.SUCURSAL_NOMBRE = S.nombre
	WHERE M.EMPLEADO_APELLIDO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_VENTA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.VENTA (
		fecha,
		numero_venta,
		subtotal,
		total_descuento_aplicado_mp,
		total_descuento_promociones,
		total_envio,
		total_venta,
		id_caja,
		id_empleado,
		id_sucursal,
		id_tipo_comprobante
	)
	SELECT DISTINCT
		M.TICKET_FECHA_HORA AS fecha,
		M.TICKET_NUMERO AS numero,
		M.TICKET_SUBTOTAL_PRODUCTOS AS subtotal,
		M.TICKET_TOTAL_DESCUENTO_APLICADO_MP AS total_descuento_aplicado_mp,
		M.TICKET_TOTAL_DESCUENTO_APLICADO AS total_descuento_promociones,
		M.TICKET_TOTAL_ENVIO AS total_envio,
		M.TICKET_TOTAL_TICKET AS total_venta,
		C.id_caja AS id_caja,
		E.id_empleado AS id_empleado,
		S.id_sucursal AS id_sucursal,
		TCOM.id_tipo_comprobante AS id_tipo_comprobante
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.SUCURSAL S 
			ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.CAJA C 
			ON M.CAJA_NUMERO = C.numero
			AND C.id_sucursal = S.id_sucursal
		INNER JOIN R2D2_ARTURITO.TIPO_CAJA TC 
			ON M.CAJA_TIPO = TC.descripcion
			AND TC.id_tipo_caja = C.id_tipo_caja
		INNER JOIN R2D2_ARTURITO.EMPLEADO E 
			ON M.EMPLEADO_DNI = E.dni
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TCOM ON M.TICKET_TIPO_COMPROBANTE = TCOM.descripcion
	WHERE M.TICKET_NUMERO IS NOT NULL
END
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES PARA ENVIO
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_CLIENTE AS
BEGIN
	INSERT INTO R2D2_ARTURITO.CLIENTE(
		apellido,
		nombre,
		dni,
		email,
		fecha_nacimiento,
		fecha_registro,
		telefono,
		id_direccion
	)
	SELECT DISTINCT
		M.CLIENTE_APELLIDO AS apellido,
		M.CLIENTE_NOMBRE AS nombre,
		M.CLIENTE_DNI AS dni,
		M.CLIENTE_MAIL AS email,
		M.CLIENTE_FECHA_NACIMIENTO AS fecha_nacimiento,
		M.CLIENTE_FECHA_REGISTRO AS fecha_registro,
		M.CLIENTE_TELEFONO AS telefono,
		D.id_direccion AS id_direccion
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.PROVINCIA P 
			ON M.CLIENTE_PROVINCIA = P.nombre
		INNER JOIN R2D2_ARTURITO.LOCALIDAD L 
			ON M.CLIENTE_LOCALIDAD = L.nombre 
			AND P.id_provincia = L.id_provincia
		INNER JOIN R2D2_ARTURITO.DIRECCION D 
			ON M.CLIENTE_DOMICILIO = D.domicilio
			AND L.id_localidad = D.id_localidad
	WHERE M.CLIENTE_APELLIDO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_ENVIO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.ENVIO (
		costo,
		hora_inicio,
		hora_fin,
		fecha_programada,
		fecha_entrega,
		id_cliente,
		id_estado_envio,
		id_venta
	)
	SELECT DISTINCT
		M.ENVIO_COSTO AS costo,
		M.ENVIO_HORA_INICIO AS fecha_inicio,
		M.ENVIO_HORA_FIN AS fecha_fin,
		M.ENVIO_FECHA_PROGRAMADA AS fecha_programada,
		M.ENVIO_FECHA_ENTREGA AS fecha_entrega,
		C.id_cliente AS id_cliente,
		EE.id_estado_envio AS id_estado_envio,
		V.id_venta AS id_venta
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.CLIENTE C ON M.CLIENTE_DNI = C.dni
		INNER JOIN R2D2_ARTURITO.ESTADO_ENVIO EE ON M.ENVIO_ESTADO = EE.descripcion
		INNER JOIN R2D2_ARTURITO.VENTA V 
			ON M.TICKET_NUMERO = V.numero_venta
			AND M.TICKET_TOTAL_TICKET = V.total_venta
			AND M.TICKET_FECHA_HORA = V.fecha
			AND M.TICKET_SUBTOTAL_PRODUCTOS = V.subtotal
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO = V.total_descuento_promociones
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO_MP = V.total_descuento_aplicado_mp
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TC
			ON M.TICKET_TIPO_COMPROBANTE = TC.descripcion
	WHERE M.ENVIO_COSTO IS NOT NULL
END
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES PARA PRODUCTOS
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_MARCA_X_PRODUCTO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.MARCA_X_PRODUCTO (id_marca,id_producto)
	SELECT DISTINCT
		SUBSTRING(M.PRODUCTO_MARCA,9,11) AS id_marca,
		SUBSTRING(M.PRODUCTO_NOMBRE,8,12) AS id_producto
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE
		M.PRODUCTO_MARCA IS NOT NULL
		AND M.PRODUCTO_NOMBRE IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_SUBCATEGORIA_X_CATEGORIA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.SUBCATEGORIA_X_CATEGORIA (id_categoria,id_subcategoria)
	SELECT DISTINCT
		SUBSTRING(M.PRODUCTO_CATEGORIA, 13, 7) AS id_categoria,
		SUBSTRING(M.PRODUCTO_SUB_CATEGORIA, 16, 8) AS id_subcategoria
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE
		M.PRODUCTO_CATEGORIA IS NOT NULL
		AND M.PRODUCTO_SUB_CATEGORIA IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_SUBCATEGORIA_X_PRODUCTO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.SUBCATEGORIA_X_PRODUCTO (id_producto,id_subcategoria)
	SELECT DISTINCT
		SUBSTRING(M.PRODUCTO_NOMBRE,8,12) AS id_producto,
		SUBSTRING(M.PRODUCTO_SUB_CATEGORIA, 16, 8) AS id_subcategoria
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE
		M.PRODUCTO_NOMBRE IS NOT NULL
		AND M.PRODUCTO_SUB_CATEGORIA IS NOT NULL
END
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES PARA PROMOCIONES
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PROMOCION_X_PRODUCTO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PROMOCION_X_PRODUCTO (id_producto,id_promocion)
	SELECT DISTINCT
		SUBSTRING(M.PRODUCTO_NOMBRE,8,12) AS id_producto,
		M.PROMO_CODIGO AS id_promocion
	FROM GD1C2024.gd_esquema.Maestra M
	WHERE
		M.PRODUCTO_NOMBRE IS NOT NULL
		AND M.PROMO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_REGLA_PROMOCION AS
BEGIN
	INSERT INTO R2D2_ARTURITO.REGLA_PROMOCION (
		cantidad_descuento,
		cantidad_productos,
		cantidad_maxima,
		descripcion,
		misma_marca,
		mismo_producto,
		porcentaje_descuento,
		id_promocion
	)
	SELECT DISTINCT
		M.REGLA_CANT_APLICA_DESCUENTO AS cantidad_descuento,
		M.REGLA_CANT_APLICABLE_REGLA AS cantidad_productos,
		M.REGLA_CANT_MAX_PROD AS cantidad_maxima,
		M.REGLA_DESCRIPCION AS descripcion,
		M.REGLA_APLICA_MISMA_MARCA AS misma_marca,
		M.REGLA_APLICA_MISMO_PROD AS mismo_producto,
		M.REGLA_DESCUENTO_APLICABLE_PROD AS porcentaje_descuento,
		P.id_promocion AS id_promocion
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.PROMOCION P ON M.PROMO_CODIGO = P.id_promocion 
	WHERE M.REGLA_CANT_MAX_PROD IS NOT NULL

END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_ITEM_VENTA AS
BEGIN
	INSERT INTO ITEM_VENTA (cantidad,precio,total,id_producto,id_venta)
	SELECT DISTINCT
		M.TICKET_DET_CANTIDAD AS cantidad,
		M.TICKET_DET_PRECIO AS precio,
		M.TICKET_DET_TOTAL AS total,
		P.id_producto AS id_producto,
		V.id_venta AS id_venta
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.PRODUCTO P 
			ON SUBSTRING(M.PRODUCTO_NOMBRE,8,12) = P.id_producto
		INNER JOIN R2D2_ARTURITO.SUCURSAL S
			ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.CAJA C
			ON M.CAJA_NUMERO = C.numero
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TC
			ON M.TICKET_TIPO_COMPROBANTE = TC.descripcion
		INNER JOIN R2D2_ARTURITO.VENTA V 
			ON M.TICKET_NUMERO = V.numero_venta
			AND M.TICKET_SUBTOTAL_PRODUCTOS = V.subtotal
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO = V.total_descuento_promociones
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO_MP = V.total_descuento_aplicado_mp
			AND M.TICKET_TOTAL_ENVIO = V.total_envio
			AND M.TICKET_TOTAL_TICKET = V.total_venta
			AND M.TICKET_FECHA_HORA = V.fecha
			AND S.id_sucursal = V.id_sucursal
			AND C.id_caja = V.id_caja
			AND TC.id_tipo_comprobante = V.id_tipo_comprobante
	WHERE M.TICKET_DET_TOTAL IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PROMOCION_APLICADA AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PROMOCION_APLICADA (
		id_promocion,
		id_item_venta,
		promocion_aplicada
	)
	SELECT DISTINCT
		P.id_promocion AS id_promocion,
		IV.id_item_venta AS id_item_venta,
		M.PROMO_APLICADA_DESCUENTO AS promocion_aplicada
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.PROMOCION P ON M.PROMO_CODIGO = P.id_promocion
		INNER JOIN R2D2_ARTURITO.SUCURSAL S ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TC ON M.TICKET_TIPO_COMPROBANTE = TC.descripcion 
		INNER JOIN R2D2_ARTURITO.VENTA V
			ON M.TICKET_NUMERO = V.numero_venta
			AND M.TICKET_FECHA_HORA = V.fecha
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO = V.total_descuento_promociones
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO_MP = V.total_descuento_aplicado_mp
			AND M.TICKET_TOTAL_ENVIO = V.total_envio
			AND M.TICKET_SUBTOTAL_PRODUCTOS = V.subtotal
			AND M.TICKET_TOTAL_TICKET = V.total_venta
			AND S.id_sucursal = V.id_sucursal
			AND TC.id_tipo_comprobante = V.id_tipo_comprobante
		INNER JOIN R2D2_ARTURITO.ITEM_VENTA IV
			ON SUBSTRING(M.PRODUCTO_NOMBRE,8,12) = IV.id_producto
			AND M.TICKET_DET_CANTIDAD = IV.cantidad
			AND M.TICKET_DET_PRECIO = IV.precio
			AND M.TICKET_DET_TOTAL = IV.total
			AND V.id_venta = IV.id_venta
	WHERE M.PROMO_CODIGO IS NOT NULL
END
GO

/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES PARA PAGOS
 *************************************************/

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_DETALLE_PAGO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.DETALLE_PAGO (id_cliente,id_tarjeta,cuotas)
	SELECT DISTINCT
		C.id_cliente AS id_cliente,
		T.id_tarjeta AS id_tarjeta,
		M.PAGO_TARJETA_CUOTAS AS cuotas
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.TARJETA T
			ON M.PAGO_TARJETA_NRO = T.numero
			AND M.PAGO_TARJETA_FECHA_VENC = T.fecha_vencimiento
		LEFT JOIN GD1C2024.gd_esquema.Maestra AUX
			ON M.TICKET_NUMERO = AUX.TICKET_NUMERO
			AND M.TICKET_FECHA_HORA = AUX.TICKET_FECHA_HORA
			AND M.TICKET_TIPO_COMPROBANTE = AUX.TICKET_TIPO_COMPROBANTE
			AND AUX.CLIENTE_DNI IS NOT NULL
		LEFT JOIN R2D2_ARTURITO.CLIENTE C
			ON AUX.CLIENTE_DNI = C.dni
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_PAGO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.PAGO (
		fecha,
		monto,
		id_detalle_pago,
		id_medio_pago,
		id_venta
	)
	SELECT DISTINCT
		M.PAGO_FECHA AS fecha,
		M.PAGO_IMPORTE AS monto,
		DP.id_detalle_pago AS id_detalle_pago,
		MP.id_medio_pago AS id_medio_pago,
		V.id_venta AS id_venta
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.TIPO_MEDIO_PAGO TMP
			ON M.PAGO_TIPO_MEDIO_PAGO = TMP.descripcion
		INNER JOIN R2D2_ARTURITO.MEDIO_PAGO MP
			ON M.PAGO_MEDIO_PAGO = MP.descripcion
			AND TMP.id_tipo_medio_pago = MP.id_tipo_medio_pago
		INNER JOIN R2D2_ARTURITO.SUCURSAL S 
			ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TC 
			ON M.TICKET_TIPO_COMPROBANTE = TC.descripcion 
		INNER JOIN R2D2_ARTURITO.VENTA V
			ON M.TICKET_NUMERO = V.numero_venta
			AND M.TICKET_FECHA_HORA = V.fecha
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO = V.total_descuento_promociones
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO_MP = V.total_descuento_aplicado_mp
			AND M.TICKET_TOTAL_ENVIO = V.total_envio
			AND M.TICKET_SUBTOTAL_PRODUCTOS = V.subtotal
			AND M.TICKET_TOTAL_TICKET = V.total_venta
			AND S.id_sucursal = V.id_sucursal
			AND TC.id_tipo_comprobante = V.id_tipo_comprobante
		LEFT JOIN R2D2_ARTURITO.TARJETA T
			ON M.PAGO_TARJETA_FECHA_VENC = T.fecha_vencimiento
			AND M.PAGO_TARJETA_NRO = T.numero
		LEFT JOIN R2D2_ARTURITO.DETALLE_PAGO DP
			ON T.id_tarjeta = DP.id_tarjeta
	WHERE
		M.PAGO_MEDIO_PAGO IS NOT NULL
		OR T.id_tarjeta IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_DESCUENTO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.DESCUENTO (
		id_descuento,
		descripcion,
		fecha_inicio,
		fecha_fin,
		maximo_descuento,
		porcentaje_descuento,
		id_medio_pago
	)
	SELECT DISTINCT
		M.DESCUENTO_CODIGO AS id_descuento,
		M.DESCUENTO_DESCRIPCION AS descripcion,
		M.DESCUENTO_FECHA_INICIO AS fecha_inicio,
		M.DESCUENTO_FECHA_FIN AS fecha_fin,
		M.DESCUENTO_TOPE AS maximo_descuento,
		M.DESCUENTO_PORCENTAJE_DESC AS porcentaje_descuento,
		MP.id_medio_pago AS id_medio_pago
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.TIPO_MEDIO_PAGO TMP
			ON M.PAGO_TIPO_MEDIO_PAGO = TMP.descripcion
		INNER JOIN R2D2_ARTURITO.MEDIO_PAGO MP 
			ON M.PAGO_MEDIO_PAGO = MP.descripcion
			AND TMP.id_tipo_medio_pago = MP.id_tipo_medio_pago
	WHERE M.DESCUENTO_CODIGO IS NOT NULL
END
GO

CREATE PROCEDURE R2D2_ARTURITO.MIGRAR_DESCUENTO_X_PAGO AS
BEGIN
	INSERT INTO R2D2_ARTURITO.DESCUENTO_X_PAGO (id_descuento,id_pago,descuento_aplicado)
	SELECT DISTINCT
		D.id_descuento AS id_descuento,
		P.id_pago AS id_pago,
		M.PAGO_DESCUENTO_APLICADO AS descuento_aplicado
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.SUCURSAL S
			ON M.SUCURSAL_NOMBRE = S.nombre
		INNER JOIN R2D2_ARTURITO.TIPO_COMPROBANTE TC
			ON M.TICKET_TIPO_COMPROBANTE = TC.descripcion
		INNER JOIN R2D2_ARTURITO.VENTA V
			ON M.TICKET_NUMERO = V.numero_venta
			AND M.TICKET_FECHA_HORA = V.fecha
			AND M.TICKET_SUBTOTAL_PRODUCTOS = V.subtotal
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO = V.total_descuento_promociones
			AND M.TICKET_TOTAL_DESCUENTO_APLICADO_MP = V.total_descuento_aplicado_mp
			AND M.TICKET_TOTAL_ENVIO = V.total_envio
			AND M.TICKET_TOTAL_TICKET = V.total_venta
			AND TC.id_tipo_comprobante = V.id_tipo_comprobante
			AND S.id_sucursal = V.id_sucursal
		INNER JOIN R2D2_ARTURITO.PAGO P
			ON V.id_venta = P.id_venta
		INNER JOIN R2D2_ARTURITO.DESCUENTO D
			ON M.DESCUENTO_CODIGO = D.id_descuento
END
GO

/*************************************************
 *	MIGRACIONES TABLAS
 *************************************************/

-- MIGRACIONES TABLAS ATOMICAS
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS ATOMICAS *** '
EXEC R2D2_ARTURITO.MIGRAR_CATEGORIA;
EXEC R2D2_ARTURITO.MIGRAR_ESTADO_ENVIO;
EXEC R2D2_ARTURITO.MIGRAR_ESTADO_FISCAL;
EXEC R2D2_ARTURITO.MIGRAR_MARCA;
EXEC R2D2_ARTURITO.MIGRAR_PRODUCTO;
EXEC R2D2_ARTURITO.MIGRAR_PROMOCION;
EXEC R2D2_ARTURITO.MIGRAR_PROVINCIA;
EXEC R2D2_ARTURITO.MIGRAR_SUBCATEGORIA;
EXEC R2D2_ARTURITO.MIGRAR_TARJETA;
EXEC R2D2_ARTURITO.MIGRAR_TIPO_CAJA;
EXEC R2D2_ARTURITO.MIGRAR_TIPO_COMPROBANTE;
EXEC R2D2_ARTURITO.MIGRAR_TIPO_MEDIO_PAGO;

-- MIGRACIONES TABLAS PARA VENTA
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS PARA CONTEXTO VENTAS *** '
EXEC R2D2_ARTURITO.MIGRAR_LOCALIDAD;
EXEC R2D2_ARTURITO.MIGRAR_DIRECCION;
EXEC R2D2_ARTURITO.MIGRAR_MEDIO_PAGO;
EXEC R2D2_ARTURITO.MIGRAR_SUPERMERCADO;
EXEC R2D2_ARTURITO.MIGRAR_SUCURSAL;
EXEC R2D2_ARTURITO.MIGRAR_CAJA;
EXEC R2D2_ARTURITO.MIGRAR_EMPLEADO;
EXEC R2D2_ARTURITO.MIGRAR_VENTA;

-- MIGRACIONES TABLAS PARA ENVIO
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS PARA CONTEXTO ENVIOS *** '
EXEC R2D2_ARTURITO.MIGRAR_CLIENTE;
EXEC R2D2_ARTURITO.MIGRAR_ENVIO;

-- MIGRACIONES TABLAS PARA PRODUCTOS
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS PARA CONTEXTO PRODUCTOS *** '
EXEC R2D2_ARTURITO.MIGRAR_MARCA_X_PRODUCTO;
EXEC R2D2_ARTURITO.MIGRAR_SUBCATEGORIA_X_CATEGORIA;
EXEC R2D2_ARTURITO.MIGRAR_SUBCATEGORIA_X_PRODUCTO;

-- MIGRACIONES TABLAS PARA PROMOCIONES
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS PARA CONTEXTO PROMOCIONES *** '
EXEC R2D2_ARTURITO.MIGRAR_PROMOCION_X_PRODUCTO;
EXEC R2D2_ARTURITO.MIGRAR_REGLA_PROMOCION;
EXEC R2D2_ARTURITO.MIGRAR_ITEM_VENTA;
EXEC R2D2_ARTURITO.MIGRAR_PROMOCION_APLICADA;

-- MIGRACIONES PARA PAGOS
PRINT ''
PRINT ' *** [MIGRACION]: TABLAS PARA CONTEXTO PAGOS *** '
EXEC R2D2_ARTURITO.MIGRAR_DETALLE_PAGO;
EXEC R2D2_ARTURITO.MIGRAR_PAGO;
EXEC R2D2_ARTURITO.MIGRAR_DESCUENTO;
EXEC R2D2_ARTURITO.MIGRAR_DESCUENTO_X_PAGO;