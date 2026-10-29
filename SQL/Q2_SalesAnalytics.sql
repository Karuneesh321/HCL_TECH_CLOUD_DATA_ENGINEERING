-- HCLTech Cloud Data Engineer - Question 2
-- Sales Analytics and Query Optimization

CREATE DATABASE IF NOT EXISTS EnterpriseDB;
USE EnterpriseDB;

-- Create the Sales table
CREATE TABLE IF NOT EXISTS Sales (
    SaleID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    SaleDate DATE NOT NULL,
    ProductName VARCHAR(100) NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice >= 0)
);

-- Insert 15 sample records
INSERT INTO Sales
    (SaleID, CustomerID, SaleDate, ProductName, Quantity, UnitPrice)
VALUES
    (1, 101, '2025-01-05', 'Laptop', 1, 65000.00),
    (2, 102, '2025-01-12', 'Mouse', 2, 500.00),
    (3, 103, '2025-01-20', 'Keyboard', 1, 1500.00),
    (4, 101, '2025-02-03', 'Laptop', 1, 65000.00),
    (5, 104, '2025-02-14', 'Monitor', 2, 12000.00),
    (6, 102, '2025-02-22', 'Mouse', 3, 500.00),
    (7, 105, '2025-03-02', 'Keyboard', 2, 1500.00),
    (8, 103, '2025-03-10', 'Laptop', 1, 65000.00),
    (9, 106, '2025-03-18', 'Monitor', 1, 12000.00),
    (10, 101, '2025-04-04', 'Mouse', 4, 500.00),
    (11, 104, '2025-04-11', 'Laptop', 1, 65000.00),
    (12, 105, '2025-04-19', 'Monitor', 2, 12000.00),
    (13, 102, '2025-05-06', 'Keyboard', 3, 1500.00),
    (14, 106, '2025-05-15', 'Laptop', 1, 65000.00),
    (15, 103, '2025-05-24', 'Mouse', 2, 500.00);

-- Verify the sample records
SELECT COUNT(*) AS total_sales FROM Sales;

-- Task A: Total revenue for each product
SELECT
    ProductName,
    SUM(Quantity * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY ProductName
ORDER BY TotalRevenue DESC;

-- Task B: Monthly revenue and month-over-month change
WITH MonthlyRevenue AS (
    SELECT
        DATE_FORMAT(SaleDate, '%Y-%m') AS SalesMonth,
        SUM(Quantity * UnitPrice) AS Revenue
    FROM Sales
    GROUP BY DATE_FORMAT(SaleDate, '%Y-%m')
),
RevenueWithPreviousMonth AS (
    SELECT
        SalesMonth,
        Revenue,
        LAG(Revenue) OVER (ORDER BY SalesMonth) AS PreviousMonthRevenue
    FROM MonthlyRevenue
)
SELECT
    SalesMonth,
    Revenue,
    PreviousMonthRevenue,
    Revenue - PreviousMonthRevenue AS RevenueChange
FROM RevenueWithPreviousMonth
ORDER BY SalesMonth;

-- Task C: Index-friendly date filtering
-- Original:
-- SELECT * FROM Employees WHERE YEAR(JoiningDate) = 2025;

-- Rewritten version:
SELECT *
FROM Employees
WHERE HireDate >= '2025-01-01'
  AND HireDate <  '2026-01-01';
