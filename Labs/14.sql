
CREATE DATABASE LINK dbs
CONNECT TO SPS
IDENTIFIED BY "1111"
USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=192.168.100.4)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl.be.by)))';


SELECT * FROM new_table@dbs;

SELECT * FROM DBA_DB_LINKS;
CREATE TABLE new_table( customer_id number(10) NOT NULL );
DROP DATABASE LINK dbs;

-- 2 --
DROP TABLE new_table;
CREATE TABLE new_table( customer_id number(10) NOT NULL );
SELECT * FROM new_table;

INSERT INTO new_table@dbs (customer_id) VALUES (16);

SELECT * FROM new_table@dbs;

UPDATE new_table@dbs SET customer_id = 6 WHERE customer_id = 1;

DELETE FROM new_table@dbs WHERE customer_id = 6;

-- 3 --
CREATE PUBLIC DATABASE LINK pdbs
CONNECT TO system
IDENTIFIED BY "1111"
USING '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=orcl)))';

SELECT * FROM DBA_DB_LINKS;

DROP PUBLIC DATABASE LINK pdbs;

-- 4 --
INSERT INTO new_table@pdbs (customer_id) VALUES (1);

SELECT * FROM new_table@pdbs;

SELECT * FROM new_table;

UPDATE new_table@pdbs SET customer_id = 5 WHERE customer_id = 1;

DELETE FROM new_table@pdbs WHERE customer_id = 5;
