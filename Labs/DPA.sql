SELECT owner, segment_name, segment_type, tablespace_name, bytes, blocks, buffer_pool
FROM DBA_SEGMENTS
WHERE tablespace_name='DPA_QDATA';

SELECT * FROM V$LOGFILE;

ALTER DATABASE ADD LOGFILE GROUP 4 'C:\app\Orcl\oradata\orcl\REDO04.LOG'
SIZE 50 m BLOCKSIZE 512;

ALTER DATABASE ADD LOGFILE MEMBER 'C:\app\Orcl\oradata\orcl\REDO043.LOG' TO GROUP 4;

ALTER DATABASE DROP LOGFILE MEMBER 'C:\app\Orcl\oradata\orcl\REDO043.LOG';


ALTER DATABASE DROP LOGFILE GROUP 4;
SELECT NAME, LOG_MODE FROM V$DATABASE;

select * from cdb_users where username like '%DPA%';

alter pluggable database all open;