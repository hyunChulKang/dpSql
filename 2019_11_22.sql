--WHERE8

SELECT *
FROM emp
WHERE deptno != 10  
AND hiredate > TO_DATE('19810601','YYYYMMDD');

--WHERE9

SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate > TO_DATE ('19810601','YYYYMMDD');


--WHERE10
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate > TO_DATE ('19810601','YYYYMMDD');

--WHERE11
SELECT *
FROM emp
WHERE job = 'SALESMAN'
--WHERE job IN (SALESMAN)
OR hiredate > TO_DATE ('19810601','YYYYMMDD');

--WHERE12
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR  empno LIKE '78%';

--WHERE13 (LIIK ���� ������)
--���� ���� : EMPNO�� ���ڿ��ߵȴ� (DESC emp.empno NUMBER)
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR  empno  BETWEEN 7800 AND 7899 ;
DESC emp;

--������ �켱���� (AND > OR)
--���� �̸��� SMITH �̰ų�, �����̸��� ALLEN�̸鼭 ������ SALESMAN�� ����
SELECT *
FROM emp 
WHERE ename = 'SMITH'
OR ename = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp 
WHERE ename = 'SMITH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');

--���� �̸��� SMITH �̰ų� ALLEN �̸鼭 ������ SALESMAN�� ���
SELECT *
FROM emp 
WHERE (ename = 'SMITH' OR ename = 'ALLEN' )
AND job = 'SALESMAN';

--WHERE14
--job�� SALESMAN �̰ų� �����ȣ�� 78�� �����ϸ鼭, �Ի����ڰ� 1981��6�� 1�� ����
SELECT *
FROM emp 
WHERE job ='SALESMAN'
OR empno LIKE '78__'
--OR empno BETWEEN 7800 AND 7899
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

--������ ����
--10, 5, 3, 2, 1

--�������� :1, 2, 3, 5, 10
--�������� :10, 5, 3, 2, 1

--�������� : ASC (ǥ�⸦ ���Ұ�� �⺻��)
--�������� : DESC (����������, �ݵ�� ǥ��)

/*

    SELECT col1, col2, ......
    FROM ���̺��
    WHERE COl1 = '��'
    ORDER BY ���ı��� �÷�1 [ASC /DESC], ���ı����÷�2 ...... [ASC/DESC]
*/

--���(emp) ���̺��� ������ ������ ���� �̸����� �������� ����

SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename ASC; --���ı����� �ۼ����� ���� ��� �������� ����

--���(emp) ���̺��� ������ ������ ���� �̸����� �������� ����

SELECT *
FROM emp
ORDER BY ename DESC;

--���(emp) ���̺��� ������ ������ �μ���ȣ�� �������� ����
--�μ���ȣ�� ���� ���� sal �������� ����
--�޿�(sal)�� �������� �̸����� ��������(ASC) ���� �Ѵ�.
SELECT *
FROM emp
ORDER BY deptno ,sal DESC, ename;

--���� �÷��� ALIAS�� ǥ��

SELECT deptno, sal ,ename nm 
FROM emp
ORDER BY nm;

--��ȸ�ϴ� �÷��� ��ġ �ε����� ǥ�� ����
SELECT deptno, sal ,ename nm 
FROM emp
ORDER BY 3; --(3��° �÷����� ��ȸ�Ѵٴ¶� -��õ ������ ����(�÷� �߰��� �ǵ��ϴ� ���� ����� ���� �� ����)

--ORDER BY 1
SELECT *
FROM dept
ORDER BY dname;  


SELECT *
FROM dept
ORDER BY loc DESC;

--ORDER BY 2
--emp ���̺��� �������� �ִ� ����鸸 ��ȸ
--�󿩸� ���� �޴� ����� ���� ��ȸ�ǵ��� (��������)
--�� ���� ��� ������� ��������
SELECT *
FROM emp
WHERE comm IS NOT NULL
and comm !=0
ORDER BY comm DESC, empno;

--ORDER BY 3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--ORDER BY 4
SELECT *
FROM emp
WHERE deptno IN (10,30)
--WHERE (deptno = 10 OR deptno =30)
and sal >1500
ORDER BY ename DESC;

 SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =2; --ROWNUM =equal �񱳴� 1�� ����

 SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <=2; --ROWNUM�� 1���� ���������� �����ϴ� ��� ����

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20; --1���� �����ϴ� ��� ����

--SELECT ���� ORDER BY ������ �������
--SELECT -> ROWNUM -> ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--INLINE VIEW�� ���� ���� ���� �����ϰ�, �ش� ����� ROWNUM�� ����
-- * ǥ���ϰ�, �ٸ��÷�|ǥ�ǽ��� ���� ��� * �տ� ���̺��̳�, ���̺� ��Ī�� ����

SELECT ROWNUM, a.*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename) a;
     
--row 1
SELECT ROWNUM rn, empno, ename
FROM emp;
WHERE ROWNUM <=10;

--row 2
SELECT a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--row 3
--emp ���̺��� ename���� ������ ����� 11~14��°�� ��ȸ�ϴ� ������ �ۼ��ϼ���

SELECT rn, empno, ename
FROM
(SELECT ROWNUM rn, a.*
FROM (SELECT empno, ename
From emp
ORDER BY ename) a)
WHERE rn  BETWEEN 11 AND 14;


