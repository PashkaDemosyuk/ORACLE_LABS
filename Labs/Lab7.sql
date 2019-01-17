--1--полный список фоновых процессов 
SELECT * FROM v$bgprocess;

--2--фоновые процессы, которые запущены и работают в насто€щий момент
SELECT * FROM v$bgprocess WHERE PADDR!=hextoraw('00');

--3--сколько процессов DBWn работает в насто€щий момент
SELECT * FROM v$bgprocess WHERE PADDR!=hextoraw('00') AND NAME LIKE 'DBW%';

--4-5--перечень текущих соединений с экземпл€ром и режимы
SELECT username, sid, serial#,server,paddr, status FROM v$session WHERE username is not null; 

--6--сервисы (точки подключени€ экземпл€ра)
SELECT * FROM v$services;

--7--параметры диспетчера и их значений
SHOW parameter dispatcher;

SELECT * FROM v$process;