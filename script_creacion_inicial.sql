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

-- Tabla ESTADO_FISCAL
CREATE TABLE R2D2_ARTURITO.ESTADO_FISCAL (
    id_estadoFiscal BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(255) NULL
);
GO

-- Tabla MARCA
CREATE TABLE R2D2_ARTURITO.MARCA (
    id_marca BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL
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
    id_tipo SMALLINT PRIMARY KEY IDENTITY(1,1),
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
 *	CREACION DE TABLAS DEPENDIENTES
 *************************************************/

-- Tabla LOCALIDAD
CREATE TABLE R2D2_ARTURITO.LOCALIDAD (
    id_localidad SMALLINT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50)NOT NULL,
    id_provincia SMALLINT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES R2D2_ARTURITO.PROVINCIA(id_provincia)
);
GO

-- Tabla DIRECCION
CREATE TABLE R2D2_ARTURITO.DIRECCION (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    domicilio VARCHAR(250)NOT NULL,
    direc_localidad SMALLINT NOT NULL,
    FOREIGN KEY (direc_localidad) REFERENCES R2D2_ARTURITO.LOCALIDAD(id_localidad)
);
GO

-- Tabla ESTADO_ENVIO
CREATE TABLE R2D2_ARTURITO.ESTADO_ENVIO (
    id_estado_envio INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50)NOT NULL
);
GO

-- Tabla MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.MEDIO_PAGO (
    id_medio_pago INT PRIMARY KEY IDENTITY(1,1),
	descripcion VARCHAR(50) NOT NULL,
    medio_pago_tipo INT NOT NULL,
    FOREIGN KEY (medio_pago_tipo) REFERENCES R2D2_ARTURITO.TIPO_MEDIO_PAGO(id_tipo_medio_pago)
);
GO

-- Tabla SUPERMERCADO
CREATE TABLE R2D2_ARTURITO.SUPERMERCADO (
    id_supermercado INT PRIMARY KEY IDENTITY(1,1),
	nombre VARCHAR(50)NOT NULL,
    razon_social VARCHAR(50)NOT NULL,
    SUPER_IBB VARCHAR(50)NOT NULL,
    direccion INT NOT NULL,
    inicio_actividad SMALLDATETIME NOT NULL,
    id_estadoFiscal INT NOT NULL,
    FOREIGN KEY (direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion),
    FOREIGN KEY (id_estadoFiscal) REFERENCES R2D2_ARTURITO.ESTADO_FISCAL(id_estadoFiscal)
);
GO

-- Tabla SUCURSAL
CREATE TABLE R2D2_ARTURITO.SUCURSAL (
    id_sucursal INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    id_localidad INT NOT NULL,
    id_supermercado INT NOT NULL,
    FOREIGN KEY (id_localidad) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion),
    FOREIGN KEY (id_supermercado) REFERENCES R2D2_ARTURITO.SUPERMERCADO(id_supermercado)
);
GO

-- Tabla CAJA
CREATE TABLE R2D2_ARTURITO.CAJA (
    id_caja INT PRIMARY KEY IDENTITY(1,1),
    numero SMALLINT NOT NULL,
    id_tipo SMALLINT NOT NULL,
	id_sucursal INT NOT NULL,
    FOREIGN KEY (id_tipo) REFERENCES R2D2_ARTURITO.TIPO_CAJA(id_tipo),
	FOREIGN KEY (id_sucursal) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal)
);
GO

-- Tabla EMPLEADO
CREATE TABLE R2D2_ARTURITO.EMPLEADO (
	id_empleado INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fecha_nacimiento  DATE NOT NULL,
    telefono VARCHAR(20)NOT NULL,
    email VARCHAR(50)NOT NULL,
    id_sucursal_empleado INT NOT NULL,
    FOREIGN KEY (id_sucursal_empleado) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal)
);
GO

-- Tabla CLIENTE
CREATE TABLE R2D2_ARTURITO.CLIENTE (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50)NOT NULL,
    apellido VARCHAR(50)NOT NULL,
    dni CHAR(8)NOT NULL,
    fecha_registro DATE NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    mail VARCHAR(100)NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    direccion INT NOT NULL,
    FOREIGN KEY (direccion) REFERENCES R2D2_ARTURITO.DIRECCION(id_direccion)
);
GO

-- Tabla REGLA_PROMOCION
CREATE TABLE R2D2_ARTURITO.REGLA_PROMOCION (
    id_regla INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NOT NULL,
    cantidad_descuentos SMALLINT NOT NULL,
    cantidad_productos SMALLINT NOT NULL,
    misma_marca BIT NOT NULL,
    mismo_producto BIT NOT NULL,
    descuento_producto DECIMAL(10,2) NOT NULL
);
GO

-- Tabla PRODUCTO
CREATE TABLE R2D2_ARTURITO.PRODUCTO (
    id_producto INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL
);
GO


-- Tabla SUBCATEGORIA
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA (
    id_subcategoria INT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NOT NULL,
    categoria_subcategoria INT NOT NULL,
    FOREIGN KEY (categoria_subcategoria) REFERENCES R2D2_ARTURITO.CATEGORIA(id_categoria)
);
GO

-- Tabla DETALLE_TARJETA
CREATE TABLE R2D2_ARTURITO.DETALLE_TARJETA (
    id_detalle_tarjeta INT PRIMARY KEY IDENTITY(1,1),
    tarjeta INT NOT NULL,
    cuotas SMALLINT NOT NULL,
    cliente_detalle INT NOT NULL,
    FOREIGN KEY (tarjeta) REFERENCES R2D2_ARTURITO.TARJETA(id_tarjeta),
    FOREIGN KEY (cliente_detalle) REFERENCES R2D2_ARTURITO.CLIENTE(id_cliente)
);
GO

