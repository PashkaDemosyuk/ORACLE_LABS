select * from inputtable; 
select * from outputtable; 
select * from helpertable; 

delete from inputtable; 
delete from outputtable; 
delete from helpertable; 

select * from v$parameter where upper (name)='JOB_QUEUE_PROCESSES';

create table helpertable 
( 
datetime date, 
info nvarchar2(10), 
timeinfo timestamp 
); 
create table inputtable 
( 
id INTEGER generated by default as identity, 
name varchar(100) 
); 
create table outputtable 
( 
id INTEGER generated by default as identity, 
name varchar(100) 
); 

drop table helpertable; 
drop table outputtable; 
drop table inputtable; 

declare 
i number := 1; 
temp varchar(100); 
begin 
loop 
temp := CONCAT('Value ', to_char(i)); 
insert into inputtable (name) values (temp); 
i := i + 1; 
exit when i > 10; 
end loop; 
end; 

select * from inputtable; 
select * from outputtable; 
select * from helpertable; 


CREATE OR REPLACE PACKAGE CHNPKG as 
PROCEDURE MOVEHELPER (id_id inputtable.id%type); 
PROCEDURE STARTMOVE; 
procedure stop; 
procedure restart; 
procedure delete; 
function isjob return boolean; 
END CHNPKG; 

CREATE OR REPLACE PACKAGE BODY CHNPKG as 
PROCEDURE MOVEHELPER (id_id inputtable.id%type) as 
cursor curs(idd inputtable.id%type) 
is select * from inputtable where id<idd; 
temp inputtable%rowtype; 
begin 
for temp in curs(id_id) 
loop 
insert into outputtable (id, name) values (temp.id, temp.name); 
delete from inputtable where rownum = 1; 
DBMS_OUTPUT.PUT_LINE('Done'); 
insert into helpertable(datetime, info, timeinfo) 
values (sysdate, 'GOOD', current_timestamp); 
end loop; 
exception when others then 
insert into helpertable(datetime, info, timeinfo) 
values (sysdate, 'ERROR', current_timestamp); 
end MOVEHELPER; 

PROCEDURE STARTMOVE is 
begin 
dbms_job.ISUBMIT( 
job => 1, 
what => 'begin MOVEHELPER(15); end;', 
next_date => sysdate, 
interval => 'sysdate + 7' 
); 
commit; 
dbms_output.put_line('startmove'); 
exception when others then 
dbms_output.put_line(sqlerrm); 
end startmove; 

FUNCTION ISJOB RETURN BOOLEAN 
IS 
temp nvarchar2(10) := 'false'; 
BEGIN 
SELECT 'true' INTO temp FROM DUAL WHERE EXISTS(SELECT * FROM USER_JOBS WHERE JOB=1 AND BROKEN='N'); 
if temp = 'true' then return true; 
else return false; 
end if; 
EXCEPTION WHEN OTHERS 
THEN RETURN FALSE; 
END isjob; 

PROCEDURE stop 
IS 
BEGIN 
DBMS_JOB.BROKEN(1, TRUE); 
COMMIT; 
END; 

PROCEDURE restart 
as 
BEGIN 
DBMS_JOB.RUN(1); 
END; 

procedure delete 
as 
begin 
dbms_job.remove(1); 
end; 
END CHNPKG; 



cREATE OR replace PROCEDURE MOVEHELPER (id_id inputtable.id%type) as 
cursor curs(idd inputtable.id%type) 
is select * from inputtable where id<idd; 
temp inputtable%rowtype; 
begin 
DBMS_OUTPUT.PUT_LINE('Done1'); 
for temp in curs(id_id) 
loop 
insert into outputtable (id, name) values (temp.id, temp.name); 
delete from inputtable where rownum = 1; 
DBMS_OUTPUT.PUT_LINE('Done2'); 
insert into helpertable(datetime, info, timeinfo) 
values (sysdate, 'GOOD', current_timestamp); 
end loop; 
DBMS_OUTPUT.PUT_LINE('Done3'); 
exception when others then 
insert into helpertable(datetime, info, timeinfo) 
values (sysdate, 'ERROR', current_timestamp); 
end MOVEHELPER;






select * from dba_scheduler_global_attribute 



