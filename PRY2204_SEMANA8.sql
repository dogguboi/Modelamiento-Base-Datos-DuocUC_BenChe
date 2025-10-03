-- REGION
CREATE TABLE REGION (
    id_region NUMBER PRIMARY KEY,
    nombre_region VARCHAR2(255) NOT NULL
);

-- COMUNA
CREATE TABLE COMUNA (
    id_comuna NUMBER PRIMARY KEY,
    nombre_comuna VARCHAR2(100) NOT NULL,
    cod_region NUMBER NOT NULL,
    CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region) REFERENCES REGION(id_region)
);

-- PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor NUMBER PRIMARY KEY,
    nombre_proveedor VARCHAR2(150) NOT NULL,
    rut_proveedor VARCHAR2(20),
    telefono VARCHAR2(20),
    email VARCHAR2(200),
    direccion VARCHAR2(200),
    cod_comuna NUMBER,
    CONSTRAINT PROVEEDOR_FK_COMUNA FOREIGN KEY (cod_comuna) REFERENCES COMUNA(id_comuna)
);

-- CATEGORIA
CREATE TABLE CATEGORIA (
    id_categoria NUMBER PRIMARY KEY,
    nombre_categoria VARCHAR2(255) NOT NULL
);

-- MARCA
CREATE TABLE MARCA (
    id_marca NUMBER PRIMARY KEY,
    nombre_marca VARCHAR2(100) NOT NULL
);

-- PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto NUMBER PRIMARY KEY,
    nombre_producto VARCHAR2(100) NOT NULL,
    precio_unitario NUMBER(12,2) NOT NULL,
    origen_nacional CHAR(1),
    stock_minimo NUMBER(5) DEFAULT 0,
    activo CHAR(1) DEFAULT 'S',
    cod_marca NUMBER,
    cod_categoria NUMBER,
    cod_proveedor NUMBER,
    CONSTRAINT PRODUCTO_FK_MARCA FOREIGN KEY (cod_marca) REFERENCES MARCA(id_marca),
    CONSTRAINT PRODUCTO_FK_CATEGORIA FOREIGN KEY (cod_categoria) REFERENCES CATEGORIA(id_categoria),
    CONSTRAINT PRODUCTO_FK_PROVEEDOR FOREIGN KEY (cod_proveedor) REFERENCES PROVEEDOR(id_proveedor)
);

-- PREVISION/SALUD 
CREATE TABLE SALUD (
    id_salud NUMBER PRIMARY KEY,
    nom_salud VARCHAR2(255) NOT NULL
);

-- AFP
CREATE TABLE AFP (
    id_afp NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 210 INCREMENT BY 6) PRIMARY KEY,
    nom_afp VARCHAR2(255) NOT NULL
);

-- EMPLEADO
CREATE TABLE EMPLEADO (
    id_empleado NUMBER PRIMARY KEY,
    rut_empleado VARCHAR2(20) NOT NULL,
    nombre_empleado VARCHAR2(100) NOT NULL,
    apellido_paterno VARCHAR2(100),
    apellido_materno VARCHAR2(100),
    fecha_contratacion DATE,
    sueldo_base NUMBER(12,2),
    bono_jefatura NUMBER(12,2),
    activo CHAR(1) DEFAULT 'S',
    tipo_empleado VARCHAR2(25),
    cod_empleado NUMBER,
    cod_salud NUMBER,
    cod_afp NUMBER,
    CONSTRAINT EMPLEADO_FK_SALUD FOREIGN KEY (cod_salud) REFERENCES SALUD(id_salud),
    CONSTRAINT EMPLEADO_FK_AFP FOREIGN KEY (cod_afp) REFERENCES AFP(id_afp)
);

