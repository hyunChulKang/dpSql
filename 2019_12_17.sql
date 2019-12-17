-- WITH
-- WITH 블록이름 AS (
--  서브쿼리
-- )
-- SELECT *
-- FROM 블록이름

-- deptno, avg(sal) avg_sal
--해당 부서의 급여평균이 전체 직원의 급여 평균보다 높은 부서에 한해 조회
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal)>( SELECT avg(sal) FROM emp);

--WITH 절을 사용하여 위의 쿼리를 작성
WITH dept_sal_avg AS(
     SELECT deptno, avg(sal) avg_sal
     FROM emp
     GROUP BY deptno),
     emp_sal_avg AS (
      SELECT avg(sal) avg_sal FROM emp
     )
SELECT *
FROM dept_sal_avg
WHERE dept_sal_avg.avg_sal > (SELECT  avg_sal FROM emp_sal_avg);

--계층쿼리
--달력만들기
--CONNECT BY LEVEL <= N
--테이블의 ROW 건수를 N만큼 반복한다.
--CONNECT BY LEVEL 절을 사용한 쿼리에서는
--SELECT 절에서 LEVEL 이라는 특수 컬럼을 사용 할 수 있다.
--계층을 표현하는 특수 컬럼으로 1부터 증가하며 ROWNUM과 유사하나
--추후 배우게될 START WITH , CONNECT BY 절에서 다른 점을 배우게 된다.

--2019년 11월은 30일까지 존재
-- 일자 + 정수 = 정수만큼 미래의 일자 증가
--201911 -- >해당년월의 날짜가 몇일까지 존재하는가?
SELECT  /* 일요일이면 날짜 ,  월요일이면 날짜 , ...  토요일이면 날짜 */
       MAX(DECODE(d,1, dt,dt-6)) s, MAX(DECODE(d,2, dt,dt-5)) m, MAX(DECODE(d,3, dt,dt-4))t,
       MAX(DECODE(d,4, dt,dt-3)) w, MAX(DECODE(d,5, dt,dt-2)) t, MAX(DECODE(d,6, dt,dt-1))f,
       MAX(DECODE(d,7, dt,dt)) sat
FROM
(SELECT TO_DATE(:yyyymm, 'YYYYMM')+ (LEVEL-1) dt,
       TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM')+ (LEVEL-1),'D') d,
       TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM')+ (LEVEL),'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'DD'))
GROUP BY dt-(d-1)
ORDER BY dt-(d-1);

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <=54;

SELECT *
FROM emp;

(SELECT TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL-1),'D') d,
        TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')+(LEVEL),'IW') iw
FROM dual
CONNECT BY LEVEL <= 10);


create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;

SELECT *
FROM sales;

SELECT 
       NVL(MIN(DECODE(mm, '01', sales_sum)), 0) JAN, NVL(MIN(DECODE(mm, '02', sales_sum)), 0)FEB,
       NVL(MIN(DECODE(mm, '03', sales_sum)), 0) MAR, NVL(MIN(DECODE(mm, '04', sales_sum)), 0)APR,
       NVL(MIN(DECODE(mm, '05', sales_sum)), 0) MAY, NVL(MIN(DECODE(mm, '06', sales_sum)), 0)JUN
FROM       
(SELECT TO_CHAR(DT,'MM') mm, SUM(sales) sales_sum
FROM sales
GROUP BY TO_CHAR(dt, 'MM'));

DECODE(DT,TO_DATE('20190103','YYYYMMDD'),sales)
FROM sales;


create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0' -- 시작점은 deptcd = 'dept0' --> xx회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;     --PRIOR 이미 읽은 데이터를 조회

/*
    dept0 (xx회사)
        dept0_00 (디자인부)
            deppt0_00_0(디자인팀)
        dpet0_01(정부기획부)
            dept0_01_0(기획팀)
                dept0_00_0_0(기획파트)
        dept0_02(정보시스템부)
            dept0_02_0(개발1팀)
            dept0_02_1(개발2팀)
*/