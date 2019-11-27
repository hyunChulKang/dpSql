--cond3

SELECT userid, usernm, ALIAS, reg_dt,
    CASE
            WHEN MOD(TO_CHAR(reg_dt, 'YYYY'),2) =
            MOD(TO_CHAR(SYSDATE, 'YYYY'), 2) THEN '건강검진 대상자'
            ELSE '건강검진 비대상자'
    END     contacttododtor
FROM users 
ORDER BY userid ;

SELECT userid, usernm, alias, T_CHAR(reg_dt, 'YYYY') yyyy,
        TO_CHAR(SYSDATE, 'YYYY') this_yyyy
FROM users;

--GROUP FUNCTION
--**********GROUP BY절에 없는 컬림이  SELECT절에 나올수 없다 ********
-- (단,예외적으로 상수값들은 SELECT절에 표현이 가능(EX: '문자열', SYSDAYE ...)
--정 컬럼이나, 표현을 기준으로 여러행의 값을 한행의 결과로 생성
--COUNT-건수, SUM-합계, AVG-평균, MAX-최대값, MIN-최소값 
--전체 직원을 대상으로
--가장 높은 급여
--전체 직원을 대상으로 (14건 ->1건)
DESC emp;
SELECT MAX(sal) max_sal,--가장 높은 급여
       MIN(sal) min_sal, --가장 낲은 급여
       ROUND(AVG(sal),2) avg_sal, --전 직원의 급여 평균
       SUM(sal) sum_sal, --전 직원의 급여 합
       COUNT(sal) count_sal,--급여 건수(null이 아닌 값으면 1건)
       COUNT(mgr) count_mgr,--직원의 관리자 건수(null이 아닌 값으면 1건)
       COUNT(*) count_row --특정 컬럼의 건수가 아니라 행싀 개수를 알고 싶을때
FROM emp;


--부서번호별 그룹함수 적용
SELECT deptno,
       MAX(sal) max_sal,--부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서 가장 낲은 급여
       ROUND(AVG(sal),2) avg_sal, --부서에서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal,--부서의 급여 건수(null이 아닌 값으면 1건)
       COUNT(mgr) count_mgr,--부서 직원의 관리자 건수(null이 아닌 값으면 1건)
       COUNT(*) count_row --부서의 조직원수
FROM emp
GROUP BY deptno;


SELECT deptno, ename,
       MAX(sal) max_sal,--부서에서 가장 높은 급여
       MIN(sal) min_sal, --부서에서 가장 낲은 급여
       ROUND(AVG(sal),2) avg_sal, --부서에서 직원의 급여 평균
       SUM(sal) sum_sal, --부서 직원의 급여 합
       COUNT(sal) count_sal,--부서의 급여 건수(null이 아닌 값으면 1건)
       COUNT(mgr) count_mgr,--부서 직원의 관리자 건수(null이 아닌 값으면 1건)
       COUNT(*) count_row --부서의 조직원수
FROM emp
GROUP BY deptno, ename;


--SELECT 절에서 GROUP BY 절에 표현된 컬럼 이외의 컬럼이 올 수 없다.
--논리적으로 성립이 되지 않음(여러명의 직원 정보로 한건의 데이터로 그루핑)
-- 단, 예외적으로 상수값들은 SELECT절에 표현이 가능
SELECT deptno, ename,
       MAX(sal) max_sal,            --부서에서 가장 높은 급여
       MIN(sal) min_sal,            --부서에서 가장 낲은 급여
       ROUND(AVG(sal),2) avg_sal,   --부서에서 직원의 급여 평균
       SUM(sal) sum_sal,            --부서 직원의 급여 합
       COUNT(sal) count_sal,        --부서의 급여 건수(null이 아닌 값으면 1건)
       COUNT(mgr) count_mgr,        --부서 직원의 관리자 건수(null이 아닌 값으면 1건)
       COUNT(*) count_row           --부서의 조직원수
FROM emp
GROUP BY deptno, ename;


--그룹함수에서 NULL 컬럼은 계산에서 제외된다.
--EMP테이블에서 comm컬럼이 null이 아닌 데이터는 4건, 9건은 null)
SELECT COUNT(comm) count_comm, --NULL이 아닌 값의 개수 4
       SUM(comm) sum_comm,    --NULL값을 제외, 300+500+1400+0 = 2200
       SUM(sal + comm) tot_sal_comm, --이미 ()안에 먼저 실행됨
       SUM(sal + NVL(comm, 0)) tot_sal_comm
FROM emp;


--WHERE 절에 GROUP 함수를 표현 할 수 없다.
--1.부서별 최대 급여 구하기
--2.부서별 최대 급여 값이 3000이 넘는 행만 구하기
SELECT deptno,
       MAX(sal) max_sal
FROM emp
WHERE MAX(sal) >3000 --WHERE 절에는 GROUP 함수가 올 수 없다.
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

SELECT COUNT(DISTINCT deptno) cnt    --DISTINCT : 중복제거
FROM emp;


--JOIN
--1.테이블 구조변경(컬럼 추가)
--2.추가된 컬럼에 값을 update
--dname 컬럼을 emp 테이블에 추가
DESC emp;
DESC dept;
--컬럼추가(dname, VARCHAR2(14))
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
-- 총 6건의 데이터 변경이 필요합니다.
-- 값의 중복이 있는 형태(반 정규형)

UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES';

--emp 테이블, dept 테이블 조인

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;