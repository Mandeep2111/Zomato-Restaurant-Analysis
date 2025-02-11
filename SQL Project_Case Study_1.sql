Create database Excel;
Use excel;

CREATE TABLE Employee (
    empno INT PRIMARY KEY ,           
    ename VARCHAR(100) not null,             
    job VARCHAR(50) default 'clerk',                 
    mgr INT,                         
    hiredate DATE not null ,                 
    sal DECIMAL(10, 2) check (sal>0),              
    comm DECIMAL(10, 2),            
    deptno INT,                      
    FOREIGN KEY (deptno) REFERENCES Dept(deptno)
);
INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600, 300, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250, 500, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250, 1400, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500, 0, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300, NULL, 10);

CREATE TABLE Dept(deptno INT PRIMARY KEY not null,
dname VARCHAR(100) not null, 
loc VARCHAR(100) not null); 

INSERT INTO Dept (deptno, dname, loc) VALUES
(10, 'OPERATIONS', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40, 'ACCOUNTING', 'NEWYORK');

describe employee;
describe dept;
select * from employee;
select * from dept;

-- 3.	List the Names and salary of the employee whose salary is greater than 1000
        SELECT ename, sal FROM Employee where sal > 1000;

-- 4.	List the details of the employees who have joined before end of September 81.
       SELECT ename, hiredate FROM Employee where hiredate < "1981-09-30" ;

-- 5.	List Employee Names having I as second character.
        SELECT ename from Employee where ename like '_I%';

-- 	6. List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. 
-- Also assign the alias name for the columns

      select ename ,sal, (sal*0.40) as "Allowances" , (sal*0.10) as "P.F" , (sal+(sal*0.40) - (sal*0.10)) as Net_Salary 
      From Employee;

-- 	7.	List Employee Names with designations who does not report to anybody
       select ename , job as 'designations', mgr from employee where mgr is null ;
     
  -- 8.	List Empno, Ename and Salary in the ascending order of salary.
	  select Empno , ename,sal from employee order by sal ;

  -- 9.	How many jobs are available in the Organization ?
        SELECT COUNT(DISTINCT job) AS 'Total Jobs' FROM Employee;
    
   --  10.Determine total payable salary of salesman category
	      select job, sum(sal) as 'total payable salary' from employee where job ="salesman";
    
    -- 11.	List average monthly salary for each job within each department   
	      Select  job , deptno , avg(sal) as 'average monthly salary'  from employee group by deptno , job ;
     
    -- 12.Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, 
	-- SALARY and DEPTNAME in which the employee is working.
         Select e.ename as Empname ,e.sal as salary , d.dname as deptname
         from employee as e
         join dept as d
         on e.deptno = d.deptno ;
         
     --  13.Create the Job Grades Table as below
       CREATE TABLE job_grades (
       grade CHAR(1) PRIMARY KEY,
       lowest_sal INT NOT NULL,
       highest_sal INT NOT NULL);
       
      INSERT INTO job_grades (grade, lowest_sal, highest_sal) VALUES
	  ('A', 0, 999),
      ('B', 1000, 1999),
      ('C', 2000, 2999),
      ('D', 3000, 3999),
      ('E', 4000, 5000);   
      select * from  job_grades;  
      
  --   14.	Display the last name, salary and  Corresponding Grade. 
       SELECT 
       e.ename AS LastName, 
       e.sal AS Salary, 
       g.grade AS Grade
       FROM 
       employee as e
       JOIN 
       job_grades as g
       ON 
       e.sal BETWEEN g.lowest_sal AND g.highest_sal; 
       
  --   15.	Display the Emp name and the Manager name under whom the Employee works in the below format .
	  SELECT 
      CONCAT(e.ename, ' Report to ', COALESCE(m.ename, 'No Manager')) AS `Emp    Report to   Mgr`
      FROM 
      employee e
      LEFT JOIN 
      employee m
      ON 
      e.mgr = m.empno; 
      
  --  16.	Display Empname and Total sal where Total Sal (sal + Comm)  
       SELECT 
       ename AS EmployeeName, 
       sal + COALESCE(comm, 0) AS TotalSalary
       FROM 
       employee;
       
  --  17.	Display Empname and Sal whose empno is a odd number   
	  SELECT 
      ename AS EmployeeName, 
      sal AS Salary
      FROM 
      employee
      WHERE 
      empno % 2 != 0;
      
 --   18.	Display Empname , Rank of sal in Organisation , Rank of Sal in their department
	 SELECT 
     e.ename AS EmployeeName,
     e.sal AS Salary,
     RANK() OVER (ORDER BY e.sal DESC) AS RankInOrganization,
     RANK() OVER (PARTITION BY e.deptno ORDER BY e.sal DESC) AS RankInDepartment
     FROM 
     employee e; 
 
-- 19.	Display Top 3 Empnames based on their Salary
    select ename as Empnames ,sal as Salary from employee order by sal desc limit 3;
       
-- 20.	 Display Empname who has highest Salary in Each Department.    
	 SELECT ename AS "Employee Name", 
	 sal AS "Salary", 
	 deptno AS "Department Number"
	 FROM Employee E
	 WHERE sal = (
     SELECT MAX(sal)
     FROM Employee
     WHERE deptno = E.deptno)
     ORDER BY E.deptno;   