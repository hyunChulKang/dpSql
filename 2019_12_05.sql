--sub4
SELECT de.deptno,de.dname, de.loc
FROM dept de,emp em
WHERE de.deptno = em.deptno(+)
AND em.ename IS NULL;

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                FROM emp);

--sub5
SELECT *
FROM product
WHERE pid  NOT IN(SELECT pid
                  FROM cycle 
                  WHERE cid = 1);
                  
--sub6
SELECT *
FROM cycle y
WHERE pid IN(SELECT pid
              FROM cycle
              WHERE cid =2)
AND cid =1;

--sub7
SELECT cy.cid,(SELECT cnm FROM customer WHERE cid =1 ) cnm, 
       cy.pid,(SELECT pnm FROM product WHERE pid =100) pnm,
       cy.day, cy.cnt
FROM cycle cy
WHERE  cy.pid IN(SELECT pid
             FROM cycle
             WHERE cid=2)
AND cy.cid =1;

SELECT cycle.cid, customer.cnm, cycle.pid, product.pnm,
        cycle.day, cycle.cnt
FROM cycle, customer, product
WHERE cycle.cid =1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND pid IN(SELECT pid
              FROM cycle
              WHERE cid =2);
              
              
--�Ŵ����� �����ϴ� ���� ���� ��ȸ
SELECT *
FROM emp e
WHERE EXISTS (SELECT 1
              FROM emp m
              WHERE m.empno = e.mgr);
--sub8            
SELECT *
FROM emp
WHERE MER IS NOT NULL;

--sub9

SELECT *
FROM product
WHERE  EXISTS (SELECT 'x'
                  FROM cycle
                  WHERE cycle.cid =1
                  AND cycle.pid = product.pid);
    

--sub10

SELECT *
FROM product
WHERE  NOT EXISTS (SELECT 'x'
                  FROM cycle
                  WHERE cycle.cid =1
                  AND cycle.pid = product.pid);


--���տ���
--UNION : ������, �� ������ �ߺ����� �����Ѵ�.
--�������� SALES�� ������ ������ȣ, ���� �̸� ��ȸ
--���Ʒ� ������� �����ϱ� ������ ������ ������ �ϰ� �ɰ��
--�ߺ��Ǵ� �����ʹ� �ѹ��� ǥ���Ѵ�.
SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';


SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION

SELECT empno, ename
FROM emp
WHERE job = 'CLERK';


SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN'

UNION ALL

SELECT empno, ename
FROM emp
WHERE job = 'SALESMAN';

-- ���տ���� ���ռ��� �÷��� ���� �ؾ��Ѵ�.
--�÷��� ������ �ٸ���� ������ ���� �ִ� ������� ������ �����ش�.
SELECT empno, ename, ' '
FROM emp
WHERE job = 'SALESMAN'

UNION ALL

SELECT empno, ename, job
FROM emp
WHERE job = 'SALESMAN';

--INTERSECT :������
--�� ���հ� �������� �����͸� ��ȸ
SELECT empno, ename
FROM emp
WHERE job IN( 'SALESMAN', 'CLERK')

INTERSECT

SELECT empno, ename
FROM emp
WHERE job IN( 'SALESMAN');

-- MINUS
-- ������ : ��, �Ʒ� ������ �������� �� ���տ��� ������ ������ ��ȸ
-- �������� ��� ������, �����հ� �ٸ��� ������ ���� ������ ��� ���տ� ������ �ش�.
SELECT empno, ename
FROM emp
WHERE job IN( 'SALESMAN', 'CLERK')

MINUS

SELECT empno, ename
FROM emp
WHERE job IN( 'SALESMAN');

--DML
--INSERT : ���̺� ���ο� �����͸� �Է�
SELECT *
FROM dept;

DELETE dept
WHERE deptno =99;
COMMIT;

--INSERT �� �÷��� ������ ���
--������ �÷��� ���� �Է��� ���� ������ ������ ����Ѵ�.
--INSERT INTO ���̺�� (�÷�1, �÷�2 ,�÷� 3..)
--             VALUES (��1, ��2 ,��3...)
--dept ���̺� 99�� �μ���ȣ, ddit ������, daejeon �������� ���� ������ �Է�
ROLLBACK;

INSERT INTO dept (deptno, dname, loc)
            VALUES(99, 'ddit', 'daejeon');
--�÷��� ����� ��� ���̺��� �÷����� ������ �ٸ��� �����ص� ����� ����.
--dept ���̺��� �÷����� :deptno, dname, location
INSERT INTO dept (loc, dname, deptno)
            VALUES('daejeon', 'ddit', 99 );
            
--�÷��� ������� �ʴ� ��� : ���̺��� �÷� ���� ������ ���� ���� ����Ѵ�.
INSERT INTO dept VALUES(99, 'ddit', 'daejeon');

--��¥ �� �Է��ϱ�
--1.SYSDATE
--2.����ڷ� ���� ���� ���ڿ��� DATE Ÿ������ �����Ͽ� �Է�

DESC emp;
INSERT INTO emp VALUES
(9998, 'sally', 'SALESMAN', NULL, SYSDATE, 5000, NULL, NULL);

SELECT *
FROM emp;
--2019�� 12�� 2�� �Ի�
INSERT INTO emp VALUES
(9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL);

--�������� �����͸� �ѹ��� �Է�
--SELECT ����� ���̺� �Է� �� �� �ִ�.
INSERT INTO emp
SELECT 9998, 'sally', 'SALESMAN', NULL, SYSDATE, 5000, NULL, NULL
FROM dual
UNION ALL
SELECT 9997, 'james', 'CLERK', NULL, TO_DATE('20191202', 'YYYYMMDD'), 500, NULL, NULL
FROM dual;