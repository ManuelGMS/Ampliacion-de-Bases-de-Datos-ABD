create or replace PROCEDURE partir_tabla_invierte  AS


-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);

BEGIN

FOR rec IN (select * from invierte)
  LOOP
   gestion_inversion (rec.NombreE, rec.DNI,rec.cantidad, rec.tipo);
  DBMS_OUTPUT.put_line (rec.NombreE || ' -- ' || rec.DNI ||
    ' -- ' || rec.cantidad || '  -- ' || rec.tipo);
END LOOP;

EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
   DBMS_output.put_line('Sale por una excepcion: ' || Tcoderror ||   '  -- ' || Ttexterror );
   DBMS_output.put_line('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' ); 

END;

/*  ---- PRUEBA ------

execute traspasar_inversiones();

*/
   
  
