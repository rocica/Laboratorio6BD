--LABORATORIO N6
ALTER TABLE sucursales ADD(
	--tipo_ahorro NUMBER (2), 
	montoahorro NUMBER(9, 2) DEFAULT 0 NOT NULL 
);

CREATE TABLE tipo_ahorro(
	tipo_ahorro NUMBER (2) NOT NULL,
    descripcion VARCHAR2 (30) NOT NULL,
    tasa NUMBER (9, 2) NOT NULL,
	CONSTRAINT Tipo_ahorro PRIMARY KEY(tipo_ahorro)
);

CREATE TABLE ahorros(
	cod_sucursal varchar2(4) NOT NULL,
	id_cliente number NOT NULL,
	tipo_ahorro number NOT NULL,
	numcuenta number NOT NULL,
	fechapertura date,
	tasainteres_ahorro number NOT NULL,
	letradepomens number NOT NULL,
	saldoahorro number NOT NULL,
	saldointeres number NOT NULL,
	fechadepo_ahorro date,
	fecharetiro_ahorro date,
	usuario varchar2(10) NOT NULL,
	fechamod_ahorro date,
	CONSTRAINT numcuenta PRIMARY KEY (numcuenta),
	CONSTRAINT FK_ahorros_cod_sucursal FOREIGN KEY (cod_sucursal)
		REFERENCES sucursales(cod_sucursal),
	CONSTRAINT FK_id_cliente_ahorro FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_tipo_ahorro FOREIGN KEY (tipo_ahorro)
		REFERENCES tipo_ahorro(tipo_ahorro)
);

CREATE TABLE auditoria(
	id_transaccion_ahorro number(4) NOT NULL,
	tabla varchar2(30) NOT NULL,
	tipo_op char NOT NULL,
    id_cliente number(4) NOT NULL,
	tipo_ahorro number(4) NOT NULL,
	tipo_transac number(1) NOT NULL,
	saldo_anterior number(9,2) NOT NULL,
	monto_retdep number(9,2) NOT NULL,
	saldofinal_desp number(9,2) NOT NULL,
	usuario varchar2(10) NOT NULL,
	fecha date,
	CONSTRAINT PK_id_transaccion_ahorro PRIMARY KEY (id_transaccion_ahorro),
	CONSTRAINT FK_id_cliente_auditoria FOREIGN KEY (id_cliente)
		REFERENCES cliente(id_cliente),
	CONSTRAINT FK_tipo_ahorro_auditoria FOREIGN KEY (tipo_ahorro)
		REFERENCES tipo_ahorro(tipo_ahorro),
    CONSTRAINT ch_tipo_op
        CHECK (tipo_op IN ('I', 'U', 'D')),
    CONSTRAINT ch_tipo_transac
        CHECK (tipo_transac IN ('1','2'))
);

CREATE TABLE transadeporeti
(
    cod_sucursal VARCHAR2(4) NOT NULL,
    id_transaccion NUMBER(4) NOT NULL,
    id_cliente NUMBER(4) NOT NULL,
    tipo_ahorro NUMBER(2) NOT NULL,
    fecha_transaccion DATE NOT NULL,
    monto_depret NUMBER (6) NOT NULL,
    status CHAR NOT NULL,
    usuario varchar2(10) NOT NULL,
    fecha_insercion DATE NOT NULL,
    tipotransac NUMBER (1) NOT NULL,
    PRIMARY KEY (id_transaccion),
    CONSTRAINT fk_cod_sucursal_trans FOREIGN KEY (cod_sucursal)
        REFERENCES SUCURSALES (cod_sucursal),
    CONSTRAINT fk_id_cliente_trans FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente),
    CONSTRAINT fk_id_transaccion_trans FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente),
    CONSTRAINT fk_tipo_ahorro_trans FOREIGN KEY (tipo_ahorro) 
        REFERENCES TIPO_AHORRO (TIPO_AHORRO),
    CONSTRAINT ch_tipotransac
        CHECK (tipotransac IN ('1','2')),
	CONSTRAINT ch_stat
        CHECK (status IN ('S', 'N'))
);

CREATE TABLE suc_tipo_ahorro(
	cod_sucursal varchar2(4) NOT NULL,
	tipo_ahorro number(4) NOT NULL, 
	montoahorrado number(9, 2) DEFAULT 0 NOT NULL,
	CONSTRAINT fk_cod_sucursal_ahorros2 
		FOREIGN KEY (cod_sucursal)
		REFERENCES sucursales (cod_sucursal),
	CONSTRAINT fk_tipo_ahorro1 
		FOREIGN KEY (tipo_ahorro)
		REFERENCES tipo_ahorro(tipo_ahorro)
);