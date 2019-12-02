
EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;     --연결고리
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
 --읽는 순서 
 --2-3-1-0 (2,3은 형제  1, 0 부모)
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
-- where절이 같지 않을때
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno;     --연결고리
--AND emp.deptno =10;


--natural join : 조인 테이블간 같은 타입, 같은이름의 컬럼으로
--               같은 값을 갖는 경우 조인

DESC emp; 
DESC dept; 

SELECT *
FROM emp NATURAL JOIN dept;

--ANSI SQL
SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--Oracle 문법
SELECT a.deptno, empno, ename --테이블 이름 붙이는건 테이블에 다 가지고있을때
FROM emp a, dept
WHERE a.deptno = dept.deptno;

--JOIN USING
--join 하려고 하는 테이블간 동일한 이름의 컬럼이 두개 이상일 때
--join 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--Oracle SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;


--ANSI JOIN with ON
--조인 하고자 하는 테이블의 컬럼 이름이 다를때
--개발자가 조인 조건을 직접 제어할 때

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--Oracle

SELECT ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELEF JOIN : 같은 테이블간 조인
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원 관리자 정보를 조회
--직원이름, 관리자이름
--ANSI
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno);

--Oracle

SELECT e.ename, m.ename, b.ename, k.ename
FROM emp e, emp m, emp b, emp k
WHERE e.mgr = m.empno 
AND m.mgr = b.empno
AND b.mgr = k.empno;


--여러테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, t.ename, k.ename
FROM emp e JOIN emp m ON( e.mgr = m.empno)
    JOIN emp t ON (m.mgr = t.empno)
    JOIN emp k ON (t.mgr = k.empno);
    
--직원의 이름과 해당 직원의 관리자 이름을 조회한다.
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회

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

--NON EQUI JOIN : 조인 조건이 = (equal)이 아닌 JOIN
-- !=, BETWEEN AND

SELECT *
FROM salgrade;

SELECT empno, ename, sal  /* 급여 grade */
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
FROM regions;


SELECT *
FROM countries;


SELECT *
FROM locations;

SELECT *
FROM departments;

SELECT *
FROM employees;

select 
        CONCAT(first_name, last_name) fullname
FROM employees;


-- join8
SELECT co.region_id, re.region_name, co.country_name
FROM  countries co, regions re
WHERE  co.region_id = re.region_id
AND re.region_name = 'Europe';


-- join9
--(row 9 - France, Denmark, Belgium 3개 국가에 속한 locationts 정보는 미존재
--나머지 5개중에 다수의 location 정보를 갖고 있는 국가가 존재한다.)
SELECT co.region_id, re.region_name, co.country_name, lo.city
FROM  countries co, regions re, locations lo
WHERE  co.region_id = re.region_id
AND co.country_id = lo.country_id
AND re.region_name = 'Europe';

--join10

SELECT co.region_id, re.region_name, co.country_name, lo.city , department_name
FROM  countries co, regions re, locations lo, departments de
WHERE  co.region_id = re.region_id
AND co.country_id = lo.country_id
AND lo.location_id = de.location_id
AND re.region_name = 'Europe';


--join11

SELECT co.region_id, re.region_name, co.country_name,
       lo.city, de.department_name, CONCAT(first_name, last_name) name
FROM  countries co, regions re, locations lo, departments de, employees em
WHERE  co.region_id = re.region_id
AND co.country_id = lo.country_id
AND lo.location_id = de.location_id
AND de.department_id = em.department_id
AND re.region_name = 'Europe';


--join12
select em.employee_id, CONCAT(em.first_name,em.last_name) name,
       em.job_id, jo.job_title
FROM employees em, jobs jo
WHERE em.job_id = jo.job_id;


--join13

select em.manager_id mng_id ,CONCAT(em2.first_name,em2.last_name) mgr_name, em.employee_id , CONCAT(em.first_name,em.last_name) name,jo.job_id, jo.job_title
FROM employees em, jobs jo, employees em2
WHERE em.job_id = jo.job_id
AND em.MANAGER_ID = em2.EMPLOYEE_ID;
