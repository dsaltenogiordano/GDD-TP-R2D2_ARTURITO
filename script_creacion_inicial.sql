USE GD1C2024;
GO

CREATE SCHEMA R2D2_ARTURITO;
GO

/*************************************************
 *	CREACION DE TABLAS INDEPENDIENTES (ATOMICAS)
 *************************************************/

-- Tabla CATEGORIA_PRODUCTO
CREATE TABLE R2D2_ARTURITO.CATEGORIA (
    id_categoria BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla ESTADO_ENVIO
CREATE TABLE R2D2_ARTURITO.ESTADO_ENVIO (
    id_estado_envio INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50)NOT NULL
);
GO

-- Tabla ESTADO_FISCAL
CREATE TABLE R2D2_ARTURITO.ESTADO_FISCAL (
    id_estado_fiscal INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(255) NULL
);
GO

-- Tabla MARCA
CREATE TABLE R2D2_ARTURITO.MARCA (
    id_marca BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla PRODUCTO
CREATE TABLE R2D2_ARTURITO.PRODUCTO (
    id_producto BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(255) NULL,
    precio DECIMAL(10,2) NULL
);
GO

-- Tabla PROMOCION
CREATE TABLE R2D2_ARTURITO.PROMOCION (
    id_promocion INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL,
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL
);
GO

-- Tabla PROVINCIA
CREATE TABLE R2D2_ARTURITO.PROVINCIA (
    id_provincia BIGINT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NULL
);
GO

-- Tabla TARJETA
CREATE TABLE R2D2_ARTURITO.TARJETA (
    id_tarjeta INT PRIMARY KEY IDENTITY(1,1),
    numero CHAR(16) NULL,
    fecha_vencimiento DATE NULL
);
GO

-- Tabla TIPO_CAJA
CREATE TABLE R2D2_ARTURITO.TIPO_CAJA (
    id_tipo_caja SMALLINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla TIPO_COMPROBANTE
CREATE TABLE R2D2_ARTURITO.TIPO_COMPROBANTE (
    id_tipo_comprobante SMALLINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
);
GO

-- Tabla TIPO_MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.TIPO_MEDIO_PAGO (
    id_tipo_medio_pago INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA VENTA
 *************************************************/

-- Tabla LOCALIDAD
CREATE TABLE R2D2_ARTURITO.LOCALIDAD (
    id_localidad SMALLINT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NULL,
    id_provincia SMALLINT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES R2D2_ARTURITO.PROVINCIA(id_provincia)
);
GO

-- Tabla DIRECCION
CREATE TABLE R2D2_ARTURITO.DIRECCION (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    domicilio VARCHAR(255) NULL,
    id_localidad SMALLINT NOT NULL,
    FOREIGN KEY (id_localidad) REFERENCES R2D2_ARTURITO.LOCALIDAD(id_localidad)
);
GO

-- Tabla MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.MEDIO_PAGO (
    id_medio_pago INT PRIMARY KEY IDENTITY(1,1),
	descripcion VARCHAR(50) NOT NULL,
    id_tipo_medio_pago INT NOT NULL,
    FOREIGN KEY (TIPO_MEDIO_PAGO) REFERENCES R2D2_ARTURITO.TIPO_MEDIO_PAGO(id_tipo_medio_pago)
);
GO

-- Tabla SUBCATEGORIA
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA (
    id_subcategoria BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL,
);
GO

-- Tabla SUPERMERCADO
CREATE TABLE R2D2_ARTURITO.SUPERMERCADO (
    id_supermercado INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(50) NULL,
    razon_social VARCHAR(50) NULL,
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
    id_sucursal INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NULL,
    id_direccion INT NOT NULL,
    id_supermercado INT NOT NULL,
    FOREIGN KEY (id_direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion),
    FOREIGN KEY (id_supermercado) REFERENCES R2D2_ARTURITO.SUPERMERCADO(id_supermercado)
);
GO

-- Tabla CAJA
CREATE TABLE R2D2_ARTURITO.CAJA (
    id_caja INT PRIMARY KEY IDENTITY(1,1),
    numero SMALLINT NOT NULL,
    id_tipo_caja SMALLINT NOT NULL,
	id_sucursal INT NOT NULL,
    FOREIGN KEY (id_tipo_caja) REFERENCES R2D2_ARTURITO.TIPO_CAJA(id_tipo_caja),
	FOREIGN KEY (id_sucursal) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal)
);
GO

-- Tabla EMPLEADO
CREATE TABLE R2D2_ARTURITO.EMPLEADO (
	id_empleado INT PRIMARY KEY IDENTITY(1,1),
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
    id_venta BIGINT PRIMARY KEY IDENTITY(1,1),
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
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
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
    id_envio INT PRIMARY KEY IDENTITY(1,1),
    fecha_programada DATE NULL,
    fecha_inicio DATE NULL,
    fecha_fin DATE NULL,
    fecha_entrega DATE NULL,
    costo DECIMAL(10,2) NULL,
    id_estado_envio INT NOT NULL,
    id_cliente INT NOT NULL,
	id_venta INT NOT NULL,
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
    id_marca INT NOT NULL,
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
    id_regla INT PRIMARY KEY IDENTITY(1,1),
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
    id_item_venta BIGINT PRIMARY KEY IDENTITY(1,1),
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
    id_promocion_aplicada INT NOT NULL,
    id_item_venta BIGINT NOT NULL,
    promocion_aplciada DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_promocion_aplicada) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion),
    FOREIGN KEY (id_item_venta) REFERENCES R2D2_ARTURITO.ITEM_VENTA(id_item_venta),
    PRIMARY KEY (id_promocion_aplicada, id_item_venta)
);
GO

