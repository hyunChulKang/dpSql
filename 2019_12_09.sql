CREATE TABLE dept_test (
    deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,;

--PAIRWISE : ���� ����
--����� PRIMARY KEY ���������� ��� �ϳ��� �÷��� ���������� ����
--���� �÷��� �������� PRIMARY KEY �������� ���� �� �� �ִ�.
--�ش� ����� ���� �� ���� ���� ó�� �÷� ���������� ���� �� �� ����.
--> TABLE LEVEL ���� ���ǻ���
    
--������ ������ dept_test ���̺� ����(drop)
DROP TABLE dept_test;

--�÷������� �ƴ�, ���̺� ������ �������� ����
CREATE TABLE dept_test (
    deptno NUMBER(2),
    dname VARCHAR2(14),
    loc VARCHAR2(13),--������ �÷� ������ �ĸ� ������ �ʱ�
    
    --deptno, dname �÷��� ������ ������(�ߺ���) �����ͷ� �ν�
    CONSTRAINT pk_dept_test PRIMARY KEY (deptno, dname)
    );
    
    DESC dept_test;
    

--�μ���ȣ, �μ��̸� ���������� �ߺ� �����͸� ����
--�Ʒ� �ΰ��� insert ������ �μ���ȣ�� ������
--�μ����� �ٸ��Ƿ� ���� �ٸ� �����ͷ� �ν� -->INSERT ����
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 99, '���', '����');

SELECT *
FROM dept_test;

--�ι�° INSERT ������ Ű���� �ߺ��ǹǷ� ����
INSERT INTO dept_test VALUES( 99, '���', 'û��');

--NOT NULL ��������
--�ش� �÷��� NULL���� ������ ���� ������ �� ���
--���� �÷��� �Ÿ��� �ִ�.

DROP TABLE dept_test;

-- dname �÷��� NULL ���� ������ ���ϵ��� NOT NULL ���� ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES( 99, 'ddit', NULL);
--deptno �÷��� PRIAMRY KEY ���࿡ �ɸ��� �ʰ�(�ߺ��� ���� �ƴϴϱ�)
--dname �÷��� NOT NULL ���������� ����
INSERT INTO dept_test VALUES( 98, NULL, '����');

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) CONSTRAINT NN_dname NOT NULL,
    loc VARCHAR2(13)
);

DROP TABLE dept_test;

CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
    --CONSTRAINT NN_danme NOT NULL(dname) : NOT NULL�� ���̺��ۼ����� ���ȵȴ�.
);

DROP TABLE dept_test;
--�÷� ���� unique ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)

);
--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ����������
--������ �� ����.
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 98, 'ddit', '����');



DROP TABLE dept_test;
--�÷� ���� unique ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14)CONSTRAINT IDX_U_dept_test_01 UNIQUE,
    loc VARCHAR2(13)

);
--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ����������
--������ �� ����.
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 98, 'ddit', '����');


DROP TABLE dept_test;
--���̺� ���� unique ���� ����
CREATE TABLE dept_test (
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),

CONSTRAINT IDX_U_dept_test_01 UNIQUE (dname)
);
--�ΰ��� insert ������ ���� dname�� ���� ���� �Է��ϱ� ������
--dname �÷��� ����� UNIQUE ���࿡ ���� �ι�° ������ ����������
--������ �� ����.
INSERT INTO dept_test VALUES( 99, 'ddit', 'daejeon');
INSERT INTO dept_test VALUES( 98, 'ddit', '����');

--FOREIGN KEY ��������
--�ٸ� ���̺� �����ϴ� ���� �Է� �� �� �ֵ��� ����

--emp_test.deptno -> dept_test.deptno �÷��� ���� �ϵ���

--dept_test���̺� ����(drop)
DROP TABLE dept_test;

--dept_test ���̺� ���� (deptno �÷� PRIMARY KEY ����)
--DEPT ���̺�� �÷��̸�, Ÿ�� �����ϰ� ����

select * 
from emp_test;
CREATE TABLE dept_test (
    deptno VARCHAR2(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13));

INSERT INTO dept_test VALUES(99, 'ddit', 'daejeon');
commit;

Desc emp_test;
--empno, ename, deptno : emp_test
--empno PRIMARY KEY
--deptno dept_test.deptno FOREIGN KEY

--�÷����� FOREIGN KEY
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
deptno VARCHAR2(2) REFERENCES dept_test(deptno)
);

