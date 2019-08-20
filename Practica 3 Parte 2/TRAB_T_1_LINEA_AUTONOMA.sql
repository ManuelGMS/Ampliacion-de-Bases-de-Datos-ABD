create or replace PROCEDURE trab_T_1_linea_autonoma (lapsus IN number)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
 milinea varchar(100) :=  ' ';
 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'Trans-Principal-nueva';

SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

DBMS_OUTPUT.PUT_LINE(' Trans. Principal Empieza: ' || numeroT);

  LOOP
     SELECT  sec_trans_1.NEXTVAL into valor_secuencia
       FROM dual ; 
     IF  valor_secuencia =  old_valor_secuencia THEN exit;
     ELSE
       old_valor_secuencia := valor_secuencia;   
       hector.dormir(5); -- en segundos   
     END IF;
   
     milinea := ' se ha dormido -> ' || ' antes:  '|| 
        old_valor_secuencia || ' despues: ' || valor_secuencia;
        --- para ver la línea cada vez que pasa por aquí       
        pone_linea_autonoma (milinea);

  END LOOP;
  
  SELECT dbms_transaction.local_transaction_id into numeroT
    FROM dual ;

  DBMS_OUTPUT.PUT_LINE(' Trans. Principal TERMINA: ' || numeroT);
 
end trab_T_1_linea_autonoma;




/*   
------- PREPARAR

--------- cada vez que empecemos 
set serveroutput on
set autocommit off
                       
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'TuTro';

SELECT dbms_transaction.local_transaction_id -- into numeroT
 FROM dual ; 

-------- solo cuando queramos empezar en cero
                                    
drop sequence  sec_trans_1;

CREATE SEQUENCE sec_trans_1
 START WITH 0 INCREMENT BY 1 minvalue 0 MAXVALUE 1 CYCLE NOCACHE;

commit;

------ la primera vez que te refieres en esta sesión



------ PROBAR 


begin
  trab_T_1_linea_autonoma (5);
end;

- - SIgue hasta que en otra session:

  SELECT  sec_trans_1.NEXTVAL    FROM dual ;    



*/
