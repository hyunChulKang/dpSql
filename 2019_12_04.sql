
--SMITH가 속한 부서 찾기
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
--SELECT 절에 표현된 서브 쿼리
--한 행, 한 COLUMN을 조회해야 한다.

SELECT empno, ename, deptno
       ,(SELECT dname FROM dept) dname
FROM emp;

--inline VIEW
--FROM 절에 사용되는 서브쿼리

--SUBQUERY
--WHERE절에 사용되는 서브쿼리


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

--SUB3  SMITH,WARD가 속한 부서의 모든 사원정보 조회 쿼리
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
                
                
--SMITH 혹은 WARD 보다 급여를 적게 받는 직원조회

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
                
--관리자 역할을 하지않는 사원 정보 조회
--NOT IN 연산자 사용시 NULL이 데이터에 존재하지 않아야 정상동작 한다.
SELECT *
FROM emp
WHERE empno NOT IN
            (SELECT NVL(mgr, -1) --NULL 값을 존재하지 않을만한 데이터로 치환
            FROM emp);
            
SELECT *
FROM emp
WHERE empno NOT IN
            (SELECT mgr --NULL 값을 존재하지 않을만한 데이터로 치환
            FROM emp
            WHERE mgr IS NOT NULL);
            
--pair wise(여러 컬럼의 값을 동시에 만족 해야하는 경우)
--ALLEN, CLARK의 매니저와 부서번호가 동시에 같은 사원 정보 조회
-- (7698,30)
-- (7839,10)


SELECT *
FROM emp
WHERE (mgr, deptno) IN( SELECT mgr, deptno
                        FROM emp
                        WHERE empno IN (7499, 7782));
                        
--매너지가7698 이거나 7839이면서
--소속부서가 10번 이거나 30번인 직원 정보 조회
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
                
                
--비상호 연관 서브쿼리
--메인쿼리의 컬럼을 서브쿼리에서 사용하지 않는 형태의 서브쿼리


--직원의 급여 평균보다 높은 급여를 받는 직원 정보 조회
SELECT *
FROM emp
WHERE sal >(SELECT AVG(sal)
            FROM emp);
            
--상호연관 서브쿼리
--해달직원이 속한 부서의 급여평균보다 높은 급여를 받는 직원 조회

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