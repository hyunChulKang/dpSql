--ourterjoin1

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);

--ANSI
SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b RIGHT OUTER JOIN prod p
ON(b.buy_date = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod);



--outerjoin2
--TO_DATE(:yyyymmdd, 'YYYYMMDD')
SELECT NVL(b.buy_date, '05/01/25') buy_date , b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);


--outerjoin3
--TO_DATE(:yyyymmdd, 'YYYYMMDD')
SELECT TO_DATE(:yyyymmdd, 'YYYYMMDD') buy_date , b.buy_prod, p.prod_id, p.prod_name, NVL(b.buy_qty, '0')
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);


--outerjoin4

SELECT pr.pid, pr.pnm, :cid cid, NVL(cy.day,'0') day, NVL(cy.cnt,'0') cnt 
FROM cycle cy, product pr
WHERE cy.pid(+) = pr.pid
AND cy.cid(+) = :cid;

--outerjoin5
SELECT pr.pid, pr.pnm, cy.cid, cu.cnm, cy.day, cy.cnt
FROM cycle cy, product pr, customer cu
WHERE cy.pid = pr.pid
AND cy.cid = cu.cid
AND cy.cid = '1';


SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt
FROM
    (SELECT pr.pid, pr.pnm, :cid cid, NVL(cy.day,'0') day, NVL(cy.cnt,'0') cnt 
        FROM cycle cy, product pr
        WHERE cy.pid(+) = pr.pid
        AND cy.cid(+) = :cid) a, customer
WHERE a.cid = customer.cid;

SELECT *
FROM product;

SELECT *
FROM customer CROSS JOIN product;

-- ���ù��������� ���� ������ ����
--���ù������� = (��Ŀŷ���� + KFC���� + �Ƶ����� ����) / �Ե����� ����
--���� / �õ� / �ñ��� / ���ù������� (�Ҽ��� ��° �ڸ����� �ݿø�)
-- 1  / ����Ư���� /���ʱ� / 7.5
-- 2  / ����Ư���� / ���ʱ� / 7.2
--�ش� �õ�, �ñ����� ��������� �Ǽ��� �ʿ�


SELECT ROWNUM rn, sido, sigungu, ���ù�������
FROM
(SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as ���ù�������
FROM
    (SELECT sido, sigungu, COUNT(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
    FROM fastfood
    WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt --�Ե����� �Ǽ�
    FROM fastfood
    WHERE gb ='�Ե�����'
    GROUP BY sido, sigungu, gb) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� DESC);

SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as ���ù�������
FROM
(SELECT gb, sido,sigungu,count(*) cnt
FROM fastfood
WHERE  GB = '�Ե�����'
GROUP BY gb, sido,sigungu)a,

(SELECT sido,sigungu,count(*) cnt
FROM fastfood
WHERE  GB IN ('�Ƶ�����','KFC','����ŷ')
GROUP BY sido, sigungu)b
WHERE a.sido = b.sido;

----------------------------------------------------
SELECT GB,SIDO,sigungu, COUNT(GB) cnt
FROM fastfood
WHERE SIDO = '����������'
AND sigungu = '�����'
AND GB = '�Ե�����'
GROUP BY GB,SIDO,sigungu;

SELECT
FROM
    (SELECT GB,SIDO,sigungu, COUNT(GB) cnt
    FROM fastfood
    WHERE SIDO = '����������'
    AND sigungu = '�����'
    GROUP BY GB,SIDO,sigungu) a;
SELECT  a.gb, a.sido, a.sigungu, a.cnt
        ,CASE
            WHEN GB ='�Ե�����' THEN 
FROM
    (SELECT gb,SIDO, sigungu, COUNT(GB) cnt
    FROM fastfood f1
        WHERE GB IN('�Ե�����','�Ƶ�����')
        GROUP BY GB, SIDO,sigungu
        ORDER BY  cnt DESC)B;
--  00 ���� 00�ÿ� �Ե����ư� 00����, 00���� 00���� �Ƶ������ KFC�� ���� ���� ������.
---------------------------------------------------------
--�ϳ��� SQL�� �ۼ��������ÿ�
--������ 5���� �������ؼ� 

--���������� ������  3+0+1 /8   
--���������� �߱�    4+1+2 /6   
--���������� ����    2+0+2 /8 
--���������� ����    7+4+6 /12  
--���������� �����  2+0 /7   
--SELECT a.sido, a.sigungu, a.gb-- COUNT(a.GB) ct--, SUM(
--FROM
   -- (
    SELECT SIDO, SIGUNGU, GB
    FROM fastfood
    WHERE SIDO = '����������'
    AND GB ='����ŷ'
    ORDER BY SIGUNGU;
    --)a
    --GROUP BY a.sido, a.sigungu,a.gb;

--�������� 1�δ� ���ҵ�ݾ� ���ϱ�
SELECT *
FROM TAX;