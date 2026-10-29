-- HCLTech Cloud Data Engineer
-- Question 3: SQL Troubleshooting

USE EnterpriseDB;

-- Task (a): Examine the execution plan
EXPLAIN
SELECT *
FROM Employees
WHERE DepartmentID = 10
  AND Salary > 80000;

-- Task (b): Create a composite index for DepartmentID and Salary
CREATE INDEX idx_employee_department_salary
ON Employees (DepartmentID, Salary);

-- Check the execution plan after creating the index
EXPLAIN
SELECT *
FROM Employees
WHERE DepartmentID = 10
  AND Salary > 80000;

-- Task (c): Find duplicate customer email addresses
SELECT Email, COUNT(*) AS DuplicateCount
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;
