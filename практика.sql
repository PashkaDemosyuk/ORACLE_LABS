SET Serveroutput ON;
CREATE SEQUENCE S1
INCREMENT BY 2
START WITH 500;
DROP SEQUENCE S1;
TRUNCATE TABLE T1;
CREATE TABLE T1(
ID NUMBER);

DECLARE
  N NUMBER := 0;
  P_ID NUMBER;
BEGIN
  WHILE(N < 10)
  LOOP
    SELECT S1.NEXTVAL INTO P_ID FROM DUAL;
    INSERT INTO T1 VALUES(P_ID);
    N := N + 1;
  END LOOP;
END;

SELECT * FROM T1 WHERE ID > 51;
SELECT * FROM T1;

OPEN curs_subject;
DBMS_OUTPUT.PUT_LINE('rowCount = '||curs_subject%rowcount);
WHILE curs_subject%found
LOOP
  FETCH curs_subject INTO rec_subject;
  DBMS_OUTPUT.PUT_LINE(' '||rec_subject.SUBJECT||' '||rec_subject.SUBJECT_NAME||' '||rec_subject.PULPIT||' '||rec_subject.PULPIT_NAME);
END LOOP;
CLOSE curs_subject;
SELECT * FROM T1; 
 
CREATE OR REPLACE PROCEDURE AUDITORIUMS(P_CAPACITY NUMBER) IS
  not_positive_arg exception;
  not_found_capacity_value exception;
  auditorium_row T1%ROWTYPE;
  select_cursor sys_refcursor;
BEGIN
  IF P_CAPACITY < 0 THEN
    RAISE not_positive_arg;
  END IF;
  IF P_CAPACITY IS NULL THEN
    RAISE not_found_capacity_value;
  END IF;
  IF(P_CAPACITY < 20) THEN
    DBMS_OUTPUT.PUT_LINE('P_CAPACITY < 20');
    OPEN select_cursor FOR SELECT * FROM T1 WHERE ID < 20;
  ELSIF(P_CAPACITY BETWEEN 20 AND 50) THEN
      DBMS_OUTPUT.PUT_LINE('P_CAPACITY BETWEEN 20 AND 50');
     OPEN select_cursor FOR SELECT * FROM T1 WHERE ID BETWEEN 20 AND 50;
  ELSIF(P_CAPACITY > 51) THEN
      DBMS_OUTPUT.PUT_LINE('P_CAPACITY > 51');
      OPEN select_cursor FOR SELECT * FROM T1 WHERE ID > 51;
  END IF;
  FETCH select_cursor INTO auditorium_row;
  WHILE select_cursor%found
  LOOP
    DBMS_OUTPUT.PUT_LINE(' '||auditorium_row.ID||' ');
    FETCH select_cursor INTO auditorium_row;
  END LOOP;
  CLOSE select_cursor;
  EXCEPTION
  WHEN not_positive_arg THEN
    DBMS_OUTPUT.PUT_LINE('not_positive_arg');
  WHEN not_found_capacity_value THEN
    DBMS_OUTPUT.PUT_LINE('not_found_capacity_value');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('others errors');
END;

BEGIN
  AUDITORIUMS(20);
END;

CREATE TABLE FACULCIES(
  ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  NAME NVARCHAR2(10)
);

CREATE TABLE PULPITS(
  ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  NAME NVARCHAR2(50),
  FACULCY_ID NUMBER,
  FOREIGN KEY(FACULCY_ID) REFERENCES FACULCIES(ID)
);

CREATE TABLE TEACHERS(
  ID NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,
  NAME NVARCHAR2(50) NOT NULL,
  PULPIT_ID NUMBER,
  FOREIGN KEY(PULPIT_ID) REFERENCES PULPITS(ID)
);

INSERT INTO FACULCIES(NAME) VALUES('OEO');
INSERT INTO FACULCIES(NAME) VALUES('OIA');
INSERT INTO FACULCIES(NAME) VALUES('OOeO');
INSERT INTO FACULCIES(NAME) VALUES('EANOIC');


INSERT INTO PULPITS(NAME, FACULCY_ID) VALUES('ENEO', 1);
INSERT INTO PULPITS(NAME, FACULCY_ID) VALUES('IIEO', 1);
INSERT INTO PULPITS(NAME, FACULCY_ID) VALUES('AYAE', 1);
INSERT INTO PULPITS(NAME, FACULCY_ID) VALUES('PUL1', 2);
INSERT INTO PULPITS(NAME, FACULCY_ID) VALUES('PUL2', 2);


INSERT INTO TEACHERS(NAME, PULPIT_ID) VALUES('TEACHER1', 1);
INSERT INTO TEACHERS(NAME, PULPIT_ID) VALUES('TEACHER2', 1);
INSERT INTO TEACHERS(NAME, PULPIT_ID) VALUES('TEACHER3', 2);
INSERT INTO TEACHERS(NAME, PULPIT_ID) VALUES('TEACHER4', 2);
INSERT INTO TEACHERS(NAME, PULPIT_ID) VALUES('TEACHER5', 2);

CREATE OR REPLACE FUNCTION TEACHERS_COUNT(FACULCY FACULCIES.NAME%TYPE)
  RETURN NUMBER IS TEACHER_COUNT NUMBER := 0;
  IN_FACULCY FACULCIES.NAME%TYPE;
  no_faculcy_param EXCEPTION;
  no_such_faculcy EXCEPTION;
  TEACHERS_COUNT_CUR sys_refcursor;
  FACULCY_COUNT NUMBER;
  TYPE TEACHERS_COUNT IS RECORD(
    TEACHERS_COUNT NUMBER,
    PULPIT_NAME PULPITS.NAME%TYPE
  );
  RESULTS_STRUCTURE TEACHERS_COUNT;
BEGIN
  IF FACULCY IS NULL THEN
    raise no_faculcy_param;
  END IF;
  SELECT COUNT(*) INTO FACULCY_COUNT FROM FACULCIES WHERE NAME = FACULCY;
  IF(FACULCY_COUNT = 0) THEN
    RAISE no_such_faculcy;
  END IF;
  OPEN TEACHERS_COUNT_CUR FOR
    SELECT DISTINCT COUNT(T.ID), P.NAME  FROM TEACHERS T
      RIGHT OUTER JOIN PULPITS P ON T.PULPIT_ID = P.ID
      INNER JOIN FACULCIES F ON P.FACULCY_ID = F.ID
      WHERE F.NAME LIKE FACULCY
      GROUP BY P.NAME;
      
  FETCH TEACHERS_COUNT_CUR INTO RESULTS_STRUCTURE;
  WHILE TEACHERS_COUNT_CUR%FOUND
    LOOP
      DBMS_OUTPUT.PUT_LINE(' '||RESULTS_STRUCTURE.TEACHERS_COUNT||' - '||RESULTS_STRUCTURE.PULPIT_NAME);
      FETCH TEACHERS_COUNT_CUR INTO RESULTS_STRUCTURE;
    END LOOP;
  RETURN FACULCY_COUNT;
  EXCEPTION
  WHEN no_faculcy_param THEN
    DBMS_OUTPUT.PUT_LINE('no_faculcy_param');
  WHEN no_such_faculcy THEN
    DBMS_OUTPUT.PUT_LINE('no_faculcy_param');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(TEACHERS_COUNT('OEO'));
END;