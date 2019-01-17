drop table my_tab;

create table my_tab
(
  integervalue float,
  charvalue nvarchar2(100),
  datevalue date
);

select * from my_tab;




spool C:\ot.txt 
select * from my_tab;
spool off

