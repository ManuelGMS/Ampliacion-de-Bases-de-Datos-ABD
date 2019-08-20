/*

APARTADO 1

ALTER TABLE PELISAHORA DROP CONSTRAINT PK_PELISACTUAL;
ALTER TABLE PELISHIST DROP CONSTRAINT PK_PELIHIST;
ALTER TABLE PELISAHORA ADD CONSTRAINT PK_PELISACTUAL PRIMARY KEY(ID);
ALTER TABLE PELISHIST ADD CONSTRAINT PK_PELISHIST PRIMARY KEY(ID);
CREATE UNIQUE INDEX idx_pelisahora_unico_titulo ON PELISAHORA(TITULO);
CREATE UNIQUE INDEX idx_pelishist_unico_titulo ON PELISHIST(TITULO);
CREATE BITMAP INDEX idx_pelisahora__bit_genero ON PELISAHORA(GENERO);
CREATE BITMAP INDEX idx_pelishist__bit_genero ON PELISHIST(GENERO);
CREATE INDEX idx_pelisahora__fun_drama ON PELISAHORA(ROUND(DRAMA));
CREATE INDEX idx_pelishist__fun_drama ON PELISHIST(ROUND(DRAMA));

*/

/*
- Starts : cuantas veces se ha ejecutado esa operación
- E-Rows : Filas estimadas de la operación de esa línea (antes de ejecutar)
- A-Rows : Filas reales (cuando ejecuta esa operación) de la operación de esa línea:
- Cuando están bien estimadas las E-Rows suele coincidir con el núm. filas de E-Rows
multiplicado por Starts: si hay mucha diferencia es que ese plan no va a ser eficiente.
- Buffers: memoria que ha usado para cada operación
*/

-- SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(format => 'ALLSTATS LAST')); ===>>> NO FUNCIONA

--Select * from V$SQL_PLAN_STATISTICS_ALL ;
--Select * from V$SQL;
--Select * from V$SQL_PLAN;

CL SCR

select /*+ GATHER_PLAN_STATISTICS */
/* prac4s10 consulta-manu */
A.ID, A.titulo,round(A.drama), H.genero
from PELISHIST H, PELISAHORA A
where A.ID = H.ID and (round(A.drama) = 43 or round(A.drama) = 50);

SELECT sql_id, child_number
FROM v$sql
WHERE sql_text LIKE  '%prac4s10 consulta-manu-1%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR
('212zqhm2yk5cd',0,format => 'ALLSTATS LAST'));

-- 62gkb9xv90n2q 212zqhm2yk5cd

/*
Sec1.1.
-- Compara E-Row y A-Row. Se parecen los valores? Sí? entonces ha hecho bien la estimación?
-- A veces tienes que multiplicar E-rows por Starts para tener el total
-- de la operación completa ejecutada, que es lo que da las A-Rows

Considerando esta ultima aclaracion la estimacion ha sido correcta.

Sec1.2.
-- Observa cómo, aunque opera con pocas filas maneja muchos bufferes:
-- Usa muchos menos bufferes en accesos a índice que a la tabla. ¿Porqué?

Por que el indice se compone de menos campos y datos que una tabla, es una estructura más simple.

Sec1.3.
-- Esta consulta-2 tiene menos operaciones que la consulta-1:
a.- Observando las operaciones: ¿Cual de las consultas te parece más eficiente, la anterior o esta?
b.- Observando la A-Rows: ¿Cual de las consultas te parece más eficiente, la anterior o esta?
c.- Observando los bufferes: ¿Cual de las consultas te parece más eficiente, la anterior o esta?
d.- Observando todo: ¿Cual de las consultas te parece más eficiente, la anterior o esta?

a) Esta (la última) ==> Parece mas eficiente la segunda
b) La primera 56 vs 119 de la segunda ==> Mas eficiente la primera
c) La primera 104 vs 166 de la segunda ==> Mas eficiente la primera
d) Teniendo en cuenta los datos anteriores y los tiempos de ejecución es mejor la segunda.

*/

select /*+ GATHER_PLAN_STATISTICS */ /* prac4s10 consulta-manu-2 */
A.ID, A.titulo, A.genero
from PELISAHORA A, PELISHIST H
where A.ID = H.ID and A.ID > 100 and A.genero = 'Terror' ;

