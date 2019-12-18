--201910 : 35, ù���� �Ͽ���: 201909, ������ ��¥ : 20191102
--��(1), ��(2), ȭ(3), ��(4), ��(5), ��(6), ��(7)
SELECT LDT-FDT +1
FROM
(SELECT LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) dt,

       LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')) + 7 - TO_CHAR(LAST_DAY(TO_DATE(:yyyymm, 'YYYYMM')), 'D') ldt,
       TO_DATE(:yyyymm, 'YYYYMM') -
       (TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) fdt
       
FROM dual);

SELECT  /* �Ͽ����̸� ��¥ ,  �������̸� ��¥ , ...  ������̸� ��¥ */
       MAX(DECODE(d,1, dt)) s, MAX(DECODE(d,2, dt)) m, MAX(DECODE(d,3, dt))t,
       MAX(DECODE(d,4, dt)) w, MAX(DECODE(d,5, dt)) td, MAX(DECODE(d,6, dt))f,
       MAX(DECODE(d,7, dt)) sat
FROM
(SELECT --TO_DATE(:yyyymm, 'YYYYMM')+ (LEVEL-1) dt,
       TO_DATE(:yyyymm, 'YYYYMM') -(TO_CHAR(TO_DATE(:yyyymm, 'YYYYMM'), 'D')-1) +(LEVEL-1) dt,        --�޷¿� �� ���� ��� ù��°��
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
START WITH deptcd = 'dept0' -- �������� deptcd = 'dept0' --> xxȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;     --PRIOR �̹� ���� �����͸� ��ȸ


SELECT LPAD('xxȸ��', 15, '*'),         --*********xxȸ��
       LPAD('xxȸ��', 15)               --         xxȸ��
FROM dual;

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

--�������� (�����) --Ư�� ��忡 �ִ� �ڽĳ����� ���󰣴�.
SELECT LEVEL LV, deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02' -- �������� deptcd = 'dept0_02' --> xxȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;

--�������� (�����)--Ư�� ��忡�� �θ��带 ���󰣴�.

SELECT *
FROM dept_h;
--��������(dept0_00_0)�� �������� ����� �������� �ۼ�
--�ڱ� �μ��� �θ� �μ��� ������ �Ѵ�.
SELECT deptcd,LPAD(' ', (LEVEL-1)*3) ||deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd ='dept0_00_0'
--CONNECT BY PRIOR p_deptcd = deptcd;     --�θ��������� ������ ���� ��� ������ 
CONNECT BY deptcd = PRIOR p_deptcd;     --�θ��������� ������ ���� ��� ������  (PRIOR: ���� ���� ��)

--h_4
SELECT LPAD(' ', (LEVEL-1)*4) ||s_id s_id, value
FROM H_SUM
START WITH s_id = '0'
CONNECT BY  ps_id = PRIOR s_id;    --PRIOR s_id (������������ ��)�� ps_id(������ ���� ��)�̶� ������

create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

--h_5
SELECT LPAD(' ', (LEVEL-1)*4) ||org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--pruning branch (����ġ��)
--���� ������ �������
--FROM --> START WITH ~ CONNECT BY --> WHERE
--������ CONNEVT BY ���� ����� ���
-- . ���ǿ� ���� ���� ROW���� ������ �ȵǰ� ����

--������ WHERE ���� ����� ���
-- . START WITH ~ CONNECT BY ���� ���� ���������� ���� �����
--WHERE ���� ����� ��� ���� �ش� �ϴ� �����͸� ��ȸ

--�ֻ��� ��忡�� ��������� Ž��

--CONNECT BY���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd =p_deptcd AND deptnm != '������ȹ��';

--WHERE ���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd =p_deptcd ;

--���� �������� ��� ������ Ư�� �Լ�
--CONNECT_BY_ROOT(col) ���� �ֻ��� row�� col ���� �� ��ȸ
--SYS_CONNECT_BY_PATH(col, ������) : �ֻ��� row���� ���� �ο���� col����
--�����ڷ� �������� ���ڿ�
--LTRIM- ���ʿ� �ִ� �����ڸ� �A��
--CONNECT_BY_ISLEAF : I�ش� ROW�� ������ ������� (leaf Nod)
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
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
commit;

SELECT *
FROM board_test;

--SIBLINGS �������� ���Ĺ��(�Խ��Ǵ��)
SELECT SEQ, LPAD(' ', 4*(LEVEL-1)) || title
FROM board_test
START WITH  parent_seq IS null 
CONNECT BY PRIOR seq =  parent_seq
ORDER SIBLINGS BY SEQ DESC;