--�������� Ȱ��ȭ /��Ȱ��ȭ
--ALTER TABLE ���̺�� ENABLE OR DISABLE CONSTRAINT �������Ǹ�;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'DEPT_TEST';

ALTER TABLE dept_test DISABLE CONSTRAINT SYS_c007121;

SELECT *
FROM dept_test;


--dept_test���̺��� deptno �÷��� ����� PRIMARY KEY ���������� ��Ȱ��ȭ �Ͽ�
--������ �μ���ȣ�� ���� �����͸� �Է��� �� �ִ�.
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 99, 'DDIT', '����');

--dept_test ���̺��� PRIMARY KEY �������� Ȱ��ȭ
--�̹� ������ ������ �ΰ��� INSERT ������ ���� ���� �μ���ȣ�� ���� �����Ͱ�
--�����ϱ� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� ����.
--Ȱ��ȭ �Ϸ��� �ߺ� �����͸� ���� �ؾ��Ѵ�.
ALTER TABLE dept_test ENABLE CONSTRAINT SYS_c007121;


--�μ���ȣ�� �ߺ��Ǵ� �����͸� ��ȸ �Ͽ�
--�ش� �����Ϳ� ���� ������ PRIMARY KEY ���������� Ȱ��ȭ �� �� �ִ�.
SELECT deptno, COUNT(*)
FROM dept_test
GROUP BY deptno
HAVING COUNT(*) >= 2;

--table_name, constraint_name, column_name
SELECT *
FROM USER_CONSTRAINTS
WHERE table_name = 'BUYER';

SELECT *
FROM user_cons_columns
WHERE table_name = 'BUYER';


--���̺� ���� ����(�ּ�) view
SELECT *
FROM user_tab_comments;

--���̺� �ּ�
--COMMENT ON TABLE ���̺�� IS '�ּ�';
COMMENT ON TABLE dept IS '�μ�';
--�÷� �ּ�
--COMMENT ON COLUMN ���̺�.�÷��� IS '�ּ�';
COMMENT ON COLUMN dept.deptno IS '�μ���ȣ';
COMMENT ON COLUMN dept.dname IS '�μ���';
COMMENT ON COLUMN dept.loc IS '�μ���ġ ����';
SELECT *
FROM USER_COL_COMMENTS
WHERE TABLE_NAME = 'DEPT';

SELECT *
FROM USER_TAB_COMMENTS;

SELECT *
FROM USER_COL_COMMENTS;


SELECT TAB_N.TABLE_NAME, TAB_N.TABLE_TYPE, TAB_N.COMMENTS, COL_N.COLUMN_NAME, COL_N.COMMENTS
FROM USER_TAB_COMMENTS TAB_N, USER_COL_COMMENTS COL_N
WHERE TAB_N.TABLE_NAME = COL_N.TABLE_NAME
AND TAB_N.TABLE_NAME IN ('CUSTOMER' ,'PRODUCT', 'CYCLE', 'DAILY');

--VIEW : QUERY�̴�
--���̺� ó�� �����Ͱ� ���������� �����ϴ� ���� �ƴϴ�.
--���� ������ �� = QUERY
--VIEW ���̺��̴�(X)

--VIEW ����
--CREATE OF REPLACE VIEW ���̸� [(�÷���Ī1, �÷���Ī2...)] AS
--SUBQUERY

--emp���̺��� sal, comm�÷��� ������ ������ 6�� �÷��� ��ȸ�� �Ǵ� view
--v_emp�̸����� ����
CREATE OR REPLACE VIEW v_emp AS
SELECT empno, ename, job, mgr, hiredate, deptno
FROM emp;

--SYSTEM �������� �۾�
--VIEW ���� ������ kavin ������ �ο�
GRANT CREATE VIEW TO kavin;

--VIEW�� ���� ������ ��ȸ
SELECT *
FROM (SELECT empno, ename, job, mgr, hiredate, deptno
      FROM emp);
      
