
--SMITH�� ���� �μ� ã��
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');
                
SELECT empno, ename, deptno
       ,(SELECT dname FROM dept 
         WHERE dept.deptno = emp.deptno) dname
FROM emp;

--SCALAR SUBQUERY 
--SELECT ���� ǥ���� ���� ����
--�� ��, �� COLUMN�� ��ȸ�ؾ� �Ѵ�.

SELECT empno, ename, deptno
       ,(SELECT dname FROM dept) dname
FROM emp;

--inline VIEW
--FROM ���� ���Ǵ� ��������

--SUBQUERY
--WHERE���� ���Ǵ� ��������


--SUB1

SELECT *
FROM emp;

SELECT COUNT(*) cnt
FROM emp
WHERE sal >(SELECT AVG(sal)
            FROM emp);
            
--SUB2
SELECT *
FROM emp
WHERE sal >(SELECT AVG(sal)
            FROM emp);

SELECT *
FROM emp;

--SUB3  SMITH,WARD�� ���� �μ��� ��� ������� ��ȸ ����
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE deptno < any
              (SELECT deptno 
               FROM emp 
               WHERE ename IN('SMITH','WARD'));
SELECT *
FROM TABLE(dbms_xplan.display);

--IN(20,30);
SELECT *
FROM emp
WHERE deptno IN(SELECT danme FROM dept WHERE dept.deptno= emp.deptno
                AND dname IN('SMITH','WARD'));
                
                
--SMITH Ȥ�� WARD ���� �޿��� ���� �޴� ������ȸ

SELECT*
FROM emp
WHERE sal <ANY( SELECT sal 
                FROM emp 
                WHERE ename IN('SMITH', 'WARD'));

SELECT*
FROM emp
WHERE sal <= ALL( SELECT sal 
                FROM emp 
                WHERE ename IN('SMITH', 'WARD'));
                
--������ ������ �����ʴ� ��� ���� ��ȸ
--NOT IN ������ ���� NULL�� �����Ϳ� �������� �ʾƾ� ������ �Ѵ�.
SELECT *
FROM emp
WHERE empno NOT IN
            (SELECT NVL(mgr, -1) --NULL ���� �������� �������� �����ͷ� ġȯ
            FROM emp);
            
SELECT *
FROM emp
WHERE empno NOT IN
            (SELECT mgr --NULL ���� �������� �������� �����ͷ� ġȯ
            FROM emp
            WHERE mgr IS NOT NULL);
            
--pair wise(���� �÷��� ���� ���ÿ� ���� �ؾ��ϴ� ���)
--ALLEN, CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� ��� ���� ��ȸ
-- (7698,30)
-- (7839,10)


SELECT *
FROM emp
WHERE (mgr, deptno) IN( SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
--�ų�����7698 �̰ų� 7839�̸鼭
--�ҼӺμ��� 10�� �̰ų� 30���� ���� ���� ��ȸ
-- 7698,10


--non pari wise                        
SELECT *
FROM emp
WHERE mgr IN( SELECT mgr
              FROM emp
              WHERE empno IN (7499, 7782))
AND deptno IN( SELECT  deptno
               FROM emp
               WHERE empno IN (7499, 7782));
                
                
--���ȣ ���� ��������
--���������� �÷��� ������������ ������� �ʴ� ������ ��������


--������ �޿� ��պ��� ���� �޿��� �޴� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE sal >(SELECT AVG(sal)
            FROM emp);
            
--��ȣ���� ��������
--�ش������� ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ

SELECT *
FROM emp m 
WHERE sal >( SELECT AVG(sal)
            FROM emp
            WHERE deptno = m.deptno);


SELECT *
FROM emp 
WHERE sal >( SELECT AVG(sal)
            FROM emp
            WHERE deptno = deptno);