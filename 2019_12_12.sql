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

--SYNONYM(���Ǿ�)
--����Ŭ ��ü�� �ٸ��̸����� �θ� �� �ֵ��� �ϴ� ��
--���࿡ emp ���̺��� e��� �ϴ� synonym(���Ǿ�)�� ������ �ϸ�
-- ������ ���� SQL�� �ۼ� �� �� �ִ�.
-- SELECT *
-- FROM e;

--kavin������ SYNONYM ���� ������ �ο� <--SYSTEM�������� ����
GRANT CREATE SYNONYM TO kavin;

--emp ���̺��� ����Ͽ� synonym  e�� ����
--CREATE SYNONYM �ó�� �̸� FOR ����Ŭ��ü;
CREATE SYNONYM e FOR emp;

--emp ��� ���̺� �� ��ſ� e ��� �ϴ� �ó���� ����Ͽ� ������ �ۼ�
--�� �� �ִ�.
SELECT *
FROM emp;

SELECT *
FROM e;

--kavin ������ fastfood ���̺��� hr ���������� �� �� �ֵ���
--���̺� ��ȸ ������ �ο�
GRANT SELECT ON fastfood TO hr;


SELECT *
FROM user_tab_columns;

SELECT *
FROM user_ind_columns;

--������ SQL�� ���信 ������ �Ʒ� SQL���� �����ȹ�� �ٸ���.
SELECT /* 201911_205*/ * FROM emp;
SELECT /* 201911_205*/ * FROM EMP;
SELECt /* 201911_205*/ * FROM EMP;

SELECt /* 201911_205*/ * FROM EMP WHERE empno = 7369;
SELECt /* 201911_205*/ * FROM EMP WHERE empno = 7499;
SELECt /* 201911_205*/ * FROM EMP WHERE empno =:empno;

--multiple insert
DROP TABLE emp_test;

--emp ���̺��� empno, ename �÷����� emp_test, emp_tes2 ���̺��� 
--���� (CTAS, �����͵� ���� ����)

CREATE TABLE emp_test AS
SELECT empno, ename
FROM emp;

CREATE TABLE emp_test2 AS
SELECT empno, ename
FROM emp;

SELECT *
FROM emp_test2;

--uncoditional insert
--���� ���̺� �����͸� ���� �Է�
--brown, cony�����͸� emp_test, emp_test2 ���̺� ���ÿ� �Է�
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
--���̺� �� �ԷµǴ� �������� �÷��� ���� ����
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
--���ǿ� ���� ���̺� �����͸� �Է�
/*
    CASE
        WHEN ���� THEN--
        WHEN ���� THEN --
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
