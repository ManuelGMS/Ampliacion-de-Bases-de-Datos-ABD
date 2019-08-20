create or replace PROCEDURE Crea_Tabla_Inversiones(nombreEmpresa Invierte.NombreE%TYPE) AS
  estaCreada INT;
  plsql_block VARCHAR2(2000);

-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);

BEGIN

  --Es necesario quitar los espacios del nombre de la empresa porque no 
  --se puede crear una tabla cuyo nombre sea inversiones_empresa 11
  
  --Además el nombre de la empresa debe estar en mayusculas porque la tabla
  --tabs almacena los nombres de los tablas con mayúsculas
  
  SELECT COUNT(*)
  INTO estaCreada
  FROM tabs
  WHERE table_name = 'INVERSIONES_' || REPLACE(UPPER(nombreEmpresa), ' ', '');
  
  IF estaCreada = 0 THEN
    plsql_block := 'CREATE TABLE inversiones_' || REPLACE(nombreEmpresa, ' ', '') || '(
                          NumInv INT NOT NULL,
                          DNI CHAR(8),
                          Cantidad INT,
                          Tipo CHAR(10),
                          CONSTRAINT pk_inversiones_' || REPLACE(nombreEmpresa, ' ', '') || ' PRIMARY KEY(NumInv))'; 
                    
    EXECUTE IMMEDIATE plsql_block;
    DBMS_OUTPUT.PUT_LINE('Se ha creado una nueva tabla con nombre inversiones_' || RTRIM(nombreEmpresa));
  ELSE
    DBMS_OUTPUT.PUT_LINE('La tabla inversiones_' || RTRIM(nombreEmpresa) || ' ya existía, no se ha creado ninguna tabla.');
  END IF;


EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
   DBMS_output.put_line('Sale por una excepcion: ' || Tcoderror ||   '  -- ' || Ttexterror );
   DBMS_output.put_line('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' ); 


END;
