--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어
--낼 수 있는 경우

SELECT rowid, emp.*
FROM emp;


--emp 테이블의 모든 컬럼을 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno =7782;

SELECT *
FROM TABLE(dbms_xplan.display);

--2번 접근 : where절에 있는 조건을 스캔
--1번 접근 : 테이블에 스캔에 해당하는 ROWID로 접근 
--0번 접근 : 접근완료
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
   
--기존 인덱스제거
--pk_emp 제약조건 삭제 --> unique 제약 삭제 --> pk_emp 인덱스 삭제
--INDEX 종류 (컬럼중복 여부)
--UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 없는 인덱스(emp.empno, dept.deptno)
--NON-UNQUE INDEX(default) : 인덱스 컬럼의 값이 중복될 수 있는 인덱스 (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

--CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno);
--위쪽 상황이랑 달라진 것은 EMPNO컬럼으로 생성된 인덱스가
-- UNIQUE -> NON-UNIQUE 인덱스로 변경됨
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

--emp 테이블에 job 컬럼으로 non-unique 인덱스 생성
--인덱스명 : idx_n_emp_02

CREATE INDEX idex_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

--emp 테이블에는 인덱스가 2개 존재
--1. empno
--2. job 

SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM emp
WHERE job = 'MANAGER';

--IDX_02 인덱스
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
   --emp 테이블의 job, ename 컬럼으로 non-unique 인덱스 생성
   CREATE INDEX idx_n_emp_03 ON emp (job, ename);
   
SELECT *
FROM emp;

--idx_n_emp_04
--ename, job 컬럼으로 emp테이블에 non-unique 인덱스 생성

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

--JOIN 쿼리에서의 인덱스
--emp 테이블은 empno컬럼으로 PRIMARY KEY 제약조건이 존재
--dept 테이블은 deptno 컬럼으로 PRIMARY KEY 제약조건이 존재
--emp 테이블은 PRIMARY KEY 제약을 삭제한 상태이므로 재성성
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
|   1 |  NESTED LOOPS                 |              |       |       |            |          |      --NESTED LOOPS : 반복을 의미
|   2 |   NESTED LOOPS                |              |     1 |    33 |     2   (0)| 00:00:01 |      --NESTED LOOPS : 반복을 의미
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