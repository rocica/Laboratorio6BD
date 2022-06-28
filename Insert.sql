--LABORATORIO 6
--TIPO AHORRO
BEGIN
	nuevo_tipo_ahorros('Navidad', 6);
	nuevo_tipo_ahorros('Corriente', 4);
	nuevo_tipo_ahorros('Escolar', 6);
END;
/

--AHORROS
BEGIN
	nueva_cuenta('S001', 1, 1, '2/01/2022', 6, 200, 5000, 50, '15/6/2022', 
				'16/2/2022', '2/01/2022');
	nueva_cuenta('S001', 2, 2, '12/01/2012', 4, 500, 65000, 500, '17/5/2022', 
				'16/6/2022', '20/8/2021');
	nueva_cuenta('S001', 3, 3, '23/09/2002', 6, 120, 8000, 600, '30/5/2022', 
				'6/3/2022', '24/02/2007');
END;
/

--TRANSDEPORETI
BEGIN
	Nueva_transaccion('S001', 1, 1, 1, '2/1/2022', 1, 500, 'S', '15/6/2022');
	Nueva_transaccion('S001', 2, 2, 2, '12/1/2012', 2, 60, 'S', '16/6/2022');
	Nueva_transaccion('S001', 3, 3, 3, '23/09/2002', 1, 100, 'S', '6/3/2022');
END;
/

--SUCURSAL TIPO AHORRO
INSERT INTO suc_tipo_ahorro (cod_sucursal, tipo_ahorro)
VALUES ('S001', 1);
INSERT INTO suc_tipo_ahorro (cod_sucursal, tipo_ahorro)
VALUES ('S001', 2);
INSERT INTO suc_tipo_ahorro  (cod_sucursal, tipo_ahorro)
VALUES ('S001', 3);