-- ADMINISTRATIVO (subtipo)
CREATE TABLE ADMINISTRATIVO (
    id_empleado NUMBER PRIMARY KEY,
    CONSTRAINT ADMIN_PK FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- VENDEDOR
CREATE TABLE VENDEDOR (
    id_empleado NUMBER PRIMARY KEY,
    comision_venta NUMBER(5,2),
    CONSTRAINT VENDEDOR_PK FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- MEDIO_PAGO
CREATE TABLE MEDIO_PAGO (
    id_mpago NUMBER PRIMARY KEY,
    nombre_mpago VARCHAR2(50) NOT NULL
);

-- VENTA
CREATE TABLE VENTA (
    id_venta NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 5050 INCREMENT BY 3) PRIMARY KEY,
    fecha_venta DATE,
    total_venta NUMBER(12,2),
    cod_mpago NUMBER,
    cod_empleado NUMBER,
    CONSTRAINT VENTA_FK_MPAGO FOREIGN KEY (cod_mpago) REFERENCES MEDIO_PAGO(id_mpago),
    CONSTRAINT VENTA_FK_EMPLEADO FOREIGN KEY (cod_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    cod_venta NUMBER,
    cod_producto NUMBER,
    cantidad NUMBER,
    precio_unitario NUMBER(12,2),
    CONSTRAINT DET_VENTA_PK PRIMARY KEY (cod_venta, cod_producto),
    CONSTRAINT DET_VENTA_FK_VENTA FOREIGN KEY (cod_venta) REFERENCES VENTA(id_venta),
    CONSTRAINT DET_VENTA_FK_PRODUCTO FOREIGN KEY (cod_producto) REFERENCES PRODUCTO(id_producto)
);

-- caso 2: alter table y sequences

ALTER TABLE EMPLEADO
ADD CONSTRAINT ck_empleado_sueldo_min
CHECK (sueldo_base >= 400000);

ALTER TABLE VENDEDOR
ADD CONSTRAINT ck_vendedor_comision CHECK (comision_venta >= 0 AND comision_venta <= 0.25);

ALTER TABLE PRODUCTO
ADD CONSTRAINT ck_producto_stock CHECK (stock_minimo >= 3);

ALTER TABLE PROVEEDOR
ADD CONSTRAINT uq_proveedor_email UNIQUE (email);

ALTER TABLE MARCA
ADD CONSTRAINT uq_marca_nombre UNIQUE (nombre_marca);

ALTER TABLE DETALLE_VENTA
ADD CONSTRAINT ck_detalle_cantidad
CHECK (cantidad > 0);

CREATE SEQUENCE SEQ_EMPLEADO START WITH 750 INCREMENT BY 3 NOCACHE;
CREATE SEQUENCE SEQ_SALUD START WITH 2050 INCREMENT BY 10 NOCACHE;

-- caso 3: poblamiento

-- REGIONES
INSERT INTO REGION (id_region, nombre_region) VALUES (1, 'Región Metropolitana');
INSERT INTO REGION (id_region, nombre_region) VALUES (2, 'Valparaíso');
INSERT INTO REGION (id_region, nombre_region) VALUES (3, 'Biobío');
INSERT INTO REGION (id_region, nombre_region) VALUES (4, 'Los Lagos');

-- MEDIO_PAGO
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (11, 'Efectivo');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (12, 'Tarjeta Débito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (13, 'Tarjeta Crédito');
INSERT INTO MEDIO_PAGO (id_mpago, nombre_mpago) VALUES (14, 'Cheque');

-- AFP
INSERT INTO AFP (nom_afp) VALUES ('AFP Habitat');
INSERT INTO AFP (nom_afp) VALUES ('AFP Cuprum');
INSERT INTO AFP (nom_afp) VALUES ('AFP Provida');
INSERT INTO AFP (nom_afp) VALUES ('AFP PlanVital');

-- SALUD
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Fonasa');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Colmena');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Banmédica');
INSERT INTO SALUD (id_salud, nom_salud) VALUES (SEQ_SALUD.NEXTVAL, 'Isapre Cruz Blanca');

-- PROVEEDORES
INSERT INTO PROVEEDOR (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (1,'Distribuciones Sur','76.111.111-1','12345678','contacto@distsur.cl','Av. Sur 100', NULL);

INSERT INTO PROVEEDOR (id_proveedor, nombre_proveedor, rut_proveedor, telefono, email, direccion, cod_comuna)
VALUES (2,'Suministros Norte','77.222.222-2','23456789','ventas@sumnorte.cl','Calle Norte 45', NULL);

-- CATEGORIA/MARCA/PRODUCTO
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (1, 'Abarrotes');
INSERT INTO CATEGORIA (id_categoria, nombre_categoria) VALUES (2, 'Bebidas');

INSERT INTO MARCA (id_marca, nombre_marca) VALUES (1, 'MarcaA');
INSERT INTO MARCA (id_marca, nombre_marca) VALUES (2, 'MarcaB');

INSERT INTO PRODUCTO (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (101, 'Arroz 1kg', 1200, 'S', 10, 'S', 1, 1, 1);

INSERT INTO PRODUCTO (id_producto, nombre_producto, precio_unitario, origen_nacional, stock_minimo, activo, cod_marca, cod_categoria, cod_proveedor)
VALUES (102, 'Bebida Cola 1.5L', 900, 'N', 20, 'S', 2, 2, 2);

-- EMPLEADOS
INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '75011111-1', 'Marcela', 'González', 'Pérez', DATE '2022-03-15', 950000, 80000, 'S', 'Administrativo', (SELECT id_salud FROM SALUD WHERE nom_salud='Fonasa' AND ROWNUM=1), (SELECT id_afp FROM AFP WHERE nom_afp LIKE 'AFP Habitat' AND ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '75322222-2', 'José', 'Muñoz', 'Ramírez', DATE '2021-07-10', 900000, 75000, 'S', 'Administrativo', (SELECT id_salud FROM SALUD WHERE nom_salud='Isapre Colmena' AND ROWNUM=1), (SELECT id_afp FROM AFP WHERE nom_afp LIKE 'AFP Cuprum' AND ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '75633333-3', 'Verónica', 'Soto', 'Alarcón', DATE '2020-05-01', 880000, 70000, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE nom_salud='Isapre Banmédica' AND ROWNUM=1), (SELECT id_afp FROM AFP WHERE nom_afp LIKE 'AFP Provida' AND ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '75944444-4', 'Luis', 'Reyes', 'Fuentes', DATE '2023-01-04', 560000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE nom_salud='Isapre Cruz Blanca' AND ROWNUM=1), (SELECT id_afp FROM AFP WHERE nom_afp LIKE 'AFP PlanVital' AND ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '76255555-5', 'Claudia', 'Fernández', 'Lagos', DATE '2023-04-15', 600000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '76566666-6', 'Carlos', 'Navarro', 'Vega', DATE '2023-05-01', 610000, NULL, 'S', 'Administrativo', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '76877777-7', 'Javiera', 'Pino', 'Rojas', DATE '2023-09-07', 670000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '77188888-8', 'Diego', 'Mella', 'Contreras', DATE '2023-12-05', 620000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '77499999-9', 'Fernanda', 'Solas', 'Herrera', DATE '2023-08-18', 570000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

INSERT INTO EMPLEADO (id_empleado, rut_empleado, nombre_empleado, apellido_paterno, apellido_materno, fecha_contratacion, sueldo_base, bono_jefatura, activo, tipo_empleado, cod_salud, cod_afp)
VALUES (SEQ_EMPLEADO.NEXTVAL, '777101010-0', 'Tomás', 'Vidal', 'Espinoza', DATE '2023-06-01', 530000, NULL, 'S', 'Vendedor', (SELECT id_salud FROM SALUD WHERE ROWNUM=1), (SELECT id_afp FROM AFP WHERE ROWNUM=1));

-- dos empleados para insertar en VENDEDOR y ADMINISTRATIVO
INSERT INTO VENDEDOR (id_empleado, comision_venta)
SELECT id_empleado, 0.10 FROM (
  SELECT id_empleado FROM EMPLEADO WHERE tipo_empleado='Vendedor' ORDER BY id_empleado FETCH FIRST 3 ROWS ONLY
);

-- tomar un administrativo
INSERT INTO ADMINISTRATIVO (id_empleado)
SELECT id_empleado FROM EMPLEADO WHERE tipo_empleado='Administrativo' AND ROWNUM = 1;

-- VENTAS
INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (DATE '2023-05-12', 225990, 12, (SELECT id_empleado FROM EMPLEADO WHERE rut_empleado='777101010-0' AND ROWNUM=1));

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (DATE '2023-10-23', 524990, 13, (SELECT id_empleado FROM EMPLEADO WHERE rut_empleado='77188888-8' AND ROWNUM=1));

INSERT INTO VENTA (fecha_venta, total_venta, cod_mpago, cod_empleado)
VALUES (DATE '2023-02-17', 466990, 11, (SELECT id_empleado FROM EMPLEADO WHERE rut_empleado='75944444-4' AND ROWNUM=1));

-- DETALLE VENTA
INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, precio_unitario)
VALUES ((SELECT id_venta FROM (SELECT id_venta, ROWNUM rn FROM VENTA) WHERE rn = 1), 101, 2, 1200);

INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, precio_unitario)
VALUES ((SELECT id_venta FROM (SELECT id_venta, ROWNUM rn FROM VENTA) WHERE rn = 2), 102, 3, 900);

INSERT INTO DETALLE_VENTA (cod_venta, cod_producto, cantidad, precio_unitario)
VALUES ((SELECT id_venta FROM (SELECT id_venta, ROWNUM rn FROM VENTA) WHERE rn = 3), 101, 1, 1200);


COMMIT;

-- caso 4: informes

SELECT 
    e.id_empleado AS IDENTIFICADOR,
    (e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || NVL(e.apellido_materno,'')) AS "NOMBRE COMPLETO",
    e.sueldo_base AS SALARIO,
    e.bono_jefatura AS BONIFICACION,
    (e.sueldo_base + e.bono_jefatura) AS "SALARIO SIMULADO"
FROM EMPLEADO e
WHERE e.activo = 'S' AND e.bono_jefatura IS NOT NULL
ORDER BY (e.sueldo_base + e.bono_jefatura) DESC, e.apellido_paterno DESC;

SELECT
    (e.nombre_empleado || ' ' || e.apellido_paterno || ' ' || NVL(e.apellido_materno,'')) AS EMPLEADO,
    e.sueldo_base AS SUELDO,
    0.08 AS "POSIBLE AUMENTO",
    (e.sueldo_base * (1 + 0.08)) AS "SALARIO SIMULADO"
FROM EMPLEADO e
WHERE e.sueldo_base BETWEEN 550000 AND 800000
ORDER BY e.sueldo_base ASC;