--emp���̺��� �����ϸ� view�� ������ ������?
--KING�� �μ���ȣ�� ���� 10��
--emp ���̺��� KING�� �μ���ȣ �����͸� 30������ ����(COMMIT ���� ����)
--v_emp ���̺��� KING�� �μ���ȣ�� ����
UPDATE emp SET deptno = 30 
    WHERE ename = 'KING';
    
SELECT *
FROM emp;

--���ε� ��� view�� ����
CREATE OR REPLACE VIEW v_emp_dept AS
SELECT emp.empno, emp.ename, dept.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM v_emp_dept;

DELETE emp
WHERE ename = 'KING';

SELECT *
FROM EMP
WHERE ename ='KING';
--emp ���̺��� KING ������ ������ v_emp_dept view�� ��ȸ ��� Ȯ��
SELECT *
FROM v_emp_dept;



--emp���̺��� empno �÷��� eno�� �÷��̸� ����
ALTER TABLE emp RENAME COLUMN empno TO eno;
ALTER TABLE emp RENAME COLUMN eno TO empno;

DROP VIEW v_emp;

INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        TO_DATE('17-NOV-1981', 'DD-MON-YYYY', 'NLS_DATE_LANGUAGE = AMERICAN'), 5000, NULL, 10);
        COMMIT;
        
--�μ��� ������ �޿� �հ�
CREATE OR REPLACE VIEW v_emp_sal AS
SELECT deptno, SUM(sal) sum_sal
FROM emp
GROUP BY deptno;

SELECT *
FROM( SELECT deptno, SUM(sal) sum_sal
      FROM emp
      GROUP BY deptno)
WHERE deptno =20;


--SEQUENCE
--����Ŭ��ü�� �ߺ����� �ʴ� ���� ���� �������ִ� ��ü
--CREATE SEQUENCE ��������
--[�ɼ�..]

CREATE SEQUENCE seq_board;
--������ ����� : ������.nextval
SELECT seq_board.nextval
FROM dual;

SELECT seq_board.currval
FROM dual;

SELECT rowid, rownum, emp.*
FROM emp;

--emp ���̺� empno �÷����� RPIMARY KEY ���� ���� : pk_emp
--dept���̺� deptno �÷����� RPIMARY KEY ���� ���� : pk_dept
--emp ���̺� deptno �÷��� dept ���̺��� deptno �÷��� �����ϵ���
--FOREIGN KEY ���� �߰� : fk_dept_deptno

ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY (deptno);
ALTER TABLE emp ADD CONSTRAINT fk_dept_deptno FOREIGN  KEY (deptno)
            REFERENCES dept (deptno);

DROP TABLE emp_test;

--emp ���̺��� �̿��Ͽ� emp_test ���̺� ����
CREATE TABLE emp_test AS
SELECT *
FROM emp;

--emp_test ���̺��� �ε����� ���� ����
--���Ѵ� �����͸� ã�� ���ؼ��� ���̺��� �����͸� ��� �о���� �Ѵ�.

EXPLAIN PLAN FOR
SELECT *
FROM emp_test
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

--�����ȹ�� ���� 7369 ����� ���� ���� ������ ��ȸ �ϱ�����
--���̺��� ��� ������(14)�� �о� �������� ����� 7369�� �����͸� �����Ͽ�
--����ڿ��� ��ȯ
--**13���� �����ʹ� ���ʿ��ϰ� ��ȸ �� ����
Plan hash value: 3124080142
 
------------------------------------------------------------------------------
| Id  | Operation         | Name     | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |          |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP_TEST |     1 |    87 |     3   (0)| 00:00:01 |
------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369;

SELECT *
FROM table(dbms_xplan.display);

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
 
   2 - access("EMPNO"=7369)
   
--�����ȹ�� ���� �м��� �ϸ�
--empno�� 7369�� ������ index�� ���� �ſ� ������ �ε����� ����
--���� ����Ǿ� �ִ� rowid ���� ���� table�� ������ �Ѵ�.
-- table���� ���� �����ʹ� 7369��� ������ �ѰǸ� ��ȸ�� �ϰ�
--������ 13�ǿ� ���ؼ��� ���� �ʰ� ó��
--14 --> 1
--1 -->1

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE 

SELECT *
FROM table(dbms_xplan.display);