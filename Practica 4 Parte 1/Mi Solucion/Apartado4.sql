CL SCR

DROP TABLE DICCION;

CREATE TABLE DICCION (PALID VARCHAR2(20), DESCRIPCION VARCHAR2(50), PADRE_ID VARCHAR2(20));

INSERT INTO DICCION VALUES ('select jerarquica','estructura tabla en arbol','select compuesta');
INSERT INTO DICCION VALUES ('fecha sistema','es la fecha que tiene el ordenador','fecha');
INSERT INTO DICCION VALUES ('fecha','tipo de dato , en oracle : DATE','nada');
INSERT INTO DICCION VALUES ('select compuesta', 'consultas con varias partes', 'select');
INSERT INTO DICCION VALUES ('select simple', 'consultas con una sola instruccion', 'select');
INSERT INTO DICCION VALUES ('select', 'hacer consulta', 'nada');
INSERT INTO DICCION VALUES ('sql','lenguaje de consultas estructuradas', 'nada');
INSERT INTO DICCION VALUES ('select correlativa', 'coordina resultado subconsulta', 'select compuesta');

SELECT * FROM DICCION;

SELECT d.palid , d.descripcion , d.padre_id 
FROM diccion d
connect by prior d.palid = d.padre_id -- relacion registro ACTUAL con registro PADRE
start with d.palid = 'select' -- nodo (valor) HOJA (TALLO del arbol)
order by d.padre_id; -- los nodos se agrupan / ordenan por su padre_id

INSERT INTO DICCION SELECT 'select anidada','consulta dentro de consulta','select compuesta' FROM DUAL WHERE EXISTS (SELECT * FROM DICCION WHERE diccion.padre_id = 'select compuesta');  
        