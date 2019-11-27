--cond3

SELECT userid, usernm, ALIAS, reg_dt,
    CASE
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'),2) =
            MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
    END     contacttododtor
FROM users 
ORDER BY userid ;

SELECT userid, usernm, alias, T_CHAR(reg_dt, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'YYYY') this_yyyy
FROM users;

--GROUP FUNCTION
--**********GROUP BY���� ���� �ø���  SELECT���� ���ü� ���� ********
-- (��,���������� ��������� SELECT���� ǥ���� ����(EX: '���ڿ�', SYSDAYE ...)
--�� �÷��̳�, ǥ���� �������� �������� ���� ������ ����� ����
--COUNT-�Ǽ�, SUM-�հ�, AVG-���, MAX-�ִ밪, MIN-�ּҰ� 
--��ü ������ �������
--���� ���� �޿�
--��ü ������ ������� (14�� ->1��)
DESC emp;
SELECT MAX(sal) max_sal,--���� ���� �޿�
       MIN(sal) min_sal, --���� �F�� �޿�
       ROUND(AVG(sal),2) avg_sal, --�� ������ �޿� ���
       SUM(sal) sum_sal, --�� ������ �޿� ��
       COUNT(sal) count_sal,--�޿� �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(mgr) count_mgr,--������ ������ �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(*) count_row --Ư�� �÷��� �Ǽ��� �ƴ϶� ���� ������ �˰� ������
FROM emp;


--�μ���ȣ�� �׷��Լ� ����
SELECT deptno,
       MAX(sal) max_sal,--�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ����� ���� �F�� �޿�
       ROUND(AVG(sal),2) avg_sal, --�μ����� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal,--�μ��� �޿� �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(mgr) count_mgr,--�μ� ������ ������ �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(*) count_row --�μ��� ��������
FROM emp
GROUP BY deptno;


SELECT deptno, ename,
       MAX(sal) max_sal,--�μ����� ���� ���� �޿�
       MIN(sal) min_sal, --�μ����� ���� �F�� �޿�
       ROUND(AVG(sal),2) avg_sal, --�μ����� ������ �޿� ���
       SUM(sal) sum_sal, --�μ� ������ �޿� ��
       COUNT(sal) count_sal,--�μ��� �޿� �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(mgr) count_mgr,--�μ� ������ ������ �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(*) count_row --�μ��� ��������
FROM emp
GROUP BY deptno, ename;


--SELECT ������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����.
--�������� ������ ���� ����(�������� ���� ������ �Ѱ��� �����ͷ� �׷���)
-- ��, ���������� ��������� SELECT���� ǥ���� ����
SELECT deptno, ename,
       MAX(sal) max_sal,            --�μ����� ���� ���� �޿�
       MIN(sal) min_sal,            --�μ����� ���� �F�� �޿�
       ROUND(AVG(sal),2) avg_sal,   --�μ����� ������ �޿� ���
       SUM(sal) sum_sal,            --�μ� ������ �޿� ��
       COUNT(sal) count_sal,        --�μ��� �޿� �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(mgr) count_mgr,        --�μ� ������ ������ �Ǽ�(null�� �ƴ� ������ 1��)
       COUNT(*) count_row           --�μ��� ��������
FROM emp
GROUP BY deptno, ename;


--�׷��Լ����� NULL �÷��� ��꿡�� ���ܵȴ�.
--EMP���̺��� comm�÷��� null�� �ƴ� �����ʹ� 4��, 9���� null)
SELECT COUNT(comm) count_comm, --NULL�� �ƴ� ���� ���� 4
       SUM(comm) sum_comm,    --NULL���� ����, 300+500+1400+0 = 2200
       SUM(sal + comm) tot_sal_comm, --�̹� ()�ȿ� ���� �����
       SUM(sal + NVL(comm, 0)) tot_sal_comm
FROM emp;


--WHERE ���� GROUP �Լ��� ǥ�� �� �� ����.
--1.�μ��� �ִ� �޿� ���ϱ�
--2.�μ��� �ִ� �޿� ���� 3000�� �Ѵ� �ุ ���ϱ�
SELECT deptno,
       MAX(sal) max_sal
FROM emp
WHERE MAX(sal) >3000 --WHERE ������ GROUP �Լ��� �� �� ����.
GROUP BY deptno;

SELECT deptno 
FROM 
(SELECT deptno,
       MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000)
WHERE deptno =20;

-- grp1

SELECT
       MAX(sal) max_sal,            
       MIN(sal) min_sal,            
       ROUND(AVG(sal),2) avg_sal,   
       SUM(sal) sum_sal,            
       COUNT(sal) count_sal,        
       COUNT(mgr) count_mgr,        
       COUNT(*) count_row           
FROM emp;

--grp2
SELECT deptno,
       MAX(sal) max_sal,            
       MIN(sal) min_sal,            
       ROUND(AVG(sal),2) avg_sal,   
       SUM(sal) sum_sal,            
       COUNT(sal) count_sal,        
       COUNT(mgr) count_mgr,        
       COUNT(*) count_row           
FROM emp
GROUP BY deptno;

--grp3
SELECT DECODE(deptno, 10, 'ACCOUNT', 20, 'RESEARCH', 30, 'SALES') dname, 
       MAX(sal) max_sal,            
       MIN(sal) min_sal,            
       ROUND(AVG(sal),2) avg_sal,   
       SUM(sal) sum_sal,            
       COUNT(sal) count_sal,        
       COUNT(mgr) count_mgr,        
       COUNT(*) count_row           
FROM emp
GROUP BY deptno
ORDER BY deptno;

--grp4
SELECT hire_YYYYMM, COUNT(*) cnt
FROM
    (SELECT TO_CHAR(hiredate, 'YYYYMM') hire_YYYYMM
    FROM emp)
GROUP BY hire_YYYYMM;

--grp5
SELECT TO_CHAR(hiredate, 'YYYY'),COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate, 'YYYY');

--grp6
SELECT COUNT(*) cnt
FROM dept;

--grp7
SELECT COUNT(*) cnt
FROM (SELECT deptno
      FROM emp GROUP BY deptno);

SELECT COUNT(DISTINCT deptno) cnt    --DISTINCT : �ߺ�����
FROM emp;


--JOIN
--1.���̺� ��������(�÷� �߰�)
--2.�߰��� �÷��� ���� update
--dname �÷��� emp ���̺� �߰�
DESC emp;
DESC dept;
--�÷��߰�(dname, VARCHAR2(14))
ALTER TABLE emp ADD(dname VARCHAR2(14));
DESC emp;

UPDATE emp SET dname = CASE
                            WHEN deptno = 10 THEN 'ACCOUNTING'
                            WHEN deptno = 20 THEN 'RESEARCH'
                            WHEN deptno = 30 THEN 'SALES'
                        END;
COMMIT;

SELECT *
FROM emp;

-- SALES --> MARKET SALES
-- �� 6���� ������ ������ �ʿ��մϴ�.
-- ���� �ߺ��� �ִ� ����(�� ������)

UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES';

--emp ���̺�, dept ���̺� ����

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;