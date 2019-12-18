--201910 : 35, 첫주의 일요일: 201909, 마지막 날짜 : 20191102
--일(1), 월(2), 화(3), 수(4), 목(5), 금(6), 토(7)
SELECT LDT-FDT +1
FROM
(SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,

       LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
       TO_DATE(:yyyymm, 'YYYYMM') -
       (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fdt
       
FROM dual);

SELECT  /* 일요일이면 날짜 ,  월요일이면 날짜 , ...  토요일이면 날짜 */
       MAX(DECODE(d,1, dt)) s, MAX(DECODE(d,2, dt)) m, MAX(DECODE(d,3, dt))t,
       MAX(DECODE(d,4, dt)) w, MAX(DECODE(d,5, dt)) td, MAX(DECODE(d,6, dt))f,
       MAX(DECODE(d,7, dt)) sat
FROM
(SELECT --TO_DATE(:yyyymm, 'YYYYMM')+ (LEVEL-1) dt,
       TO_DATE(:yyyymm, 'YYYYMM') -(TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) +(LEVEL-1) dt,        --달력에 맨 왼쪽 상단 첫번째일
       TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1)+ (LEVEL-1),'D') d,
       TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM') - (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1)+ (LEVEL),'IW') iw
FROM dual
CONNECT BY LEVEL <= (SELECT LDT-FDT +1
                     FROM
                        (SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,
                               LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
                               TO_DATE(:yyyymm, 'YYYYMM') -
                               (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fdt
                        FROM dual)))
GROUP BY dt-(d-1)
ORDER BY dt-(d-1);





SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH deptcd = 'dept0' -- 시작점은 deptcd = 'dept0' --> xx회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;     --PRIOR 이미 읽은 데이터를 조회


SELECT LPAD('xx회사', 15, '*'),         --*********xx회사
       LPAD('xx회사', 15)               --         xx회사
FROM dual;

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

--계층쿼리 (하향식) --특정 노드에 있는 자식노드들을 따라간다.
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02' -- 시작점은 deptcd = 'dept0_02' --> xx회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리 (상향식)--특정 노드에서 부모노드를 따라간다.

SELECT *
FROM dept_h;
--디자인팀(dept0_00_0)을 기준으로 상향식 계층쿼리 작성
--자기 부서의 부모 부서와 연결을 한다.
SELECT deptcd,LPAD(' ', (LEVEL-1)*3) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd ='dept0_00_0'
--CONNECT BY PRIOR p_deptcd = deptcd;     --부모의쿼리가 앞으로 읽을 행과 같을때 
CONNECT BY deptcd = PRIOR p_deptcd;     --부모의쿼리가 앞으로 읽을 행과 같을때  (PRIOR: 내가 읽은 행)

--h_4
SELECT LPAD(' ', (LEVEL-1)*4) ||s_id s_id, value
FROM H_SUM
START WITH s_id = '0'
CONNECT BY  ps_id = PRIOR s_id;    --PRIOR s_id (내가지금읽은 값)이 ps_id(앞으로 읽을 값)이랑 같을때

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

--h_5
SELECT LPAD(' ', (LEVEL-1)*4) ||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--pruning branch (가지치기)
--계층 쿼리의 실행순서
--FROM --> START WITH ~ CONNECT BY --> WHERE
--조건을 CONNEVT BY 절에 기술한 경우
-- . 조건에 따라 다음 ROWㄹ로 연결이 안되고 종료

--조건을 WHERE 절에 기술한 경우
-- . START WITH ~ CONNECT BY 절에 의해 계층형으로 나온 결과에
--WHERE 절에 기술한 결과 값에 해당 하는 데이터만 조회

--최상위 노드에서 하향식으로 탐색

--CONNECT BY절에 deptnm != '정보기획부' 조건을 기술한 경우
SELECT *
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd =p_deptcd AND deptnm != '정보기획부';

--WHERE 절에 deptnm != '정보기획부' 조건을 기술한 경우
SELECT *
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd =p_deptcd ;

--계층 쿼리에서 사용 가능한 특수 함수
--CONNECT_BY_ROOT(col) 가장 최상위 row의 col 정보 값 조회
--SYS_CONNECT_BY_PATH(col, 구분자) : 최상위 row에서 현재 로우까지 col값을
--구분자로 연결해준 문자열
--LTRIM- 왼쪽에 있는 구분자를 뺸다
--CONNECT_BY_ISLEAF : I해당 ROW가 마지막 노드인지 (leaf Nod)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ', 4*(LEVEL-1)) || deptnm,
       CONNECT_BY_ROOT(deptnm) c_root,
       LTRIM(SYS_CONNECT_BY_PATH(deptnm,'~'),'~') sys_path,
       CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd =p_deptcd ;


CREATE table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

--SIBLINGS 계층쿼리 정렬방법(게시판댓글)
SELECT SEQ, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH  parent_seq IS null 
CONNECT BY PRIOR seq =  parent_seq
ORDER SIBLINGS BY SEQ DESC;