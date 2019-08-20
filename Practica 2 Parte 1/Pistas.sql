
---- LA TABLA

select count(table_name) into si_esta from tabs where table_name =
    RTRIM( UPPER('cupones_' || Restaurante));


if si_esta = 0 THEN creo la tabla con "execute immediate . . . "

-- LA secuencia
select count(object_name)  into si_esta_sec 
from user_objects
where object_type ='SEQUENCE' and 
       object_name =  RTRIM( UPPER('sec_'|| Restaurante));

if si_esta = 0 THEN creo la secuencia con "execute immediate . . . "

