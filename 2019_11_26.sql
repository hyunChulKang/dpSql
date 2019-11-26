--��¥ ���� �Լ�
--ROUND, TRUNC
--(MONTHS_BETWEEN) ADD_MONTHS, NEXT_DAY
--LAST_DAY : �ش� ��¥�� ���� ���� ������ ����(DATE)


--�� : 1, 3, 5, 7, 8, 10, 12 :31��
--   : 2 -���� ���� 28,29
--   :
SELECT SYSDATE, LAST_DAY(SYSDATE)
FROM dual;
-- '201912' --> date Ÿ������ �����ϱ�
-- �ش� ��¥�� ��������¥�� �̵�
-- ���� �ʵ常 �����ϱ�
-- DATE --> �����÷�(DD)�� ����
-- DATE --> ���ڿ�(DD)

SELECT :yyyymm param,
        TO_CHAR(LAST_DAY(TO_DATE(:yyyymm ,'YYYYMM')), 'DD') DT
FROM dual;

--SYSDATE�� YYYY/MM/DD ������ ���ڿ��� ���� (DATE -> CHAR)
SELECT TO_CHAR(SYSDATE,'YYYY/MM/DD') days 
FROM dual;

--��¥Ÿ�Կ��� ���ڿ�Ÿ������ �����ϴ� �۾�
SELECT TO_CHAR(TO_DATE(TO_CHAR(SYSDATE,'YYYY/MM/DD'), 'YYYY/MM/DD'), 'YYYY-MM-DD hh24:mi:ss') days 
FROM dual;

--EMPNO    NOT NULL NUMBER(4)    
--HIREDATE          DATE         
DESC emp;

--empno�� 7369�� ���� ���� ��ȸ �ϱ�
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
|*  1 |  TABLE ACCESS FULL| EMP  |     1 |    87 |     3   (0)| 00:00:01 |  -- TABLE ACCESS FULL : ���̺��� ��� �����͸� �о�´�.
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("EMPNO"=7369)         --����ȯ : ������ ����ȯ
 
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
WHERE empno = 7369 + '69'; --69 ->���ڷ� ����


--
SELECT *
FROM emp
WHERE hiredate > = TO_DATE('1981/06/01', 'YYYY/MM/DD');

--DATEŸ���� ������ ����ȯ�� ����� ������ ����
--RR ����Ҷ� ���� 50��������1900�⵵ 2000�⵵�� ���� 
SELECT *
FROM emp
WHERE hiredate > = TO_DATE('1981/06/01', 'RRRR/MM/DD');
    --hiredate > = TO_DATE('81/06/01', 'RR/MM/DD');
    --hiredate >= '81/06/01';
    
--���� --> ���ڿ�
--���ڿ� -->����
--��¥ ���� : YYYY,MM,DD,HH24,MI,SS
--���� ���� : ���� ǥ�� :9, �ڸ������� ���� 0ǥ�� :0, ȭ����� : L,
--           1000�ڸ� ����: ,�Ҽ��� : .

--���� ->���ڿ� TO_CHAR(����,'����')
--���� ������ �������� ���� �ڸ����� ����� ǥ��
SELECT empno, ename, sal,TO_CHAR(sal,'L009,999') fm_sal
FROM emp;

SELECT TO_CHAR(1000000000000, '99,999,999,999,999')
FROM dual;

--NULL ó�� �Լ� : NVL, NVL2, NULLIF, COALESCE

--NVL (expr1, expr2) : �Լ� ���� �ΰ�

--expr1 �� NULL �̸� expr2�� ��ȯ
--expr1 �� NULL�� �ƴϸ� expr1�� ��ȯ

SELECT empno,ename,comm, NVL(comm,-1) nvl_comm
FROM emp;

--��븹�� ����--��븹�� ����--��븹�� ����--��븹�� ����
--NVL2(expr1, expr2, expr3)

--expr1 IS NOT NULL expr2����
--expr1 IS  NULL expr3����

SELECT empno,ename,comm, NVL2(comm,1000, -500) nvl_comm,
         NVL2(comm, comm, -500) nvl_comm -- NVL�� ������ ���
FROM emp;

--��븹�� ����--��븹�� ����--��븹�� ����--��븹�� ����
--NULLIF(expr1, expr2)

--expr1 = expr2 NULL�� ����
--expr1 != expr2 expr1�� ����
--comm�� NULL�϶� comm+500 : NULL
--  NULLIF(NULL, NULL) :NULL
--comm�� NULL�� �ƴҶ� comm+500 : comm+500
--  NULLIF(comm, comm+500) : comm
SELECT empno,ename, comm, NULLIF(comm, comm+500) nullif_comm
FROM emp;


--COALESCE(expr1, expr2, expr3.....)
--�����߿� ù��°�� �����ϴ� NULL�� �ƴ� exprN�� ����
--expr1 IS NOT NULL expr1�� �����ϰ�
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
--emp.job �÷��� ��������
--  'SALESMAN'�̸� sal * 1.05�� ������ �� ����
--  'MANAGER'�̸� sal * 1.00�� ������ �� ����
--  'PRESIDENT'�̸� sal * 1.20�� ������ �� ����
--  �� 3���� ������ �ƴ� ��� sal����
--  empno, ename, job, sal, ���� ������ �޿� AS bonus

SELECT empno , job, ename, sal, comm
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.00
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE sal
    END bonus,
    comm,
    --NULLó�� �Լ� ������� �ʰ�, CASE ���� �̿��Ͽ�
    --comm�� NULL�� ��� -10�� �����ϵ��� ����
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