CREATE TABLESPACE ESPABD0321 DATAFILE 'ESPABD0321' SIZE 16M AUTOEXTEND OFF;

CREATE USER ABD0321 IDENTIFIED BY mana DEFAULT TABLESPACE ESPABD0321 TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON ESPABD0321;

GRANT create table, delete any table, select any dictionary ,
connect, create session , create synonym , create public synonym ,
create sequence, create view , create trigger TO ABD0321;

GRANT create procedure, alter any procedure, drop any procedure, execute any procedure TO ABD0321;

GRANT create trigger, alter any trigger, drop any trigger TO ABD0321;

-- ALTER USER <nombre-usuario> IDENTIFIED BY <nueva-contraseña>;

