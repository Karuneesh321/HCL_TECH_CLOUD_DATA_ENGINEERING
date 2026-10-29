create database EnterpriseDB;
use EnterpriseDB;

create table Departments (
    DepartmentID int Primary Key,
    DepartmentName varchar(100) not null,
    Location varchar(100) not null
);

create table Employees(
               EmployeeID int Primary Key,
               EmployeeName varchar(100) not null,
               DepartmentID int,
               Salary decimal(10,2) not null ,
               JoiningDate DATE not null,
               ManagerID int, 
                foreign key (DepartmentID) references Departments(DepartmentID),
				 foreign key  (ManagerID) references Employees(EmployeeID)
               );
               

insert into departments (departmentid, departmentname, location) values
(10, 'human resources', 'new york'),
(20, 'engineering', 'san francisco'),
(30, 'finance', 'chicago'),
(40, 'sales', 'austin'),
(50, 'marketing', 'los angeles');

insert into employees (employeeid, employeename, departmentid, salary, joiningdate, managerid) values
(1, 'alice smith', 20, 150000.00, '2022-01-15', null),
(2, 'bob jones', 20, 120000.00, '2022-03-20', 1),
(3, 'charlie brown', 20, 110000.00, '2022-06-01', 1),
(4, 'david miller', 20, 95000.00, '2023-02-10', 2),
(5, 'eva green', 20, 95000.00, '2023-05-12', 2),
(6, 'frank white', 20, 80000.00, '2024-01-15', 3),
(7, 'grace harris', 30, 140000.00, '2021-11-01', null),
(8, 'henry clark', 30, 105000.00, '2022-08-14', 7),
(9, 'ivy lewis', 30, 90000.00, '2023-07-19', 7),
(10, 'jack walker', 10, 95000.00, '2020-05-01', null),
(11, 'karen hall', 10, 70000.00, '2023-01-10', 10),
(12, 'leo allen', 40, 115000.00, '2021-04-22', null),
(13, 'mia young', 40, 85000.00, '2022-10-05', 12),
(14, 'nathan king', 40, 75000.00, '2023-11-30', 12),
(15, 'olivia wright', 40, 60000.00, '2024-03-18', 13);

-- TASKS 
 -- a. Display employee names, department names, and manager names using joins. (2 marks) 
 select 
    e.employeename as employee,
    d.departmentname as department,
    m.employeename as manager
from employees e
left join departments d on e.departmentid = d.departmentid
left join employees m on e.managerid = m.employeeid;

-- b. Find employees earning more than their department's average salary. (2 marks)

select e.employeeid, e.employeename, e.departmentid, e.salary
from employees e
where e.salary > (
    select avg(sub.salary)
    from employees sub
    where sub.departmentid = e.departmentid
);

-- c. Find the second-highest distinct salary without using LIMIT, TOP, or FETCH FIRST. (2 marks) 

select max(salary) as secondhighestsalary
from employees
where salary < (select max(salary) from employees);

-- d. Rank employees by salary within each department and display the top three employees per department, retaining ties at the cutoff. (2 marks) 

with rankedemployees as (
    select 
        employeeid,
        employeename,
        departmentid,
        salary,
        dense_rank() over (partition by departmentid order by salary desc) as salaryrank
    from employees
)
select employeeid, employeename, departmentid, salary, salaryrank
from rankedemployees
where salaryrank <= 3;
