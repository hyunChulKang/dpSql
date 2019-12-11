--INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� �����͸� �����
--�� �� �ִ� ���

SELECT rowid, emp.*
FROM emp;


--emp ���̺��� ��� �÷��� ��ȸ
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--2�� ���� : where���� �ִ� ������ ��ĵ
--1�� ���� : ���̺� ��ĵ�� �ش��ϴ� ROWID�� ���� 
--0�� ���� : ���ٿϷ�
Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    38 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    38 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
   
--���� �ε�������
--pk_emp �������� ���� --> unique ���� ���� --> pk_emp �ε��� ����
--INDEX ���� (�÷��ߺ� ����)
--UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���(emp.empno, dept.deptno)
--NON-UNQUE INDEX(default) : �ε��� �÷��� ���� �ߺ��� �� �ִ� �ε��� (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno);
--���� ��Ȳ�̶� �޶��� ���� EMPNO�÷����� ������ �ε�����
-- UNIQUE -> NON-UNIQUE �ε����� �����
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN For
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(dbms_xplan.display);

DELETE emp WHERE empno = 9999;
INSERT INTO emp( empno, ename) VALUES ( 7782, 'brown');
COMMIT;

--emp ���̺� job �÷����� non-unique �ε��� ����
--�ε����� : idx_n_emp_02

CREATE INDEX idex_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--emp ���̺��� �ε����� 2�� ����
--1. empno
--2. job 

SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 �ε���
EXPLAIN PLAN For
SELECT *
FROM emp
WHERE ename LIKE 'C%'
AND job = 'MANAGER';
SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 436186366
 
---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP           |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDEX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
   
EXPLAIN PLAN For
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 436186366
 
---------------------------------------------------------------------------------------------
| Id  | Operation                   | Name          | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |               |     1 |    38 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP           |     1 |    38 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDEX_N_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')
   
   
   --idx_n_emp_03
   --emp ���̺��� job, ename �÷����� non-unique �ε��� ����
   CREATE INDEX idx_n_emp_03 ON emp (job, ename);
   
SELECT *
FROM emp;

--idx_n_emp_04
--ename, job �÷����� emp���̺� non-unique �ε��� ����

CREATE INDEX idx_n_emp04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job ='MANAGER'
AND ename LIKE 'J%';

SELECT *
FROM TABLE(dbms_xplan.display);

--JOIN ���������� �ε���
--emp ���̺��� empno�÷����� PRIMARY KEY ���������� ����
--dept ���̺��� deptno �÷����� PRIMARY KEY ���������� ����
--emp ���̺��� PRIMARY KEY ������ ������ �����̹Ƿ� �缺��
DELETE emp
WHERE ename = 'brown';
select *
from emp;
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3070176698
 
----------------------------------------------------------------------------------------------
| Id  | Operation                     | Name         | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |              |     1 |    33 |     2   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |              |       |       |            |          |      --NESTED LOOPS : �ݺ��� �ǹ�
|   2 |   NESTED LOOPS                |              |     1 |    33 |     2   (0)| 00:00:01 |      --NESTED LOOPS : �ݺ��� �ǹ�
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP          |     1 |    13 |     1   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_N_EMP_01 |     1 |       |     0   (0)| 00:00:01 |  
|*  5 |    INDEX UNIQUE SCAN          | PK_DEPT      |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT         |     4 |    80 |     1   (0)| 00:00:01 |
----------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
   

DROP TABLE dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1 =1 ;

CREATE UNIQUE INDEX indx_1 ON dept_test (deptno);

CREATE INDEX indx_2 ON dept_test (dname);

CREATE INDEX indx_3 ON dept_test (deptno, dname);


DROP INDEX indx_1;

DROP INDEX indx_2;

DROP INDEX indx_3;

CREATE UNIQUE INDEX indx_emp_no ON emp_test (empno);