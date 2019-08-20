create or replace PROCEDURE Gestion_Inversion (
       	  nombreEmpresa Invierte.nombreE%TYPE,
	  dniCliente Invierte.dni%TYPE,
	  cantidad Invierte.cantidad%TYPE,
	  tipo Invierte.tipo%TYPE) AS
	  
  existeEmpresa INT;
  plsql_block VARCHAR2(2000);
  valorDeLaSecuencia INT;


-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);


BEGIN

    SELECT COUNT(*)
    INTO existeEmpresa
    FROM Empresa E
    WHERE E.nombreE = nombreEmpresa;
    
    IF existeEmpresa <> 0 THEN
      CREA_SECUENCIA_INVERSION(nombreEmpresa);
      CREA_TABLA_INVERSIONES(nombreEmpresa);
      plsql_block := 'BEGIN
                          :a := SEC_' || REPLACE(UPPER(nombreEmpresa), ' ', '') || '.NEXTVAL;
                      END;';
      EXECUTE IMMEDIATE plsql_block USING OUT valorDeLaSecuencia;
      
      plsql_block := 'BEGIN
                        INSERT INTO INVERSIONES_' || REPLACE(UPPER(nombreEmpresa), ' ', '') || ' VALUES (:a, :b, :c, :d);
                      END;'; 
                      
      
      EXECUTE IMMEDIATE plsql_block USING IN valorDeLaSecuencia, dniCliente, cantidad, tipo;
      DBMS_OUTPUT.PUT_LINE('Se ha insertado la inversion en la tabla inversiones_ ' || REPLACE(nombreEmpresa, ' ', ''));
    ELSE
      DBMS_OUTPUT.PUT_LINE('La empresa ' || RTRIM(nombreEmpresa) || ' no existe en la BBDD.');
    END IF;

EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
   DBMS_output.put_line('Sale por una excepcion: ' || Tcoderror ||   '  -- ' || Ttexterror );
   DBMS_output.put_line('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' ); 

END;
