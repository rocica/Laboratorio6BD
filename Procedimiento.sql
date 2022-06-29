--PROCEDIMIENTO 1
CREATE SEQUENCE cont_ahorro
    START WITH 1 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE nuevo_tipo_ahorros(
	p_descripcion in tipo_ahorro.descripcion%type,
	p_interes in tipo_ahorro.tasa%type) IS
BEGIN
	insert into tipo_ahorro(tipo_ahorro, descripcion, tasa) 
	values (cont_ahorro.nextval, p_descripcion, p_interes);
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	WHEN others THEN
		DBMS_OUTPUT.PUT_LINE('Error desconocido');
END;
/

--PROCEDIMIENTO 2
CREATE SEQUENCE cont_cuenta
	START with 1
	INCREMENT by 1;
CREATE OR REPLACE PROCEDURE nueva_cuenta(
	p_codsucursal in ahorros.cod_sucursal%type,
	p_idcliente in ahorros.id_cliente%type,
	p_tipo_ahorro in ahorros.tipo_ahorro%type,
	p_fapertura in ahorros.fechapertura%type,
	p_interes in ahorros.tasainteres_ahorro%type,
	p_letradep in ahorros.letradepomens%type,
	p_saldoahorro in ahorros.saldoahorro%type,
	p_saldointeres in ahorros.saldointeres%type,
	p_fdeposito in ahorros.fechadepo_ahorro%type,
	p_fretiro in ahorros.fecharetiro_ahorro%type,
	p_fmodificacion in ahorros.fechamod_ahorro%type) is
BEGIN
	insert into ahorros(cod_sucursal, id_cliente, tipo_ahorro, numcuenta,
		fechapertura, tasainteres_ahorro, letradepomens, saldoahorro, 
        saldointeres, fechadepo_ahorro, fecharetiro_ahorro, usuario, fechamod_ahorro) 
	values (p_codsucursal, p_idcliente, p_tipo_ahorro, cont_cuenta.nextval, 
        p_fapertura, p_interes, p_letradep, p_saldoahorro, 
        p_saldointeres, p_fdeposito, p_fretiro, user, p_fmodificacion);
	
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
END; 
/


--PROCEDIMIENTO 3
CREATE SEQUENCE cont_tr
	START with 1
	INCREMENT by 1;

CREATE OR REPLACE PROCEDURE Nueva_transaccion(
	p_codsucursal in Transadeporeti.cod_sucursal%type,
	p_idtransaccion in Transadeporeti.id_transaccion%type,
	p_idcliente in Transadeporeti.id_cliente%type,
	p_tipo_ahorro in Transadeporeti.tipo_ahorro%type,
	p_ftransaccion in Transadeporeti.fecha_transaccion%type,
	p_tipotransac in Transadeporeti.tipotransac%type,
	p_monto in Transadeporeti.monto_depret%type,
	p_status in Transadeporeti.status%type,
	p_finsercion in Transadeporeti.fecha_insercion%type) is
BEGIN
	insert into Transadeporeti(cod_sucursal, id_transaccion, id_cliente,
		tipo_ahorro, fecha_transaccion, tipotransac, monto_depret, status,
		fecha_insercion, usuario) 
	values (p_codsucursal, cont_tr.nextval, p_idcliente, p_tipo_ahorro,
		p_ftransaccion, p_tipotransac, p_monto, p_status, p_finsercion, 
		user);
EXCEPTION
	WHEN dup_val_on_index THEN
		DBMS_OUTPUT.PUT_LINE('Valores duplicados');
	END;
/


--PROCEDIMIENTO 4
CREATE OR REPLACE FUNCTION InteresAhorro(
	p_monto in Transadeporeti.monto_depret%type,
	p_interes in tipo_ahorro.tasa%type)
	RETURN Transadeporeti.monto_depret%type IS 
BEGIN 
	RETURN (p_monto * p_interes)/100;
END InteresAhorro;
/

