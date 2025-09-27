-- tablas
-- region
CREATE TABLE REGION (
    id_region NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 7 INCREMENT BY 2),
    nombre_region VARCHAR2(25) NOT NULL,
    CONSTRAINT PK_REGION PRIMARY KEY (id_region)
);

-- comunas
CREATE TABLE COMUNA (
    id_comuna NUMBER(5) NOT NULL,
    comuna_nombre VARCHAR2(25) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna, cod_region),
    CONSTRAINT FK_COMUNA_REGION FOREIGN KEY (cod_region) REFERENCES REGION(id_region)
);

-- compania
CREATE TABLE COMPANIA (
    id_empresa NUMBER(2) NOT NULL,
    nombre_empresa VARCHAR2(25) NOT NULL,
    calle VARCHAR2(50),
    numeracion NUMBER(5),
    renta_promedio NUMBER(10),
    pct_aumento NUMBER(4,3),
    cod_comuna NUMBER(5),
    cod_region NUMBER(2),
    CONSTRAINT PK_COMPANIA PRIMARY KEY (id_empresa),
    CONSTRAINT UN_COMPANIA_NOMBRE UNIQUE (nombre_empresa),
    CONSTRAINT FK_COMPANIA_COMUNA FOREIGN KEY (cod_comuna, cod_region)
        REFERENCES COMUNA(id_comuna, cod_region)
);

-- idioma
CREATE TABLE IDIOMA (
    id_idioma NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 25 INCREMENT BY 3),
    nombre_idioma VARCHAR2(30) NOT NULL,
    CONSTRAINT PK_IDIOMA PRIMARY KEY (id_idioma)
);

-- personal
CREATE TABLE PERSONAL (
    id_personal NUMBER NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    dv_persona VARCHAR2(1),
    sueldo NUMBER,
    id_empresa NUMBER(2),
    id_comuna NUMBER(5),
    cod_region NUMBER(2),
    CONSTRAINT PK_PERSONAL PRIMARY KEY (id_personal),
    CONSTRAINT FK_PERSONAL_COMPANIA FOREIGN KEY (id_empresa) REFERENCES COMPANIA(id_empresa),
    CONSTRAINT FK_PERSONAL_COMUNA FOREIGN KEY (id_comuna, cod_region) REFERENCES COMUNA(id_comuna, cod_region)
);

-- alters
-- email unico
ALTER TABLE PERSONAL
ADD CONSTRAINT UNQ_PERSONAL_EMAIL UNIQUE (email);

-- codigo verificador
ALTER TABLE PERSONAL
ADD CONSTRAINT CK_DV CHECK (dv_persona IN ('0','1','2','3','4','5','6','7','8','9','K'));

-- sueldo de 450.000
ALTER TABLE PERSONAL
ADD CONSTRAINT CK_SUELDO CHECK (sueldo >= 450000);

-- secuencias

CREATE SEQUENCE SEQ_COMUNA START WITH 1101 INCREMENT BY 6 NOCACHE;
CREATE SEQUENCE SEQ_COMPANIA START WITH 10 INCREMENT BY 5 NOCACHE;

-- poblar 
-- regiones
INSERT INTO REGION (nombre_region) VALUES ('ARICA Y PARINACOTA');
INSERT INTO REGION (nombre_region) VALUES ('METROPOLITANA');
INSERT INTO REGION (nombre_region) VALUES ('LA ARAUCANIA');

-- comunas
INSERT INTO COMUNA VALUES (SEQ_COMUNA.NEXTVAL, 'Arica', 7);
INSERT INTO COMUNA VALUES (SEQ_COMUNA.NEXTVAL, 'Santiago', 9);
INSERT INTO COMUNA VALUES (SEQ_COMUNA.NEXTVAL, 'Temuco', 11);

-- idiomas
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Ingles');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Chino');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Aleman');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Espanol');
INSERT INTO IDIOMA (nombre_idioma) VALUES ('Frances');

-- companias
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'CCyRojas', 'Amapolas', 506, 1857000, 0.5, 1101, 7);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'SenTTy', 'Los Alamos', 3498, 897000, 0.025, 1101, 7);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'Praxia LTDA', 'Las Camelias', 11098, 2157000, 0.335, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'TIC spa', 'FLORES S.A.', 4357, 857000, NULL, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'SANTANA LTDA', 'AVDA VIC. MACKENA', 106, 757000, 0.015, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'FLORES Y ASOCIADOS', 'PEDRO LATORRE', 557, 589000, 0.015, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'J.A. HOFFMAN', 'LATINA D.32', 509, 1857000, NULL, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'CAGLIARI D.', 'ALAMEDA', 206, 1857000, NULL, 1107, 9);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'Rojas HNOS LTDA', 'SUCRE', 106, 957000, 0.005, 1113, 11);
INSERT INTO COMPANIA VALUES (SEQ_COMPANIA.NEXTVAL, 'FRIENDS P. S.A', 'SUECIA', 506, 857000, 0.015, 1113, 11);

-- consultas

-- simular de Renta Promedio
SELECT 
    c.nombre_empresa AS "Nombre Empresa",
    c.calle || ' ' || c.numeracion AS "Direccion",
    c.renta_promedio AS "Renta Promedio",
    (c.renta_promedio * (1 + NVL(c.pct_aumento, 0))) AS "Simulacion de Renta"
FROM COMPANIA c
ORDER BY c.renta_promedio DESC, c.nombre_empresa ASC;

-- INFORME 2: Nueva simulación con +15%
SELECT 
    c.id_empresa AS "ID Empresa",
    c.nombre_empresa AS "Nombre Empresa",
    c.renta_promedio AS "Renta Promedio Actual",
    (NVL(c.pct_aumento, 0) + 0.15) AS "Porcentaje Aumentado",
    (c.renta_promedio * (1 + NVL(c.pct_aumento, 0) + 0.15)) AS "Renta Promedio Incrementada"
FROM COMPANIA c
ORDER BY c.renta_promedio ASC, c.nombre_empresa DESC;
