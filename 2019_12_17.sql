-- WITH
-- WITH ����̸� AS (
--  ��������
-- )
-- SELECT *
-- FROM ����̸�

-- deptno, avg(sal) avg_sal
--�ش� �μ��� �޿������ ��ü ������ �޿� ��պ��� ���� �μ��� ���� ��ȸ
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal)>( SELECT avg(sal) FROM emp);

--WITH ���� ����Ͽ� ���� ������ �ۼ�
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

--��������
--�޷¸����
--CONNECT BY LEVEL <= N
--���̺��� ROW �Ǽ��� N��ŭ �ݺ��Ѵ�.
--CONNECT BY LEVEL ���� ����� ����������
--SELECT ������ LEVEL �̶�� Ư�� �÷��� ��� �� �� �ִ�.
--������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� ROWNUM�� �����ϳ�
--���� ���Ե� START WITH , CONNECT BY ������ �ٸ� ���� ���� �ȴ�.

--2019�� 11���� 30�ϱ��� ����
-- ���� + ���� = ������ŭ �̷��� ���� ����
--201911 -- >�ش����� ��¥�� ���ϱ��� �����ϴ°�?
SELECT  /* �Ͽ����̸� ��¥ ,  �������̸� ��¥ , ...  ������̸� ��¥ */
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

insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0' -- �������� deptcd = 'dept0' --> xxȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;     --PRIOR �̹� ���� �����͸� ��ȸ

/*
    dept0 (xxȸ��)
        dept0_00 (�����κ�)
            deppt0_00_0(��������)
        dpet0_01(���α�ȹ��)
            dept0_01_0(��ȹ��)
                dept0_00_0_0(��ȹ��Ʈ)
        dept0_02(�����ý��ۺ�)
            dept0_02_0(����1��)
            dept0_02_1(����2��)
*/