--dept_test ���̺� �����ϴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
--dept_test ���̺� �������� �ʴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 99);

DROP TABLE emp_test;
--�÷����� FOREIGN KEY(�������� �� �߰�)
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
deptno NUMBER(2),
CONSTRAINT FK_dept_test  FOREIGN KEY (deptno)
REFERENCES dept_test(deptno)
);

--dept_test ���̺� �����ϴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
--dept_test ���̺� �������� �ʴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9998, 'sally', 98);

SELECT *
FROM dept_test;

--�μ������� �������
--��������ϴ� �μ���ȣ�� �����ϴ� ����������
--���� �Ǵ� deptno �÷��� NULLó��
--EMP - > DEPT




--FOREIGN KEY OPTION -ON DELETE CASCADE
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
deptno NUMBER(2),
CONSTRAINT FK_dept_test  FOREIGN KEY (deptno)
REFERENCES dept_test(deptno) ON DELETE CASCADE
);

--dept_test ���̺� �����ϴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

SELECT *
FROM dept_test;
-- ON DELETE CASCADE �ɼǿ� ���� DEPT �����͸� ������ ���
-- �ش� �����͸� �����ϰ� �ִ� EMP���̺��� ��� �����͵� �����ȴ�.
DELETE dept_test
WHERE deptno =99;
--�μ������� �������
--��������ϴ� �μ���ȣ�� �����ϴ� ����������
--���� �Ǵ� deptno �÷��� NULLó��
--EMP - > DEPT


DROP TABLE emp_test;
--FOREIGN KEY OPTION -ON DELETE SET NULL
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
deptno NUMBER(2),
CONSTRAINT FK_dept_test  FOREIGN KEY (deptno)
REFERENCES dept_test(deptno) ON DELETE SET NULL
);

--dept_test ���̺� �����ϴ� deptno�� ���� �Է�
INSERT INTO emp_test VALUES(9999, 'brown', 99);
COMMIT;

SELECT *
FROM dept_test;
-- ON DELETE SET NULL �ɼǿ� ���� DEPT �����͸� ������ ���
-- �ش� �����͸� �����ϰ� �ִ� EMP���̺��� DEPTNO �÷��� NULL�� �����Ѵ�.
DELETE dept_test
WHERE deptno =99;


--CHECK ��������
--�÷��� ���� ���� ������ ��
-- EX: �޿� �÷����� ���� 0���� ū ���� ������ üũ
--     ���� �÷����� ��/�� Ȥ�� F/M ���� ������ ����

--emp _test ���̺� ����(drop)
DROP TABLE emp_test;

--emp_test ���̺� �÷�
--empno NUBMER(4)
--ename VARCHAR2(10)
--sal NUMBERS(7,2) --0���� ū ���ڸ� �Է� �ǵ��� ����
--EMP_gb VARCHAR2(2) -- ���� ���� 01-������, 02-����
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
sal NUMBER(7,2) CHECK (sal >0),
emp_gb VARCHAR2(2) CHECK (emp_gb IN('01', '02') ) );

--emp_test ������ �Է�
--sal�÷� CHECK ��������(sal >0)�� ���ؼ� ���� ���� �Է� �� �� ����.
INSERT INTO emp_test VALUES (9999, 'brown', -1, '01');

--CHECK �������� ���� ���� �����Ƿ� ���� �Է� (sal, emp_gb)
INSERT INTO emp_test VALUES (9999, 'brown', 1000, '01');

--emp_gb CHECK ���ǿ� ����(emp_gb ('01', '02') )
INSERT INTO emp_test VALUES (9998, 'sally', 1000, '03');

--CHECK  ���� ���� ���� ���� �����Ƿ� ���� �Է�(sal, emp_gb
INSERT INTO emp_test VALUES (9998, 'sally', 1000, '02');

--���̺� ����
DROP TABLE emp_test;

--CHECK �������� �������� �̸� ����
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
--sal NUMBER(7,2) CHECK (sal >0),
sal NUMBER(7,2) CONSTRAINT C_SAL CHECK (sal >0),
--emp_gb VARCHAR2(2) CHECK (emp_gb IN('01', '02') ) );
emp_gb VARCHAR2(2) CONSTRAINT C_EMP_GB CHECK (emp_gb IN('01', '02') ) );

SELECT *
FROM emp_test;




