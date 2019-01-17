--2--перечень параметров экземпл€ра Oracle под system
SELECT a.name, a.value  FROM v$parameter ;

--3--под SYSTEM к PDB, список табличных пространств, файлов табличных пространств, ролей и пользователей.
alter pluggable database SPS_PDB open;
--connect SYSTEM/1111@//localhost:1521/SPS_PDB.be.by;
SELECT TABLESPACE_NAME FROM DBA_TABLESPACES;
SELECT FILE_NAME, TABLESPACE_NAME,STATUS, MAXBYTES, USER_BYTES FROM DBA_DATA_FILES
UNION
SELECT FILE_NAME, TABLESPACE_NAME,STATUS, MAXBYTES, USER_BYTES FROM DBA_TEMP_FILES;
SELECT USERNAME FROM DBA_USERS;
SELECT * FROM DBA_ROLES;

--6--под собственным пользователем и с применением подготовленной строки подключени€
-- connect U1_SPS_PDB/1111@SPS_PDB

--7--select к любой таблице, которой владеет ваш пользователь
select x,s from SPS_t;

--8--timing
set timing on;

--9--DESCRIBE
--DESCRIBE U1_SPS_PDB.SPS_t;

--10--перечень всех сегментов, владельцем которых €вл€етс€ ваш пользователь
SELECT segment_name, segment_type, tablespace_name, bytes, blocks, buffer_pool FROM USER_SEGMENTS;

CREATE VIEW info AS
  SELECT count(*) as segments,
  sum(extents) as extents,
  sum(blocks) as blocks,
  sum(bytes) as bytes
FROM user_segments;

drop VIEW info;
select * from info;