--GRANT CREATE SESSION,
    --  CREATE TABLE,
    --  CREATE VIEW,
    --  CREATE SEQUENCE,
    --  SELECT ANY DICTIONARY,
    --  CREATE CLUSTER,
    --  CREATE SYNONYM,
    --  CREATE PUBLIC SYNONYM,
    --  CREATE MATERIALIZED VIEW,
    --  CREATE PROCEDURE TO RLSPSCORE;

--2--последовательность S1
--начальное значение 1000; приращение 10; нет минимального значения; нет максимального значения; 
--не циклическая; значения не кэшируются в памяти; хронология значений не гарантируется.
CREATE SEQUENCE S1
  INCREMENT BY 10 
  START WITH 1000
  NOMAXVALUE
  NOMINVALUE
  NOCYCLE
  NOCACHE
  NOORDER;

SELECT S1.NEXTVAL FROM DUAL;
SELECT S1.CURRVAL FROM DUAL;

--3--последовательность S2 
--начальное значение 10; приращение 10; максимальное значение 100; не циклическую

CREATE SEQUENCE S2
  INCREMENT BY 10 
  START WITH 10
  MAXVALUE 100
  NOMINVALUE
  NOCYCLE
  NOCACHE
  NOORDER;
  
SELECT S2.NEXTVAL FROM DUAL;
SELECT S2.CURRVAL FROM DUAL;

DROP SEQUENCE S2;
--4--	Создайте последовательность S3 
--начальное значение 10; приращение -10; минимальное значение -100; не циклическую; гарантирующую хронологию значений. 
CREATE SEQUENCE S3
  INCREMENT BY -10 
  START WITH 10
  MAXVALUE 10
  MINVALUE -100
  NOCYCLE
  ORDER;
  
SELECT S3.NEXTVAL FROM DUAL;
SELECT S3.CURRVAL FROM DUAL;
  
DROP SEQUENCE S3;

--5-- Создайте последовательность S4
--начальное значение 1; приращение 1; минимальное значение 10; циклическая; кэшируется в памяти 5 значений; 
--хронология значений не гарантируется. Продемонстрируйте цикличность генерации значений последовательностью S4.

CREATE SEQUENCE S4
  INCREMENT BY 1
  START WITH 10
  MAXVALUE 16
  MINVALUE 10
  CYCLE
  CACHE 5;

SELECT S4.NEXTVAL FROM DUAL;
SELECT S4.CURRVAL FROM DUAL;

DROP SEQUENCE S4;

--6--список всех последовательностей в словаре базы данных, владельцем которых является пользователь SPS.
SELECT * FROM sys.dba_sequences WHERE SEQUENCE_OWNER='SPS';

--7--таблицу T1, имеющую столбцы N1, N2, N3, N4, типа NUMBER (20), кэшируемую и расположенную в буферном пуле KEEP. 
--С помощью оператора INSERT добавьте 7 строк, вводимое значение для столбцов должно формироваться с помощью 
--последовательностей S1, S2, S3, S4.

CREATE TABLE T1(
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)) STORAGE(BUFFER_POOL KEEP);
  
INSERT INTO T1 VALUES (S1.NEXTVAL,S2.NEXTVAL,S3.NEXTVAL,S4.NEXTVAL);

SELECT * FROM T1;

--8--Создайте кластер ABC, имеющий hash-тип (размер 200) и содержащий 2 поля: X (NUMBER (10)), V (VARCHAR2(12)).
CREATE CLUSTER ABC(
  X NUMBER(10),
  V VARCHAR2(12)
)
HASHKEYS 200;
  
DROP CLUSTER ABC;

--9--Создайте таблицу A, имеющую столбцы XA (NUMBER (10)) и VA (VARCHAR2(12)), принадлежащие кластеру ABC, 
--а также еще один произвольный столбец
CREATE TABLE A(
  Xa NUMBER(10),
  Va VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xa, Va);
  
--10--таблицу B, имеющую столбцы XB (NUMBER (10)) и VB (VARCHAR2(12)), принадлежащие кластеру ABC, 
--а также еще один произвольный столбец.
CREATE TABLE B(
  Xb NUMBER(10),
  Vb VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xb, Vb);
 
--11--Создайте таблицу С, имеющую столбцы XС (NUMBER (10)) и VС (VARCHAR2(12)), принадлежащие кластеру ABC, 
--а также еще один произвольный столбец.  
CREATE TABLE C(
  Xc NUMBER(10),
  Vc VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xc, Vc);

--12--Найдите созданные таблицы и кластер в представлениях словаря Oracle
SELECT cluster_name, owner, tablespace_name, cluster_type, cache FROM SYS.DBA_CLUSTERS;


--13--частный синоним для таблицы XXX.С и продемонстрируйте его применение
CREATE SYNONYM TC FOR SPS.C;
SELECT * FROM TC;

--14--публичный синоним для таблицы XXX.B и продемонстрируйте его применение.
CREATE PUBLIC SYNONYM TB FOR SPS.B;
SELECT * FROM TB;

--15--Создайте две произвольные таблицы A и B (с первичным и внешним ключами), заполните их данными, 
--создайте представление V1, основанное на SELECT... FOR A inner join B. Продемонстрируйте его работоспособность.

CREATE TABLE AA(
  idAA NUMBER PRIMARY KEY,
  name VARCHAR2(12)
);

CREATE TABLE BB(
  idBB NUMBER PRIMARY KEY,
  AA NUMBER,
  CONSTRAINT FK_AA FOREIGN KEY(AA) REFERENCES AA(idAA)
); 
INSERT INTO AA VALUES (3, 'UIO');
INSERT INTO BB VALUES (6, 3);

CREATE VIEW V1 AS
  SELECT * FROM 
  AA INNER JOIN BB
  ON AA.IDAA=BB.AA;
  
SELECT * FROM V1;

--16--На основе таблиц A и B создайте материализованное представление MV, 
--которое имеет периодичность обновления 2 минуты. Продемонстрируйте его работоспособность.

CREATE MATERIALIZED VIEW MV1
BUILD IMMEDIATE
REFRESH NEXT SYSDATE + 1/1440
AS
 SELECT * FROM 
  AA INNER JOIN BB
  ON AA.IDAA=BB.AA;
  
DROP    MATERIALIZED VIEW MV1;
INSERT INTO BB VALUES (8, 3);

UPDATE AA SET NAME='ASD' WHERE NAME='QWE'; 
COMMIT;
SELECT * FROM MV1;
