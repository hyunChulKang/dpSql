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
--sem.fastfood --> fastfood �ó������ ����
-- ������ ���� sql�� �������׷� �����ϴ��� Ȯ��
CREATE SYNONYM fastfood FOR kavin.fastf
SELECT *
FROM fastfood;