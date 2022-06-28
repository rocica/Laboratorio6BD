/*TRIGGER 1*/
CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE ON ahorros
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

/*TRIGGER 2*/
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