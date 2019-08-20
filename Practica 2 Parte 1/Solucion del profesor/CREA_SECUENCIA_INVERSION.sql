create or replace PROCEDURE Crea_Secuencia_Inversion(nombreEmpresa Invierte.NombreE%TYPE) AS

  estaCreada INT;
  plsql_block VARCHAR2(2000);


-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);
      
BEGIN
  
  --Es necesario quitar los espacios del nombre de la empresa porque no 
  --se puede crear una secuencia cuyo nombre sea secuencia_empresa 11.
  
  --Además el nombre de la empresa debe estar en mayusculas porque la tabla
  --user_objects almacena los nombres de los objetos con mayúsculas
  
  SELECT COUNT(*)
  INTO estaCreada
  FROM user_objects
  WHERE object_name = 'SEC_' || REPLACE(UPPER(nombreEmpresa), ' ', '');
  
  IF estaCreada = 0 THEN
    plsql_block := 'CREATE SEQUENCE sec_' || REPLACE(nombreEmpresa, ' ', '') || ' INCREMENT BY 1 START WITH 1 NOMAXVALUE';
    EXECUTE IMMEDIATE plsql_block;
    DBMS_OUTPUT.PUT_LINE('Se ha creado una nueva secuencia con nombre secuencia_' || RTRIM(nombreEmpresa));
  ELSE
    DBMS_OUTPUT.PUT_LINE('La secuencia secuencia_' || RTRIM(nombreEmpresa) || ' ya existía, no se ha creado ninguna secuencia.');
  END IF;

EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
   DBMS_output.put_line('Sale por una excepcion: ' || Tcoderror ||   '  -- ' || Ttexterror );
   DBMS_output.put_line('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' ); 


END Crea_Secuencia_Inversion;
