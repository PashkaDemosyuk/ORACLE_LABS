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

--2--������������������ S1
--��������� �������� 1000; ���������� 10; ��� ������������ ��������; ��� ������������� ��������; 
--�� �����������; �������� �� ���������� � ������; ���������� �������� �� �������������.
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

--3--������������������ S2 
--��������� �������� 10; ���������� 10; ������������ �������� 100; �� �����������

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
--4--	�������� ������������������ S3 
--��������� �������� 10; ���������� -10; ����������� �������� -100; �� �����������; ������������� ���������� ��������. 
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

--5-- �������� ������������������ S4
--��������� �������� 1; ���������� 1; ����������� �������� 10; �����������; ���������� � ������ 5 ��������; 
--���������� �������� �� �������������. ����������������� ����������� ��������� �������� ������������������� S4.

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

--6--������ ���� ������������������� � ������� ���� ������, ���������� ������� �������� ������������ SPS.
SELECT * FROM sys.dba_sequences WHERE SEQUENCE_OWNER='SPS';

--7--������� T1, ������� ������� N1, N2, N3, N4, ���� NUMBER (20), ���������� � ������������� � �������� ���� KEEP. 
--� ������� ��������� INSERT �������� 7 �����, �������� �������� ��� �������� ������ ������������� � ������� 
--������������������� S1, S2, S3, S4.

CREATE TABLE T1(
  N1 NUMBER(20),
  N2 NUMBER(20),
  N3 NUMBER(20),
  N4 NUMBER(20)) STORAGE(BUFFER_POOL KEEP);
  
INSERT INTO T1 VALUES (S1.NEXTVAL,S2.NEXTVAL,S3.NEXTVAL,S4.NEXTVAL);

SELECT * FROM T1;

--8--�������� ������� ABC, ������� hash-��� (������ 200) � ���������� 2 ����: X (NUMBER (10)), V (VARCHAR2(12)).
CREATE CLUSTER ABC(
  X NUMBER(10),
  V VARCHAR2(12)
)
HASHKEYS 200;
  
DROP CLUSTER ABC;

--9--�������� ������� A, ������� ������� XA (NUMBER (10)) � VA (VARCHAR2(12)), ������������� �������� ABC, 
--� ����� ��� ���� ������������ �������
CREATE TABLE A(
  Xa NUMBER(10),
  Va VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xa, Va);
  
--10--������� B, ������� ������� XB (NUMBER (10)) � VB (VARCHAR2(12)), ������������� �������� ABC, 
--� ����� ��� ���� ������������ �������.
CREATE TABLE B(
  Xb NUMBER(10),
  Vb VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xb, Vb);
 
--11--�������� ������� �, ������� ������� X� (NUMBER (10)) � V� (VARCHAR2(12)), ������������� �������� ABC, 
--� ����� ��� ���� ������������ �������.  
CREATE TABLE C(
  Xc NUMBER(10),
  Vc VARCHAR2(12),
  Xblabla NUMBER(2)
)
CLUSTER ABC(Xc, Vc);

--12--������� ��������� ������� � ������� � �������������� ������� Oracle
SELECT cluster_name, owner, tablespace_name, cluster_type, cache FROM SYS.DBA_CLUSTERS;


--13--������� ������� ��� ������� XXX.� � ����������������� ��� ����������
CREATE SYNONYM TC FOR SPS.C;
SELECT * FROM TC;

--14--��������� ������� ��� ������� XXX.B � ����������������� ��� ����������.
CREATE PUBLIC SYNONYM TB FOR SPS.B;
SELECT * FROM TB;

--15--�������� ��� ������������ ������� A � B (� ��������� � ������� �������), ��������� �� �������, 
--�������� ������������� V1, ���������� �� SELECT... FOR A inner join B. ����������������� ��� �����������������.

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

--16--�� ������ ������ A � B �������� ����������������� ������������� MV, 
--������� ����� ������������� ���������� 2 ������. ����������������� ��� �����������������.

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
