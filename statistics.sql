-- 1. tax테이블을 이용 시도/시군구별 인당 연말정산 신고액 구하기
-- 2. 신고액이 많은 순서로 랭킹 부여하기
--  랭킹    시도    시군구   인당연말정산 신고액
--  1      서울특별시 서초구    7000
--  2      서울특별시 강남구    8000

SELECT sido, sigungu, ROUND(sal/people,1) avg
FROM tax
ORDER BY avg DESC;

SELECT *
FROM tax;

SELECT do.rn,  do.sido, do.sigungu, 도시발전지수, tax_1.rn, tax_1.sido, tax_1.sigungu, tax_1.avg
FROM
    (SELECT ROWNUM rn, sido, sigungu, 도시발전지수
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as 도시발전지수
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt --버거킹, KFC, 맥도날드 건수
            FROM fastfood
            WHERE gb IN('KFC', '버거킹', '맥도날드')
            GROUP BY sido, sigungu) a,
            (SELECT  sido, sigungu, COUNT(*) cnt --롯데리아 건수
            FROM fastfood
            WHERE gb ='롯데리아'
            GROUP BY sido, sigungu, gb) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY 도시발전지수 DESC)) do,
    (SELECT ROWNUM rn, sido, sigungu, avg
    FROM
    (SELECT  sido, sigungu, ROUND(sal/people,1) avg
    FROM tax
    ORDER BY avg)) tax_1
WHERE do.rn(+) = tax_1.rn
ORDER BY tax_1.rn;

--도시발전지수 시도, 시군구와 연말정산 납입금액의 시도, 시군구가
--같은 지역끼리 조인
--정렬 순서는 tax 테이블의 id 컬럼순으로 정렬

SELECT tax_1.id, tax_1.sido, tax_1.sigungu, tax_1.avg, 도시발전지수
FROM
    (SELECT ROWNUM rn, sido, sigungu, 도시발전지수
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as 도시발전지수
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt --버거킹, KFC, 맥도날드 건수
            FROM fastfood
            WHERE gb IN('KFC', '버거킹', '맥도날드')
            GROUP BY sido, sigungu) a,
            (SELECT  sido, sigungu, COUNT(*) cnt --롯데리아 건수
            FROM fastfood
            WHERE gb ='롯데리아'
            GROUP BY sido, sigungu, gb) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY 도시발전지수 DESC)) do,
    (SELECT ROWNUM rn, id, sido, sigungu, avg
    FROM
    (SELECT  id, sido, sigungu, ROUND(sal/people,1) avg
    FROM tax
    ORDER BY avg)) tax_1
WHERE do.sido(+) = tax_1.sido
and do.sigungu(+) = tax_1.sigungu
ORDER BY id;

SELECT *
FROM tax;,