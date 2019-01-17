SELECT a.name, a.value  FROM v$parameter a
ORDER BY a.name;


connect SYSTEM_BAV_PDB/1111@//localhost:1521/BAV_PDB as sysdba;

SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;
SELECT USERNAME FROM DBA_USERS;
SELECR * FROM DBA_ROLES;

SELECT * FROM DBA_TABLES;

SELECT TABLE_NAME FROM DBA_TABLES
WHERE OWNER LIKE 'U1_%';

DESCRIBE U1_BAV_PDB.T1;

SELECT COUNT(*) FROM USER_SEGMENTS;

set timing on;
select stuff from U1_BAV_PDB.T1;

select METRIC_NAME,
VALUE
from SYS.V_$SYSMETRIC
where METRIC_NAME IN ('Database CPU Time Ratio',
'Database Wait Time Ratio') AND
INTSIZE_CSEC = 
(select max(INTSIZE_CSEC) from SYS.V_$SYSMETRIC); 

select end_time, 
value 
from sys.v_ $sysmetric_history;


select count(*) from user_segments;
select count(*) from user_extents;
select count(*) from user_blocks;
select sum(blocks) as blocks
from user_segments;
select sum(extents) as blocks
from user_segments;

CREATE MATERIALIZED VIEW infoSize AS
  SELECT sum(extents) as extents,
  sum(blocks) as blocks,
  count(*) as segments
FROM user_segments;
commit;


CREATE MATERIALIZED VIEW VIEW2 BUILD IMMEDIATE REFRESH COMPLETE ON DEMAND NEXT SYSDATE + NUMTODSINTERVAL(1, 'MINUTE') AS 
SELECT sum(extents) as extents,
  sum(blocks) as blocks,
  count(*) as segments
FROM user_segments;
