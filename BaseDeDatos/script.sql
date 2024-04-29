drop table if exists detalle_pedido;
drop table if exists detalle_ventas;
drop table if exists historial_stock;
drop table if exists productos;
drop table if exists categorias;
drop table if exists unidades_medida;
drop table if exists categorias_unidades_medida;
drop table if exists cabecera_pedido;
drop table if exists cabecera_ventas;
drop table if exists proveedores;
drop table if exists estados_pedido;
drop table if exists tipo_documentos;

create table categorias(
	codigo_cat serial not null primary key,
	nombre varchar(100) not null,
	categoria_padre int,
	foreign key (categoria_padre) references categorias(codigo_cat)
);

create table categorias_unidades_medida(
	codigo_cat_udm char(1) not null primary key,
	nombre varchar(100) not null
);

create table unidades_medida(
	codigo_udm varchar(2) not null primary key,
	descripcion varchar(100) not null,
	categoria_udm char(1) not null,
	foreign key (categoria_udm) references categorias_unidades_medida(codigo_cat_udm)
);

create table productos(
	codigo_producto serial not null primary key,
	nombre varchar(100) not null,
	udm varchar(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria int not null,
	stock int not null,
	foreign key (udm) references unidades_medida(codigo_udm),
	foreign key (categoria) references categorias(codigo_cat)	
);

create table historial_stock(
	codigo serial not null primary key,
	fecha timestamp not null,
	referencia varchar(100) not null,
	producto int not null,
	cantidad int not null,
	foreign key (producto) references productos(codigo_producto)
);

create table tipo_documentos(
	codigo char(1) not null primary key,
	descripcion varchar(100) not null
);

create table proveedores(
	identificador varchar(13) not null primary key,
	tipo_documento char(1) not null,
	nombre varchar(100) not null,
	telefono varchar(10) not null,
	correo varchar(100) not null,
	direccion varchar(100) not null,
	foreign key (tipo_documento) references tipo_documentos(codigo)
);

create table estados_pedido(
	codigo char(1) not null primary key,
	descripcion varchar(100) not null
);

create table cabecera_pedido(
	numero serial not null primary key,
	proveedor varchar(13) not null,
	fecha date not null,
	estado char(1) not null,
	foreign key (proveedor) references proveedores(identificador),
	foreign key (estado) references estados_pedido(codigo)
);

create table detalle_pedido(
	codigo serial not null primary key,
	cabecera_pedido int not null,
	producto int not null,
	cantidad_solicitada int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	foreign key (cabecera_pedido) references cabecera_pedido(numero),
	foreign key (producto) references productos(codigo_producto)
);

create table cabecera_ventas(
	codigo serial not null primary key,
	fecha timestamp not null,
	total_sin_iva money not null,
	iva money not null,
	total money not null
);

create table detalle_ventas(
	codigo serial not null primary key,
	cabecera_ventas int not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_con_iva money not null,
	foreign key (cabecera_ventas) references cabecera_ventas(codigo),
	foreign key (producto) references productos(codigo_producto)
);

insert into categorias(nombre, categoria_padre) values
('Materia Prima', null),
('Proteína', 1),
('Salsas', 1),
('Punto de venta', null),
('Bebidas', 4),
('Con alcohol', 5),
('Sin alcohol', 5);

insert into categorias_unidades_medida(codigo_cat_udm, nombre) values
('U','Unidades'),
('V','Volumen'),
('P','Peso');

insert into unidades_medida(codigo_udm, descripcion, categoria_udm) values
('ml', 'mililitros', 'V'),
('L', 'litros', 'V'),
('u', 'unidad', 'U'),
('d', 'docena', 'U'),
('g', 'gramos', 'P'),
('kg', 'kilogramos', 'P'),
('lb', 'libras', 'P');

insert into productos(nombre, udm, precio_venta, tiene_iva, coste, categoria, stock) values
('Coca cola pequeña', 'u', money(0.5804), true, money(0.3729), 7, 105),
('Salsa de tomate', 'kg', money(0.84), true, money(0.68), 3, 0),
('Mostaza', 'kg', money(0.95), true, money(0.89), 3, 0),
('Fuze Tea', 'u', money(0.8), true, money(0.7), 7, 49);

insert into historial_stock(fecha, referencia, producto, cantidad) values
('20/04/2024 19:34', 'PEDIDO 1', 1, 100),
('20/04/2024 19:34', 'PEDIDO 1', 4, 50),
('20/04/2024 19:34', 'PEDIDO 2', 1, 10),
('20/04/2024 20:34', 'VENTA 1', 1, -5),
('20/04/2024 20:34', 'VENTA 1', 4, -1);

insert into tipo_documentos(codigo, descripcion) values
('C', 'CEDULA'),
('R', 'RUC');

insert into proveedores(identificador, tipo_documento, nombre, telefono, correo, direccion) values
('0102285747', 'C', 'ALEXANDER ESTRELLA', '0994784547', 'correo@mail.com', 'Cumbayork'),
('1748731025', 'R', 'SNACKS SA', '0945931048', 'mail@gmail.com', 'La Tola');

insert into estados_pedido(codigo, descripcion) values
('S', 'Solicitado'),
('R', 'Recibido');

insert into cabecera_pedido(proveedor, fecha, estado) values
('1748731025', '20/04/2024', 'R'),
('1748731025', '20/04/2024', 'R');

insert into detalle_pedido(cabecera_pedido, producto, cantidad_solicitada, subtotal, cantidad_recibida) values
(1, 1, 100, money(37.20), 100),
(1, 4, 50, money(11.8), 50),
(2, 1, 10, money(3.73), 10);

insert into cabecera_ventas(fecha, total_sin_iva, iva, total) values
('20/04/2024 20:00', money(3.13), money(0.73), money(3.86));

insert into detalle_ventas(cabecera_ventas, producto, cantidad, precio_venta, subtotal, subtotal_con_iva) values
(1, 1, 5, money(0.58), money(2.9), money(3.25)),
(1, 4, 1, money(0.36), money(0.36), money(0.4));

