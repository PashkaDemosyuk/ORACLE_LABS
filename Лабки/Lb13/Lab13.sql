SET serveroutput ON;

DECLARE
  PROCEDURE GET_TEACHERS (PCODE TEACHER.PULPIT%TYPE) IS
    CURSOR my_curs IS SELECT TEACHER_NAME, TEACHER FROM TEACHER WHERE PULPIT = PCODE;
    t_name TEACHER.TEACHER_NAME%type;
    t_code TEACHER.TEACHER%type;
  BEGIN
    OPEN my_curs;
    LOOP
      DBMS_OUTPUT.PUT_LINE(t_code||' '||t_name);
      FETCH my_curs INTO t_name, t_code;
      EXIT WHEN my_curs%notfound;
    END LOOP;
    CLOSE my_curs;
  END GET_TEACHERS;
BEGIN
GET_TEACHERS(13);
END;

DECLARE
  PCODE TEACHER.PULPIT%type;
BEGIN
  PCODE := 13;
  GET_TEACHERS(PCODE);
 -- GET_TEACHERS(PCODE);
END;

DECLARE
  FUNCTION GET_NUM_TEACHERS(PCODE TEACHER.PULPIT%TYPE)
    RETURN NUMBER IS
      tCount NUMBER;
  BEGIN
    SELECT COUNT(*) INTO tCount FROM TEACHER WHERE PULPIT = PCODE;
    RETURN tCount;
    EXCEPTION
      WHEN OTHERS THEN
      return -1;
  END GET_NUM_TEACHERS;
BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS(8));
END;

CREATE OR REPLACE PROCEDURE GET_TEACHERS(FCODE FACULTY.FACULTY_N%TYPE) IS
  CURSOR my_curs IS
    SELECT T.TEACHER_NAME, T.TEACHER, P.FACULTY
    FROM TEACHER T
    INNER JOIN PULPIT P
    ON T.PULPIT = P.PULPIT
    WHERE P.FACULTY = FCODE;
  t_name TEACHER.TEACHER_NAME%type;
  t_code TEACHER.TEACHER%type;
  t_faculty PULPIT.FACULTY%type;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(t_name||' '||t_code||' '||t_faculty);
    FETCH my_curs INTO t_name, t_code, t_faculty;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

SELECT * FROM FACULTY;
BEGIN
GET_TEACHERS(22);
END;

CREATE OR REPLACE PROCEDURE GET_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE) IS
  CURSOR my_curs IS
      SELECT SUBJECT, SUBJECT_NAME, S.PULPIT
        FROM SUBJECT S
        WHERE S.PULPIT = PCODE;
  s_subject SUBJECT.SUBJECT%TYPE;
  s_subject_name SUBJECT.SUBJECT_NAME%TYPE;
  s_pulpit SUBJECT.PULPIT%TYPE;
BEGIN
  OPEN my_curs;
  LOOP
    DBMS_OUTPUT.PUT_LINE(s_subject||' '||s_subject_name||' '||s_pulpit);
    FETCH my_curs INTO s_subject, s_subject_name, s_pulpit;
    EXIT WHEN my_curs%notfound;
  END LOOP;
  CLOSE my_curs;
END;

BEGIN
  GET_SUBJECTS(1);
END;

CREATE OR REPLACE FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY_N%TYPE)
  RETURN NUMBER IS
    tCount NUMBER;
BEGIN
  SELECT COUNT(*) INTO tCount FROM TEACHER T
  INNER JOIN PULPIT P
  ON T.PULPIT = T.PULPIT
  WHERE P.FACULTY = FCODE;
    RETURN tCount;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN -1;
END;
SELECT * FROM TEACHER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_TEACHERS(21));
END;

CREATE OR REPLACE FUNCTION GET_NUM_SUBJECTS (PCODE SUBJECT.PULPIT%TYPE)
  RETURN NUMBER IS
    tCount NUMBER:=0;
BEGIN
    SELECT COUNT(*) INTO tCount
      FROM SUBJECT
      WHERE SUBJECT.PULPIT = PCODE;
    RETURN tCount;
    EXCEPTION
      WHEN OTHERS THEN
      tCount := -1;
      RETURN tCount;
END;

BEGIN
  DBMS_OUTPUT.PUT_LINE(GET_NUM_SUBJECTS(1));
END;

CREATE OR REPLACE
PACKAGE TEACHERS AS
  TYPE TEACHER_REC IS RECORD
  (
    FCODE FACULTY.FACULTY_N%TYPE,
    PCODE SUBJECT.PULPIT%TYPE
  );
  EXC_GET_NUM_TEACHERS EXCEPTION;
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY_N%TYPE) RETURN NUMBER;
END TEACHERS;

CREATE OR REPLACE PACKAGE BODY TEACHERS AS
  FUNCTION GET_NUM_TEACHERS(FCODE FACULTY.FACULTY_N%TYPE) RETURN NUMBER
    IS
        tCount NUMBER;
    BEGIN
      SELECT COUNT(*) INTO tCount FROM TEACHER T
      INNER JOIN PULPIT P
      ON T.PULPIT = T.PULPIT
      WHERE P.FACULTY = FCODE;
        RETURN tCount;
      EXCEPTION
        WHEN OTHERS THEN RAISE EXC_GET_NUM_TEACHERS;
      END GET_NUM_TEACHERS;
END TEACHERS;
  
DECLARE
  rec TEACHERS.TEACHER_REC;
BEGIN
  rec.FCODE := 21;
  rec.PCODE := 8;
  DBMS_OUTPUT.PUT_LINE(TEACHERS.GET_NUM_TEACHERS(rec.FCODE));
  EXCEPTION
    WHEN TEACHERS.EXC_GET_NUM_TEACHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error in TEACHERS.GET_NUM_TEACHERS'||' '||sqlcode);
END;
  