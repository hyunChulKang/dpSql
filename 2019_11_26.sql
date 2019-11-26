--날짜 관련 함수
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : 해당 날짜가 속한 월의 마지막 일자(DATE)


--월 : 1, 3, 5, 7, 8, 10, 12 :31일
--   : 2 -윤년 여부 28,29
--   :
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;
-- '201912' --> date 타입으로 변경하기
-- 해당 날짜의 마지막날짜로 이동
-- 일자 필드만 추출하기
-- DATE --> 일자컬럼(DD)만 추출
-- DATE --> 문자열(DD)

SELECT :yyyymm param,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm ,'YYYYMM')), 'DD') DT
FROM dual;

--SYSDATE를 YYYY/MM/DD 포맷의 문자열로 변경 (DATE -> CHAR)
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD') days 
FROM dual;

--날짜타입에서 문자열타입으로 변경하는 작업
SELECT TO_CHAR(TO_DATE(TO_CHAR(SYSDATE,'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD hh24:mi:ss') days 
FROM dual;

--EMPNO    NOT NULL NUMBER(4)    
--HIREDATE          DATE         
DESC emp;

--empno가 7369인 직원 정보 조회 하기
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     1 |    87 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |  -- TABLE ACCESS FULL : 테이블의 모든 데이터를 읽어온다.
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)         --형변환 : 묵시적 형변환
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

SELECT *
FROM TABLE(dbms_xplan.display);


EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7369 + '69'; --69 ->숫자로 변경


--
SELECT *
FROM emp
WHERE hiredate > = TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATE타입의 묵시적 형변환은 사용을 권하지 않음
--RR 사용할때 주의 50기준으로1900년도 2000년도로 나뉨 
SELECT *
FROM emp
WHERE hiredate > = TO_DATE('1981/06/01', 'RRRR/MM/DD');
    --hiredate > = TO_DATE('81/06/01', 'RR/MM/DD');
    --hiredate >= '81/06/01';
    
--숫자 --> 문자열
--문자열 -->숫자
--날짜 포맷 : YYYY,MM,DD,HH24,MI,SS
--숫자 포맷 : 숫자 표현 :9, 자리맞춤을 위한 0표시 :0, 화폐단위 : L,
--           1000자리 구분: ,소수점 : .

--숫자 ->문자열 TO_CHAR(숫자,'포맷')
--숫자 포맷의 길어질경우 숫자 자리수를 충분히 표현
SELECT empno, ename, sal,TO_CHAR(sal,'L009,999') fm_sal
FROM emp;

SELECT TO_CHAR(1000000000000, '99,999,999,999,999')
FROM dual;

--NULL 처리 함수 : NVL, NVL2, NULLIF, COALESCE

--NVL (expr1, expr2) : 함수 인자 두개

--expr1 이 NULL 이면 expr2를 반환
--expr1 이 NULL이 아니면 expr1을 반환

SELECT empno,ename,comm, NVL(comm,-1) nvl_comm
FROM emp;

--사용많이 않함--사용많이 않함--사용많이 않함--사용많이 않함
--NVL2(expr1, expr2, expr3)

--expr1 IS NOT NULL expr2리턴
--expr1 IS  NULL expr3리턴

SELECT empno,ename,comm, NVL2(comm,1000, -500) nvl_comm,
         NVL2(comm, comm, -500) nvl_comm -- NVL과 동일한 결과
FROM emp;

--사용많이 않함--사용많이 않함--사용많이 않함--사용많이 않함
--NULLIF(expr1, expr2)

--expr1 = expr2 NULL을 리턴
--expr1 != expr2 expr1을 리턴
--comm이 NULL일때 comm+500 : NULL
--  NULLIF(NULL, NULL) :NULL
--comm이 NULL이 아닐때 comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno,ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;


--COALESCE(expr1, expr2, expr3.....)
--인자중에 첫번째로 등장하는 NULL이 아닌 exprN을 리턴
--expr1 IS NOT NULL expr1을 리턴하고
--expr1 IS  NULL COALESCE( expr1, expr2, expr3 ..)

SELECT empno, ename, comm, sal , COALESCE(comm, sal) coal_sal
FROM emp;

--fn4

SELECT empno, ename, mgr, 
       NVL(mgr,9999) mgr_n1,
       NVL2(mgr, mgr , 9999) mgr_n2,
       COALESCE(mgr,9999) mgr_n_2
FROM emp;


--fn5

SELECT userid, usernm, reg_dt, NVL(reg_dt,SYSDATE) n_reg_dt 
FROM users
WHERE userid NOT IN ('brown');

--condition
--case
--emp.job 컬럼을 기준으로
--  'SALESMAN'이면 sal * 1.05를 적용한 값 리턴
--  'MANAGER'이면 sal * 1.00를 적용한 값 리턴
--  'PRESIDENT'이면 sal * 1.20를 적용한 값 리턴
--  위 3가지 직군이 아닐 경우 sal리턴
--  empno, ename, job, sal, 요율 적용한 급여 AS bonus

SELECT empno , job, ename, sal, comm
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.00
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END bonus,
    comm,
    --NULL처리 함수 사용하지 않고, CASE 절을 이용하여
    --comm이 NULL일 경우 -10을 리턴하도록 구성
        CASE 
            WHEN comm IS NULL THEN -10
            ELSE comm
        END  case_null
FROM emp;
--ORDER BY job; 

--DECODE
SELECT empno, ename, job, sal, 
       DECODE(job, 'SALESMAN',  sal * 1.05,
                   'MANAGER',   sal * 1.10,
                   'PRESIDENT', sal * 1.20,
                                sal) bonus

FROM emp;