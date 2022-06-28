CREATE OR REPLACE PROCEDURE ActualizarTransacciones IS
	v_idcliente transadeporeti.id_cliente%type;
	v_dep_ret transadeporeti.monto_depret%type;
	v_tipoahorro transadeporeti.tipo_ahorro%type;
	V_tipotransac transadeporeti.tipotransac%type;
	v_interes transadeporeti.monto_depret%type;

	v_tasa ahorros.tasainteres_ahorro%type;
	v_salAhorro ahorros.saldoahorro%type;
	v_salInteres ahorros.saldoahorro%type;
	v_NewSalAhorro ahorros.saldoahorro%type;
	v_NewInteres ahorros.saldoahorro%type;

	CURSOR c_Transacciones IS 
		SELECT id_cliente, tipo_ahorro, tipotransac, monto_depret  
		FROM transadeporeti
		WHERE (status = 'S');
BEGIN
	OPEN c_Transacciones;
	LOOP
		FETCH c_Transacciones INTO v_idcliente, v_tipoahorro, 
			v_tipotransac, v_dep_ret;
		EXIT WHEN c_Transacciones%NOTFOUND;
		SELECT tasainteres_ahorro, saldoahorro, saldointeres  
			INTO v_tasa, v_salAhorro, v_salInteres
			FROM ahorros
			WHERE (id_cliente = v_idcliente);
		IF (v_tipotransac = 1) THEN
			IF (v_tipoahorro = 1) OR (v_tipoahorro = 3) THEN
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
			AND (tipoahorro = v_tipoahorro);
            --COMMIT;	
		ELSE 
			IF (v_tipoahorro = 1) OR (v_tipoahorro = 3) THEN
				DBMS_OUTPUT.PUT_LINE('No se pueden hacer retiros de las cuentas de ahorro escolar o de navidad');
			ELSE
				v_NewSalAhorro := v_salAhorro - v_dep_ret;
			END IF;
			UPDATE ahorros
			SET saldoahorro = v_NewSalAhorro,
				fecharetiro_ahorro = sysdate
			WHERE (id_cliente = v_idcliente)
			AND (tipoahorro = v_tipoahorro);
            --COMMIT;
		END IF;
        --COMMIT;
		UPDATE Transadeporeti
            SET status = 'N';
	END LOOP;
    CLOSE c_Transacciones;
	EXCEPTION
		WHEN dup_val_on_index THEN
			DBMS_OUTPUT.PUT_LINE ('ERROR. Ya existe ese registro.');
--		WHEN others THEN
--			DBMS_OUTPUT.PUT_LINE('ERROR DETECTADO') ;
END;
/


SELECT * FROM ahorros;

SELECT * FROM transadeporeti;

SELECT * FROM sucursales;

SELECT * FROM suc_tipo_ahorro;

UPDATE sucursales
	SET montoahorro =

delete ahorros;

delete transadeporeti;

BEGIN
	nueva_cuenta('S001', 1, 1, '2/01/2022', 6, 200, 5000, 50, '15/6/2022', 
				'16/2/2022', '2/01/2022');
	nueva_cuenta('S001', 2, 2, '12/01/2012', 4, 500, 65000, 500, '17/5/2022', 
				'16/6/2022', '20/8/2021');
	nueva_cuenta('S001', 3, 3, '23/09/2002', 6, 120, 8000, 600, '30/5/2022', 
				'6/3/2022', '24/02/2007');
END;
/

BEGIN
	Nueva_transaccion('S001', 1, 1, 1, '2/1/2022', 1, 500, 'S', '15/6/2022');
	Nueva_transaccion('S001', 2, 2, 2, '12/1/2012', 2, 60, 'S', '16/6/2022');
	Nueva_transaccion('S001', 3, 3, 3, '23/09/2002', 1, 100, 'S', '6/3/2022');
END;
/

BEGIN 
    ActualizarTransacciones();
END;
/