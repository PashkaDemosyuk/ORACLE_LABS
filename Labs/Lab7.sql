--1--������ ������ ������� ��������� 
SELECT * FROM v$bgprocess;

--2--������� ��������, ������� �������� � �������� � ��������� ������
SELECT * FROM v$bgprocess WHERE PADDR!=hextoraw('00');

--3--������� ��������� DBWn �������� � ��������� ������
SELECT * FROM v$bgprocess WHERE PADDR!=hextoraw('00') AND NAME LIKE 'DBW%';

--4-5--�������� ������� ���������� � ����������� � ������
SELECT username, sid, serial#,server,paddr, status FROM v$session WHERE username is not null; 

--6--������� (����� ����������� ����������)
SELECT * FROM v$services;

--7--��������� ���������� � �� ��������
SHOW parameter dispatcher;

SELECT * FROM v$process;