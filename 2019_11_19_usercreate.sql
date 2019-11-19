SELECT * FROM DBA_DATA_FILES;


--table space 积己
  CREATE TABLESPACE TS_DBSQL
   DATAFILE 'E:\B_UTIL\4.ORACLE\APP\ORACLE\ORADATA\XE\DBSQL.DBF' 
   SIZE 100M 
   AUTOEXTEND ON;


create user KAVIN identified by java
default tablespace TS_DBSQL
temporary tablespace temp
quota unlimited on TS_DBSQL
quota 0m on system;


--立加, 积己鼻茄
GRANT CONNECT, RESOURCE TO KAVIN;
