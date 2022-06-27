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
Create or replace trigger Update_Aho_Suc 
After update on ahorros FOR EACH ROW

Cursor c_data_aho_tip is
	select tipoahorro, cod_sucursalursal
	from tipo_ahorro_tip;
Cursor c_aho_rec is
	select ahorro, cod_sucursal, tipoahorro
	from ahorros;
Begin
	open c_data_aho_tip;
	open c_aho_rec;
	loop
		fetch c_data_aho into v_cod_sucursal, v_tipoahorro1;
		EXIT WHEN c_data_aho_tip%NOTFOUND;
		Update tipo_ahorro
		set monto = 0
		where cod_sucursal = v_cod_sucursal and tipoahorro = v_tipoahorro;
		LOOP
			Fetch c_aho_rec into v_ahorro, v_cod_sucursal_aho, v_tipoahorro2;
			EXIT WHEN c_cod_sucursal_aho%NOTFOUND;
			If v_cod_sucursal_aho = v_cod_sucursal and v_tipoahorro2 = v_tipoahorro1 THEN
				update tipo_ahorro_tip
				set Monto = Monto + v_ahorro;
				Where cod_sucursal = v_cod_sucursal and tipoahorro = v_tipoahorro2 ;
		END LOOP;
	END LOOP;
	Close C_data_aho_tip;
	Close c_aho_rec;
END Update_Aho_Suc;
/
