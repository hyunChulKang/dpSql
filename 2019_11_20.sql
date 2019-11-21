SELECT --'SELECT * FROM '|| table_name || ';' query
    --CONCAT함수만 이용해서 
    CONCAT(CONCAT('SELCT *FROM ',table_name),';') query
FROM user_tables;


SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid ='brown';

--emp테이블의 전체 데이터 조회 (모든 행(row), 열(column)

SELECT * 
FROM emp;

--부서번호(deptno)가 20보다 크거나 같은 부서에서 일하는 직원 정보 조회

SELECT * 
FROM emp
WHERE deptno >= 20 ORDER BY empno DESC;

--사원번호(empno)가 7700보다 크거나 같은 사원의 정보를 조회

SELECT * 
FROM emp
WHERE empno >= 7700;

--사원 입사일자(hiredate)가 1982년 1월 1일 이후인 사원 정보 조회
--문자열 --> 날짜 타입으로 변경 TO_DATE('날짜문자열', '날짜문자열포맷')
--한국 날짜 표현 : 년-월-일
--미국 날짜 표현 : 일-월-년
SELECT empno, ename, hiredate,
    2000 no, '문자열상수' str, TO_DATE('19810101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');

--범위 조회(BETWEEN 시작기준 AND 종료기준)
--시작기준, 종료기준을 포함
--사원중에서 급여(sal)rk 1000보다 크거나 같고, 2000보다 작거나 같은 사원 정보조회
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--BETWEEN AND 연산자는 부등호 연산자로 대체 가능

SELECT *
FROM emp
WHERE sal >= 1000 
AND sal <= 2000;

--조건에 맞는 데이터 조회 (BETWEEN...AND...실습 where1)
--emp테이블에서 입사 일자가 1982년 1월 1일 이후 부터 1983년1월 1일 이전인 사원의
--ename, hiredate 데이터를 조회하는 쿼리를 작성하시오
--단 연산자는 between을 사용한다.

SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101', 'YYYYMMDD')
AND TO_DATE('19830101', 'YYYYMMDD');

SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD')
AND hiredate <= TO_DATE('19830101', 'YYYYMMDD');