-- Tabla DESCUENTO
CREATE TABLE R2D2_ARTURITO.DESCUENTO (
    id_descuento INT PRIMARY KEY IDENTITY(1,1),
    DESCUENTO_DESCRIPCION VARCHAR(50) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    porcentaje_descuento DECIMAL(5,2) NOT NULL,
    descuento_x_medio_pago INT NOT NULL,
    FOREIGN KEY (descuento_x_medio_pago) REFERENCES R2D2_ARTURITO.MEDIO_PAGO(id_medio_pago)
);
GO

-- Tabla VENTA
CREATE TABLE R2D2_ARTURITO.VENTA (
    id_venta INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    descuento DECIMAL(10,2) NOT NULL,
    sucursal_venta INT NOT NULL,
    empleado_venta INT NOT NULL,
    caja_venta INT NOT NULL,
    FOREIGN KEY (sucursal_venta) REFERENCES R2D2_ARTURITO.SUCURSAL(id_sucursal),
    FOREIGN KEY (empleado_venta) REFERENCES R2D2_ARTURITO.EMPLEADO(id_empleado),
    FOREIGN KEY (caja_venta) REFERENCES R2D2_ARTURITO.CAJA(id_caja)
);
GO

-- Tabla PAGO
CREATE TABLE R2D2_ARTURITO.PAGO (
    id_pago INT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    venta_pago INT NOT NULL,
    medio_pago_venta INT NOT NULL,
    detalle_venta INT NOT NULL,
    FOREIGN KEY (venta_pago) REFERENCES R2D2_ARTURITO.VENTA(id_venta),
    FOREIGN KEY (medio_pago_venta) REFERENCES R2D2_ARTURITO.MEDIO_PAGO(id_medio_pago),
    FOREIGN KEY (detalle_venta) REFERENCES R2D2_ARTURITO.DETALLE_TARJETA(id_detalle_tarjeta)
);
GO

-- Tabla ITEM_VENTA
CREATE TABLE R2D2_ARTURITO.ITEM_VENTA (
    id_item_venta INT PRIMARY KEY IDENTITY(1,1),
    detalle_venta INT NOT NULL,
    detalle_producto INT NOT NULL,
    cantidad SMALLINT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (detalle_venta) REFERENCES R2D2_ARTURITO.VENTA(id_venta),
    FOREIGN KEY (detalle_producto) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto)
);
GO

-- Tabla DESCUENTO_X_PAGO
CREATE TABLE R2D2_ARTURITO.DESCUENTO_X_PAGO (
    id_pago INT NOT NULL,
    descuento INT NOT NULL,
    descuento_aplicado DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pago) REFERENCES R2D2_ARTURITO.PAGO(id_pago),
    FOREIGN KEY (descuento) REFERENCES R2D2_ARTURITO.DESCUENTO(id_descuento),
    PRIMARY KEY (id_pago, descuento)
);
GO

-- Tabla PROMOCION_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.PROMOCION_X_PRODUCTO (
    id_promocion_x_producto INT NOT NULL,
    id_producto_x_promocion INT NOT NULL,
    FOREIGN KEY (id_promocion_x_producto) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion),
    FOREIGN KEY (id_producto_x_promocion) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    PRIMARY KEY (id_promocion_x_producto, id_producto_x_promocion)
);
GO

-- Tabla MARCA_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.MARCA_X_PRODUCTO (
    id_producto_marca INT NOT NULL,
    id_marca_producto INT NOT NULL,
    FOREIGN KEY (id_producto_marca) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    FOREIGN KEY (id_marca_producto) REFERENCES R2D2_ARTURITO.MARCA(id_marca),
    PRIMARY KEY (id_producto_marca, id_marca_producto)
);
GO

-- Tabla SUBCATEGORIA_X_PRODUCTO
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA_X_PRODUCTO (
    id_producto_subcategoria INT NOT NULL,
    id_subcategoria_producto INT NOT NULL,
    FOREIGN KEY (id_producto_subcategoria) REFERENCES R2D2_ARTURITO.PRODUCTO(id_producto),
    FOREIGN KEY (id_subcategoria_producto) REFERENCES R2D2_ARTURITO.SUBCATEGORIA(id_subcategoria),
    PRIMARY KEY (id_producto_subcategoria, id_subcategoria_producto)
);
GO

-- Tabla PROMOCION_APLICADA
CREATE TABLE R2D2_ARTURITO.PROMOCION_APLICADA (
    id_promocion_aplicada INT NOT NULL,
    id_item_venta INT NOT NULL,
    promocion_aplciada DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_promocion_aplicada) REFERENCES R2D2_ARTURITO.PROMOCION(id_promocion),
    FOREIGN KEY (id_item_venta) REFERENCES R2D2_ARTURITO.ITEM_VENTA(id_item_venta),
    PRIMARY KEY (id_promocion_aplicada, id_item_venta)
);
GO

-- Tabla ENVIO
CREATE TABLE R2D2_ARTURITO.ENVIO (
    id_envio INT PRIMARY KEY IDENTITY(1,1),
    fecha_programada DATE NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    fecha_entrega DATE NOT NULL,
    costo_envio DECIMAL(10,2) NOT NULL,
    estado_envio INT NOT NULL,
    cliente_envio INT NOT NULL,
    FOREIGN KEY (estado_envio) REFERENCES R2D2_ARTURITO.ESTADO_ENVIO(id_estado_envio),
    FOREIGN KEY (cliente_envio) REFERENCES R2D2_ARTURITO.CLIENTE(id_cliente)
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