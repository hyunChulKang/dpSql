-- 1. tax���̺��� �̿� �õ�/�ñ����� �δ� �������� �Ű�� ���ϱ�
-- 2. �Ű���� ���� ������ ��ŷ �ο��ϱ�
--  ��ŷ    �õ�    �ñ���   �δ翬������ �Ű��
--  1      ����Ư���� ���ʱ�    7000
--  2      ����Ư���� ������    8000

SELECT sido, sigungu, ROUND(sal/people,1) avg
FROM tax
ORDER BY avg DESC;

SELECT *
FROM tax;

SELECT do.rn,  do.sido, do.sigungu, ���ù�������, tax_1.rn, tax_1.sido, tax_1.sigungu, tax_1.avg
FROM
    (SELECT ROWNUM rn, sido, sigungu, ���ù�������
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as ���ù�������
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
            FROM fastfood
            WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY sido, sigungu) a,
            (SELECT  sido, sigungu, COUNT(*) cnt --�Ե����� �Ǽ�
            FROM fastfood
            WHERE gb ='�Ե�����'
            GROUP BY sido, sigungu, gb) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY ���ù������� DESC)) do,
    (SELECT ROWNUM rn, sido, sigungu, avg
    FROM
    (SELECT  sido, sigungu, ROUND(sal/people,1) avg
    FROM tax
    ORDER BY avg)) tax_1
WHERE do.rn(+) = tax_1.rn
ORDER BY tax_1.rn;

--���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ�����
--���� �������� ����
--���� ������ tax ���̺��� id �÷������� ����

SELECT tax_1.id, tax_1.sido, tax_1.sigungu, tax_1.avg, ���ù�������
FROM
    (SELECT ROWNUM rn, sido, sigungu, ���ù�������
    FROM
        (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 1) as ���ù�������
        FROM
            (SELECT sido, sigungu, COUNT(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
            FROM fastfood
            WHERE gb IN('KFC', '����ŷ', '�Ƶ�����')
            GROUP BY sido, sigungu) a,
            (SELECT  sido, sigungu, COUNT(*) cnt --�Ե����� �Ǽ�
            FROM fastfood
            WHERE gb ='�Ե�����'
            GROUP BY sido, sigungu, gb) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY ���ù������� DESC)) do,
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