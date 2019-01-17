set serveroutput on ; 
GRANT CREATE ANY TRIGGER TO U2_DPA_PDB; 
--1. �������� �������, ������� ��������� ���������, ���� �� ������� ��������� ����. 

CREATE TABLE T15( 
row1 NUMBER(10) NOT NULL, 
row2 VARCHAR2(10), 
CONSTRAINT PK_row1 PRIMARY KEY(row1) 
); 

--2. ��������� ������� �������� (10 ��.). 
INSERT INTO T15 (row1, row2) VALUES (1,'qwe1'); 
INSERT INTO T15 (row1, row2) VALUES (2,'qwe2'); 
INSERT INTO T15 (row1, row2) VALUES (3,'qwe3'); 
INSERT INTO T15 (row1, row2) VALUES (4,'qwe4'); 
INSERT INTO T15 (row1, row2) VALUES (5,'qwe5'); 
INSERT INTO T15 (row1, row2) VALUES (6,'qwe6'); 
INSERT INTO T15 (row1, row2) VALUES (7,'qwe7'); 
INSERT INTO T15 (row1, row2) VALUES (8,'qwe8'); 
INSERT INTO T15 (row1, row2) VALUES (91,'qwe9'); 
INSERT INTO T15 (row1, row2) VALUES (10,'qwe10'); 

SELECT * FROM T15; 

--3. �������� BEFORE � ������� ������ ��������� �� ������� INSERT, DELETE � UPDATE 
--4. ���� � ��� ����������� �������� ������ �������� ��������� �� ��������� ������� (DMS_OUTPUT) �� ����� ����������� ������. 
CREATE OR REPLACE TRIGGER TR_BEFORE_INS_UPD_DEL 
BEFORE INSERT OR UPDATE OR DELETE ON T15 
BEGIN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL'); 
END; 

INSERT INTO T15 (row1, row2) VALUES (11,'qwe11'); 
INSERT INTO T15 (row1, row2) VALUES (12,'qwe12'); 

UPDATE T15 SET ROW2 = 'QWE' WHERE ROW1=11 OR ROW1=12; 
SELECT *FROM T15; 

--5. �������� BEFORE-������� ������ ������ �� ������� INSERT, DELETE � UPDATE. 
--6. ��������� ��������� INSERTING, UPDATING � DELETING. 
CREATE OR REPLACE TRIGGER TR_BEFORE_INS_UPD_DEL_ROW 
BEFORE INSERT OR UPDATE OR DELETE ON T15 
FOR EACH ROW 
BEGIN 
IF INSERTING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW INSERTING'); 
ELSIF UPDATING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW UPDATING'); 
ELSIF DELETING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW DELETING'); 
END IF; 
END; 

UPDATE T15 SET ROW2='qwe_UP' WHERE ROW1>10 and ROW1<15; 

INSERT INTO T15 (row1, row2) VALUES (13,'qwe13'); 
INSERT INTO T15 (row1, row2) VALUES (14,'qwe14'); 

--7. ������������ AFTER-�������� ������ ��������� �� ������� INSERT, DELETE � UPDATE. 
CREATE OR REPLACE TRIGGER TR_AFTER_INS_UPD_DEL 
AFTER INSERT OR UPDATE OR DELETE ON T15 
BEGIN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL'); 
END; 

INSERT INTO T15 (row1, row2) VALUES (15,'qwe15'); 

--8. ������������ AFTER-�������� ������ ������ �� ������� INSERT, DELETE � UPDATE. 
CREATE OR REPLACE TRIGGER TR_AFTER_INS_UPD_DEL_ROW 
AFTER INSERT OR UPDATE OR DELETE ON T15 
FOR EACH ROW 
BEGIN 
IF INSERTING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW INSERTING'); 
ELSIF UPDATING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW UPDATING'); 
ELSIF DELETING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW DELETING'); 
END IF; 
END; 

INSERT INTO T15 (row1, row2) VALUES (16,'qwe16'); 



--9. �������� ������� � ������ AUDIT. ������� ������ ��������� ����: 
--OperationDate, 
--OperationType (�������� �������, ���������� � ��������), 
--TriggerName(��� ��������), 
--Data (������ � ���������� ����� �� � ����� ��������). 

CREATE TABLE "AUDIT"( 
OperationDate DATE, 
OperationType VARCHAR2(20), 
TriggerName VARCHAR2(50), 
Data VARCHAR2(200) 
); 

