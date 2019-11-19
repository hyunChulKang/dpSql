SELECT * 
FROM prod;

--pord 테이블의 prod_id, prod_name 컬러만 모든 데이터(모든 row)에 대해 조회

SELECT prod_id, prod_name 
FROM prod;

--현재 접속한 계정에 생성되어 있는 테이블 목록을 조회

SELECT *
FROM USER_TABLES;

--테이블의 컬럼 리스트 조회

SELECT *
FROM USER_TAB_COLUMNS;

--DESC 테이블명 
DESC prod;

-- select1
SELECT *
FROM lprod;


SELECT buyer_id, buyer_name
FROM buyer;


SELECT *
FROM cart;


SELECT mem_id, mem_pass, mem_name
FROM member;
