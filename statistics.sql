-- �õ����� 1����� ���ҵ� 

SELECT sido, sigungu,people, ROUND(sal/people,0) avg
FROM tax;
GROUP BY sido, sigungu,people;

SELECT *
FROM tax;