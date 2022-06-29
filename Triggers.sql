--TRIGGER 1
CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE OR INSERT ON ahorros
DECLARE
    v_codsucursal ahorros.cod_sucursal%type;
    v_montoahorro ahorros.saldoahorro%TYPE;
    CURSOR c_sucursales IS
		SELECT cod_sucursal
		FROM sucursales;
BEGIN
    OPEN c_sucursales;
    LOOP
        FETCH c_sucursales INTO v_codsucursal;
        EXIT WHEN c_sucursales%NOTFOUND;
        SELECT SUM (saldoahorro) 
            INTO v_montoahorro
            FROM ahorros 
            WHERE cod_sucursal = v_codsucursal;
        UPDATE sucursales 
            SET montoahorro = v_montoahorro
			WHERE cod_sucursal = v_codsucursal;
    END LOOP;
    CLOSE c_sucursales;
END ActSucursal;
/

--TRIGGER 2
CREATE OR REPLACE TRIGGER Act_Suc_Tipo_Prest
AFTER UPDATE ON ahorros 
DECLARE 
	v_montoahorro ahorros.saldoahorro%TYPE;
	v_tipo_ahorro ahorros.tipo_ahorro%TYPE;
	v_codsucursal ahorros.cod_sucursal%TYPE;
	CURSOR c_tipo_ahorro IS
		SELECT cod_sucursal, tipo_ahorro
		FROM suc_tipo_ahorro;
BEGIN
	OPEN c_tipo_ahorro;
	LOOP
		FETCH c_tipo_ahorro INTO v_codsucursal, v_tipo_ahorro;
		EXIT WHEN c_tipo_ahorro%NOTFOUND;
		SELECT SUM (saldoahorro)
			INTO v_montoahorro
            FROM ahorros 
            WHERE (cod_sucursal = v_codsucursal) AND (tipo_ahorro = v_tipo_ahorro);
		UPDATE suc_tipo_ahorro 
            SET montoahorrado = v_montoahorro
			WHERE (cod_sucursal = v_codsucursal) AND (tipo_ahorro = v_tipo_ahorro);
    END LOOP;
    CLOSE c_tipo_ahorro;
END Act_Suc_Tipo_Prest;
/

/*TRIGGER 3*/    
CREATE SEQUENCE SEQUENCE1
    START WITH 1
    INCREMENT BY 1;

CREATE OR REPLACE TRIGGER auditorias_disp
AFTER INSERT OR UPDATE OR DELETE ON AHORROS FOR EACH ROW
DECLARE
    v_accion char;
    v_name_tabla varchar2(20) := 'Ahorro';
    v_monto_retdep number(9,2);
    v_saldo_anterior auditoria.saldo_anterior%type;
    v_saldofinal_desp auditoria.saldofinal_desp%type;
    v_id_cliente ahorros.id_cliente%type;
    v_tipo_ahorro ahorros.tipo_ahorro%type;
    v_tipo_transac auditoria.tipo_transac%type;

BEGIN
    v_id_cliente := :NEW.id_cliente;
    v_tipo_ahorro := :NEW.tipo_ahorro;
    IF UPDATING THEN
        v_saldo_anterior :=:OLD.saldoahorro;
        v_saldofinal_desp := :NEW.saldoahorro;
        v_monto_retdep := ABS(v_saldofinal_desp - v_saldo_anterior);
        SELECT tipotransac INTO v_tipo_transac
            FROM transadeporeti 
            WHERE (id_cliente = v_id_cliente AND tipo_ahorro = V_tipo_ahorro);
    ELSIF INSERTING THEN
        v_accion:= 'I';
        v_tipo_transac:= 1;
        v_saldofinal_desp := :NEW.saldoahorro;
        v_monto_retdep := 0;
        v_saldo_anterior := 0;
    ELSIF DELETING THEN
        v_accion:= 'D';
        v_tipo_transac:= 2;
    END IF;
INSERT INTO auditoria
(id_transaccion_ahorro, tipo_op, monto_retdep, saldo_anterior, saldofinal_desp,tipo_transac,tabla, id_cliente, tipo_ahorro, fecha, usuario)
VALUES
(SEQUENCE1.nextval, v_accion, v_monto_retdep, v_saldo_anterior, v_saldofinal_desp,v_tipo_transac,v_name_tabla, v_id_cliente, v_tipo_ahorro, SYSDATE(), user);
END auditorias_disp;
/