
-- OUTER join  : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는
-- 나오도록 하는 join
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
-- 테이블 1과 테이블 2를 조인할때 조인에 실패하더라도 테이블1쪽에 데이터는
-- 조회가 되도록 한다.
-- JOIN에 실패한 행에서 테이블 2의 컬럼값은 존재하지 않으므로 NULL로 표시 된다.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
--ON절에 작성한것과 WHERE절에 작성한것 비교
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno)
WHERE m.deptno =10;

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno AND m.deptno =10);
           
-- oracle  outer join syntax
--일반조인과 차이점은 컬럼명에 (+)표시
--(+) 표시 : 데이터가 존재하지 않는데 나와야 하는 테이블의 컬럼
-- 직원 LEFT OUTER JOIN 매니저
--      ON(직원.매니저 = 매니저.직원번호)
-- oracle  outer
-- WHERE 직원.매니저번호 = 매니저.직원번호(+) -- 매니저쪽 데이터가 존재하지않음

--ansi
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--oracle outer
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE  e.mgr = m.empno(+);


--매니저 부서번호 제한
--ANSI SQL WHERE 절에 기술
-- --> OUTER JOIN이 적용되지 않은 상황
--OUTER JOIN이 적용되어야 하는 테이블의 모든 컬럼에 (+)가 붙어야 된다.
--ansi sql의 on절에 기술한 경우와 동일

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE  e.mgr = m.empno(+)
AND m.deptno(+) = 10;


--emp 테이블에는 14명의 직원이 있고 14명 10, 20, 30부서중에 한 부서에
-- 속한다.
-- 하지만 dept테이블에 10, 20, 30, 40번 부서가 존재
-- 부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성

SELECT d.deptno, d.dname, COUNT(e.deptno)
FROM emp e, dept d
WHERE d.deptno = e.deptno(+)
GROUP BY e.deptno, d.dname,  d.deptno
ORDER BY e.deptno;

-- dept : deptno, dname
-- inline : deptno, cnt(직원의 수)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno
ORDER BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);


--ANSI
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN  (SELECT deptno, COUNT(*) cnt
                            FROM emp
                            GROUP BY deptno
                            ORDER BY deptno) emp_cnt
                        ON (dept.deptno = emp_cnt.deptno);
                        
                        
                        
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER -중복데이터 한거만 남기기
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m
           ON (e.mgr = m.empno);           

--ourterjoin1

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);

--ANSI
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON(b.buy_date = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod);



--outerjoin2

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);




SELECT buy_date
FROM buyprod b, p;

SELECT *
FROM buyprod;

