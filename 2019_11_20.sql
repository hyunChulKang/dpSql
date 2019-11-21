SELECT --'SELECT * FROM '|| table_name || ';' query
    --CONCAT�Լ��� �̿��ؼ� 
    CONCAT(CONCAT('SELCT *FROM ',table_name),';') query
FROM user_tables;


SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid ='brown';

--emp���̺��� ��ü ������ ��ȸ (��� ��(row), ��(column)

SELECT * 
FROM emp;

--�μ���ȣ(deptno)�� 20���� ũ�ų� ���� �μ����� ���ϴ� ���� ���� ��ȸ

SELECT * 
FROM emp
WHERE deptno >= 20 ORDER BY empno DESC;

--�����ȣ(empno)�� 7700���� ũ�ų� ���� ����� ������ ��ȸ

SELECT * 
FROM emp
WHERE empno >= 7700;

--��� �Ի�����(hiredate)�� 1982�� 1�� 1�� ������ ��� ���� ��ȸ
--���ڿ� --> ��¥ Ÿ������ ���� TO_DATE('��¥���ڿ�', '��¥���ڿ�����')
--�ѱ� ��¥ ǥ�� : ��-��-��
--�̱� ��¥ ǥ�� : ��-��-��
SELECT empno, ename, hiredate,
    2000 no, '���ڿ����' str, TO_DATE('19810101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');

--���� ��ȸ(BETWEEN ���۱��� AND �������)
--���۱���, ��������� ����
--����߿��� �޿�(sal)rk 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ��� ������ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--BETWEEN AND �����ڴ� �ε�ȣ �����ڷ� ��ü ����

SELECT *
FROM emp
WHERE sal >= 1000 
AND sal <= 2000;

--���ǿ� �´� ������ ��ȸ (BETWEEN...AND...�ǽ� where1)
--emp���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���� ���� 1983��1�� 1�� ������ �����
--ename, hiredate �����͸� ��ȸ�ϴ� ������ �ۼ��Ͻÿ�
--�� �����ڴ� between�� ����Ѵ�.

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD')
AND TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');
