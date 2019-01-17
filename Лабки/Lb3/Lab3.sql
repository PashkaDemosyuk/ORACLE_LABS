--CONNECT TO SYSTEM_BAV_PDB
SELECT name, open_mode, con_id from v$pdbs;

select comp_name, status, version from DBA_REGISTRY;
v
drop pluggable database BAV_PDB including datafiles;



select * from dba_users;

CREATE TABLESPACE SYS_BAV_PDB
  DATAFILE 'D:\5sem\BD\LB\Lb3\SYS_BAV_PDB.dbf'
  SIZE 7 m
  AUTOEXTEND ON NEXT 5 m
  MAXSIZE 20 m
  EXTENT MANAGEMENT LOCAL;
  
CREATE TEMPORARY TABLESPACE TEMP_SYS_BAV_PDB
  TEMPFILE 'D:\5sem\BD\LB\Lb3\TEMP_SYS_BAV_PDB.dbf'
  SIZE 7 m
  AUTOEXTEND ON NEXT 5 m
  MAXSIZE 20 m
  EXTENT MANAGEMENT LOCAL;

alter session set "_ORACLE_SCRIPT"=true;

CREATE ROLE RL_BAV_PDB; 

GRANT CREATE SESSION,
      CREATE TABLE,
      CREATE VIEW,
      CREATE PROCEDURE
      TO RL_BAV_PDB;
      
REVOKE ALL privileges ON DBA_SYS_PRIVS FROM RL_BAV_PDB;
      
CREATE PROFILE PF_BAV_PDB LIMIT
  PASSWORD_LIFE_TIME 180 --истечение срока годности пароля
  SESSIONS_PER_USER 3 
  FAILED_LOGIN_ATTEMPTS 7
  PASSWORD_LOCK_TIME 1 --время блокировки после неудачных попыток
  PASSWORD_REUSE_TIME 10 --повторное использование пароля, дни
  PASSWORD_GRACE_TIME DEFAULT --предупреждение о смене пароля
  CONNECT_TIME 180 --время подключ, мин
  IDLE_TIME 30 --простой, минуты
  

CREATE USER U1_BAV_PDB IDENTIFIED BY 1111
  DEFAULT TABLESPACE SYS_BAV_PDB QUOTA UNLIMITED ON SYS_BAV_PDB
  TEMPORARY TABLESPACE TEMP_SYS_BAV_PDB
  PROFILE PF_BAV_PDB
  ACCOUNT UNLOCK
  
  GRANT RL_BAV_PDB TO U1_BAV_PDB
  
--CONNECT TO U1_BAV_PDB 
CREATE TABLE BAV_table(id number(3), name varchar2(15));
INSERT INTO BAV_table values(3, 'Hanna');
INSERT INTO BAV_table values(2, 'Pasha');
INSERT INTO BAV_table values(1, 'Polina');

SELECT * FROM DBA_USERS;

SELECT * FROM USER_ROLE_PRIVS;
SELECT * FROM USER_USERS;
SELECT * FROM USER_SYS_PRIVS;
SELECT * FROM USER_TAB_PRIVS;
SELECT * FROM ROLE_TAB_PRIVS;

--connect to CDB
CREATE USER C##BAV identified by 1111;
grant create session to C##BAV;
grant create session to C##YYY;
--привелегия 

COMMIT






  
