-- CONSULTA 1 –

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select PELISACTUAL.ID from PELISACTUAL, PELISHISTORICO where PELISACTUAL.ID = PELISHISTORICO.ID;

-- CONSULTA 2 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select PELISACTUAL.DESCRIPCION from PELISACTUAL, PELISHISTORICO where PELISACTUAL.DESCRIPCION = PELISHISTORICO.DESCRIPCION;

-- CONSULTA 3 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select PELISACTUAL.TITULO from PELISACTUAL, PELISHISTORICO where PELISACTUAL.TITULO = PELISHISTORICO.TITULO;

-- CONSULTA 4 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select PELISACTUAL.TITULO from PELISACTUAL where PELISACTUAL.TITULO in (select PELISHISTORICO.TITULO from PELISHISTORICO);

-- CONSULTA 5 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select PELISACTUAL.TITULO from PELISACTUAL where PELISACTUAL.TITULO in (select PELISHISTORICO.TITULO from PELISHISTORICO where PELISACTUAL.TITULO = PELISHISTORICO.TITULO);

/*

CREATE INDEX IND_PELISACTUAL ON PELISACTUAL(TITULO); 
CREATE INDEX IND_PELISHISTORICO ON PELISHISTORICO(TITULO);

ALTER TABLE PELISACTUAL ADD CONSTRAINT PELISACUTAL_PK PRIMARY KEY (ID);
ALTER TABLE PELISACTUAL ADD CONSTRAINT PELISHISTORICO_PK PRIMARY KEY (ID);

**************************************************************

INFORME DEL PLAN 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                               1   142     0     1
INDEX        FULL SCAN    SYS_C007466      1   142     1     2
INDEX        UNIQUE SCAN  SYS_C007467      0     1     1     3

**************************************************************

INFORME DEL PLAN 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
HASH JOIN                                 88   144     0     1
TABLE ACCESS FULL         PELISACTUAL     19   142     1     2
TABLE ACCESS FULL         PELISHISTORI    68   521     1     3
                          CO              

**************************************************************
INFORME DEL PLAN 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                               3   142     0     1
INDEX        FAST FULL    IND_PELISHIS     3   521     1     2
             SCAN         TORICO_TITUL                        
                          O                                   

INDEX        RANGE SCAN   IND_PELISACT     0     1     1     3
                          UAL_TITULO                          
select PELISACTUAL.TITULO from PELISACTUAL, PELISHISTORICO where PELISACTUAL.TITULO = PELISHISTORICO.TITULO;
**************************************************************
INFORME DEL PLAN 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                               4   142     0     1
SORT         UNIQUE                        3   521     1     2
INDEX        FAST FULL    IND_PELISHIS     3   521     2     3
             SCAN         TORICO_TITUL                        
                          O                                   
INDEX        RANGE SCAN   IND_PELISACT     0     1     1     4
                          UAL_TITULO                          
select PELISACTUAL.TITULO from PELISACTUAL where PELISACTUAL.TITULO in (select PELISHISTORICO.TITULO from PELISHISTORICO);
**************************************************************

INFORME DEL PLAN 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                               4   142     0     1
SORT         UNIQUE                        3   521     1     2
INDEX        FAST FULL    IND_PELISHIS     3   521     2     3
             SCAN         TORICO_TITUL                        
                          O                                   

INDEX        RANGE SCAN   IND_PELISACT     0     1     1     4
                          UAL_TITULO                          

***************************************************************

SELECT dni FROM invierte; -- INDEX FULL SCAN

SELECT dni FROM cliente WHERE dni = '00000001'; -- UNIQUE SCAN

SELECT cantidad FROM invierte WHERE cantidad < 230000; -- FULL TABLE ACCESS

SELECT c.dni , m.nombrec FROM CLIENTE C, MOROSO M; -- CARTESIAN JOIN

***************************************************************

*/