---- JOB�� ���� M���� �����ϴ� ����� �ƴ� ����� ��ȸ
SELECT empno, ename, job
FROM emp
WHERE job NOT IN(LIKE 'M%')0;


SELECT empno, ename, hiredate, sal
FROM emp
WHERE ename LIKE 'J%';

SELECT UPPER(ename)
FROM emp;

SELECT empno, ename, hiredate
FROM emp
WHERE LOWER(ename) = 'ford';

SELECT deptno, dname, CONCAT(deptno, dname) d_noname
FROM dept
WHERE deptno = 10;

