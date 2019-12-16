--GROUP SET(col1, col2)
--다음과 같은 결과 동일
--개발자가 GROUP BY의 기준을 직접 명시한다.
--ROLLUP과 달리 방향성을 갖지 않는다.
--GROUPING SETS(col1, col2) = GROUPING SETS(col2, col1)

--GROUPING SETS(col1, col2)
--GROUP BY COl1
--UNION ALL
--GROUP BY col2

--emp 테이블에서 직원의 job(업무)별 급여 (sal)+상여(comm)합,
--                     deptno(부서)별 급여(sal)+ 상여(comm)합 구하기
--기존방식 (GROUP FUNCTION) : 2번의 SQL작성 필요(UNINON / NUION ALL)
SELECT job,null deptno/*(타입맞추기위해 임의 컬럼생성)*/, sum(sal+ NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY job



UNION ALL       --컬럼수 동일 데이터, 타입 동일
SELECT '',deptno, sum(sal+ NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY deptno;

--GROUP SETS 구문을 이용하여 위의 SQL을 집합연산을 사용하지 않가ㅗ
--테이블을 한번 읽어서 처리\
SELECT job, deptno, SUM(sal +NVL(comm, 0)) sal_comm_sum
FROM emp
GROUP BY GROUPING SETS (job,deptno);    -- , 의 기준으로 GROUP BY 의 기준을 정할수 있다.

--job, deptno를 그룹으로 한 sal_comm합
--mgr를 그룹으로 한 sal+comm 합
--GROUP BY job, deptno
--UNION ALL
--GROUP BY mgr
-- --> GROUPING SETS((job, deptno), mgr)

SELECT job, deptno, mgr, SUM(sal +NVL(comm , 0)) sal_comm_sum
       , GROUPING(job),GROUPING(deptno),GROUPING(mgr) --null이 실제의 null인지 아니면 그룹함수를 통해 나오는 null인지 GROUPING으로 확인
FROM emp
GROUP BY GROUPING SETS((job,deptno),mgr);

--CUBE (col1, col2,,...)
-- 나열된 컬럼의 모든 가능한 조합으로 GROUP BY suset을 만든다.
--CUBE에 나열된 컬럼이 2개인 경우 : 가능한 조합 4개
--CUBE에 나열된 컬럼이 3개인 경우 : 가능한 조합 8개
--CUBE에 나열된 컬럼수를 2의 제곱승 한결과가 가능한 조합 개수가 된다(2^n)
--컬럼이 조그만 많아져도 가능한 조합이 기하급수적으로 늘어 나기 때문에
--많이 사용하지 않는다.

--job, deptno 를 이용하여 CUBE 적용
SELECT job, deptno, SUM(sal+ NVL(comm, 0)) sal_comm_sum
    ,GROUPING(job),GROUPING(deptno)
FROM emp
GROUP BY CUBE(job, deptno);
--job, detpno
--1,    1    -->GROUP BY job, deptno
--1,    0    -->GROUP BY job
--0,    1    -->GROUP BY deptno
--0,    0    -->GROUP BY --emp 테이블의 모든 행에 대해 GROUP BY

--GROUP BY ROLLUP, CUBE를 섞어 사용하기
--가능한 조합을 생각해보면 쉽게 결과를 예측할 수 있다.
-- GROUP BY job, rollup(deptno), cube(mgr)

SELECT job, deptno, mgr, SUM(sal +NVL(comm, 0 )) sal_comm_sum
FROM emp
GROUP BY  job, ROLLUP(deptno), CUBE(mgr);

SELECT *
FROM emp;
WHERE deptno = 10;
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD (empcnt NUMBER);


UPDATE dept_test 
SET empcnt = (SELECT COUNT(deptno) cnt
            FROM emp
            GROUP BY deptno);
SELECT *
FROM dept_test;

CREATE TABLE dept_test AS
SELECT *
FROM dept;

ALTER TABLE dept_test ADD(empcnt NUMBER);

UPDATE dept_test
SET empcnt = (SELECT COUNT(*)
              FROM emp
              WHERE emp.deptno = dept_test.deptno);
--deptno= 10 --> empcnt = 3;
--deptno= 20 --> empcnt = 5;
--deptno= 30 --> empcnt = 6;
SELECT *
FROM dept_test;

SELECT COUNT(*) empcnt
FROM dept_test;

DROP TABLE dept_test;
insert into dept_test VALUES (99, 'it1', 'daejeon');
insert into dept_test VALUES (98, 'it2', 'daejeon');

DELETE dept_test
WHERE deptno NOT IN (SELECT deptno
                     FROM emp
                     GROUP BY deptno);

SELECT DEPTNO
FROM dept_test;

SELECT *
FROM emp;

DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT *
FROM emp;
--sub_3
UPDATE emp_test SET sal = sal + 200
WHERE sal <(SELECT ROUND(AVG(sal),2)
            FROM emp
            WHERE deptno = emp_test.deptno);
ROLLBACK;
SELECT deptno, AVG(sal)
FROM emp_test
GROUP BY deptno;

--MERGE 구문을 이용한 업데이트
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
FROM emp_test
GROUP BY deptno) b
ON (a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal =  sal +200
    WHERE a.sal < b.avg_sal;
    
    ROLLBACK;
    
MERGE INTO emp_test a
USING (SELECT deptno, AVG(sal) avg_sal
FROM emp_test
GROUP BY deptno) b
ON (a.deptno = b.deptno )
WHEN MATCHED THEN
    UPDATE SET sal =  CASE
                        WHEN a.sal < b.avg_sal THEN sal +200
                        ELSE sal
                        end;