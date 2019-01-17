SELECT * FROM v$bgprocess;

SELECT * FROM v$bgprocess
WHERE PADDR!=hextoraw('00');


SELECT * FROM v$bgprocess
WHERE PADDR!=hextoraw('00') AND
NAME LIKE 'DBW%';

SELECT * FROM v$session
WHERE username IS NOT NULL;

SELECT * FROM v$services;

SHOW parameter dispatcher;
SELECT * FROM v$process;


