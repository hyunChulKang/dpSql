
-- OUTER join  : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� �����ʹ�
-- �������� �ϴ� join
--LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
-- ���̺� 1�� ���̺� 2�� �����Ҷ� ���ο� �����ϴ��� ���̺�1�ʿ� �����ʹ�
-- ��ȸ�� �ǵ��� �Ѵ�.
-- JOIN�� ������ �࿡�� ���̺� 2�� �÷����� �������� �����Ƿ� NULL�� ǥ�� �ȴ�.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
--ON���� �ۼ��ѰͰ� WHERE���� �ۼ��Ѱ� ��
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno)
WHERE m.deptno =10;

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno AND m.deptno =10);
           
-- oracle  outer join syntax
--�Ϲ����ΰ� �������� �÷��� (+)ǥ��
--(+) ǥ�� : �����Ͱ� �������� �ʴµ� ���;� �ϴ� ���̺��� �÷�
-- ���� LEFT OUTER JOIN �Ŵ���
--      ON(����.�Ŵ��� = �Ŵ���.������ȣ)
-- oracle  outer
-- WHERE ����.�Ŵ�����ȣ = �Ŵ���.������ȣ(+) -- �Ŵ����� �����Ͱ� ������������

--ansi
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--oracle outer
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE  e.mgr = m.empno(+);


--�Ŵ��� �μ���ȣ ����
--ANSI SQL WHERE ���� ���
-- --> OUTER JOIN�� ������� ���� ��Ȳ
--OUTER JOIN�� ����Ǿ�� �ϴ� ���̺��� ��� �÷��� (+)�� �پ�� �ȴ�.
--ansi sql�� on���� ����� ���� ����

SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e , emp m
WHERE  e.mgr = m.empno(+)
AND m.deptno(+) = 10;


--emp ���̺��� 14���� ������ �ְ� 14�� 10, 20, 30�μ��߿� �� �μ���
-- ���Ѵ�.
-- ������ dept���̺� 10, 20, 30, 40�� �μ��� ����
-- �μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�

SELECT d.deptno, d.dname, COUNT(e.deptno)
FROM emp e, dept d
WHERE d.deptno = e.deptno(+)
GROUP BY e.deptno, d.dname,  d.deptno
ORDER BY e.deptno;

-- dept : deptno, dname
-- inline : deptno, cnt(������ ��)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno
ORDER BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);


--ANSI
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN  (SELECT deptno, COUNT(*) cnt
                            FROM emp
                            GROUP BY deptno
                            ORDER BY deptno) emp_cnt
                        ON (dept.deptno = emp_cnt.deptno);
                        
                        
                        
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER -�ߺ������� �ѰŸ� �����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m
           ON (e.mgr = m.empno);           

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

SELECT b.buy_date, b.buy_prod, p.prod_id, p.prod_name, b.buy_qty
FROM buyprod b , prod p
WHERE b.buy_date(+) = TO_DATE('20050125', 'YYYYMMDD')
AND p.prod_id = b.buy_prod(+);




SELECT buy_date
FROM buyprod b, p;

SELECT *
FROM buyprod;

