--LABORATORIO 5
--PROFESIÓN
begin
	nuevo_tipo_profesion('PR01', 'Abogado');
	nuevo_tipo_profesion('PR02', 'Profesor');
	nuevo_tipo_profesion('PR03', 'Mecánico');
end;
/

--SUCURSAL
BEGIN
	Nueva_sucursal('S001', 'Casa Matriz');
END;
/

--CLIENTE
BEGIN
	Insertar_cliente('8-979-2047', 'Daniela', 'Mosocoso', 'F', '08/07/1997', 'PR01', 'S001');
	Insertar_cliente('8-258-455', 'Chantal', 'De Gracia', 'F', '08/07/2000', 'PR02', 'S001');
	Insertar_cliente('8-987-8125', 'Rocio', 'Cortez', 'F', '08/05/2001', 'PR03', 'S001');
	Insertar_cliente('8-441-2588', 'Romas', 'Lescure', 'M', '09/04/2001', 'PR03', 'S001');
END;
/

--TIPO TELÉFONO
begin
	nuevo_tipo_telefono('TT01', 'Celular');
	nuevo_tipo_telefono('TT02', 'Residencia');
	nuevo_tipo_telefono('TT03', 'Familiar cercano');
	nuevo_tipo_telefono('TT05', 'Laboral');
end;
/

--TELÉFONO
begin
	Nuevo_Telefono('4', '6258-5877', 'TT01');
	Nuevo_Telefono('2', '6675-2258', 'TT02');
	Nuevo_Telefono('3', '6675-4458', 'TT03');
	Nuevo_Telefono('1', '6675-8875', 'TT05');
end;
/

--TIPO EMAIL
begin
	nuevo_tipo_email('EM01', 'Personal');
end;
/

--EMAIL
BEGIN
	nuevo_email(1, 'EM04', 'danikarma@gmail.COM');
	nuevo_email(2, 'EM04', 'itgirl@hotmail.COM');
	nuevo_email(3, 'EM04', 'rocioca@gmail.COM');
	nuevo_email(4, 'EM04', 'romasalex@gmail.COM');
END;
/

--TIPO PRÉSTAMO
begin
	nuevo_tipo_prestamo('TP01', 'Personal', 'S001');
	nuevo_tipo_prestamo('TP02', 'Auto', 'S001');
	nuevo_tipo_prestamo('TP03', 'Hipoteca', 'S001');
	nuevo_tipo_prestamo('TP05', 'Escolar', 'S001');
end;
/

--PRÉSTAMO
BEGIN 
	insertar_prestamo( 1,'TP01','09/07/2021',2300.00, 2.5, 115.00, 0.00, '12/09/2021','S001',0.00, 0.00, '03/06/2022');
	insertar_prestamo( 2,'TP02','09/07/2021',5000.00, 1.5, 500.00, 0.00, '12/09/2021','S001',0.00, 0.00, '03/06/2022');
	insertar_prestamo( 3,'TP03','09/07/2021',6000.00, 2.0, 600.00, 0.00, '12/09/2021','S001',0.00, 0.00, '03/06/2022');
	insertar_prestamo( 4,'TP05','09/07/2021',8300.00, 3.0, 600.00, 0.00, '12/09/2021','S001',0.00, 0.00, '03/06/2022');
END;
/

--TRANSAC_PAGOS
BEGIN 
	introducir_transac_pago(1, 'TP01', 'S001', '05/08/2021', 15);
	introducir_transac_pago(2, 'TP02', 'S001', '05/08/2021', 500);
	introducir_transac_pago(3, 'TP03', 'S001', '05/08/2021', 600);
	introducir_transac_pago(4, 'TP05', 'S001', '05/08/2021', 600);
END;
/

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
