--1
SELECT *
FROM emp;

CREATE INDEX idx_n_empno ON emp (empno);

--2
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND : ed_sal
AND deptno = :deptno;
--FULL SCAN

--3
SELECT *
FROM emp
WHERE ename = :ename;

CREATE INDEX idx_n_ename ON emp (ename);

--4
SELECT b.*
FROM emp a, emp b
WHERE a.mgr = b.empno
AND a.deptno = :deptno;

CREATE INDEX idx_n_ename ON emp (detpno,mgr);

--5
EXPLAIN PLAN FOR
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno = :deptno
AND emp.empno LIKE :empno || '%';
SELECT *
FROM TABLE(dbms_xplan.display);

CREATE INDEX idx_n_em_dp ON emp (deptno,empno);
DROP INDEX idx_n_em_dp;

--SYNONYM(동의어)
--오라클 객체를 다른이름으로 부를 수 있도록 하는 것
--만약에 emp 테이블을 e라고 하는 synonym(동의어)로 생성을 하면
-- 다음과 같이 SQL을 작성 할 수 있다.
-- SELECT *
-- FROM e;

--kavin계정에 SYNONYM 생성 권한을 부여 <--SYSTEM계정에서 실행
GRANT CREATE SYNONYM TO kavin;

--emp 테이블을 사용하여 synonym  e로 생성
--CREATE SYNONYM 시노님 이름 FOR 오라클객체;
CREATE SYNONYM e FOR emp;

--emp 라는 테이블 명 대신에 e 라고 하는 시노님을 사용하여 쿼리를 작성
--할 수 있다.
SELECT *
FROM emp;

SELECT *
FROM e;

--kavin 계정의 fastfood 테이블을 hr 계정에서도 볼 수 있도록
--테이블 조회 권한을 부여
GRANT SELECT ON fastfood TO hr;


SELECT *
FROM user_tab_columns;

SELECT *
FROM user_ind_columns;

--동일한 SQL의 개념에 따르면 아래 SQL들의 실행계획은 다르다.
SELECT /* 201911_205*/ * FROM emp;
SELECT /* 201911_205*/ * FROM EMP;
SELECt /* 201911_205*/ * FROM EMP;

SELECt /* 201911_205*/ * FROM EMP WHERE empno = 7369;
SELECt /* 201911_205*/ * FROM EMP WHERE empno = 7499;
SELECt /* 201911_205*/ * FROM EMP WHERE empno =:empno;

--multiple insert
DROP TABLE emp_test;

--emp 테이블의 empno, ename 컬럼으로 emp_test, emp_tes2 테이블을 
--생성 (CTAS, 데이터도 같이 복사)

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT *
FROM emp_test2;

--uncoditional insert
--여러 테이블에 데이터를 동시 입력
--brown, cony데이터를 emp_test, emp_test2 테이블에 동시에 입력
INSERT ALL
    INTO emp_test
    INTO emp_test2
SELECT  9999, 'brown' FROM DUAL UNION ALL
SELECT  9998, 'cony' FROM DUAL; 



SELECT *
FROM emp_test
WHERE empno >9000;

SELECT *
FROM emp_test2
WHERE empno >9000;

ROLLBACK;
--테이블 별 입력되는 데이터의 컬럼을 제어 가능
INSERT ALL
    INTO emp_test( empno, ename) Values(eno, enm)
    INTO emp_test2 (empno) VALUES (eno)
SELECT  9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT  9998, 'cony' FROM DUAL; 

SELECT *
FROM emp_test
WHERE empno >9000
UNION ALL

SELECT *
FROM emp_test2
WHERE empno >9000;

ROLLBACK;

--CONDITIONAL INSERT
--조건에 따라 테이블에 데이터를 입력
/*
    CASE
        WHEN 조건 THEN--
        WHEN 조건 THEN --
        ESLE --
*/
ROLLBACK;
INSERT ALL
WHEN eno > 9000 THEN
        INTO emp_test (empno,ename) VALUES (eno, enm)
WHEN eno > 9500 THEN
        INTO emp_test (empno,ename) VALUES (eno, enm)
ELSE 
        INTO emp_test (empno) VALUES (eno)
SELECT  9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT  8000, 'cony' FROM DUAL; 


SELECT *
FROM emp_test
WHERE empno >9000 UNION ALL
SELECT *
FROM emp_test
WHERE empno < 9000;





ROLLBACK;
INSERT FIRST
WHEN eno > 9000 THEN
        INTO emp_test (empno,ename) VALUES (eno, enm)
WHEN eno > 9500 THEN
        INTO emp_test (empno,ename) VALUES (eno, enm)
ELSE 
        INTO emp_test (empno) VALUES (eno)
SELECT  9999 eno, 'brown' enm FROM DUAL UNION ALL
SELECT  8000, 'cony' FROM DUAL; 
