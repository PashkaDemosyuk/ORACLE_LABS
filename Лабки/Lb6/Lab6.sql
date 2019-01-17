SELECT * FROM v$sga;

SELECT SUM(VALUE) FROM v$sga;

SELECT
  component,
  current_size,
  max_size,
  last_oper_mode,
  last_oper_time,
  granule_size,
  current_size/granule_size as Ratio
FROM v$sga_dynamic_components
WHERE current_size>0;

SHOW parameter sga;

SELECT 
  COMPONENT,
  min_size,
  current_size
FROM v$sga_dynamic_components;


SELECT name, resize_state, block_size, buffers, prev_buffers from v$buffer_pool;

CREATE TABLE BAV_KEEP_POOL(k int) STORAGE(BUFFER_POOL KEEP);
CREATE TABLE BAV_DEFAULT_POOL(k int) STORAGE(BUFFER_POOL DEFAULT);
CREATE TABLE BAV_DEFAULT_POOL1(k int);

SELECT segment_name, segment_type, tablespace_name, buffer_pool
FROM user_segments
WHERE segment_name in('BAV_KEEP_POOL', 'BAV_DEFAULT_POOL', 'BAV_DEFAULT_POOL1');

show parameter log_buffer;

SELECT
  component,
  min_size,
  current_size,
  max_size
FROM v$sga_dynamic_components
WHERE component='shared pool';

SELECT pool, name, bytes
FROM v$sgastat
WHERE pool='shared pool';

SELECT pool, name, bytes
FROM v$sgastat
WHERE pool='shared pool'
ORDER BY BYTES DESC;

SELECT
  component,
  min_size,
  current_size,
  max_size,
  MAX_SIZE - current_size as free_size
FROM v$sga_dynamic_components
WHERE component='large pool';

SELECT username, service_name, server FROM v$session
WHERE username is not null; 


SELECT *
FROM dba_segments;

--SYS
SELECT *
  FROM x$bh
  ORDER BY tch DESC;