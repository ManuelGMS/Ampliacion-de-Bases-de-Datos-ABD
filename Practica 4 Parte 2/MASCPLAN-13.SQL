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
