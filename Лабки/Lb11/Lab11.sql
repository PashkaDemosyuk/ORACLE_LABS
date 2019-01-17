INSERT INTO FACULTY (FACULTY_NAME) values('FIT');
INSERT INTO FACULTY (FACULTY_NAME) values('ÕÒèÒ');
 
DELETE  FACULTY
WHERE FACULTY_NAME LIKE 'FIT';
DELETE  FACULTY
WHERE FACULTY_NAME LIKE 'ÕÒèÒ';
--with FIT
DECLARE
  faculty_rec FACULTY%rowtype;
  BEGIN
    SELECT * INTO faculty_rec FROM FACULTY;
    DBMS_OUTPUT.PUT_LINE(faculty_rec.FACULTY_NAME);
END;

-- with a few rows/without any
DECLARE
  faculty_rec FACULTY.FACULTY_NAME%type;
  BEGIN
    SELECT FACULTY_NAME INTO faculty_rec FROM FACULTY;
    DBMS_OUTPUT.PUT_LINE(faculty_rec.FACULTY_NAME);
  EXCEPTION
    WHEN too_many_rows THEN
    DBMS_OUTPUT.PUT_LINE('There are too many rows in result of request - '||sqlcode);
    WHEN no_data_found THEN
    DBMS_OUTPUT.PUT_LINE('There are no data in result of request - '||sqlcode);
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(sqlerrm||sqlcode);
END;

INSERT INTO AUDITORIUM_TYPE(AUDITORIUM_TYPENAME) VALUES('LB');
INSERT INTO AUDITORIUM_TYPE(AUDITORIUM_TYPENAME) VALUES('LK');



--INSERT
DECLARE
  auditorium_cur U2_DPA_PDB.auditorium%rowtype;
  isFounded BOOLEAN;
  isOpened BOOLEAN;
  rowCount PLS_INTEGER;
BEGIN
  INSERT INTO AUDITORIUM (AUDITORIUM_NAME, AUDIRORIUM_CAPACITY, AUDITORIUM_TYPE)
                        values('309a-1', 25, 1);
  isFounded :=sql%found;
  isOpened := sql%isopen;
  rowCount := sql%rowcount;
  IF isFounded THEN
    DBMS_OUTPUT.PUT_LINE('FOUNDED');
  END IF ;
  IF isOpened THEN
    DBMS_OUTPUT.PUT_LINE('OPENED');
  END IF ;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||rowCount);
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;

--UPDATE
DECLARE
  auditorium_cur U2_DPA_PDB.auditorium%rowtype;
  isFounded BOOLEAN;
  isOpened BOOLEAN;
  rowCount PLS_INTEGER;
BEGIN
  UPDATE AUDITORIUM SET AUDITORIUM_NAME = '309-1'
                    WHERE AUDITORIUM_NAME='309a-1';
  isFounded :=sql%found;
  isOpened := sql%isopen;
  rowCount := sql%rowcount;
  IF isFounded THEN
    DBMS_OUTPUT.PUT_LINE('FOUNDED');
  END IF ;
  IF isOpened THEN
    DBMS_OUTPUT.PUT_LINE('OPENED');
  END IF ;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||rowCount);
  COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;

--DELETE
DECLARE
  auditorium_cur U2_DPA_PDB.auditorium%rowtype;
  a_name U2_DPA_PDB.auditorium.AUDITORIUM_NAME%type;
  isFounded BOOLEAN;
  isOpened BOOLEAN;
  rowCount PLS_INTEGER;
  fk_exc EXCEPTION;
  PRAGMA EXCEPTION_INIT(fk_exc, -8888);
BEGIN
  DELETE  AUDITORIUM WHERE AUDITORIUM_NAME='309-1'
  RETURNING AUDITORIUM_NAME
  INTO a_name;
  DBMS_OUTPUT.PUT_LINE('DELETED AUDITORIUM`s NAME - '||a_name);
  isFounded :=sql%found;
  isOpened := sql%isopen;
  rowCount := sql%rowcount;
  IF isFounded THEN
    DBMS_OUTPUT.PUT_LINE('FOUNDED');
  END IF ;
  IF isOpened THEN
    DBMS_OUTPUT.PUT_LINE('OPENED');
  END IF ;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||rowCount);
  COMMIT;
  EXCEPTION
  WHEN fk_exc THEN
    DBMS_OUTPUT.PUT_LINE('myException');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
    ROLLBACK;
