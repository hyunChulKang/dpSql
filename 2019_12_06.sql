SELECT *
FROM dept;

--dept ���̺� �μ���ȣ 99, �μ��� ddit, ��ġ daejeon

INSERT INTO dept VALUES(99, 'ddit','daejeon');
COMMIT;

--UPDATE : ���̺� ����� �÷��� ���� ����
--UPDATE ���̺�� SET �÷���1= �����Ϸ����ϴ� ��1. �÷���2 = �����Ϸ����ϴ� ��2///
--[WERE row ��ȸ ����] -- ��ȸ���ǿ� �ش��ϴ� �����͸� ������Ʈ�� �ȴ�.

--�μ���ȣ�� 99���� �μ��� �μ����� ���IT��, ������ ���κ������� ����

UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

--������Ʈ���� ������Ʈ �Ϸ����ϴ� ���̺��� WERE���� ����� �������� SELECT��
--�Ͽ� ������Ʈ ��� ROW�� Ȯ���غ���
SELECT *
FROM dept;
WHERE deptno = 99;

--���� QUERY�� �����ϸ� WHERE���� ROW ���� ������ ���� ������
--dept ���̺��� ��� �࿡ ���� �μ���, ��ġ ������ �����Ѵ�.
UPDATE dept SET dname = '���IT', loc = '���κ���';


--SUBQUERY�� �̿��� UPDATE 
--emp ���̺� �ű� ������ �Է�
--�����ȣ 9999. ����̸� brown, ���� : null

INSERT INTO emp (empno, ename) VALUES ( 9999, 'brown');

SELECT *
FROM emp;
commit;

--�����ȣ�� 9999�� ����� �Ҽ� �μ���, �������� SMITH����� �μ�, ������ ������Ʈ

UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename='SMITH') ,
               job = (SELECT job FROM emp WHERE ename='SMITH')
WHERE empno =9999;

SELECT *
FROM emp
WHERE empno =9999;

-DELETE : ���ǿ� �ش��ϴ� ROW�� ����
--�÷��� ���� ����??(NULL)������ �����Ϸ��� --> UPDATE

--DELETE ���̺��
--[WHERE ����]

--UPDATE������ ���������� DELETE ���� ���������� �ش� ���̺��� WHERE������ ����
--�ϰ� �Ͽ� SELECT�� ����, ������ ROW�� ���� Ȯ���غ���.

--emp���̺� �����ϴ� �����ȣ 9999�� ����� ����
DELETE emp
WHERE empno = 9999;

SELECT *
FROM emp;
WHERE empno =9999;
commit;



--�Ŵ����� 7698�� ��� ����� ����
--�������� ���


DELETE emp
WHERE empno IN(SELECT empno
             FROM emp
             WHERE mgr = 7698);
--�� ������ �Ʒ������� ����
DELETE emp WHERE mgr =7698;

SELECT *
FROM dept;
DELETE dept
WHERE deptno = 99;
COMMIT;

--���̺� ���� DDL : TALBE ����
--DDL�� roolback�� ���� (�ڵ� Ŀ�� �ǹǷ� rollback�� �� �� ����.
--CREATE TABLE [����ڸ�.] ���̺��(
--    �÷�1 �÷�Ÿ��1,
--    �÷�2 �÷�Ÿ��2,
--    �÷�N �÷�Ÿ��N};

SELECT *
FROM ranger;

CREATE TABLE ranger (
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE);
DESC ranger;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER'; 
-- ����Ŭ���� ��ü ������ �ҹ��ڷ� �����ϴ���
--���������δ� �빮�ڷ� �����Ѵ�.

INSERT INTO ranger VALUES( 1, 'brown', SYSDATE);

SELECT *
FROM ranger;
--DML���� DDL�� �ٸ��� ROLLBACK�� �����ϴ�.
ROLLBACK;

SELECT *
FROM ranger;

--DATE Ÿ�Կ��� �ʵ� �����ϱ�
--EXTRACT (�ʵ�� FROM �÷�/ expression)
SELECT TO_CHAR(SYSDATE, 'YYYY') yyyy,
       TO_CHAR(SYSDATE, 'mm') mm,
       EXTRACT(year FROM SYSDATE)
FROM dual;

--���̺� ������ �÷� ���� �������� ����
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13));

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

--dept_test ���̺��� deptno �÷��� PRIMARY KEY ���������� �ֱ� ������
--deptno �� ������ �����͸� �Է��ϰų� ���� �� �� ����.

--���� �������̹Ƿ� �Է¼���
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');

--dept_test �����Ϳ� deptno�� 99���� �����Ͱ� �����Ƿ�
--primary key �������ǿ� ���� �Է� �� �� ����.
-- ORA-00001 unique constraint ���� ����
--����Ǵ� �������Ǹ� SYS-C007105�������� ����
--SYS-C007105 ���������� � ������������ �Ǵ��ϱ� ����Ƿ�
--�������ǿ� �̸��� �ڵ� �꿡 ���� �ٿ��ִ� ����
--���������� ���ϴ�.
INSERT INTO dept_test VALUES( 99, '���', '����');

--���̺� ������ �������� �̸��� �߰��Ͽ� �����
DROP TABLE dept_test;
--primary key : pk_���̺��
CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));
    
--INSERT ���� ����
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 99, '���', '����');