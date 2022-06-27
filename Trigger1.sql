CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE ON ahorros
DECLARE
	v_sucursales ahorros.cod_sucursal%TYPE := 1;
	v_suma ahorros.saldoahorro%TYPE;
	v_cont_suc ahorros.saldoahorro%TYPE;
	CURSOR c_ahorro IS
		SELECT SUM(saldoahorro)
		FROM ahorros
		WHERE (cod_sucursal = v_sucursales);
	CURSOR C_SUCURSAL IS
		SELECT COUNT(cod_sucursal) suma
		FROM sucursales;
BEGIN
	OPEN c_ahorro;
	OPEN C_SUCURSAL;
	FETCH C_SUCURSAL INTO v_cont_suc;
	FOR v_sucursales in 1..5 LOOP
		FETCH c_ahorro INTO v_suma;
		UPDATE sucursales
			SET montoahorro = v_suma
			WHERE (cod_sucursal = v_sucursales);
			v_suma:=0;
	END LOOP;
CLOSE c_ahorro;
CLOSE C_SUCURSAL;
END ActSucursal;
/


/*PRUEBAS*/
CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE ON ahorros FOR EACH ROW
DECLARE
	v_sucursales ahorros.cod_sucursal%TYPE := 1;
	v_sumatoria ahorros.saldoahorro%TYPE;
	v_cont_suc BINARY_INTEGER;
	CURSOR c_ahorro IS
		SELECT SUM(saldoahorro)
		FROM ahorros
		WHERE (cod_sucursal = v_sucursales);
	SELECT COUNT(cod_sucursal) INTO v_sumatoria
		FROM sucursales;
BEGIN
	OPEN c_ahorro;
	FETCH C_SUCURSAL INTO v_cont_suc;
	LOOP
		EXIT WHEN c_ahorro%NOTFOUND;
		UPDATE sucursales
			SET montoahorro = v_sumatoria
			WHERE (cod_sucursal = v_sucursales);
			v_sumatoria:=0;
	END LOOP;
CLOSE c_ahorro;
END UpdateSucursalMonto;
/



CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE ON ahorros
DECLARE
	v_sucursales ahorros.cod_sucursal%TYPE;
	v_sumatoria ahorros.saldoahorro%TYPE;
	CURSOR c_ahorro IS
		SELECT SUM(saldoahorro) suma
			FROM ahorros
			WHERE (cod_sucursal = v_sucursales);
	CURSOR c_sucursales IS
		SELECT cod_sucursal
			FROM sucursales;
BEGIN
	OPEN c_ahorro;
	OPEN c_sucursales;
	LOOP
		FETCH c_sucursales INTO v_sucursales;
		FETCH c_ahorro INTO v_sumatoria;
		EXIT WHEN c_sucursales%NOTFOUND;
		UPDATE sucursales
			SET montoahorro = v_sumatoria
			WHERE (cod_sucursal = v_sucursales);
		v_sumatoria :=0;
END LOOP;
EXCEPTION
	WHEN DUP_VAL_ON_INDEX THEN
		DBMS_OUTPUT.PUT_LINE('ERROR. Ya existe ese registro.');
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('ERROR. No se encuentra ese registro.');
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('ERROR DETECTADO');
END ActSucursal;
/








CREATE OR REPLACE TRIGGER ActSucursal
AFTER UPDATE ON ahorros
DECLARE
    v_codsucursal ahorros.cod_sucursal%type;
    v_montoahorro ahorros.saldoahorro%TYPE;
	v_montosucursal sucursales.montoahorro%TYPE;
    CURSOR c_sucursales IS
		SELECT cod_sucursal, montoahorro
		FROM sucursales;
BEGIN
    OPEN c_sucursales;
    LOOP
        FETCH c_sucursales INTO v_codsucursal, v_montosucursal;
        EXIT WHEN c_sucursales%NOTFOUND;
        SELECT SUM (saldoahorro) 
            INTO v_montoahorro
            FROM ahorros 
            WHERE cod_sucursal = v_codsucursal;
            UPDATE sucursales 
                SET montoahorro = v_montoahorro;
    END LOOP;
    CLOSE c_sucursales;
END ActSucursal;
/