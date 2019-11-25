-- row_1 : emp���̺��� ���ľ��� ROWNUM�� 1~10�� �ุ ��ȸ

SELECT ROWNUM, empno, ename
From emp
WHERE ROWNUM BETWEEN 1 AND 10;

-- row_2 : emp���̺���(empno, ename) ���ľ��� ROWNUM�� 11~14�� �ุ ��ȸ

---ROWNUM ������ * �� �ü� ��� ���̺� ���� Alias�� �����ϸ� ������.
SELECT ROWNUM, a.*
FROM 
(SELECT ROWNUM rn, empno, ename
From emp) a
WHERE rn BETWEEN 11 AND 14;

--row_3 emp���̺��� ename �÷� ������ �������� ���� ������ 11~14��° ���� �����͸�
-- ��ȸ�ϴ� sql�� �ۼ��ϼ���

SELECT rn, empno, ename
FROM
(SELECT ROWNUM rn, a.*
FROM (SELECT empno, ename
From emp
ORDER BY ename) a)
WHERE rn  BETWEEN 11 AND 14;

--DUBA ���̺� : sys ������ �մ� ������ ��밡���� ���̺��̸�, ���ุ �����ϸ�
-- �����ʹ� ���ุ �����ϸ� �÷�(dummy)�� �ϳ� ����

SELECT *
FROM dual;

-- SINGKE ROW FUNCTION : ��� �ѹ��� FUNCTION�� ����
-- 1���� �� INPUT -> 1���� ������ OUTPUT (COLUMN)
-- 'Hello, World'
-- dual ���̺��� �����Ͱ� �ϳ��� �ุ �����Ѵ� ����� �ϳ��� ������ ���´�.
SELECT LOWER('Hello, World'), UPPER('Hello, World'),
    INITCAP('Hello, World')
FROM dual;

--emp���̺��� �� 14���� ������(����)�� ���� (14���� ��)
--�Ʒ������� ����� 14���� ��
SELECT LOWER('Hello, World'), UPPER('Hello, World'),
    INITCAP('Hello, World')
FROM emp;

SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE ename = UPPER('smith'); -- ���� �̸��� smith�� ����� ��ȸ �Ϸ��� �빮��/�ҹ���?

SELECT UPPER('smith')
FROM dual;

--���̺� �÷��� �����ص� ������ ����� ���� �� ������
--���̺� �÷����� ������� �����ϴ� ���� �ӵ��鿡�� ����
--�ش� �÷��� �ε����� �����ϴ��� �Լ��� �����ϰԵǸ� ���� �޶����� �Ǿ�
--�ε����� Ȱ�� �� �� ���� �ȴ�.
--���� : FBI (Function Based Index)

SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER(ename) = 'smith'; -- ���� �̸��� smith�� ����� ��ȸ �Ϸ��� �빮��/�ҹ���?

--HELLO
--,
--WORLD
--HELLO, WORLD (�� 3���� ���ڿ� ����� �̿�, CONCAT �Լ��� ����Ͽ� ���ڿ� ����)
SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') c2,  --�Լ� ��ø(CONCAT����� ���ڿ��̹Ƿ�)
        'HELLO' || ', ' || 'WORLD' c2, 
        
        --�����ε����� 1����, �����ε��� ���ڿ����� �����Ѵ�.
        SUBSTR('HELLO, WORLD', 1, 5) s1,--SUBSTR(���ڿ�, �����ε���, �����ε���)
        
        --INSTR :���ڿ��� Ư�� ���ڿ��� �����ϴ���, ������ ��� ������ �ε����� ����
        INSTR('HELLO, WORLD', 'O') i1, --5, 9
        --'HELLO, WORLD' ���ڿ��� 6��° �ε��� ���Ŀ� �����ϴ� 'O'���ڿ��� �ε��� ����
        INSTR('HELLO, WORLD', 'O', 6) i2, -- ���ڿ��� Ư�� �ε��� ���ĺ��� �˻� �ϵ��� �ɼ�
         INSTR('HELLO, WORLD', 'O',INSTR('HELLO, WORLD', 'O', 6) + 1) i3, -- ���ڿ��� Ư�� �ε��� ���ĺ��� �˻� �ϵ��� �ɼ�


        --L/RPAD Ư�� ���ڿ��� ����/�����ʿ� ������ ���ڿ� ���̺��� ������ ��ŭ ���ڿ���
        --ä�� �ִ´�.
        LPAD('HELLO, WORLD', 15, '*') L1,
        LPAD('HELLO, WORLD', 15) L2, --DEFAULT ä�� ���ڴ� �����̴�.
        RPAD('HELLO, WORLD', 15, '*') R1,
        
        --REPLACE(����ڿ�, �˻� ���ڿ�, ������ ���ڿ�)
        --����ڿ����� �˻� ���ڿ��� ������ ���ڿ��� ġȯ
        REPLACE ('HELLO, WORLD', 'HELLO', 'hello') rep1, --hello, WORLD
        
        --���ڿ� ��, ���� ������ ����
        '   HELLO, WORLD   ' before_trim,
        TRIM('   HELLO, WORLD   ') after_trim,
        TRIM('H' FROM 'HELLO, WORLD') after_trim2
FROM dept;


--���� �����Լ�
--ROUND : �ݿø� - ROUND(����, �ݿø� �ڸ�)
--TRUNC : ���� - TRUNC(����, ���� �ڸ�)
--MOD   : ������ ����  MOD(������, ����) //MOD(5, 2) : 1


