create or replace PROCEDURE insertoConsistente (
DNI_p        invierte.DNI%TYPE,
NombreE_p    invierte.NombreE%TYPE,
Cantidad_p   invierte.Cantidad%TYPE,
Tipo_p       invierte.Tipo%TYPE
)  AS


/* ------ empiezo un bloque sin nombre para las pruebas -----------

DECLARE 

-- vars. de prueba que luego serán los parámetros del procedimiento

DNI_p        invierte.DNI%TYPE := '00000002';
NombreE_p    invierte.NombreE%TYPE := 'Empresa XX' ;
Cantidad_p   invierte.Cantidad%TYPE := 9999999;
Tipo_p       invierte.Tipo%TYPE := 'bono99';
--- SE comenta cuando funcionan todas los CASOS 
--- y se pone la definición del procedimeinto y las vars. de prueba se ponen como parámetros
------- */

-- para dar permiso de ejecución a todos: GRANT EXECUTE ON insertoconsistente TO public;

-- vars de trabajo

Cantidad_old   invierte.Cantidad%TYPE;

es_dni_nuevo int := 0;  -- tendra un 0 si el DNI es nuevo
es_tipo_nuevo int := 0;  -- tendra un 0 si el tipo es nuevo
es_empresa_nueva int := 0;    -- tendra un 0 si la empresa es nueva


-- Decido si ese DNI es nuevo (no tiene inversiones) : si 0 es nuevo

Cursor c_dni_nuevo IS
       select count(*)   -- 0 si no hay, 1 si hay una o más
       from dual
       where EXISTS ( select null from invierte 
                      where DNI= DNI_p);
		      
/* --------- puedo hacer esto, pero cambia la condición abajo
 Cursor c_dni_nuevo IS
       select count(*)   -- 0 si no hay, mayor que 0 si hay una o más
       from invierte
       where DNI= DNI_p;
---------*/




-- Decido si es Tipo nuevo para ese cliente: si 0 es nuevo
Cursor c_tipo_nuevo IS
       select count(*)   -- 0 si no hay, 1 si hay una o más
       from dual
       where EXISTS ( select null from invierte 
                      where DNI= DNI_p and Tipo= Tipo_p );
 
-- Decido si es empresa nueva para ese cliente: si 0 es nuevo
Cursor c_empresa_nueva IS

       select count(*)   -- 0 si no hay, 1 si hay una o más
       from dual
       where EXISTS ( select null from invierte 
                      where DNI= DNI_p and NombreE= NombreE_p );


-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);



BEGIN

--------- muestro los datos de entrada (parámetros) con los que trabajo

 DBMS_output.put_line('-------    Inversion: DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
 DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p );
 DBMS_output.put_line('-------------------');

-- Si no exístían inversiones para ese DNI 
      open  c_dni_nuevo;
       fetch c_dni_nuevo   into  es_dni_nuevo;
       close  c_dni_nuevo; 

-- CASO 0.- No hay inversiones de ese DNI: inserto la fila y termino
 IF  es_dni_nuevo = 0 THEN 
       DBMS_output.put_line('--- CASO: no existe ninguna inversión con ese cliente');
       DBMS_output.put_line('          creamos una fila, no hay obligación de crear más');

      insert into Invierte VALUES (DNI_p, NombreE_p, Cantidad_p, Tipo_p );
--- imprimo la fila nueva
       DBMS_output.put_line('====== Inversion de DNI NUEVO: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
       DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p);
       DBMS_output.put_line('=======');
ELSE
  --- RESTO DE CASOS ----------



-- EN que CASO estoy?
       open  c_tipo_nuevo;
       fetch c_tipo_nuevo   into  es_tipo_nuevo;
       close  c_tipo_nuevo; 


       open  c_empresa_nueva;
       fetch c_empresa_nueva   into  es_empresa_nueva;
       close  c_empresa_nueva; 

-- imprimo en el caso que estamos
       DBMS_output.put_line('--- CASO: TIPO: ' ||   es_tipo_nuevo || '  NOMBREE ' || es_empresa_nueva );


-- CASO 1.-  Ya existe una fila con mismo Tipo (1) y Empresa (1) : es un error, no se lo permito 

 IF  es_tipo_nuevo = 1 and es_empresa_nueva = 1 THEN 
       DBMS_output.put_line('--- CASO: ya existe una inversión con ese cliente,empresa y tipo');
       DBMS_output.put_line('         está prohibido por la dependencia multivalorada');
ELSIF

   es_tipo_nuevo = 0 and es_empresa_nueva = 1 THEN 
-- CASO 2.-  tipo nuevo para una  Empresa que ya hay inversiones: debo insertar filas con ese tipo para todas sus empresas

    for cada_emp in
            (select distinct NombreE from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, cada_emp.NombreE, Cantidad_p, Tipo_p );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para: DNI: ' ||  DNI_p || ' NombreE_p:  ' || cada_emp.NombreE);
        DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p );
        DBMS_output.put_line('======='); 
    END LOOP;

ELSIF
   es_tipo_nuevo = 1 and es_empresa_nueva = 0 THEN 
-- CASO 3.- Empresa nueva para un tipo que ya hay inversiones: debo insertar filas con ese empresa para todos sus tipos
--          No tomo en cuenta la nueva cantidad (es complejo comprobar la antigüa si hay varias empresas con ese Tipo)

    for cada_tipo in
            (select distinct Tipo, Cantidad from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, NombreE_p, cada_tipo.Cantidad, cada_tipo.Tipo );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para: DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
        DBMS_output.put_line('            Cantidad: ' || cada_tipo.Cantidad ||   '  TIPO: ' || cada_tipo.Tipo);
        DBMS_output.put_line('=======');
     END LOOP;

ELSIF
   es_tipo_nuevo = 0 and es_empresa_nueva = 0 THEN 
-- CASO 4.- El tipo y la empresa son nuevos: Como  CASO 2 + CASO 3

------ para cada empresa que había tengo que insertar el bono nuevo
for cada_emp in
            (select distinct NombreE from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, cada_emp.NombreE, Cantidad_p, Tipo_p );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para empresa anterior DNI: ' ||  DNI_p || ' NombreE_p:  ' || cada_emp.NombreE);
        DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p );
        DBMS_output.put_line('======='); 
    END LOOP;


------- para esta empresa nueva tengo que insertar todos los bonos que había 
--      (como incluye el bono nuevo, que está ya en la BD, genera también 
--         la fila de los argumentos de entrada)
for cada_tipo in
            (select distinct Tipo, Cantidad from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, NombreE_p, cada_tipo.Cantidad, cada_tipo.Tipo );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para bonos antigüos DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
        DBMS_output.put_line('            Cantidad: ' || cada_tipo.Cantidad ||   '  TIPO: ' || cada_tipo.Tipo);
        DBMS_output.put_line('=======');
     END LOOP;



 END IF;
      
END IF;    


EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
   DBMS_output.put_line('Sale por una excepcion: ' || Tcoderror ||   '  -- ' || Ttexterror );
   DBMS_output.put_line('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$' ); 


END;