END;


DECLARE
  CURSOR curs_subject IS SELECT TEACHER, TEACHER_NAME, PULPIT, PULPIT_NAME
                                                          FROM TEACHER;
  t_teacher U2_DPA_PDB.TEACHER.TEACHER%type;
  t_teacherName U2_DPA_PDB.TEACHER.TEACHER_NAME%type;
  t_pulpit U2_DPA_PDB.TEACHER.PULPIT%type;
  t_pulpitName U2_DPA_PDB.TEACHER.PULPIT_NAME%type;
BEGIN
  OPEN curs_subject;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||curs_subject%rowcount);
  LOOP
    FETCH curs_subject INTO t_teacher, t_teacherName, t_pulpit, t_pulpitName;
    EXIT WHEN curs_subject%notfound;
    DBMS_OUTPUT.PUT_LINE(' '||t_teacher||' '||t_teacherName||' '||t_pulpit||' '||t_pulpitName);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||curs_subject%rowcount);
  CLOSE curs_subject;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;

DECLARE
  CURSOR curs_subject IS SELECT SUBJECT, SUBJECT_NAME, PULPIT, PULPIT_NAME
                                                          FROM SUBJECT;
  rec_subject U2_DPA_PDB.SUBJECT%rowtype;
BEGIN
  OPEN curs_subject;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||curs_subject%rowcount);
  WHILE curs_subject%found
  LOOP
    FETCH curs_subject INTO rec_subject;
    DBMS_OUTPUT.PUT_LINE(' '||rec_subject.SUBJECT||' '||rec_subject.SUBJECT_NAME||' '||rec_subject.PULPIT||' '||rec_subject.PULPIT_NAME);
  END LOOP;
  CLOSE curs_subject;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


DECLARE
  CURSOR curs_subject IS SELECT P.PULPIT_NAME, T.TEACHER_NAME, S.SUBJECT_NAME
    FROM PULPIT P INNER JOIN TEACHER T ON P.PULPIT = T.PULPIT
                INNER JOIN SUBJECT S ON P.PULPIT = S.PULPIT;
  p_pulpit U2_DPA_PDB.PULPIT.PULPIT_NAME%type;
  t_teacherName U2_DPA_PDB.TEACHER.TEACHER_NAME%type;
  s_subjectName U2_DPA_PDB.SUBJECT.SUBJECT_NAME%type;
BEGIN
  OPEN curs_subject;
  DBMS_OUTPUT.PUT_LINE('rowCount = '||curs_subject%rowcount);
  FOR curs_obj IN curs_subject
  LOOP
    FETCH curs_subject INTO p_pulpit, t_teacherName, s_subjectName;
    DBMS_OUTPUT.PUT_LINE(' '||p_pulpit||' '||t_teacherName||' '||s_subjectName);
  END LOOP;
  CLOSE curs_subject;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;


VARIABLE x REFCURSOR;
DECLARE
  TYPE audit_type is ref cursor return AUDITORIUM_TYPE%rowtype;
  xcurs audit_type;
  rec_tlesson AUDITORIUM_TYPE%rowtype;
BEGIN
  OPEN xcurs FOR SELECT * FROM U2_DPA_PDB.AUDITORIUM_TYPE;
  :x := xcurs;
  EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;
print x;

DECLARE
  CURSOR cur_subject IS SELECT AT.AUDITORIUM_TYPE,
          CURSOR(
          SELECT A.AUDITORIUM_NAME, A.AUDIRORIUM_CAPACITY
          FROM AUDITORIUM A
          WHERE A.AUDITORIUM_TYPE = AT.AUDITORIUM_TYPE)
          FROM AUDITORIUM_TYPE AT;
  aud_cursor SYS_REFCURSOR;
  a_type AUDITORIUM_TYPE.AUDITORIUM_TYPENAME%type;
  a_name AUDITORIUM.AUDITORIUM_NAME%type;
  a_capacity AUDITORIUM.AUDIRORIUM_CAPACITY%type;
  message VARCHAR2(1000);
