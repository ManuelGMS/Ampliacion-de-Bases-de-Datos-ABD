
/*     para saber si estamos dentro de una Transacción
       y que número tiene
*/

set serveroutput on
set autocommit off

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'TuTro';

declare

 numeroT varchar(50);
begin 

 SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

 hector.dormir(5); -- en segundos
 DBMS_OUTPUT.PUT_LINE('se ha dormido la trans->  ' || numeroT);
end;


/*   PARA HACER PRUEBAS DE TRANSACCIONES NECESITAMOS CONTROLAR: CUANDO FUNCIONAN
     Simulamos que una transacción dura un tiempo, poniéndola a dormir.
     Así puedes hacer pruebas de bloqueos y resultados de Niveles de Aislamiento.
     Usa este procedimiento 

*/
