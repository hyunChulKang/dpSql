SELECT *
FROM kavin.uesrs;

SELECT *
FROM jobs;

SELECT *
FROM USER_TABLES;

SELECT *
FROM  ALL_TABLES;
WHERE OWNER = 'KAVIN';

SELECT *
FROM kavin.fastfood;
--sem.fastfood --> fastfood 시노님으로 생성
-- 생성후 다음 sql이 정상저그로 동작하는지 확인
CREATE SYNONYM fastfood FOR kavin.fastf
SELECT *
FROM fastfood;