--���̺� ����
DROP TABLE emp_test;

--table level CHECK �������� �������� �̸� ����
CREATE TABLE emp_test(
empno NUMBER(4) PRIMARY KEY,
ename VARCHAR2(10),
sal NUMBER(7,2), 
emp_gb VARCHAR2(2),

CONSTRAINT nn_ename CHECK (ename IS NOT NULL),
CONSTRAINT C_SAL CHECK (sal >0),
CONSTRAINT C_EMP_GB CHECK (emp_gb IN('01', '02') ) );





--���̺� ���� : CREATE TABLE ���̺�� (
--              �÷� �÷� Ÿ�� ....);
--���� ���̺� ������ Ȱ���ؼ� ���̺� �����ϱ�
--      CREATE TABLE ���̺�� [(�÷�1, �÷�2, �÷�3....)] AS
--         SELECT col1, col2...
--         FROM �ٸ� ���̺�
--         WHERE ����

--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

--�ߺ�Ȯ�� �����Ͱ� ������ ���簡 �� �Ȱ���.
SELECT *
FROM emp_test;

MINUS


SELECT *
FROM emp;


--emp_test ���̺� ����(drop)
DROP TABLE emp_test;

--emp ���̺��� �����͸� �����ؼ� emp_test ���̺��� �÷����� �����Ͽ� ����
CREATE TABLE emp_test(c1, c2, c3 , c4, c5, c6, c7, c8) AS
    SELECT *
    FROM emp;
    
SELECT *
FROM emp_test;

--emp_test ���̺� ����
DROP TABLE emp_tet;
--�����ʹ� �����ϰ� ���̺��� ��ü(�÷� ����)�� �����Ͽ� ���̺� ����
CREATE TABLE emp_test AS
    SELECT *
    FROM emp
    WHERE 1=2;s
SELECT *
FROM emp_test;

DROP TABLE emp_test;


--empno, ename, deptno �÷����� emp_test ����
CREATE TABLE emp_test AS
SELECT empno, ename, deptno
FROM emp
WHERE 1=2;

--emp_test ���̺� �ű� �÷� �߰�
--HP VARCHAR2(20) DEFAULT '010'
--ALTER TABLE ���̺�� ADD (�÷��� �÷� Ÿ�� [default value])
SELECT *
FROM emp_test;

ALTER TABLE emp_test  ADD( hp VARCHAR2(20) DEFAULT  '010');

--���� �÷� ����
--ALTER TABLE ���̺�� MODIFY(�÷� �÷� Ÿ�� [default vaule]);
--hp �÷��� Ÿ���� VARCHAR2(20) -> VHARCHAR2(30)
ALTER TABLE emp_test MODIFY (hp VARCHAR2(30));

--���� emp_test ���̺� �����Ͱ� ���� ������ �÷� Ÿ���� �����ϴ� ����
--�����ϴ�.
--hp �÷��� Ÿ���� VARCHAR2(30) ->NUMBER
ALTER TABLE emp_test MODIFY (hp NUMBER);
DESC emp_test;

--�÷��� ����
--�ش� �÷��� PK, UNIQUE, NOT NULL, CHECK ���� ���ǽ� ����� �÷���
--�� ���ؼ��� �ڵ������� ������ �ȴ�.
--hp �÷� hp_n���� ����
--ATER TABLE ���̺�� RENAME COLUMN �����÷��� TO �����÷���;
ALTER TABLE  emp_test RENAME COLUMN hp TO hp_n;
DESC emp_test;

--�÷� ����(2���� ���)
--ALTER TABLE ���̺�� DROP (�÷�);
--ALTER TABLE ���̺�� DROP COLUMN �÷�;

ALTER TABLE emp_test DROP (hp_n);

--���� ���� �߰�
--ALTER TABLE ���̺��  ADD   --���̺� ���� �������� ��ũ��Ʈ
--emp_test���̺��� empno�÷��� PK �������� �߰�

ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test
                         PRIMARY KEY (empno);
                         
--���� ���� ����
--ALTER TABLE ���̺�� DROP CONSTRAINT ���������̸�;
--emp_test ���̺��� PRIMARY KEY ���������� pk_emp_test ���� ����
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;
DESC emp_test;

--���̺� �÷�, Ÿ�� ������ ���������γ��� ����
--���̺��� �÷������� �����Ѵ� ���� �Ұ����ϴ�.