create or replace PROCEDURE pone_linea_autonoma (milinea IN varchar)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
--- en origen: milinea varchar(100) :=  ' ';
 
 -- Hacemos transacción autónoma 
 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'Trans-Principal';

SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

DBMS_OUTPUT.PUT_LINE(milinea || ' Num.Trans.Secun: ' || numeroT);

commit;  -- termina transacción, es obligatorio

end pone_linea_autonoma;
