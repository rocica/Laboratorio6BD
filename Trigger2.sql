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

/*TRIGGER 2*/
Create or replace trigger ActAhorroSuc 
AFTER UPDATE on ahorros FOR EACH ROW

Cursor c_ahorrotipo is
	select tipoahorro, cod_sucursal
	from tipo_ahorro_tip;
Cursor c_aho_rec is
	select ahorro, cod_sucursal, tipoahorro
	from ahorros;
BEGIN
	OPEN c_ahorrotipo;
	OPEN c_aho_rec;
	LOOP
		FETCH c_data_aho INTO v_cod_sucursal, v_tipoahorro1;
		EXIT WHEN c_ahorrotipo%NOTFOUND;
		UPDATE tipo_ahorro
		set monto = 0
		WHERE cod_sucursal = v_cod_sucursal AND tipoahorro = v_tipoahorro;
		LOOP
			FETCH c_aho_rec INTO v_ahorro, v_cod_sucursal_aho, v_tipoahorro2;
			EXIT WHEN c_cod_sucursal_aho%NOTFOUND;
			IF v_cod_sucursal_aho = v_cod_sucursal AND v_tipoahorro2 = v_tipoahorro1 THEN
				UPDATE tipo_ahorro_tip
				set Monto = Monto + v_ahorro;
				WHERE cod_sucursal = v_cod_sucursal AND tipoahorro = v_tipoahorro2 ;
		END LOOP;
	END LOOP;
	Close c_ahorrotipo;
	Close c_aho_rec;
END ActAhorroSuc;
/