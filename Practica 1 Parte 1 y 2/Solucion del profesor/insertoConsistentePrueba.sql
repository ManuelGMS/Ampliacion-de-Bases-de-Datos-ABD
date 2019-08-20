-------------  SCRIPT AUTOCONTENIDO PARA PROBAR TODOS LOS CASOS  -----------

===>  Ejecuta una a una las instrucciones y las pruebas (no todo de una vez)

-- Poner en SQLDeveloper : SET SERVEROUTPUT ON

SET SERVEROUTPUT ON SIZE 100000;

DROP TABLE Invierte CASCADE CONSTRAINTS;

create table Invierte (
DNI		CHAR(8)  not null, 
NombreE	CHAR(20) not null,
Cantidad	FLOAT,
Tipo		CHAR(10) not null
);



REM ...             Invierte: I(DNI, NombreE,Cantidad,Tipo)

--------------- DATOS CONSISTENTES ---------
INSERT INTO Invierte VALUES ('00000001', 'Empresa 11',110001, 'bono1');
INSERT INTO Invierte VALUES ('00000001', 'Empresa 11',220002, 'bono2');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 33',112221, 'bono1');
----- Para una nueva empresa, me obliga a insertar:
INSERT INTO Invierte VALUES ('00000001', 'Empresa 22',110001, 'bono1');
INSERT INTO Invierte VALUES ('00000001', 'Empresa 22',220002, 'bono2');
------ Para un nuevo bono: me obliga a insertar:
INSERT INTO Invierte VALUES ('00000001', 'Empresa 11',330003, 'bono3');
INSERT INTO Invierte VALUES ('00000001', 'Empresa 22',330003, 'bono3');

-- se pide que insertoConsistente inserte las filas obligadas también

-- Compruebo lo que ha ido creando en cada paso con:
--          select * from invierte ORDER by DNI, NombreE,tipo;


-- Uso el "execute" si es en la Hoja de Trabajo

-- CASO 0 --  %%%%%%%%% Prueba   CASO  0 : DNI Nuevo  %%%%%%%%%%%%%

execute insertoConsistente('00000009', 'Empresa 11', 111111, 'bono1');

-- 

-- CASO 1 --  %%%%%%%%% Prueba   CASO  1 : ERROR. ->
--              Empresa está y Tipo también,  para ese cliente  %%%%%%%%%%%%%

execute insertoConsistente('00000001', 'Empresa 11',110001, 'bono1');


-- CASO 2 --  %%%%%%%%% Prueba   CASO  2: tipo nuevo, empresa está   %%%%%%%%%%%%%

execute insertoConsistente('00000001', 'Empresa 11',444444, 'bono4');

-- CASO 3 --  %%%%%%%%% Prueba   CASO  3: empresa nueva, tipo está  %%%%%%%%%%%%%% 

-- (Ignoro la cantidad nueva diferente, uso la antigüa)



execute insertoConsistente('00000001', 'EmpresaZZ',101010, 'bono1');
 

-- CASO 4 --   %%%%%%%%% Prueba   CASO  4: empresa nueva, tipo nuevo   %%%%%%%%%%%%



execute insertoConsistente('00000001', 'Empresa 44',5555, 'bono5');



