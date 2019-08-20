SQL_ID  0u9yhd57rmu6t, child number 0
-------------------------------------
--select /*+ GATHER_PLAN_STATISTICS */ /* prac4s10 consulta-1 */ A.ID, 
A.titulo,round(A.drama), H.genero from PELISHIST H, PELISAHORA A where 
A.ID = H.ID and (round(A.drama) = 43 or round(A.drama) = 50)
 
Plan hash value: 1770619335
 
----------------------------------------------------------------------------------------------------------------------
| Id  | Operation                      | Name                      | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
----------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT               |                           |      1 |        |      7 |00:00:00.01 |      25 |
|   1 |  NESTED LOOPS                  |                           |      1 |        |      7 |00:00:00.01 |      25 |
|   2 |   NESTED LOOPS                 |                           |      1 |      1 |      7 |00:00:00.01 |      18 |
|   3 |    INLIST ITERATOR             |                           |      1 |        |      7 |00:00:00.01 |       9 |
|   4 |     TABLE ACCESS BY INDEX ROWID| PELISAHORA                |      2 |      1 |      7 |00:00:00.01 |       9 |
|*  5 |      INDEX RANGE SCAN          | IDX_PELISAHORA__FUN_DRAMA |      2 |      1 |      7 |00:00:00.01 |       2 |
|*  6 |    INDEX UNIQUE SCAN           | PK_PELISHIST              |      7 |      1 |      7 |00:00:00.01 |       9 |
|   7 |   TABLE ACCESS BY INDEX ROWID  | PELISHIST                 |      7 |      1 |      7 |00:00:00.01 |       7 |
----------------------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   5 - access(("A"."SYS_NC00016$"=43 OR "A"."SYS_NC00016$"=50))
   6 - access("A"."ID"="H"."ID")
 
Note
-----
   - dynamic sampling used for this statement (level=2)


--****************************************************************************************************************************

SQL_ID  9tf04hutryfg8, child number 0
-------------------------------------
select /*+ GATHER_PLAN_STATISTICS */ /* prac4s10 consulta-manu-2 */ 
A.ID, A.titulo, A.genero from PELISAHORA A, PELISHIST H where A.ID = 
H.ID and A.ID > 100 and A.genero = 'Terror'
 
Plan hash value: 2542610768
 
---------------------------------------------------------------------------------------------------------
| Id  | Operation                    | Name           | Starts | E-Rows | A-Rows |   A-Time   | Buffers |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |                |      1 |        |      3 |00:00:00.01 |      55 |
|   1 |  NESTED LOOPS                |                |      1 |      3 |      3 |00:00:00.01 |      55 |
|*  2 |   TABLE ACCESS BY INDEX ROWID| PELISAHORA     |      1 |      3 |      3 |00:00:00.01 |      50 |
|*  3 |    INDEX RANGE SCAN          | PK_PELISACTUAL |      1 |      1 |    107 |00:00:00.01 |       1 |
|*  4 |   INDEX UNIQUE SCAN          | PK_PELISHIST   |      3 |      1 |      3 |00:00:00.01 |       5 |
---------------------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - filter("A"."GENERO"='Terror')
   3 - access("A"."ID">100)
   4 - access("A"."ID"="H"."ID")
       filter("H"."ID">100)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
 