/*************************************************
 *	CREACION DE TABLAS DEPENDIENTES PARA REPRESENTAR PAGOS
 *************************************************/

-- Tabla DETALLE_PAGO
CREATE TABLE R2D2_ARTURITO.DETALLE_PAGO (
    id_detalle_pago INT PRIMARY KEY IDENTITY(1,1),
    cuotas SMALLINT NOT NULL,
	id_tarjeta INT NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_tarjeta) REFERENCES R2D2_ARTURITO.TARJETA(id_tarjeta),
    FOREIGN KEY (id_cliente) REFERENCES R2D2_ARTURITO.CLIENTE(id_cliente)
);
GO

-- Tabla PAGO
CREATE TABLE R2D2_ARTURITO.PAGO (
    id_pago INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    id_venta BIGINT NOT NULL,
    id_medio_pago INT NOT NULL,
    id_detalle_pago INT NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES R2D2_ARTURITO.VENTA(id_venta),
    FOREIGN KEY (id_medio_pago) REFERENCES R2D2_ARTURITO.MEDIO_PAGO(id_medio_pago),
    FOREIGN KEY (id_detalle_pago) REFERENCES R2D2_ARTURITO.DETALLE_PAGO(id_detalle_pago)
);
GO

-- Tabla DESCUENTO
CREATE TABLE R2D2_ARTURITO.DESCUENTO (
    id_descuento INT PRIMARY KEY IDENTITY(1,1),
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





----------------------------------------------------------------------
-- MIGRACION DE TABLAS 
----------------------------------------------------------------------

-- TABLAS SIN DEPENDENCIAS
CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarProvincia AS
BEGIN
    PRINT 'PROVINCIA'
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


CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarEstadoEnvio AS
BEGIN
    PRINT 'ESTADO_ENVIO'
    INSERT INTO GD1C2024.R2D2_ARTURITO.ESTADO_ENVIO (descripcion)
    SELECT DISTINCT 
        M.ENVIO_ESTADO AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.ENVIO_ESTADO IS NOT NULL
END
GO


CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarTipoMedioPago AS
BEGIN
    PRINT 'TIPO_MEDIO_PAGO'
    INSERT INTO GD1C2024.R2D2_ARTURITO.TIPO_MEDIO_PAGO(descripcion)
    SELECT DISTINCT 
        M.PAGO_TIPO_MEDIO_PAGO AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.PAGO_TIPO_MEDIO_PAGO IS NOT NULL
END
GO


CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarCaja AS
BEGIN
    PRINT 'CAJA'
    INSERT INTO GD1C2024.R2D2_ARTURITO.CAJA(
        numero,
        id_tipo,
        id_sucursal
    )
    SELECT DISTINCT 
        M.CAJA_NUMERO AS numero,
        M.CAJA_TIPO AS id_tipo,
        suc.id_sucursal AS id_sucursal
    FROM 
        GD1C2024.gd_esquema.Maestra M 
		INNER JOIN R2D2_ARTURITO.TIPO_CAJA tc
			ON tc.descripcion=SUBSTRING( M.CAJA_TIPO,CHARINDEX(' ', M.CAJA_TIPO, CHARINDEX(' ', M.CAJA_TIPO) + 1) + 1,LEN(M.CAJA_TIPO))
        INNER JOIN R2D2_ARTURITO.SUCURSAL suc 
			ON suc.nombre = M.SUCURSAL_NOMBRE
    WHERE 
        M.SUCURSAL_NOMBRE IS NOT NULL
        AND M.CAJA_NUMERO IS NOT NULL
		AND M.CAJA_TIPO IS NOT NULL
END
GO


CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarCategoriaProducto AS
BEGIN
    PRINT 'CATEGORIA'   
	INSERT INTO GD1C2024.R2D2_ARTURITO.CATEGORIA(descripcion)
    SELECT DISTINCT 
        M.PRODUCTO_CATEGORIA AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.PRODUCTO_CATEGORIA IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarMarca AS
BEGIN
    PRINT 'MARCA'
	INSERT INTO GD1C2024.R2D2_ARTURITO.MARCA(descripcion)
	 SELECT DISTINCT 
        M.PRODUCTO_MARCA AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.PRODUCTO_MARCA IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarEstadoFiscal AS
BEGIN
    PRINT 'ESTADO_FISCAL'
	INSERT INTO GD1C2024.R2D2_ARTURITO.ESTADO_FISCAL(descripcion)
	SELECT DISTINCT 
        M.SUPER_CONDICION_FISCAL AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.SUPER_CONDICION_FISCAL IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarTipoCaja AS
BEGIN
    PRINT 'TIPO_CAJA'
	INSERT INTO GD1C2024.R2D2_ARTURITO.TIPO_CAJA(descripcion)
	SELECT DISTINCT 
        M.CAJA_TIPO AS descripcion
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.CAJA_TIPO IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarTarjeta AS
BEGIN
    PRINT 'TARJETA'
	INSERT INTO GD1C2024.R2D2_ARTURITO.TARJETA(numero,fecha_vencimiento)
	SELECT DISTINCT 
        M.PAGO_TARJETA_NRO AS numero,
		M.PAGO_TARJETA_FECHA_VENC AS fecha_vencimiento
    FROM GD1C2024.gd_esquema.Maestra M
    WHERE M.PAGO_TARJETA_NRO IS NOT NULL AND M.PAGO_TARJETA_FECHA_VENC IS NOT NULL
END
GO


-- TABLAS CON DEPENDENCIAS DE LAS ANTERIORES

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarLocalidad AS
BEGIN
PRINT 'LOCALIDAD'
INSERT INTO GD1C2024.R2D2_ARTURITO.LOCALIDAD(
		nombre,
		id_provincia
	)
	SELECT DISTINCT 
        M.SUPER_LOCALIDAD AS nombre,
        prov.id_provincia AS id_provincia
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA prov ON prov.nombre = M.SUPER_PROVINCIA
    WHERE M.SUPER_LOCALIDAD IS NOT NULL
    UNION
    SELECT DISTINCT 
        M.SUCURSAL_LOCALIDAD AS nombre,
        prov.id_provincia AS id_provincia
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA prov ON prov.nombre = M.SUCURSAL_PROVINCIA
    WHERE M.SUCURSAL_LOCALIDAD IS NOT NULL
    UNION
    SELECT DISTINCT 
        M.CLIENTE_LOCALIDAD AS nombre,
        prov.id_provincia AS id_provincia
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA prov ON prov.nombre = M.CLIENTE_PROVINCIA
    WHERE M.CLIENTE_LOCALIDAD IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarDireccion AS
BEGIN
    PRINT 'DIRECCION'
    INSERT INTO GD1C2024.R2D2_ARTURITO.DIRECCION (
        domicilio,
        direc_localidad
    )
    SELECT DISTINCT 
        M.CLIENTE_DOMICILIO AS domicilio,
        l.id_localidad AS direc_localidad
    FROM 
         GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA p ON M.super_provincia = p.nombre
        INNER JOIN R2D2_ARTURITO.LOCALIDAD l ON p.id_provincia = l.id_provincia AND M.super_localidad = l.nombre
    WHERE M.super_domicilio IS NOT NULL
			AND M.super_provincia IS NOT NULL
			AND M.super_localidad IS NOT NULL
    UNION
    SELECT DISTINCT
        M.sucursal_direccion AS domicilio,
        l.id_localidad AS direc_localidad
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA p ON M.sucursal_provincia = p.nombre
        INNER JOIN R2D2_ARTURITO.LOCALIDAD l ON p.id_provincia = l.id_provincia AND M.sucursal_localidad = l.nombre
    WHERE M.sucursal_direccion IS NOT NULL
			AND M.sucursal_provincia IS NOT NULL
			AND M.sucursal_localidad IS NOT NULL
    UNION
    SELECT DISTINCT
        M.cliente_domicilio AS domicilio,
        l.id_localidad AS direc_localidad
    FROM 
        GD1C2024.gd_esquema.Maestra M
        INNER JOIN R2D2_ARTURITO.PROVINCIA p ON M.cliente_provincia = p.nombre
        INNER JOIN R2D2_ARTURITO.LOCALIDAD l ON p.id_provincia = l.id_provincia AND M.cliente_localidad = l.nombre
    WHERE M.cliente_domicilio IS NOT NULL
			AND M.cliente_provincia  IS NOT NULL
			AND M.cliente_localidad  IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarMedioPago AS
BEGIN
PRINT 'MEDIO_PAGO'
    INSERT INTO R2D2_ARTURITO.MEDIO_PAGO (
        descripcion,
        medio_pago_tipo)
	SELECT DISTINCT  
        M.PAGO_MEDIO_PAGO AS descripcion,
        TMP.id_tipo_medio_pago AS medio_pago_tipo
	FROM GD1C2024.gd_esquema.Maestra M
		INNER JOIN R2D2_ARTURITO.TIPO_MEDIO_PAGO TMP 
			ON M.PAGO_TIPO_MEDIO_PAGO = TMP.descripcion
	WHERE 
		M.PAGO_MEDIO_PAGO IS NOT NULL
		AND M.PAGO_TIPO_MEDIO_PAGO IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarTarjeta AS
BEGIN
PRINT 'TARJETA'
INSERT INTO GD1C2024.R2D2_ARTURITO.TARJETA(
		numero,
		fecha_vencimiento
	)
	SELECT DISTINCT 
		M.PAGO_TARJETA_NRO AS numero,
		M.PAGO_TARJETA_FECHA_VENC AS fecha_vencimiento
	FROM
		GD1C2024.gd_esquema.Maestra M
	WHERE
		M.PAGO_TARJETA_NRO IS NOT NULL
		AND PAGO_TARJETA_FECHA_VENC IS NOT NULL

END
GO

-- Tablas con Dependencias Multiples

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarSupermercado AS
BEGIN
    PRINT 'SUPERMERCADO'
    INSERT INTO GD1C2024.R2D2_ARTURITO.SUPERMERCADO (
        nombre,
        razon_social,
        SUPER_IBB,
        direccion,
        inicio_actividad,
        id_estadoFiscal
    )
    SELECT DISTINCT
        M.SUPER_NOMBRE AS nombre,
        M.SUPER_RAZON_SOC AS razon_social,
        M.SUPER_IIBB AS SUPER_IBB,
        dir.id_direccion AS direccion,
        M.SUPER_FECHA_INI_ACTIVIDAD AS inicio_actividad,
        ef.id_estadoFiscal AS id_estadoFiscal
    FROM
        GD1C2024.gd_esquema.Maestra M

		INNER JOIN R2D2_ARTURITO.PROVINCIA p ON M.SUPER_PROVINCIA = p.nombre
		INNER JOIN R2D2_ARTURITO.LOCALIDAD l ON m.SUPER_LOCALIDAD = l.nombre
											 AND p.nombre = l.nombre
        INNER JOIN R2D2_ARTURITO.DIRECCION dir ON dir.domicilio = M.SUPER_DOMICILIO
        INNER JOIN R2D2_ARTURITO.ESTADO_FISCAL ef ON ef.descripcion = M.SUPER_CONDICION_FISCAL
    WHERE
        M.SUPER_NOMBRE IS NOT NULL
        AND M.SUPER_RAZON_SOC IS NOT NULL
        AND M.SUPER_IIBB IS NOT NULL
        AND M.SUPER_DOMICILIO IS NOT NULL
        AND M.SUPER_CONDICION_FISCAL IS NOT NULL
        AND M.SUPER_FECHA_INI_ACTIVIDAD IS NOT NULL
END
GO

CREATE OR ALTER PROCEDURE R2D2_ARTURITO.MigrarCliente AS
BEGIN
PRINT 'CLIENTE'
    INSERT INTO R2D2_ARTURITO.CLIENTE (
        nombre,
        apellido,
        dni,
        fecha_nacimiento,
		fecha_registro,
		telefono,
		mail,
		direccion
    )
    SELECT DISTINCT          
        M.CLIENTE_NOMBRE AS nombre,             
        M.CLIENTE_APELLIDO AS apellido,         
        M.CLIENTE_DNI AS nro_documento,        
        M.CLIENTE_FECHA_NACIMIENTO AS fecha_nacimiento,
		M.CLIENTE_FECHA_REGISTRO AS fecha_registro,
		M.CLIENTE_TELEFONO AS celular,
		M.CLIENTE_MAIL AS email,
		M.CLIENTE_DOMICILIO AS direccion
    FROM
        GD1C2024.gd_esquema.Maestra M
    
	WHERE
		M.CLIENTE_DNI IS NOT NULL
		AND CLIENTE_NOMBRE IS NOT NULL
END
GO


CREATE PROCEDURE R2D2_ARTURITO.MigrarSucursal
AS
BEGIN
PRINT 'SUCURSAL'
	INSERT INTO R2D2_ARTURITO.SUCURSAL (nombre, id_localidad, id_supermercado)
	SELECT DISTINCT s.nombre,
                d.id_direccion,
                s.id_supermercado
	FROM gd_esquema.Maestra m
		JOIN R2D2_ARTURITO.SUPERMERCADO s ON m.SUPER_CUIT = s.id_supermercado
		JOIN R2D2_ARTURITO.PROVINCIA p ON m.SUCURSAL_PROVINCIA = p.id_provincia
		JOIN R2D2_ARTURITO.LOCALIDAD l ON m.SUCURSAL_LOCALIDAD = l.id_localidad
		AND p.id_provincia = l.id_provincia
		JOIN R2D2_ARTURITO.DIRECCION d ON m.SUCURSAL_DIRECCION = d.domicilio
		AND l.id_localidad = d.direc_localidad

	WHERE 
			M.SUCURSAL_LOCALIDAD IS NOT NULL
			AND M.SUCURSAL_PROVINCIA IS NOT NULL
END
GO



-- TABLAS SIN DEPENDENCIAS (ATOMICAS)
EXEC R2D2_ARTURITO.MigrarProvincia;
EXEC R2D2_ARTURITO.MigrarEstadoEnvio;
EXEC R2D2_ARTURITO.MigrarTipoMedioPago;
EXEC R2D2_ARTURITO.MigrarCategoriaProducto;
EXEC R2D2_ARTURITO.MigrarMarca;

EXEC R2D2_ARTURITO.MigrarCaja;
EXEC R2D2_ARTURITO.MigrarLocalidad;
EXEC R2D2_ARTURITO.MigrarDireccion;
EXEC R2D2_ARTURITO.MigrarMedioPago;
EXEC R2D2_ARTURITO.MigrarTarjeta;

EXEC R2D2_ARTURITO.MigrarSupermercado;
EXEC R2D2_ARTURITO.MigrarCliente;
EXEC R2D2_ARTURITO.MigrarSucursal;