SELECT sql_id, child_number
FROM v$sql
WHERE sql_text LIKE  '%prac4s10 consulta-manu-2%';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR
('9tf04hutryfg8',0,format => 'ALLSTATS LAST'));

--********************************************************************************************************************

/*

1.- Tabla user_indexes y dba_indexes :
(si son índices de otro usuario trabaja con: all_indexes )
SE PIDE:
- Para entender los atributos BLEVEL, DISTINCT_KEYS, LEAF_BLOCKS, NUM_ROWS puedes
consultar la explicación que vimos en clase de teoría.
- Ejecuta cada una de las instrucciones, copia el resultado de ejecutar la instrucción
- Contesta a las preguntas de cada consulta

1.a) desc user_indexes – Qué atributos parecen interesantes?

SELECT * FROM USER_INDEXES;

INDEX_NAME
INDEX_TYPE
TABLE_OWNER
TABLE_NAME
UNIQUENESS
TABLESPACE_NAME
NUM_ROWS
BLEVEL
LEAF_BLOCKS
DISTINCT_KEYS

--

SELECT * FROM DBA_INDEXES;

OWNER

1.b) --- Índices de tu usuario
select INDEX_NAME,INDEX_TYPE, TABLE_NAME, UNIQUENESS from user_indexes Where TABLE_NAME = 'PELISAHORA';

PK_PELISACTUAL	NORMAL	PELISAHORA	UNIQUE
IDX_PELISAHORA_UNICO_TITULO	NORMAL	PELISAHORA	UNIQUE
IDX_PELISAHORA__FUN_DRAMA	FUNCTION-BASED NORMAL	PELISAHORA	NONUNIQUE

1.b.1 Porqué los índices de función y bitmap no son únicos?

Por que al ser pocos valores los que gestionan es muy normal que los valores
se puedan repetir, luego no pueden ser unicos.

1.c) select INDEX_NAME, INITIAL_EXTENT, BLEVEL, LEAF_BLOCKS, NUM_ROWS from user_indexes Where TABLE_NAME = 'PELISHIST';

INDEX_NAME                  INITIAL_LEVEL   BLEVEL  BLEAF_BLOCKS    NUM_ROWS
PK_PELISHIST	            65536	        1	    2	            521
IDX_PELISHIST_UNICO_TITULO	65536	        1	    3	            521
IDX_PELISHIST__FUN_DRAMA	65536	        0	    1	            521

1.c.1 Porqué tienen tan pocos niveles y bloques hoja estos índices?

Por la definicion de  arbol B+ que es con la que se crean estos indices,
cada bloque del arbol B+ es muy ancho y puede manejar más datos y punteros,
son arboles anchos y bajitos gracias a esta característica de los nodos.

1.c.2 Porqué el índice de género solo tiene 25 filas? demuéstralo con una consulta a la tabla

Por que es un índice BITMAP, diseñado para el manejo de pocos valores repetidos.

SELECT COUNT(DISTINCT(GENERO)) FROM PELISHIST; -- 25

1.d) select INDEX_NAME, DISTINCT_KEYS, AVG_LEAF_BLOCKS_PER_KEY, AVG_DATA_BLOCKS_PER_KEY, CLUSTERING_FACTOR from user_indexes 
Where TABLE_NAME = 'PELISHIST';

INDEX_NAME                  DISTINCT_KEYS   AVG_LEAAF_BLOCKS_PER_KEY AVG_DATA_BLOCKS_PER_KEY CLUSTERING_FACTOR
PK_PELISHIST	            521	            1	                     1	                     194
IDX_PELISHIST_UNICO_TITULO	521	            1	                     1	                     516
IDX_PELISHIST__FUN_DRAMA	52	            1	                     5	                     311

1.d.1 Qué son las DISTINCT_KEYS : comprúebalo con una consulta a cada tabla

SELECT COUNT(DISTINCT(ID)) FROM PELISHIST; -- 521
SELECT COUNT(DISTINCT(TITULO)) FROM PELISHIST; -- 521
SELECT COUNT(DISTINCT(ROUND(DRAMA))) FROM PELISHIST; -- 52

1.d.2 (para nota) Qué es el CLUSTERING_FACTOR?

Es una relacion entre el orden del índice y  el orden de la tabla que se utiliza como métrica del rendimiento.

Nos dice que tan ordenados se encuentran los registros de una tabla en relación a los valores de un índice.

INDEX CLUSTERING FACTOR ==> Factor de agrupación del índice.

Si el CLUSTERING FACTOR de un índice es elevado quiere decir que los datos no están bien ordenados con respecto
a la tabla y por tanto habrá que leer un mayor número de bloques de datos del índice (las filas estarán dispersas en varios
bloques deL índice). Esto favorece el FULL TABLE ACCESS.

Si el CLUSTERING FACTOR de un índice es pequeño quiere decir que los datos están bien ordenados con respecto a la tabla
y por tanto habrá que leer un menor número de bloques del índice. Eesto favorece el INDEX SCAN.

1.e) (para nota) Para ver mayor cantidad de valores de índices con muchas más filas
- Compara LEAF_BLOCKS, NUM_ROWS de varios índices: tienen la misma relación?
¿Qué te puede indicar? (busca en la web el sentido)

SELECT OWNER, INDEX_NAME, BLEVEL, LEAF_BLOCKS, NUM_ROWS
from dba_indexes -- los índices del sistema
where NUM_ROWS > 50000;

OWNER   INDEX_NAME  BLEVEL  LEAF_BLOCKS NUM_ROWS    CLUSTERING_FACTOR
SYS	    I_COL2	    1	    212	        76056       1152                ====> Los nodos del índice B+ son más grandes y los datos estarán mejor agrupados.
SYS	    I_COL3	    1	    171	        76056       1131
SYS	    I_COL1	    1	    453	        76056       4403                ====> Los nodos del índice B+ son más pequeños y los datos estarán peor agrupados.
SYS	    I_ARGUMENT1	2	    774	        100961      7557
SYS	    I_ARGUMENT2	1	    523	        100961      1988
SYS	    I_SOURCE1	1	    562	        232401      5839

Como los datos están más ordenados son necesarios menos nodos del arbol para almacenar las claves
ya que los valores están agrupados en los nodos y no dispersos en varios.

2.- Tabla user_tables : (si son tablas de otro usuario trabaja con: all_tables)
SE PIDE:
- Ejecuta cada una de las instrucciones, copia el resultado de ejecutar la instrucción
- Describe qué obtienes con cada una, describe sus atributos (los más importantes en 2.c)
y valores obtenidos. Necesitarás consultar documentación en la web.

2.a) desc user_tables

Nombre                    ¿Nulo?   Tipo         
------------------------- -------- ------------ 
TABLE_NAME                NOT NULL VARCHAR2(30) 
TABLESPACE_NAME                    VARCHAR2(30) 
CLUSTER_NAME                       VARCHAR2(30) 
IOT_NAME                           VARCHAR2(30) 
STATUS                             VARCHAR2(8)  
PCT_FREE                           NUMBER       
PCT_USED                           NUMBER       
INI_TRANS                          NUMBER       
MAX_TRANS                          NUMBER       
INITIAL_EXTENT                     NUMBER       
NEXT_EXTENT                        NUMBER       
MIN_EXTENTS                        NUMBER       
MAX_EXTENTS                        NUMBER       
PCT_INCREASE                       NUMBER       
FREELISTS                          NUMBER       
FREELIST_GROUPS                    NUMBER       
LOGGING                            VARCHAR2(3)  
BACKED_UP                          VARCHAR2(1)  
NUM_ROWS                           NUMBER       
BLOCKS                             NUMBER       
EMPTY_BLOCKS                       NUMBER       
AVG_SPACE                          NUMBER       
CHAIN_CNT                          NUMBER       
AVG_ROW_LEN                        NUMBER       
AVG_SPACE_FREELIST_BLOCKS          NUMBER       
NUM_FREELIST_BLOCKS                NUMBER       
DEGREE                             VARCHAR2(40) 
INSTANCES                          VARCHAR2(40) 
CACHE                              VARCHAR2(20) 
TABLE_LOCK                         VARCHAR2(8)  
SAMPLE_SIZE                        NUMBER       
LAST_ANALYZED                      DATE         
PARTITIONED                        VARCHAR2(3)  
IOT_TYPE                           VARCHAR2(12) 
TEMPORARY                          VARCHAR2(1)  
SECONDARY                          VARCHAR2(1)  
NESTED                             VARCHAR2(3)  
BUFFER_POOL                        VARCHAR2(7)  
FLASH_CACHE                        VARCHAR2(7)  
CELL_FLASH_CACHE                   VARCHAR2(7)  
ROW_MOVEMENT                       VARCHAR2(8)  
GLOBAL_STATS                       VARCHAR2(3)  
USER_STATS                         VARCHAR2(3)  
DURATION                           VARCHAR2(15) 
SKIP_CORRUPT                       VARCHAR2(8)  
MONITORING                         VARCHAR2(3)  
CLUSTER_OWNER                      VARCHAR2(30) 
DEPENDENCIES                       VARCHAR2(8)  
COMPRESSION                        VARCHAR2(8)  
COMPRESS_FOR                       VARCHAR2(12) 
DROPPED                            VARCHAR2(3)  
READ_ONLY                          VARCHAR2(3)  
SEGMENT_CREATED                    VARCHAR2(3)  
RESULT_CACHE                       VARCHAR2(7)  

2.b) select table_name, num_rows, blocks, avg_row_len from user_tables;

TABLE_NAME      NUM_ROWS    BLOCKS  AVG_ROW_LEN
NOTIFICACIONES	0	        0	    0
DICCION	        9	        5	    53
EMPRESA	        5	        5	    29
CLIENTE	        7	        5	    49
CLIENTE_N	    3	        5	    20
CLIENTE_I	    4	        5	    31
MOROSO	        4	        5	    49
OFERTA	        2	        5	    44
INVIERTE	    8	        5	    48
TARJETA	        10	        5	    37
COMPRAS	        11	        5	    46
PUESTO	        6	        5	    22
TIENET	        8	        5	    22
TIENETEL	    6	        5	    22
PELISAHORA	    142	        65	    2475
PELISHIST	    521	        244	    2228

2.b.1 Qué son los blocks? Qué relación tienen con num_rows?

Los blocks son bloques de datos que contienen información.
Cuantos más bloques de datos hay es porque más dispersos estarán los registros almacenados en el disco,
si hay pocos bloques es porque más registros se almacenan dentro del mismo bloque de datos.

2.b.2 Porqué avg_row_len es diferente en la table pelsiahora y en pelishist?

TABLE_NAME      NUM_ROWS    BLOCKS  AVG_ROW_LEN
PELISAHORA	    142	        65	    2475
PELISHIST	    521	        244	    2228

AVG_ROW_LEN es el tamaño medio de memoria que gasta un registro de una tabla.

Por que la memoria media empleada por cada descripción de película es mayor en la tabla PELISAHORA que en PELISHIST.

PELISHIST:
COLUMN_NAME DATA_TYPE 
ID	        NUMBER(38,0)
TITULO	    VARCHAR2(128 BYTE)
GENERO	    VARCHAR2(26 BYTE)
DESCRIPCION	VARCHAR2(4000 BYTE)

PELISHIST:
COLUMN_NAME DATA_TYPE
ID	        NUMBER(38,0)
TITULO	    VARCHAR2(128 BYTE)
GENERO	    VARCHAR2(26 BYTE)
DESCRIPCION	VARCHAR2(4000 BYTE)

-- 1110817 / 521 = 2132
SELECT COUNT(*) FROM pelishist; -- 521
SELECT SUM(LENGTH(DESCRIPCION)) FROM pelishist; -- 1110817

-- 336922 / 142 = 2372
SELECT COUNT(*) FROM pelisahora; -- 142
SELECT SUM(LENGTH(DESCRIPCION)) FROM pelisahora; -- 336922


Sección 3 : Estadísticas de una Tabla y de Columna desde el SQL DEVELOPER
SE PIDE:
- Explora estas instrucciones, ejecútalas e indica qué obtienes
- Explica los atributos que reconoces, que creas más importantes

a) Encima de una tabla botón derecho: menu contexto "Estadísticas" + “Valida Estructura”

analyze table "ABD0321"."PELISHIST" VALIDATE structure 

Permite verificar el estado de todos los bloques de datos de un bojeto.
Si se detecta algún fallo las filas pasan a agregarse a la tabla INVALID_ROWS.

b) Encima de una tabla + B.dcho: menu contexto "Estadísticas" + Recopilar Estadística (equivale al ANALIZE)

begin 

    DBMS_STATS.GATHER_TABLE_STATS (ownname => '"ABD0321"',tabname => '"PELISHIST"',estimate_percent => 1);
          
end;

DBMS_STATS permite recopilar estadísticas sobre un objeto. El optimizador podrá usarlas para elegi el plan
de ejecución más eficiente para las sentencias SQL que accedan a los objetos analizados. Se recomienda más
usar este paquete que ANALYZE para recopilar estadísticas de uso. Las estadísticas se pueden almacenar dentro
del diccionario de datos o en tablas fuera de este, donde pueden ser manipuladas sin afectar al optimizador.
Las estadísticas se pueden copiar entre bases de datos e incluso hacer cópias de seguridad de ellas.

La opción GATHER_TABLE_STATS permite recopilar estadísticas de tablas, columnas y índices.


c) Ahora se puede consultar, un vez abierta esa tabla, en la ventana derecha con pestañas: en la pestaña "estadísticas".

OKEY ==> ¿ Como se accede a estas tablas por SQL ?
* Sospecho que las monta lanzando querys de forma dinamica, no son tablas fijas.

d) Desde la misma ventana con pestañas de una tabla: pestaña "Estadística"
- Abajo en ventana "Estadísticas de Columna"

OKEY ==> ¿ Como se accede a estas tablas por SQL ?
* Sospecho que las monta lanzando querys de forma dinamica, no son tablas fijas.

e) En "Refrescar = 5" refresca datos cada 5 segundos

OKEY

f) Desde la misma ventana con pestañas de una tabla: pestaña "Detalles"

OKEY



Sección 4 .- Paquete DBMS_STATS: Estadísticas del Optimizador de Consultas (para nota)

Gestión de estadísticas de tablas e índices que usa el Optimizador para calcular costes en la decisión de
escoger su Plan de Ejecución. El optimizador usa las estadísticas que tengas para decidir el plan de ejecución
de las operaciones. Si no se cambian nunca, puede que estén obsoletas. Conviene obtenerlas de nuevo cada cierto tiempo.

SE PIDE:
- Ejecuta cada una de las instrucciones, copia el resultado de ejecutar la instrucción
- Describe qué obtienes con cada una, describe sus atributos y valores obtenidos

Necesitarás consultar la web para saber el modo de usarlo.

a) EXEC DBMS_STATS.GATHER_INDEX_STATS('tuusuario', 'PK_PELISHIST'); ==> (ordena que se almacenen estadísticas)

    EXEC DBMS_STATS.GATHER_INDEX_STATS('ABD0321', 'PK_PELISHIST'); --> Como ADMIN

    Recolectaremos estadísticas de un índice perteneciente a un usuario.

b) EXEC DBMS_STATS.GATHER_TABLE_STATS('tuusuario', 'PELISHIST'); ==> (ordena que se almacenen estadísticas)

    EXEC DBMS_STATS.GATHER_TABLE_STATS('ABD0321', 'PELISHIST');

c) select OWNER,INDEX_NAME,NUM_ROWS,LAST_ANALYZED,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS
from dba_indexes where owner = 'tuuusario' and index_name ='PK_PELISHIST';

select OWNER,INDEX_NAME,NUM_ROWS,LAST_ANALYZED,BLEVEL,LEAF_BLOCKS,DISTINCT_KEYS
from dba_indexes where owner = 'ABD0321' and index_name ='PK_PELISHIST';  

OWNER   INDEX_NAME      NUM_ROWS    LAST_ANALYZED   BLEVEL  LEAF_BLOCKS DISTINCT_KEYS
ABD0321	PK_PELISHIST	521	        11/04/19	    1	    2	        521

*/


    