BEGIN
  OPEN cur_subject;
  FETCH cur_subject INTO a_type, aud_cursor;
  WHILE cur_subject%found
  LOOP
    message:=' '||a_type||': ';
    WHILE aud_cursor%found
    LOOP
      FETCH aud_cursor INTO a_name, a_capacity;
      message:=' '||' '||a_name||' '||a_capacity||';';
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(message);
    FETCH cur_subject INTO a_type, aud_cursor;
  END LOOP;
  CLOSE cur_subject;
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;

SELECT rtrim(AUDITORIUM_NAME), rowid,
        substr(rowid, 1, 7) "ñåãìåíò",
        substr(rowid, 8, 3) "¹ ôàéëà",
        substr(rowid, 11, 6) "¹ áëîêà",
        substr(rowid, 16, 3) "¹ ñòðîêè"
FROM AUDITORIUM;
SELECT AUDITORIUM_CAPACITY FROM AUDITORIUM;
DECLARE
  CURSOR curs_auditorium(minCapacity AUDITORIUM.AUDITORIUM_CAPACITY%type, maxCapacity AUDITORIUM.AUDITORIUM_CAPACITY%type)
    IS SELECT AUDITORIUM_NAME, AUDITORIUM_CAPACITY
    FROM AUDITORIUM
    WHERE AUDITORIUM_CAPACITY >= minCapacity AND AUDITORIUM_CAPACITY <=maxCapacity FOR UPDATE;
  a_name U2_DPA_PDB.AUDITORIUM.AUDITORIUM_NAME%type;
  a_capacity AUDITORIUM.AUDIRORIUM_CAPACITY%type;
BEGIN
  OPEN curs_auditorium(40, 80);
  FETCH curs_auditorium into a_name, a_capacity;
  WHILE(curs_auditorium%found)
  LOOP
    a_capacity:=a_capacity*1.1;
    UPDATE AUDITORIUM
    SET AUDITORIUM_CAPACITY = a_capacity
    WHERE CURRENT OF curs_auditorium;
  END LOOP;
  CLOSE curs_auditorium;
  EXCEPTION
  WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;



INSERT INTO FACULTY (FACULTY_NAME) values('FIT');
INSERT INTO FACULTY (FACULTY_NAME) values ('ÕÒèÒ');
INSERT INTO FACULTY (FACULTY_NAME) values ('ÒÎÂ');

SELECT * FROM FACULTY;

INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DD1', 21);
INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DD2', 21);
INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DD3', 21);
INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DF4', 22);
INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DD6', 22);
INSERT INTO PULPIT (PULPIT_NAME, FACULTY) values('DD5', 23);


SELECT * FROM PULPIT;

INSERT INTO TEACHER (TEACHER_NAME, PULPIT, PULPIT_NAME) values('DDD1', 8, 'DD1');
INSERT INTO TEACHER (TEACHER_NAME, PULPIT, PULPIT_NAME) values('DDD2', 9, 'DD2');
INSERT INTO TEACHER (TEACHER_NAME, PULPIT, PULPIT_NAME) values('DDD3', 13, 'DD5');
INSERT INTO TEACHER (TEACHER_NAME, PULPIT, PULPIT_NAME) values('DDD4', 8, 'DD1');

DECLARE
  CURSOR curs_audit(n NUMBER)
      IS SELECT n, TEACHER, TEACHER_NAME
      FROM TEACHER;
  mCol NUMBER:=0;
BEGIN
  FOR teacher IN curs_audit(10)
  LOOP
    IF mCol mod 3 = 0 THEN
      DBMS_OUTPUT.PUT_LINE('-----------');
    END IF;
    DBMS_OUTPUT.PUT_LINE(' '||teacher.n||' '||teacher.TEACHER||' '||teacher.TEACHER_NAME||' ');
    mCol:=mCol+1;
  END LOOP;
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(sqlerrm);
END;


