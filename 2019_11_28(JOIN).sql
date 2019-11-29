
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;     --�����
--AND emp.deptno =10;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

Plan hash value: 615168685
 
---------------------------------------------------------------------------
| Id  | Operation          | Name | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------
|   0 | SELECT STATEMENT   |      |    14 |   588 |     7  (15)| 00:00:01 |
|*  1 |  HASH JOIN         |      |    14 |   588 |     7  (15)| 00:00:01 |
|   2 |   TABLE ACCESS FULL| DEPT |     4 |    88 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS FULL| EMP  |    14 |   280 |     3   (0)| 00:00:01 |
---------------------------------------------------------------------------
 --�д� ���� 
 --2-3-1-0 (2,3�� ����  1, 0 �θ�)
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
-- where���� ���� ������
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;     --�����
--AND emp.deptno =10;


--natural join : ���� ���̺� ���� Ÿ��, �����̸��� �÷�����
--               ���� ���� ���� ��� ����

DESC emp; 
DESC dept; 

SELECT *
FROM emp NATURAL JOIN dept;

--ANSI SQL
SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--Oracle ����
SELECT a.deptno, empno, ename --���̺� �̸� ���̴°� ���̺� �� ������������
FROM emp a, dept
WHERE a.deptno = dept.deptno;

--JOIN USING
--join �Ϸ��� �ϴ� ���̺� ������ �̸��� �÷��� �ΰ� �̻��� ��
--join �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--Oracle SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


--ANSI JOIN with ON
--���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ���
--�����ڰ� ���� ������ ���� ������ ��

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--Oracle

SELECT ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELEF JOIN : ���� ���̺� ����
--emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
--���� ������ ������ ��ȸ
--�����̸�, �������̸�
--ANSI
--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--Oracle

SELECT e.ename, m.ename, b.ename, k.ename
FROM emp e, emp m, emp b, emp k
WHERE e.mgr = m.empno 
AND m.mgr = b.empno
AND b.mgr = k.empno;


--�������̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON( e.mgr = m.empno)
    JOIN emp t ON (m.mgr = t.empno)
    JOIN emp k ON (t.mgr = k.empno);
    
--������ �̸��� �ش� ������ ������ �̸��� ��ȸ�Ѵ�.
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ

SELECT e.ename, m.ename, b.ename, k.ename
FROM emp e, emp m, emp b, emp k
WHERE e.mgr = m.empno 
AND m.mgr = b.empno
AND b.mgr = k.empno;
SELECT *
FROM;

SELECT s.ename, m.ename
FROM  emp s, emp m
WHERE s.empno BETWEEN 7369 AND 7698
AND s.mgr = m.empno;

--ANSI
SELECT s.ename, m.ename
FROM  emp s JOIN emp m ON(s.mgr = m.empno)
WHERE s.empno BETWEEN 7369 AND 7698;

--NON EQUI JOIN : ���� ������ = (equal)�� �ƴ� JOIN
-- !=, BETWEEN AND

SELECT *
FROM salgrade;

SELECT empno, ename, sal  /* �޿� grade */
FROM emp;

--Oracle
SELECT empno,ename,sal ,grade
FROM salgrade s, emp e
WHERE e.sal BETWEEN s.losal AND s.hisal;

--ANSI
SELECT empno,ename,sal ,grade
FROM salgrade  JOIN emp  ON sal BETWEEN losal AND hisal; 


--join00

SELECT e.empno, e.ename, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.deptno;

--join01
SELECT empno, ename, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND (e.deptno = 10 
OR e.deptno =30);

--join02

SELECT e.empno, e.ename,e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
ORDER BY e.deptno;

--join03

SELECT e.empno, e.ename,e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno >7600
ORDER BY e.deptno;


SELECT empno, ename, sal, e.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal >2500
AND e.empno >7600;
--join04

SELECT e.empno, e.ename,e.sal, e.deptno, d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND e.sal > 2500
AND e.empno >7600
AND d.dname = 'RESEARCH'
ORDER BY e.deptno;

--join1

SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod p, lprod l
WHERE p.prod_lgu = l.lprod_gu;

--join2
SELECT buyer_id, b.buyer_name, p.prod_id, p.prod_name
FROM prod p, buyer b
WHERE p.prod_buyer = b.buyer_id
ORDER BY b.buyer_id;

SELECT*
FROM buyer;

SELECT*
FROM prod;
--join3

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
AND cart_prod = prod_id;

--join4

SELECT cs.cid, cnm, pid, day, cnt
FROM customer cs, cycle cy
WHERE cs.cid = cy.cid
AND (CNM = 'brown' 
OR CNM = 'sally');

--join5

SELECT cy.cid, cs.cnm, cy.pid, pr.pnm, cy.cnt
FROM customer cs, cycle cy, product pr
WHERE cs.cid = cy.cid
AND cy.pid = pr.pid
AND (CNM = 'brown' 
OR CNM = 'sally');

--join6
--SELECT cy.cid, cs.cnm, cy.pid, pr.pnm, cy.cnt
SELECT   cy.cid , cs.cnm,cy.pid, pr.pnm , sum(cy.cnt) cnt
FROM customer cs, cycle cy, product pr
WHERE cs.cid = cy.cid
AND cy.pid = pr.pid
GROUP BY cy.pid, cy.cid, cs.cnm, pr.pnm;

--join7

SELECT cy.pid, pr.pnm, sum(cy.cnt) cnt
FROM customer cs, cycle cy, product pr
WHERE cs.cid = cy.cid
AND cy.pid = pr.pid
GROUP BY cy.pid, pr.pnm
ORDER BY cy.pid;



SELECT *
FROM customer;

SELECT *
FROM cycle;

SELECT *
FROM product;

SELECT *
FROM HR;