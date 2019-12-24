--FOR LOOP���� ������ Ŀ�� ����ϱ�
SET SERVEROUTPUT ON;
DECLARE
    CURSOR dept_cursor IS
        SELECT dname, loc
        FROM dept;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
   
END;
/

--Ŀ������ ���ڰ� ���� ���

DECLARE
    CURSOR dept_cursor(p_deptno dept.deptno%TYPE)IS
        SELECT dname, loc
        FROM dept
        WHERE deptno = p_deptno;
    v_dname dept.dname%TYPE;
    v_loc dept.loc%TYPE;
BEGIN
    FOR record_row IN dept_cursor(10) LOOP
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/

--FOR LOOP �ζ��� Ŀ��
--FOR LOOP �������� Ŀ���� ���� ����
DECLARE
BEGIN
    FOR record_row IN(SELECT dname, loc FROM dept)LOOP
        DBMS_OUTPUT.PUT_LINE(record_row.dname || ', ' || record_row.loc);
    END LOOP;
END;
/
 CREATE TABLE DT
(	DT DATE);

insert into dt
select trunc(sysdate + 10) from dual union all
select trunc(sysdate + 5) from dual union all
select trunc(sysdate) from dual union all
select trunc(sysdate - 5) from dual union all
select trunc(sysdate - 10) from dual union all
select trunc(sysdate - 15) from dual union all
select trunc(sysdate - 20) from dual union all
select trunc(sysdate - 25) from dual;

commit;


SELECT *
FROM dt;

/*
20/01/03
19/12/29
19/12/24
19/12/19
19/12/14
19/12/09
19/12/04
19/11/29*/

DECLARE
    
BEGIN
    FOR record_row IN(SELECT dt FROM dt)LOOP
        
         DBMS_OUTPUT.PUT_LINE(record_row.dt);
    END LOOP;
END;
/


--PRO_3
CREATE OR REPLACE PROCEDURE AVGDT IS
    TYPE dt_tab IS TABLE OF dt%ROWTYPE INDEX BY BINARY_INTEGER;
        v_dt_tab dt_tab;
    v_sum NUMBER := 0;
BEGIN
    SELECT *
    BULK COLLECT INTO v_dt_tab
    FROM dt
    ORDER BY dt;
    FOR i IN 1..(v_dt_tab.count-1) LOOP
        v_sum :=v_sum + v_dt_tab(i+1).dt -v_dt_tab(i).dt;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(v_sum/(v_dt_tab.count-1));
END;
/

exec AVGDT


--SQL
SELECT AVG(sum_avg) sum_avg
FROM
(SELECT LEAD(dt) OVER(ORDER BY dt) - dt sum_avg
FROM dt);


SELECT *
FROM cycle;

SELECT *
FROM daily;

SET SERVEROUT ON;

CREATE OR REPLACE PROCEDURE CREATE_DAILY_SALES
(v_yyyymm IN VARCHAR2) IS
    TYPE cal_row_type IS RECORD (
        dt VARCHAR2(8),
        day NUMBER
        );
        
    TYPE cal_tab IS TABLE OF cal_row_type INDEX BY BINARY_INTEGER;
    v_cal_tab cal_tab;
BEGIN
    --�����ϱ����� �ش����� �ش��ϴ� �Ͻ��� �����͸� �����Ѵ�.
    DELETE daily
    WHERE dt LIKE v_yyyymm ||'%';
    --�޷������� table ������ �����Ѵ�.
    --�ݺ����� sql ������ �����ϱ� ���� �ѹ��� �����Ͽ� ������ ����
    SELECT TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM')+(LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(v_yyyymm, 'YYYYMM')+(LEVEL-1), 'D') day
    BULK COLLECT INTO v_cal_tab
    FROM dual
    CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE(v_yyyymm, 'YYYYMM')), 'DD');
    
    --�����ֱ� ������ �д´�.
    FOR daily IN (SELECT * FROM cycle)LOOP
        --12�� ���ڴ޷� : cycle row �Ǽ� ��ŭ �ݺ�
        FOR i IN 1..v_cal_tab.count LOOP
            IF daily.day =v_cal_tab(i).day THEN
            --cid,pid,����,���� ����
                INSERT INTO daily VALUES(daily.cid, daily.pid, v_cal_tab(i).dt, daily.cnt);
            END IF;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(daily.cid ||', ' || daily.day);
    END LOOP;
    
    COMMIT;

END;
/

exec create_daily_sales('201912');



SELECT TO_CHAR(TO_DATE('201912', 'YYYYMM')+(LEVEL-1), 'YYYYMM   DD') dt,
       TO_CHAR(TO_DATE('201912', 'YYYYMM')+(LEVEL-1), 'D') day
FROM dual
CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE('201912', 'YYYYMM')), 'DD');

SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM cycle,
( SELECT TO_CHAR(TO_DATE(:v_yyyymm, 'YYYYMM')+(LEVEL-1), 'YYYYMMDD') dt,
           TO_CHAR(TO_DATE(:v_yyyymm, 'YYYYMM')+(LEVEL-1), 'D') day
    FROM dual
    CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(TO_DATE(:v_yyyymm, 'YYYYMM')), 'DD')) cal
WHERE cycle.day =cal.day;






SELECT *
FROM daily;
WHERE dt LIKE '201912' ||'%';


SELECT *
FROM daily
WHERE dt BETWEEN '201911' ||'01' AND  '201911' ||'31' ;




