-- CONSULTA 1 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
(select * from cliente where DNI < '00000005') union (select * from moroso where NombreC = 'Client E');

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

-- CONSULTA 2 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
(select * from cliente where DNI = '00000005') union (select * from moroso where NombreC = 'Client E');

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

-- CONSULTA 3 --

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
select * from cliente where DNI in (select DNI from moroso where NombreC = 'Client E');

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

-- CONSULTA 4 –----

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
(select * from cliente where dni in (select dni from invierte));

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

-- CONSULTA 5 -

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
(select * from cliente where dni in (select dni from invierte where cantidad < 30000));

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

-- CONSULTA 6 -

delete plan_table;

EXPLAIN PLAN INTO plan_table FOR
(select distinct NombreC from Cliente, Compras, Invierte where Cliente.DNI = Invierte.DNI and Invierte.NombreE = 'Empresa 55' and Compras.DNI = Cliente.DNI and Compras. Importe >1000);

-- MASCARA PARA CONSULTAR LA TABLA DEL PLAN --

ttitle ' INFORME DEL PLAN  '

col operation   heading 'OPERACION' format a12 word_wrapped
col options     heading 'OPCIONES' format a12 word_wrapped
col object_name heading 'TABLA'    format a12 word_wrapped
col cost        heading 'Coste'    format a5
col cardinality heading 'Filas'    format a5
col parent_id   heading 'PADRE'    format a5
col id          heading 'Id_Fila'  format a5

select operation,options,object_name,cost,cardinality,parent_id,id 
from plan_table
connect by prior id=parent_id    -- and statement_id= 'actuaT'
start with id = 1                -- and statement_id= 'actuaT'
order by id;
/

/*

INFORME DEL PLAN 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
SORT         UNIQUE                        7     2     0     1
UNION-ALL                                              1     2
TABLE ACCESS BY INDEX     CLIENTE          2     1     2     3
             ROWID                                            

INDEX        RANGE SCAN   SYS_C007402      1     1     3     4
TABLE ACCESS FULL         MOROSO           3     1     2     5

(select * from cliente where DNI < '00000005') union (select * from moroso where NombreC = 'Client E');

**************************************************************

INFORME DEL PLAN 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
SORT         UNIQUE                        6     2     0     1
UNION-ALL                                              1     2
TABLE ACCESS BY INDEX     CLIENTE          1     1     2     3
             ROWID                                            

INDEX        UNIQUE SCAN  SYS_C007402      1     1     3     4
TABLE ACCESS FULL         MOROSO           3     1     2     5

(select * from cliente where DNI = '00000005') union (select * from moroso where NombreC = 'Client E');
**************************************************************

INFORME DEL PLAN 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                                           0     1
NESTED LOOPS                               4     1     1     2
TABLE ACCESS FULL         MOROSO           3     1     2     3
INDEX        UNIQUE SCAN  SYS_C007402      0     1     2     4
TABLE ACCESS BY INDEX     CLIENTE          1     1     1     5
             ROWID                                            
             
select * from cliente where DNI in (select DNI from moroso where NombreC = 'Client E');
**************************************************************

INFORME DEL PLAN 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
HASH JOIN    SEMI                          6     3     0     1
TABLE ACCESS FULL         CLIENTE          3     7     1     2                                            
INDEX        FAST FULL    CLAVE_INVIER     2     8     1     3
                          TE_PRIM

**************************************************************

INFORME DEL PLAN 5                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
NESTED LOOPS                                           0     1
NESTED LOOPS                               5     1     1     2
SORT         UNIQUE                        3     1     2     3
TABLE ACCESS FULL         INVIERTE         3     1     3     4
INDEX        UNIQUE SCAN  SYS_C007402      0     1     2     5
TABLE ACCESS BY INDEX     CLIENTE          1     1     1     6
             ROWID                                            

**************************************************************

INFORME DEL PLAN 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
HASH         UNIQUE                    10    2     0     1
HASH JOIN                              9     2     1     2
HASH JOIN                              7     4     2     3
TABLE ACCESS FULL         COMPRAS      3     4     3     4
TABLE ACCESS FULL         CLIENTE      3     7     3     5
INDEX        FULL SCAN    CLAVE_INVI   2     4     2     6
                          ERTE_PRIM  

**************************************************************

*/

/*

APARTADO B:

Compara CONSULTA 2 y CONSULTA 1 ¿Qué reglas aplica en ambas consultas para que no coincidan las operaciones que realizan?

INFORME DEL PLAN 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
SORT         UNIQUE                        7     2     0     1
UNION-ALL                                              1     2
TABLE ACCESS BY INDEX     CLIENTE          2     1     2     3
             ROWID                                            

INDEX        RANGE SCAN   SYS_C007402      1     1     3     4
TABLE ACCESS FULL         MOROSO           3     1     2     5

(select * from cliente where DNI < '00000005') union (select * from moroso where NombreC = 'Client E');

**************************************************************

INFORME DEL PLAN 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
OPERACION    OPCIONES     TABLA        Coste Filas PADRE Id_Fi
------------ ------------ ------------ ----- ----- ----- -----
SORT         UNIQUE                        6     2     0     1
UNION-ALL                                              1     2
TABLE ACCESS BY INDEX     CLIENTE          1     1     2     3
             ROWID                                            

INDEX        UNIQUE SCAN  SYS_C007402      1     1     3     4
TABLE ACCESS FULL         MOROSO           3     1     2     5

(select * from cliente where DNI = '00000005') union (select * from moroso where NombreC = 'Client E');

**************************************************************

b.2 Porqué en CONSULTA 1 no accede por el índice a MOROSO ?

    + Por que el campo no está indexado, ni posee una CONSTRAINT de PK o UNIQUE.

b.3 Porqué en CONSULTA 2 sí accede por el índice a CLIENTE ?

    + Por que el campo DNI es PK y por tanto está indexado.

b.4 Porqué en CONSULTA 3 no accede por el índice a CLIENTE ?

    + select * from cliente where DNI in (select DNI from moroso where NombreC = 'Client E');
    
    + Full acce

*/