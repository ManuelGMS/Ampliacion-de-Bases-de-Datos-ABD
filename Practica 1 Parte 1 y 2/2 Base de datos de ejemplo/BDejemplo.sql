-- 
---------------------------------------------------------------------
-- Declaraciones de la BDejemplo -- Sin PK's ni FK's para NORMALIZAR
-- Es una BD de Clientes "activos" que invierten en empresas. 
-- Algunos clientes son morosos. Algún moroso no es cliente
-- Clientes que trabajan en cierto puesto. Clientes que compran con
-- Tarjetas
---------------------------------------------------------------------

/*
       --- Características detalladas de BDejemplo:                                                                             
- Hay morosos, que pueden ser clientes o no, con la misma información que los clientes.
  No relacionar con el resto.
- Un cliente trabaja como máximo en un puesto, estar en paro también se incluye, 
  con Título = 'parado'.
- Un cliente puede no invertir o invertir en varias empresas. Puede tener varios Tipos 
  de inversiones en la misma empresa.
-  El cliente invierte en una empresa, una cantidad y en un tipo. Solo puede invertir una
   vez en el mismo tipo para la misma empresa. Puede invertir en varios tipos en varias 
   empresas.
- El cliente hace compras con tarjetas
- En compras, para un mismo cliente hay un num. factura secuencial sin duplicados para 
  una tarjeta determinada. 
- Una tarjeta tiene un tipo, un número diferente en todas las tarjetas y la organización
  propietaria del tipo.
- El cliente puede tener varias tarjetas o ninguna. Como máximo tiene tres tarjetas. 
  Puede haber más de un propietario de cada tarjeta. Cada propietario tiene para cada
  tarjeta una caducidad y un saldo.

*/


REM ... Empresa: E(NombreE, Cotizacion, Capital)
--  Nombre de Empresa, Precio de Acción (cotización), Cantidad de Capital


create table Empresa
	(NombreE		CHAR(20) not null,
	 Cotizacion    	INT default 99,
	 Capital       	FLOAT,
	 CHECK          (Capital > 0)
		);
---------------------------------------------------------------------

REM ... Cliente: CL(DNI, NombreC,Direccion,Telefono)
--    DNI del cliente, Nombre del Cliente, su Teléfono

create table Cliente  
(DNI		CHAR(8)  not null, 
NombreC		CHAR(30), 
Direccion	VARCHAR2(50),
Telefono	CHAR(12)
-- Total_invertido -- Para redundancia entre tablas 
--                 -- Razón para dejar esta redundancia
);

---------------------------------------------------------------------

REM ... Moroso: MO(DNI, NombreC,Direccion,Telefono)
--    DNI del cliente moroso, Nombre del Cliente, su Teléfono

create table Moroso  
(DNI		CHAR(8)  not null, 
NombreC		CHAR(30), 
Direccion	VARCHAR2(50),
Telefono	CHAR(12)
);

---------------------------------------------------------------------

REM ... Invierte: I(DNI, NombreE,Cantidad,Tipo) -------------
--    DNI del cliente, Nombre de Empresa en la que invierte, Cantidad y
--    el Tipo de inversión


create table Invierte (
DNI		CHAR(8)  not null, 
NombreE	CHAR(20) not null,
Cantidad	FLOAT,
Tipo		CHAR(10) not null
);

---------------------------------------------------------------------

REM ... Tarjeta: T(NumT, TipoT, Organizacion)
--  Número de Tarjeta, Tipo de Tarjeta, Organización de esa Tarjeta

create table Tarjeta
 (NumT		INT  CHECK (NumT <> 0),
 TipoT		CHAR(10), 
 Organizacion	CHAR(20),
 CHECK (TipoT in ('VXK','COSA','PISA'))
 );
---------------------------------------------------------------------

REM ... Compras: CO(DNI, NumT, NumF, Fecha, Tienda, Importe)
-- DNI del cliente comprador, Num de su tarjeta, Num de Factura, 
-- la fecha de compra en entero, Tienda donde se compró, Importe de compra

create table Compras
(DNI		CHAR(8)  not null, 
 NumT		  INT, 
 NumF		  INT,
 Fecha		INT,
 Tienda		CHAR(20), 
 Importe		INT
  );
---------------------------------------------------------------------

REM ... Puesto: P(DNI, Titulo, Sueldo)
-- DNI del cliente, Título del puesto de trabajo, sueldo en ese puesto

create table Puesto
(DNI 		CHAR(8)  not null, 
 Titulo		VARCHAR2(30),
 Sueldo		FLOAT
 );
---------------------------------------------------------------------
REM ... TieneT: TTA(DNI,NumT, Caducidad, Saldo)
-- Tarjetas que tiene el cliente: su DNI, Núm Tarjeta
--  Caducidad de esa tarjeta, Saldo de esa tarjeta

create table TieneT
(DNI		CHAR(8)  not null, 
 NumT		INT not null,
 -- Caducidad	INT, 
 Caducidad	INT, 
 Saldo		FLOAT 
);

---------------------------------------------------------------------

REM --- > crear los datos completos e integros

REM ...              Cliente: CL(DNI, NombreC,Direccion,Telefono)

INSERT INTO Cliente 
  VALUES ('00000001','Client A','direc 11','911111111111');
