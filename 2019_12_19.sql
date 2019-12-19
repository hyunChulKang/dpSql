--����̸�, �����ȣ, ��ü�����Ǽ�
SELECT A.* 
FROM 
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC
)A
;

SELECT a.ename, a.sal, a.deptno, b.rn
FROM
(SELECT ename, sal, deptno, ROWNUM j_rn
FROM
(SELECT ename, sal, deptno                           
FROM emp
ORDER BY deptno, sal DESC))a,
(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.* ,a.rn
    FROM
        (SELECT ROWNUM rn
            FROM dual
            CONNECT BY LEVEL <=(SELECT COUNT(*) FROM emp)) a,
        (SELECT deptno, COUNT(*) cnt
            FROM emp
            GROUP BY deptno) b 
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn)) b
WHERE a.j_rn = b.j_rn;


--ana0-�� �м��Լ���
SELECT ename, sal, deptno,
        RANK() OVER (PARTITION BY deptno ORDER BY sal ) rank,
        DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal ) dense_rank,
        ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal ) row_rank
FROM emp;

--no_ana1
SELECT empno,ename, sal, deptno,
        RANK() OVER (ORDER BY sal DESC,empno) rank,
        DENSE_RANK() OVER (ORDER BY sal DESC,empno) dense_rank,
        ROW_NUMBER() OVER (ORDER BY sal DESC,empno) row_rank
FROM emp
;
--no_ana2
--�м��Լ����X
SELECT b.empno, b.ename, b.deptno, a.cnt
FROM
(SELECT empno,ename, deptno
FROM emp) b,
(SELECT deptno,COUNT(deptno) cnt
FROM emp
GROUP BY deptno)a
WHERE a.deptno = b.deptno
ORDER BY a.cnt, b.ename;

--�м��Լ����
--ana1
SELECT empno, ename, deptno,
        COUNT(*)OVER(PARTITION BY deptno) cnt      --�ϳ��� �÷�
FROM emp;

--ana2
SELECT empno, ename,sal, deptno,
        ROUND(AVG(SAL)OVER(PARTITION BY deptno),2) cnt      --�ϳ��� �÷�
FROM emp
GROUP BY empno, ename,sal, deptno;

--ana3
SELECT empno, ename,sal, deptno,
        MAX(SAL)OVER(PARTITION BY deptno) MAX_SAL      --�ϳ��� �÷�
FROM emp
GROUP BY empno, ename,sal, deptno;


--ana4
SELECT empno, ename,sal, deptno,
        MIN(SAL)OVER(PARTITION BY deptno) MAX_SAL      --SAL�ּҰ��� ���ϴµ� deptno�� ��Ƽ���� �д�
FROM emp
GROUP BY empno, ename,sal, deptno;


--��ü����� ������� �޿������� �ڽź���, �Ѵܰ� ���� ����� �޿�
--(�޿��� ���� ��� �Ի����ڰ� ���� ����� ���� ����)
SELECT empno, ename, hiredate, sal,
       LAG(sal)OVER(ORDER BY sal DESC, hiredate) lead_sal,
       LEAD(sal)OVER(ORDER BY sal DESC, hiredate) lead_sal
FROM emp;
--ORDER BY sal DESC , hiredate;

--ana6
SELECT empno, ename, hiredate, job, sal,
       LAG(sal)OVER(PARTITION BY job ORDER BY job ) lag_sal         --�޿�, job��(��Ƽ�ǻ��)
FROM emp;
--ORDER BY sal DESC , hiredate;
--no_ana3

(SELECT a.*, ROWNUM-1 rn2
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal)a)d,
(SELECT b.*, ROWNUM rn1
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal)b)c
WHERE c.sal = c.sal;

SELECT d.empno, d.ename, d.sal
FROM
(SELECT b.empno, b.ename, b.sal,ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal)b)d,
(SELECT a.empno, a.ename, a.sal,ROWNUM rn
FROM
(SELECT empno, ename, sal
FROM emp
ORDER BY sal)A)c
WHERE c.rn >=d.rn
GROUP BY d.empno, d.ename, d.sal 
ORDER BY SAL;