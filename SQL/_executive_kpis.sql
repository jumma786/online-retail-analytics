USE RetailDB;

-- Check row count
SELECT COUNT(*) AS TotalRows FROM sales;

-- Preview the data
SELECT TOP 10 * FROM sales;

-- Verify the totals match what we calculated in Python
SELECT 
    SUM(Revenue) AS TotalRevenue,
    COUNT(DISTINCT [Customer ID]) AS UniqueCustomers,
    COUNT(DISTINCT StockCode) AS UniqueProducts,
    COUNT(DISTINCT Country) AS Countries,
    MIN(InvoiceDate) AS EarliestDate,
    MAX(InvoiceDate) AS LatestDate
FROM sales;


USE RetailDB;

-- =====================================================
-- QUERY 1: Overall Bus.iness KPIs
-- =====================================================
SELECT 
    COUNT(DISTINCT Invoice) AS TotalOrders,
    COUNT(DISTINCT CASE WHEN CustomerType = 'Registered' THEN [Customer ID] END) AS RegisteredCustomers,
    COUNT(DISTINCT StockCode) AS UniqueProducts,
    SUM(CASE WHEN IsCancellation = 0 THEN Revenue ELSE 0 END) AS GrossRevenue,
    SUM(CASE WHEN IsCancellation = 1 THEN Revenue ELSE 0 END) AS Returns,
    SUM(Revenue) AS NetRevenue
FROM sales;


-- =====================================================
-- QUERY 2: Revenue by Year
-- =====================================================
SELECT 
    Year,
    SUM(Revenue) AS Revenue,
    COUNT(DISTINCT Invoice) AS Orders,
    COUNT(DISTINCT [Customer ID]) AS Customers
FROM sales
WHERE IsCancellation = 0
GROUP BY Year
ORDER BY Year;


-- =====================================================
-- QUERY 3: Monthly Revenue Trend
-- =====================================================
SELECT 
    YearMonth,
    SUM(Revenue) AS MonthlyRevenue,
    COUNT(DISTINCT Invoice) AS Orders,
    AVG(Revenue) AS AvgLineValue
FROM sales
WHERE IsCancellation = 0
GROUP BY YearMonth
ORDER BY YearMonth;


-- =====================================================
-- QUERY 4: Top 10 Countries by Revenue
-- =====================================================
SELECT TOP 10
    Country,
    SUM(Revenue) AS Revenue,
    COUNT(DISTINCT Invoice) AS Orders,
    COUNT(DISTINCT [Customer ID]) AS Customers
FROM sales
WHERE IsCancellation = 0
GROUP BY Country
ORDER BY Revenue DESC;


-- =====================================================
-- QUERY 5: Top 10 Best-Selling Products by Revenue
-- =====================================================
SELECT TOP 10
    StockCode,
    Description,
    SUM(Quantity) AS UnitsSold,
    SUM(Revenue) AS Revenue
FROM sales
WHERE IsCancellation = 0
GROUP BY StockCode, Description
ORDER BY Revenue DESC;

