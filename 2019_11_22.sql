--WHERE8

SELECT *
FROM emp
WHERE deptno != 10  
AND hiredate > TO_DATE('19810601','YYYYMMDD');

--WHERE9

SELECT *
FROM emp
WHERE deptno NOT IN (10)
AND hiredate > TO_DATE ('19810601','YYYYMMDD');


--WHERE10
SELECT *
FROM emp
WHERE deptno IN (20, 30)
AND hiredate > TO_DATE ('19810601','YYYYMMDD');

--WHERE11
SELECT *
FROM emp
WHERE job = 'SALESMAN'
--WHERE job IN (SALESMAN)
OR hiredate > TO_DATE ('19810601','YYYYMMDD');

--WHERE12
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR  empno LIKE '78%';

--WHERE13 (LIIK 연산 사용금지)
--전제 조건 : EMPNO가 숫자여야된다 (DESC emp.empno NUMBER)
SELECT *
FROM emp
WHERE job ='SALESMAN'
OR  empno  BETWEEN 7800 AND 7899 ;
DESC emp;

--연산자 우선순위 (AND > OR)
--직원 이름이 SMITH 이거나, 직원이름이 ALLEN이면서 역할이 SALESMAN인 직원
SELECT *
FROM emp 
WHERE ename = 'SMITH'
OR ename = 'ALLEN'
AND job = 'SALESMAN';

SELECT *
FROM emp 
WHERE ename = 'SMITH'
OR (ename = 'ALLEN' AND job = 'SALESMAN');

--직원 이름이 SMITH 이거나 ALLEN 이면서 역할이 SALESMAN인 사람
SELECT *
FROM emp 
WHERE (ename = 'SMITH' OR ename = 'ALLEN' )
AND job = 'SALESMAN';

--WHERE14
--job이 SALESMAN 이거나 사원번호가 78로 시작하면서, 입사일자가 1981년6월 1일 이후
SELECT *
FROM emp 
WHERE job ='SALESMAN'
OR empno LIKE '78__'
--OR empno BETWEEN 7800 AND 7899
AND hiredate > TO_DATE('19810601', 'YYYYMMDD');

--데이터 정렬
--10, 5, 3, 2, 1

--오른차순 :1, 2, 3, 5, 10
--내림차순 :10, 5, 3, 2, 1

--오름차순 : ASC (표기를 안할경우 기본값)
--내림차순 : DESC (내림차순시, 반드시 표기)

/*

    SELECT col1, col2, ......
    FROM 테이블명
    WHERE COl1 = '값'
    ORDER BY 정렬기준 컬럼1 [ASC /DESC], 정렬기준컬럼2 ...... [ASC/DESC]
*/

--사원(emp) 테이블에서 직원의 정보를 직원 이름으로 오름차순 정렬

SELECT *
FROM emp
ORDER BY ename;

SELECT *
FROM emp
ORDER BY ename ASC; --정렬기준을 작성하지 않을 경우 오름차순 적용

--사원(emp) 테이블에서 직원의 정보를 직원 이름으로 내림차순 정렬

SELECT *
FROM emp
ORDER BY ename DESC;

--사원(emp) 테이블에서 직원의 정보를 부서번호로 내림차순 정렬
--부서번호가 같을 때는 sal 내림차순 정렬
--급여(sal)가 같을때는 이름으로 오름차순(ASC) 정렬 한다.
SELECT *
FROM emp
ORDER BY deptno ,sal DESC, ename;

--정렬 컬럼을 ALIAS로 표현

SELECT deptno, sal ,ename nm 
FROM emp
ORDER BY nm;

--조회하는 컬럼의 위치 인덱스로 표현 가능
SELECT deptno, sal ,ename nm 
FROM emp
ORDER BY 3; --(3번째 컬럼으로 조회한다는뜻 -추천 하지는 않음(컬럼 추가시 의도하는 않은 결과가 나올 수 있음)

--ORDER BY 1
SELECT *
FROM dept
ORDER BY dname;  


SELECT *
FROM dept
ORDER BY loc DESC;

--ORDER BY 2
--emp 테이블에서 상여정보가 있는 사람들만 조회
--상여를 많이 받는 사람이 먼저 조회되도록 (내림차순)
--상여 같을 경우 사번으로 오름차순
SELECT *
FROM emp
WHERE comm IS NOT NULL
and comm !=0
ORDER BY comm DESC, empno;

--ORDER BY 3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

--ORDER BY 4
SELECT *
FROM emp
WHERE deptno IN (10,30)
--WHERE (deptno = 10 OR deptno =30)
and sal >1500
ORDER BY ename DESC;

 SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM =2; --ROWNUM =equal 비교는 1만 가능

 SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM <=2; --ROWNUM을 1부터 순차적으로 적용하는 경우 가능

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 20; --1부터 시작하는 경우 가능

--SELECT 절과 ORDER BY 구문의 실행순서
--SELECT -> ROWNUM -> ORDER BY
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;

--INLINE VIEW를 통해 정렬 먼저 실행하고, 해당 결과에 ROWNUM을 적용
-- * 표현하고, 다른컬럼|표션식을 썻을 경우 * 앞에 테이블이나, 테이블 별칭을 적용

SELECT ROWNUM, a.*
FROM(SELECT empno,ename
     FROM emp
     ORDER BY ename) a;
     
--row 1
SELECT ROWNUM rn, empno, ename
FROM emp;
WHERE ROWNUM <=10;

--row 2
SELECT a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp) a
WHERE rn BETWEEN 11 AND 14;

--row 3
--emp 테이블에서 ename으로 정렬한 결과에 11~14번째행 조회하는 쿼리를 작석하세요

SELECT rn, empno, ename
FROM
(SELECT ROWNUM rn, a.*
FROM (SELECT empno, ename
From emp
ORDER BY ename) a)
WHERE rn  BETWEEN 11 AND 14;