CREATE OR REPLACE PROCEDURE ActualizarTransacciones IS
	v_idcliente transadeporeti.id_cliente%type;
	v_dep_ret transadeporeti.monto_depret%type;
	v_tipo_ahorro transadeporeti.tipo_ahorro%type;
	V_tipotransac transadeporeti.tipotransac%type;
	v_interes transadeporeti.monto_depret%type;

	v_tasa ahorros.tasainteres_ahorro%type;
	v_salAhorro ahorros.saldoahorro%type;
	v_salInteres ahorros.saldoahorro%type;
	v_NewSalAhorro ahorros.saldoahorro%type;
	v_NewInteres ahorros.saldoahorro%type := 0;

	CURSOR c_Transacciones IS 
		SELECT id_cliente, tipo_ahorro, tipotransac, monto_depret  
		FROM transadeporeti
		WHERE (status = 'S');

	CURSOR c_ahorros IS
		SELECT tasainteres_ahorro, saldoahorro, saldointeres
		FROM ahorros;

BEGIN
	OPEN c_Transacciones;
	OPEN c_ahorros;
	LOOP
		FETCH c_Transacciones INTO v_idcliente, v_tipo_ahorro, 
			v_tipotransac, v_dep_ret;
		FETCH c_ahorros INTO v_tasa, v_salAhorro, v_salInteres;
		
		EXIT WHEN c_Transacciones%NOTFOUND;
		IF (v_tipotransac = 1) THEN
			IF (v_tipo_ahorro = 1) OR (v_tipo_ahorro = 3) THEN
				v_interes := InteresAhorro(v_dep_ret, v_tasa);
				v_NewSalAhorro := v_salAhorro + v_dep_ret;
				v_NewInteres := v_salInteres + v_interes;
			ELSE
				v_NewSalAhorro := v_salAhorro + v_dep_ret;
			END IF;
			UPDATE ahorros
			SET saldoahorro = v_NewSalAhorro,
				saldointeres = v_NewInteres,
				fechadepo_ahorro = sysdate
			WHERE (id_cliente = v_idcliente)
			AND (tipo_ahorro = v_tipo_ahorro);	
		ELSE 
			IF (v_tipo_ahorro = 1) OR (v_tipo_ahorro = 3) THEN
				DBMS_OUTPUT.PUT_LINE('No se pueden hacer retiros de las cuentas de ahorro escolar o de navidad');
			ELSE
				v_NewSalAhorro := v_salAhorro - v_dep_ret;
			END IF;
			UPDATE ahorros
			SET saldoahorro = v_NewSalAhorro,
				fecharetiro_ahorro = sysdate
			WHERE (id_cliente = v_idcliente)
			AND (tipo_ahorro = v_tipo_ahorro);
		END IF;

		UPDATE Transadeporeti
		SET status = 'N';
	END LOOP;
    CLOSE c_ahorros;
    CLOSE c_Transacciones;
END;
/


--PROCEDIMIENTO 5
CREATE OR REPLACE PROCEDURE ActCuentaCorriente IS
	v_tasa ahorros.tasainteres_ahorro%type;
	v_salAhorro ahorros.saldoahorro%type;
	v_tipo_ahorro ahorros.tipo_ahorro%type;
	v_salInteres ahorros.saldoahorro%type;
	v_interes ahorros.saldoahorro%type;

	CURSOR c_ahorros IS
		SELECT tasainteres_ahorro, saldoahorro, tipo_ahorro, saldointeres
		FROM ahorros
		WHERE tipo_ahorro = 2;
BEGIN
	OPEN c_ahorros;
	LOOP
		FETCH c_ahorros INTO v_tasa, v_salAhorro, v_tipo_ahorro, v_salInteres;
		EXIT WHEN c_ahorros%NOTFOUND;
			v_interes := InteresAhorro(v_salAhorro, v_tasa);
			v_salAhorro := v_salAhorro + v_interes;
			v_salInteres := v_salInteres + v_interes;
			UPDATE ahorros
			SET saldoahorro = v_salAhorro,
			saldointeres = v_salInteres
			WHERE tipo_ahorro = v_tipo_ahorro;	
	END LOOP;
    CLOSE c_ahorros;
END;
/