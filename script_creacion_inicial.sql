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
    id_provincia INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NULL
);
GO

-- Tabla SUBCATEGORIA
CREATE TABLE R2D2_ARTURITO.SUBCATEGORIA (
    id_subcategoria BIGINT PRIMARY KEY IDENTITY(1,1),
    descripcion VARCHAR(50) NULL,
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
    id_localidad INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NULL,
    id_provincia INT NOT NULL,
    FOREIGN KEY (id_provincia) REFERENCES R2D2_ARTURITO.PROVINCIA(id_provincia)
);
GO

-- Tabla DIRECCION
CREATE TABLE R2D2_ARTURITO.DIRECCION (
    id_direccion INT PRIMARY KEY IDENTITY(1,1),
    domicilio VARCHAR(255) NULL,
    id_localidad INT NOT NULL,
    FOREIGN KEY (id_localidad) REFERENCES R2D2_ARTURITO.LOCALIDAD(id_localidad)
);
GO

-- Tabla MEDIO_PAGO
CREATE TABLE R2D2_ARTURITO.MEDIO_PAGO (
    id_medio_pago INT PRIMARY KEY IDENTITY(1,1),
	descripcion VARCHAR(50) NOT NULL,
    id_tipo_medio_pago INT NOT NULL,
    FOREIGN KEY (id_tipo_medio_pago) REFERENCES R2D2_ARTURITO.TIPO_MEDIO_PAGO(id_tipo_medio_pago)
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


/*************************************************
 *	CREACION DE PROCEDURES PARA MIGRACIONES
 *************************************************/