--10. �������� �������� ����� �������, ����� ��� �������������� ��� �������� � �������� �������� � ������� AUDIT. 
CREATE OR REPLACE TRIGGER TR_BEFORE_INS_UPD_DEL_ROW 
BEFORE INSERT OR UPDATE OR DELETE ON T15 
FOR EACH ROW 
BEGIN 
IF INSERTING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW INSERTING'); 
INSERT INTO "AUDIT" VALUES(sysdate,'inserting','beforetrigger','old: '||to_char(:old.row2)||' new: '|| to_char(:new.row2)); 
ELSIF UPDATING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW UPDATING'); 
INSERT INTO "AUDIT" VALUES(sysdate,'updating','beforetrigger','old: '||to_char(:old.row2)||' new: '|| to_char(:new.row2)); 
ELSIF DELETING THEN 
DBMS_OUTPUT.PUT_LINE('TR_BEFORE_INS_UPD_DEL_ROW DELETING'); 
INSERT INTO "AUDIT"
 
VALUES(sysdate,'deleting','beforetrigger','old: '||to_char(:old.row2)||' new: '|| to_char(:new.row2)); 
END IF; 
END; 

CREATE OR REPLACE TRIGGER TR_AFTER_INS_UPD_DEL_ROW 
AFTER INSERT OR UPDATE OR DELETE ON T15 
FOR EACH ROW 
BEGIN 
IF INSERTING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW INSERTING'); 
INSERT INTO "AUDIT" VALUES(sysdate,'inserting','aftertrigger','old: '||to_char(:old.row2) ||' new: '|| to_char(:new.row2) ); 
ELSIF UPDATING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW UPDATING'); 
INSERT INTO "AUDIT" VALUES(sysdate,'updating','aftertrigger','old: '||to_char(:old.row2)||' new: '|| to_char(:new.row2)); 
ELSIF DELETING THEN 
DBMS_OUTPUT.PUT_LINE('TR_AFTER_INS_UPD_DEL_ROW DELETING'); 
INSERT INTO "AUDIT" VALUES(sysdate,'deleting','aftertrigger','old: '||to_char(:old.row2)||' new: '|| to_char(:new.row2)); 
END IF; 
END; 

UPDATE T15 SET ROW2='qwe_UP' WHERE ROW1>10 and ROW1<15; 

INSERT INTO T15 (row1, row2) VALUES (18,'qwe18'); 

SELECT * FROM "AUDIT"; 
SELECT * FROM T15; 

--11. ��������� ��������, ���������� ����������� ������� �� ���������� �����. 
--��������, ��������������� �� ������� ��� �������. ��������� ���������. 
INSERT INTO T15 (row1, row2) VALUES (1,'qwe1'); 

--12. ������� (drop) �������� �������. ��������� ���������. �������� �������, ����������� �������� �������� �������. 
DROP TABLE T15; 
FLASHBACK TABLE T15 TO BEFORE DROP; 
SELECT * FROM T15; 

CREATE OR REPLACE TRIGGER DDL_TR 
BEFORE ddl ON SCHEMA 
BEGIN 
DBMS_OUTPUT.PUT_LINE('BEFORE ddl'); 
IF(ora_sysevent='DROP' AND ORA_DICT_OBJ_NAME = 'T15' ) THEN
RAISE_APPLICATION_ERROR(-20000, 'Do not drop table'); 
END IF; 
END; 

--13. ������� (drop) ������� AUDIT. ����������� ��������� ��������� � ������� SQL-DEVELOPER. ��������� ���������. �������� ��������. 

DROP TABLE "AUDIT"; 
SELECT * FROM USER_TRIGGERS; 

SELECT * FROM T15; 
--14. �������� ������������� ��� �������� ��������. ������������ INSTEADOF INSERT-�������. ������� ������ ��������� ������ � �������. 

CREATE VIEW T15_VIEW AS 
SELECT * FROM T15; 

CREATE OR REPLACE TRIGGER TR_VIEW 
INSTEAD OF INSERT ON T15_VIEW 
FOR EACH ROW 
BEGIN 
DBMS_OUTPUT.PUT_LINE(to_char(:new.row1)); 
INSERT INTO T15 VALUES(:new.row1,:new.row2); 
END TR_VIEW; 

INSERT INTO T15_VIEW VALUES (39,'WE'); 

select * from T15; 
--15. �����������������, � ����� ������� ����������� ��������.
alter trigger DDL_TR disable;