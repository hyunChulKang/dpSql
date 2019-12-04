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

-- 도시발전지수가 높은 순으로 나열
--도시발전지수 = (버커킹개수 + KFC개수 + 맥도날드 개수) / 롯데리아 개수
--순위 / 시도 / 시군구 / 도시발전지수 (소수점 둘째 자리에서 반올림)
-- 1  / 서울특별시 /서초구 / 7.5
-- 2  / 서울특별시 / 서초구 / 7.2
--해당 시도, 시군구별 프렌차이즈별 건수가 필요


SELECT ROWNUM rn, sido, sigungu, 도시발전지수
FROM
(SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as 도시발전지수
FROM
    (SELECT sido, sigungu, COUNT(*) cnt --버거킹, KFC, 맥도날드 건수
    FROM fastfood
    WHERE gb IN('KFC', '버거킹', '맥도날드')
    GROUP BY sido, sigungu) a,
    (SELECT sido, sigungu, COUNT(*) cnt --롯데리아 건수
    FROM fastfood
    WHERE gb ='롯데리아'
    GROUP BY sido, sigungu, gb) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY 도시발전지수 DESC);

SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as 도시발전지수
FROM
(SELECT gb, sido,sigungu,count(*) cnt
FROM fastfood
WHERE  GB = '롯데리아'
GROUP BY gb, sido,sigungu)a,

(SELECT sido,sigungu,count(*) cnt
FROM fastfood
WHERE  GB IN ('맥도날드','KFC','버거킹')
GROUP BY sido, sigungu)b
WHERE a.sido = b.sido;

----------------------------------------------------
SELECT GB,SIDO,sigungu, COUNT(GB) cnt
FROM fastfood
WHERE SIDO = '대전광역시'
AND sigungu = '대덕구'
AND GB = '롯데리아'
GROUP BY GB,SIDO,sigungu;

SELECT
FROM
    (SELECT GB,SIDO,sigungu, COUNT(GB) cnt
    FROM fastfood
    WHERE SIDO = '대전광역시'
    AND sigungu = '대덕구'
    GROUP BY GB,SIDO,sigungu) a;
SELECT  a.gb, a.sido, a.sigungu, a.cnt
        ,CASE
            WHEN GB ='롯데리아' THEN 
FROM
    (SELECT gb,SIDO, sigungu, COUNT(GB) cnt
    FROM fastfood f1
        WHERE GB IN('롯데리아','맥도날드')
        GROUP BY GB, SIDO,sigungu
        ORDER BY  cnt DESC)B;
--  00 도의 00시에 롯데리아가 00개면, 00도의 00시의 맥도날드와 KFC를 더한 것을 나눈다.
---------------------------------------------------------
--하나의 SQL로 작성하지마시오
--대전시 5개의 구에대해서 

--대전광역시 유성구  3+0+1 /8   
--대전광역시 중구    4+1+2 /6   
--대전광역시 동구    2+0+2 /8 
--대전광역시 서구    7+4+6 /12  
--대전광역시 대덕구  2+0 /7   
--SELECT a.sido, a.sigungu, a.gb-- COUNT(a.GB) ct--, SUM(
--FROM
   -- (
    SELECT SIDO, SIGUNGU, GB
    FROM fastfood
    WHERE SIDO = '대전광역시'
    AND GB ='버거킹'
    ORDER BY SIGUNGU;
    --)a
    --GROUP BY a.sido, a.sigungu,a.gb;

--지역마다 1인당 연소득금액 구하기
SELECT *
FROM TAX;