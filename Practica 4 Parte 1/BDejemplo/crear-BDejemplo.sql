--   
---------------------------------------------------------------------
-- EJERCICIO PRACTICO: Declaraciones de la BD y sus actualizaciones --
--     BDEjemplo implementada 
--       - con tipos de datos básicos:  no usa DATE para fechas
--       - Creación de filas con INSERT
--   FALTA (hazlo tú) añadir filas de estas Tablas:
--                     TieneTel, Cliente_I, Cliente_N, Oferta, 
--                     Oferta y valor oferta en invierte
--         
---------------------------------------------------------------------


REM ... Empresa: E(NombreE, Cotizacion, Capital)

 create table Empresa
	(NombreE	CHAR(20) not null,
	 Cotizacion    	INT default 99,
	 Capital       	FLOAT,
	 PRIMARY KEY    (NombreE),
	 CHECK          (Capital > 0)
		);

---------------------------------------------------------------------

REM ... Cliente: CL(DNI, NombreC,Direccion)

create table Cliente  
(DNI		CHAR(8)  not null, 
NombreC		CHAR(30), 
Direccion	VARCHAR2(50),
PRIMARY KEY (DNI));

---------------------------------------------------------------------

REM . . . Cliente_N:   CL_N(DNI,Provincia,LineaCredito)

create table Cliente_N 
(DNI		CHAR(8)  not null,  
Provincia	VARCHAR2(50),
LineaCredito	NUMERIC(8,2),
PRIMARY KEY (DNI),
FOREIGN KEY (DNI) REFERENCES Cliente(DNI) on delete cascade );

---------------------------------------------------------------------

REM . . . Cliente_I:   CL_I(DNI,Pais,Email)

create table Cliente_I 
(DNI		CHAR(8)  not null, 
Pais		VARCHAR2(50),
Email		VARCHAR2(50),
PRIMARY KEY (DNI),
FOREIGN KEY (DNI) REFERENCES Cliente(DNI) on delete set null );

---------------------------------------------------------------------

REM ... Moroso: MO(DNI, NombreC,Direccion)

create table Moroso  
(DNI		CHAR(8)  not null, 
NombreC		CHAR(30), 
Direccion	VARCHAR2(50),
PRIMARY KEY (DNI));

---------------------------------------------------------------------

REM . . . Oferta:   I(CodOferta,Clase,Total)

create table Oferta  
(CodOferta	CHAR(8)  not null, 
 Clase		CHAR(30), 
 Total		Numeric(8,2),
PRIMARY KEY (CodOferta));

---------------------------------------------------------------------

REM ... Invierte: I(DNI, NombreE,Cantidad,Tipo,Oferta) -------------

create table Invierte (
DNI		CHAR(8)  not null REFERENCES Cliente(DNI), 
NombreE	CHAR(20) not null,
Cantidad	FLOAT,
Tipo		CHAR(10) not null,
CodOferta	CHAR(8)  REFERENCES Oferta(CodOferta), -- puede ser null
CONSTRAINT clave_invirte_prim   -- dar nombre a la restricción MUY UTIL para encontrarla si hay errores
 		PRIMARY KEY (DNI, NombreE, Tipo),
CONSTRAINT clave_invirte_empresa
	FOREIGN KEY (NombreE) REFERENCES Empresa(NombreE)  );

---------------------------------------------------------------------

REM ... Tarjeta: T(NumT, TipoT, Organizacion)

create table Tarjeta
 (NumT		INT  CHECK (NumT <> 0),
 TipoT		CHAR(10), 
 Organizacion	CHAR(20),
 PRIMARY KEY (NumT),
 CHECK (TipoT in ('VXK','COSA','PISA'))
 );

---------------------------------------------------------------------

REM ... Compras: CO(DNI, NumT, NumF, Fecha, Tienda, Importe)

create table Compras
(DNI		CHAR(8)  not null, 
 NumT		INT, 
 NumF		INT,
 Fecha		INT,
 Tienda		CHAR(20), 
 Importe		INT,
 PRIMARY KEY (DNI, NumT, NumF),
 FOREIGN KEY (DNI) REFERENCES Cliente(DNI),
 FOREIGN KEY (NumT)  REFERENCES Tarjeta(NumT)
  );
---------------------------------------------------------------------

REM ... Puesto: P(DNI, Titulo, Sueldo)

create table Puesto
(DNI 		CHAR(8)  not null, 
 Titulo		VARCHAR2(30),
 Sueldo		FLOAT,
 PRIMARY KEY (DNI),
 FOREIGN KEY (DNI) REFERENCES Cliente(DNI)
 );

---------------------------------------------------------------------
REM ... TieneT: TTA(DNI,NumT, Caducidad, Saldo)