SELECT ROUND(105.54, 1) r1, -- �ݿø������ �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� �ݿø�)
       ROUND(105.55, 1) r2,
       ROUND(105.55, 0) r3, -- �Ҽ��� ù��° �ڸ����� �ݿø�
       ROUND(105.55, -1) r4 -- ���� ù��° �ڸ����� �ݿø�
FROM dual;


SELECT TRUNC(105.54, 1) t1, -- ���� ����� �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� �ݿø�)
       TRUNC(105.55, 1) t2,
       TRUNC(105.55, 0) t3, -- �Ҽ��� ù��° �ڸ����� ����
       TRUNC(105.55, -1) t4 -- ���� ù��° �ڸ����� ����
FROM dual;


--MOD(������, ����) �������� ������ ���� ������ ��
--MOD(M, 2) �� ��� ���� : 0, 1(0~����-1)
SELECT MOD(5,2) m1 --5/2 : ���� 2, [�������� 1]
FROM dual;

--emp ���̺��� sal �÷��� 1000���� �������� ����� ������ ���� ��ȸ �ϴ� sql �ۼ�
--ename, sal, sal/1000�� ����  ��, sal/1000�� ���� ������

SELECT ename, sal, TRUNC(sal/1000), MOD(sal, 1000),
        TRUNC(sal/1000) * 1000 + MOD(sal, 1000) sal2
FROM emp;

--DATE : �����, �ð�, ��, ��
SELECT ename, TO_CHAR(hiredate, 'YYYY/MM/DD hh24*mi*ss') --YYYY/MM/DD
FROM emp;

--SYSDATE : ������ ���� DATE�� �����ϴ� �����Լ�, Ư���� ���ڰ� ����.     
--DATE ����  DATE + ����N = N���� ��ŭ ���Ѵ�.
--DATE ���꿡 �־ ������ ����
--�Ϸ�� 24�ð�
--DATE Ÿ�Կ� �ð��� ���� �� �� �ִ� 1�ð� = 1/24
SELECT TO_CHAR(SYSDATE + 5, 'YYYY-MM-DD hh24:mi:ss') AFTER5_DAYS,
       TO_CHAR(SYSDATE + 5/24, 'YYYY-MM-DD hh24:mi:ss') AFTER5_HOURS,
       TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTER5_MINS
FROM dual;


SELECT TO_CHAR('20191231', 'YYMMDD') LASTDAY,
       TO_CHAR('20191231', 'YYMMDD') -5 LASTDAY_BEFORE5,
          SYSDATE NOW,
          SYSDATE -3 NOW_BEFORE3
FROM dual;

--YYYY,MM,DD D (������ ���ڷ� : �Ͽ��� 1 , ������ 2, ȭ���� 3,......����� :7 )
--IW(���� 1~53), HH, MI, SS
SELECT TO_CHAR(SYSDATE, 'YYYY') YYYY, --���� �⵵
       TO_CHAR(SYSDATE, 'MM') MM, --�����
       TO_CHAR(SYSDATE, 'DD') DD, --������
       TO_CHAR(SYSDATE, 'D') D, --���� ����(�ְ����� 1~7)
       TO_CHAR(SYSDATE, 'IW') IW, --���� ������ ���� 
       --2019�� 12�� 31���� �������� �����°�?
       TO_CHAR(TO_DATE('20191231' ,'YYYYMMDD'), 'IW')
FROM dual;


-- fn2
-- ���� ��¥�� ��-��-��
-- ���� ��¥�� ��-��-�� �ð�(24)-��-��
-- ���� ��¥�� ��-��-��

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD') dt_dash,
       TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') dt_dash_with_time, 
       TO_CHAR(SYSDATE, 'DD-MM-YYYY') dt_dd_mm_yyyy
FROM dual;

--DATE Ÿ���� ROUND, TRUNC ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM���� �ݿø�(11�� -> 1��)
       TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       --DD���� �ݿø�(25= >1����
       TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --�ð����� �ݿø�
       TO_CHAR(ROUND(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
FROM dual;

------ũ�� ������� ����----------
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now,
        --MM���� ����(11�� -> 1��)
       TO_CHAR(TRUNC(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY,
       --DD���� ����(25= >1����
       TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM,
       --�ð����� ����(����ð� ->0��)
       TO_CHAR(TRUNC(SYSDATE, 'DD'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
FROM dual;


--��¥ ���� �Լ�
--MONTHS_BETWEEN(date1, date2) : date2�� date1 ������ ���� ��
--ADD_MONTHS(date, ������ ������) : date���� Ư�� �������� ���ϰų� �� ��¥
--NEXT_DAY(date, weekday(1~7)) : date���� ù ��° weekday ��¥
--LAST_DAY(date) : date�� ���� ���� ������ ��¥


--mMONTHS_BETWEEN(date1, date2)
SELECT MONTHS_BETWEEN(TO_DATE('2019-11-25','YYYY-MM-DD'),
                      TO_DATE('2019-03-31','YYYY-MM-DD')) m_bet,
                      TO_DATE('2019-11-25','YYYY-MM-DD')-
                      TO_DATE('2019-03-31','YYYY-MM-DD') d_m --�γ�¥ ���� ���� ��
FROM dual;

-- ADD_MONTHS(date,number(+,-))

SELECT ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), 5) NOW_AFTER5M,
       ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), -5) NOW_AFTER5M,
       SYSDATE + 100 --100�� ���� ��¥ (�� ���� 3-31, 2-28/29)
FROM dual;

--NEXT_DAY(date, weekday number(1~7))
SELECT NEXT_DAY(SYSDATE, 1) N_DAY --���� ��¥(2109/11/25)�� ���� �����ϴ� ù��° �����
FROM dual;