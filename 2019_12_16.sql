--GROUP SET(col1, col2)
--������ ���� ��� ����
--�����ڰ� GROUP BY�� ������ ���� ����Ѵ�.
--ROLLUP�� �޸� ���⼺�� ���� �ʴ´�.
--GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)

--GROUPING SETS(col1, col2)
--GROUP BY COl1
--UNION ALL
--GROUP BY col2

--emp ���̺��� ������ job(����)�� �޿� (sal)+��(comm)��,
--                     deptno(�μ�)�� �޿�(sal)+ ��(comm)�� ���ϱ�
--������� (GROUP FUNCTION) : 2���� SQL�ۼ� �ʿ�(UNINON / NUION ALL)
SELECT job,null deptno/*(Ÿ�Ը��߱����� ���� �÷�����)*/, sum(sal+ NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job



UNION ALL       --�÷��� ���� ������, Ÿ�� ����
SELECT '',deptno, sum(sal+ NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

--GROUP SETS ������ �̿��Ͽ� ���� SQL�� ���տ����� ������� �ʰ���
--���̺��� �ѹ� �о ó��\
SELECT job, deptno, SUM(sal +NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job,deptno);    -- , �� �������� GROUP BY �� ������ ���Ҽ� �ִ�.

--job, deptno�� �׷����� �� sal_comm��
--mgr�� �׷����� �� sal+comm ��
--GROUP BY job, deptno
--UNION ALL
--GROUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal +NVL(comm , 0)) sal_comm_sum
       , GROUPING(job),GROUPING(deptno),GROUPING(mgr) --null�� ������ null���� �ƴϸ� �׷��Լ��� ���� ������ null���� GROUPING���� Ȯ��
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

--CUBE (col1, col2,,...)
-- ������ �÷��� ��� ������ �������� GROUP BY suset�� �����.
--CUBE�� ������ �÷��� 2���� ��� : ������ ���� 4��
--CUBE�� ������ �÷��� 3���� ��� : ������ ���� 8��
--CUBE�� ������ �÷����� 2�� ������ �Ѱ���� ������ ���� ������ �ȴ�(2^n)
--�÷��� ���׸� �������� ������ ������ ���ϱ޼������� �þ� ���� ������
--���� ������� �ʴ´�.

--job, deptno �� �̿��Ͽ� CUBE ����
SELECT job, deptno, SUM(sal+ NVL(comm, 0)) sal_comm_sum
    ,GROUPING(job),GROUPING(deptno)
FROM emp
GROUP BY CUBE(job, deptno);
--job, detpno
--1,    1    -->GROUP BY job, deptno
--1,    0    -->GROUP BY job
--0,    1    -->GROUP BY deptno
--0,    0    -->GROUP BY --emp ���̺��� ��� �࿡ ���� GROUP BY

--GROUP BY ROLLUP, CUBE�� ���� ����ϱ�
--������ ������ �����غ��� ���� ����� ������ �� �ִ�.
-- GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal +NVL(comm, 0 )) sal_comm_sum
FROM emp
GROUP BY  job, ROLLUP(deptno), CUBE(mgr);

SELECT *
FROM emp;
WHERE deptno = 10;
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);


UPDATE dept_test 
SET empcnt = (SELECT COUNT(deptno) cnt
            FROM emp
            GROUP BY deptno);
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD(empcnt NUMBER);

UPDATE dept_test
SET empcnt = (SELECT COUNT(*)
              FROM emp
              WHERE emp.deptno = dept_test.deptno);
--deptno= 10 --> empcnt = 3;
--deptno= 20 --> empcnt = 5;
--deptno= 30 --> empcnt = 6;
SELECT *
FROM dept_test;

SELECT COUNT(*) empcnt
FROM dept_test;

DROP TABLE dept_test;
insert into dept_test VALUES (99, 'it1', 'daejeon');
insert into dept_test VALUES (98, 'it2', 'daejeon');

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     GROUP BY deptno);

SELECT DEPTNO
FROM dept_test;

SELECT *
FROM emp;

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;
--sub_3
UPDATE emp_test SET sal = sal + 200
WHERE sal <(SELECT ROUND(AVG(sal),2)
            FROM emp
            WHERE deptno = emp_test.deptno);
ROLLBACK;
SELECT deptno, AVG(sal)
FROM emp_test
GROUP BY deptno;

--MERGE ������ �̿��� ������Ʈ
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
FROM emp_test
GROUP BY deptno) b
ON (a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal =  sal +200
    WHERE a.sal < b.avg_sal;
    
    ROLLBACK;
    
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
FROM emp_test
GROUP BY deptno) b
ON (a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal =  CASE
                        WHEN a.sal < b.avg_sal THEN sal +200
                        ELSE sal
                        end;