create table TieneT
(DNI		CHAR(8)  not null, 
 NumT		INT not null,
 Caducidad	INT, 
 Saldo		FLOAT,
 PRIMARY KEY (DNI, NumT),
 FOREIGN KEY (DNI) REFERENCES Cliente(DNI),
 FOREIGN KEY (NumT)  REFERENCES Tarjeta(NumT)
);

---------------------------------------------------------------------

REM ... TieneTel: TTE(DNI, NumTel)

create table TieneTel
(DNI 		CHAR(8)  not null,
 Telefono	CHAR(12),
 PRIMARY KEY (DNI, Telefono),
 FOREIGN KEY (DNI) REFERENCES Cliente(DNI)
 );

---------------------------------------------------------------------

REM --- > crear los datos completos e integros

REM ...              Cliente: CL(DNI, NombreC,Direccion)

INSERT INTO Cliente 
  VALUES ('00000001','Client A','direc 11');
INSERT INTO Cliente 
  VALUES ('00000003','Client B','direc 13');
INSERT INTO Cliente 
  VALUES ('00000002','Client C','direc 12');
INSERT INTO Cliente 
  VALUES ('00000005','Client A','direc 15');
INSERT INTO Cliente 
  VALUES ('00000004','Client A','direc 14');
INSERT INTO Cliente 
  VALUES ('00000006','Client D','direc 12');

INSERT INTO Cliente 
  VALUES ('00000099','Client X','dire RARO');

---------------------------------------------------------------------

REM . . . Cliente_N:   CL_N(DNI,Provincia,LineaCredito)


INSERT INTO Cliente_N VALUES ('00000002','Madrid',900000);
INSERT INTO Cliente_N VALUES ('00000004','Valencia',820000);
INSERT INTO Cliente_N VALUES ('00000003','Sevilla',620000);

---------------------------------------------------------------------

REM . . . Cliente_I:   CL_I(DNI,Pais,Email)


INSERT INTO Cliente_I 
  VALUES ('00000001','USA','int-1@gmail.com');
INSERT INTO Cliente_I 
  VALUES ('00000002','Holanda','int-2@gmail.com');
INSERT INTO Cliente_I 
  VALUES ('00000005','India','int-5@gmail.com');
INSERT INTO Cliente_I 
  VALUES ('00000006','Suiza','int-6@gmail.com');

---------------------------------------------------------------------


REM ... TieneTel: TTE(DNI, NumTel)

INSERT INTO TieneTel 
  VALUES ('00000001','911111111111');
INSERT INTO TieneTel 
  VALUES ('00000003','911111111113');
INSERT INTO TieneTel 
  VALUES ('00000002','911111111112');
INSERT INTO TieneTel 
  VALUES ('00000005','911111111115');
INSERT INTO TieneTel 
  VALUES ('00000004','911111111114');
INSERT INTO TieneTel 
  VALUES ('00000006','911111111116');



---------------------------------------------------------------------

REM ... Moroso: MO(DNI, NombreC,Direccion,Telefono)

INSERT INTO Moroso 
  VALUES ('00000003','Client B','direc 13');
INSERT INTO Moroso
  VALUES ('00000007','Client E','direc 17');
INSERT INTO Moroso
  VALUES ('00000005','Client A','direc 15');
INSERT INTO Moroso
  VALUES ('00000006','Client D','direc 16');

---------------------------------------------------------------------

REM ...           Empresa: E(NombreE, Cotizacion, Capital)

INSERT INTO Empresa VALUES ('Empresa 11', 111111, 110000.00);
INSERT INTO Empresa VALUES ('Empresa 22', 222222, 220000.00);
INSERT INTO Empresa VALUES ('Empresa 33', 333333, 330000.00);
INSERT INTO Empresa VALUES ('Empresa 44', 444444, 440000.00);
INSERT INTO Empresa VALUES ('Empresa 55', 555555, 550000.00);

---------------------------------------------------------------------

REM . . . Oferta:   I(CodOferta,Clase,Total)

INSERT INTO Oferta VALUES ('BlackFri','exclusiva,gratis,regalo', 10.2);
INSERT INTO Oferta VALUES ('GreenFri','descuento por educado', 20.0);

---------------------------------------------------------------------

REM ...             Invierte: I(DNI, NombreE,Cantidad,Tipo,Oferta)

INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',210000, 'bono1','BlackFri');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',220000, 'bono2','');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',230000, 'bono3','');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 44',240000, 'bono4','');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 55',310000, 'bono1','');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 33',320000, 'bono2','');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',410000, 'bono1','BlackFri');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',420000, 'bono2','BlackFri');

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

INSERT INTO Puesto VALUES ('00000001', 'cajera', 30);
INSERT INTO Puesto VALUES ('00000002', 'estudiante', 30);
INSERT INTO Puesto VALUES ('00000003', 'Presidente', 30);
INSERT INTO Puesto VALUES ('00000004', 'VicePresidente', 30);
INSERT INTO Puesto VALUES ('00000005', 'Presidente', 30);
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