EXEC DBMS_JOB.BROKEN(1,false); 
exec dbms_job.remove(1); 

BEGIN CHNPKG.STARTMOVE; END; 

select * from inputtable; 
select * from outputtable; 
select * from helpertable; 

exec chnpkg.movehelper(6); 
select * from user_jobs; 

SELECT last_date, last_sec, next_date, next_sec, broken, failures, total_time FROM dba_jobs WHERE job = 1; 



declare 
temp boolean; 
begin 
temp := CHNPKG.isjob; 
if temp = true then 
dbms_output.put_line('true'); 
else 
dbms_output.put_line('false'); 
end if; 
end; 

begin 
chnpkg.stop; 
end; 

begin 
chnpkg.restart; 
end; 

begin 
chnpkg.delete; 
end; 

------------------------------------------------------------------------------� 

CREATE OR REPLACE PACKAGE CHNPKG2 as 
PROCEDURE MOVEHELPER; 
PROCEDURE STARTMOVE; 
procedure stop; 
procedure restart; 
procedure delete; 
function isjob return boolean; 
END CHNPKG2; 

CREATE OR REPLACE PACKAGE BODY CHNPKG2 as 
PROCEDURE MOVEHELPER as 
temp inputtable%rowtype; 
begin 
select * into temp from inputtable where rownum = 1; 
insert into outputtable (id, name) values (temp.id, temp.name); 
delete from inputtable where rownum = 1; 
DBMS_OUTPUT.PUT_LINE('Done'); 
insert into helpertable(datetime, info, timeinfo) values (sysdate, 'GOOD', current_timestamp); 
exception when others then 
insert into helpertable(datetime, info, timeinfo) values (sysdate, 'ERROR', current_timestamp); 
end MOVEHELPER; 

PROCEDURE STARTMOVE is 
begin 
DBMS_SCHEDULER.create_job ( 
job_name => 'test_full_job_definition',
job_type => 'PLSQL_BLOCK', 
job_action => 'BEGIN chnpkg2.movehelper; END;', 
start_date => SYSTIMESTAMP, 
repeat_interval => 'freq=MINUTELY;', 
end_date => NULL, 
enabled => TRUE, 
comments => 'Job defined entirely by the CREATE JOB procedure.');
commit; 
dbms_output.put_line('startmove'); 
exception when others then dbms_output.put_line(sqlerrm); 
end startmove; 

PROCEDURE restart 
as 
BEGIN 
DBMS_SCHEDULER.ENABLE('TEST_FULL_JOB_DEFINITION'); 
END restart; 

PROCEDURE stop 
IS 
BEGIN 
DBMS_SCHEDULER.disable('TEST_FULL_JOB_DEFINITION'); 
COMMIT; 
END stop; 

procedure delete 
as 
begin 
SYS.DBMS_SCHEDULER.DROP_JOB (job_name => 'TEST_FULL_JOB_DEFINITION'); 
end delete; 

FUNCTION ISJOB RETURN BOOLEAN 
IS 
temp nvarchar2(10) := 'false'; 
BEGIN 
SELECT 'true' INTO temp 
FROM DUAL 
WHERE EXISTS 
(SELECT * FROM all_scheduler_jobs 
where job_name = 'TEST_FULL_JOB_DEFINITION'); 
if temp = 'true' then 
return true; 
else 
return false; 
end if; 
EXCEPTION WHEN OTHERS THEN 
RETURN FALSE; 
END isjob; 

END CHNPKG2; 


SELECT owner, job_name, comments FROM dba_scheduler_jobs 
where job_name = 'TEST_FULL_JOB_DEFINITION'; 


SELECT * FROM dba_scheduler_jobs 
where job_name = 'TEST_FULL_JOB_DEFINITION'; 

begin 
chnpkg2.startmove; 
end; 

begin 
chnpkg2.restart; 
end; 

begin 
chnpkg2.stop; 
end; 

begin 
chnpkg2.delete; 
end; 

select * from inputtable; 
select * from outputtable; 
select * from helpertable; 


declare 
temp boolean; 
begin 
temp := CHNPKG2.isjob; 
if temp = true then 
dbms_output.put_line('true'); 
else 
dbms_output.put_line('false'); 
end if; 
end;