INSERT INTO Cliente 
  VALUES ('00000003','Client B','direc 13','911111111113');
INSERT INTO Cliente 
  VALUES ('00000002','Client C','direc 12','911111111112');
INSERT INTO Cliente 
  VALUES ('00000005','Client A','direc 11','911111111115');
INSERT INTO Cliente 
  VALUES ('00000004','Client A','direc 14','911111111114');
INSERT INTO Cliente 
  VALUES ('00000006','Client D','direc 16','911111111116');


---------------------------------------------------------------------

REM ... Moroso: MO(DNI, NombreC,Direccion,Telefono)

INSERT INTO Moroso 
  VALUES ('00000003','Client B','direc 13','911111111113');
INSERT INTO Moroso
  VALUES ('00000007','Client E','direc 17','911111111117');
INSERT INTO Moroso
  VALUES ('00000005','Client A','direc 11','911111111115');
INSERT INTO Moroso
  VALUES ('00000006','Client D','direc 16','911111111116');

---------------------------------------------------------------------

REM ...           Empresa: E(NombreE, Cotizacion, Capital)

INSERT INTO Empresa VALUES ('Empresa 11', 111111, 110000.00);
INSERT INTO Empresa VALUES ('Empresa 22', 222222, 220000.00);
INSERT INTO Empresa VALUES ('Empresa 33', 333333, 330000.00);
INSERT INTO Empresa VALUES ('Empresa 44', 444444, 440000.00);
INSERT INTO Empresa VALUES ('Empresa 55', 555555, 550000.00);

---------------------------------------------------------------------

REM ...             Invierte: I(DNI, NombreE,Cantidad,Tipo)

INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',210000, 'bono1');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',220000, 'bono2');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',230000, 'bono3');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 44',240000, 'bono4');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 55',310000, 'bono1');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 33',320000, 'bono2');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',410000, 'bono1');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',420000, 'bono2');

---------------------------------------------------------------------

REM ...              Tarjeta: T(NumT, TipoT, Organizacion)

INSERT INTO Tarjeta VALUES ('10000001', 'PISA','MASTERUIN');
INSERT INTO Tarjeta VALUES ('30000002', 'PISA','MASTERUIN');
INSERT INTO Tarjeta VALUES ('50000003', 'PISA','MASTERUIN');
INSERT INTO Tarjeta VALUES ('00000010', 'COSA','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('30000020', 'COSA','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('50000030', 'COSA','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('00000100', 'VXK','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('40000200', 'VXK','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('30000300', 'VXK','MENOSRUIN');
INSERT INTO Tarjeta VALUES ('50000400', 'VXK','MENOSRUIN');
---------------------------------------------------------------------

REM ...          Compras: CO(DNI, NumT, NumF, Fecha, Tienda, Importe)

INSERT INTO Compras VALUES ('00000005', '50000400',1, 0501,'tienda1',50);
INSERT INTO Compras VALUES ('00000005', '50000030',1, 0501,'tienda1',5);
INSERT INTO Compras VALUES ('00000005', '50000400',2, 0502,'tienda1',500);
INSERT INTO Compras VALUES ('00000005', '50000400',3, 0501,'tienda2',5000);
INSERT INTO Compras 
  VALUES ('00000005', '50000003',1, 0501,'tienda8',50000);
INSERT INTO Compras VALUES ('00000003', '30000002',1, 0501,'tienda7',3);
INSERT INTO Compras VALUES ('00000003', '30000300',1, 0501,'tienda7',30);
INSERT INTO Compras VALUES ('00000003', '30000020',1, 0501,'tienda7',300);
INSERT INTO Compras VALUES ('00000003', '30000020',2, 0501,'tienda7',3000);
INSERT INTO Compras 
  VALUES ('00000003', '30000020',3, 0501,'tienda8',30000);
INSERT INTO Compras VALUES ('00000004', '40000200',1, 0501,'tienda7',4);
---------------------------------------------------------------------

REM ...             Puesto: P(DNI, T¡tulo, Sueldo)

INSERT INTO Puesto VALUES ('00000001', 'cajera', 300);
INSERT INTO Puesto VALUES ('00000002', 'estudiante', 301);
INSERT INTO Puesto VALUES ('00000003', 'Presidente', 30000);
INSERT INTO Puesto VALUES ('00000004', 'VicePresidente', 3000);
INSERT INTO Puesto VALUES ('00000005', 'Presidente', 30000);
INSERT INTO Puesto VALUES ('00000006', 'Parado', 0);
---------------------------------------------------------------------

REM ...           TieneT: TTA(DNI,NumT, Caducidad, Saldo)

INSERT INTO TieneT VALUES ('00000001', '10000001', 0901, 30);
INSERT INTO TieneT VALUES ('00000003', '30000002', 0901, 30);
INSERT INTO TieneT VALUES ('00000003', '30000020', 0901, 300);
INSERT INTO TieneT VALUES ('00000003', '30000300', 0901, 3000);
INSERT INTO TieneT VALUES ('00000004', '40000200', 0901, 40);
INSERT INTO TieneT VALUES ('00000005', '50000003', 0901, 50);
INSERT INTO TieneT VALUES ('00000005', '50000030', 0901, 500);
INSERT INTO TieneT VALUES ('00000005', '50000400', 0901, 50000);
---------------------------------------------------------------------
---------------------------------------------------------------------



