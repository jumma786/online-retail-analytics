
USE RetailDB;

-- =====================================================
-- QUERY 6: Guest vs Registered Customer Breakdown
-- =====================================================
SELECT 
    CustomerType,
    COUNT(*) AS Transactions,
    COUNT(DISTINCT Invoice) AS Orders,
    SUM(Revenue) AS Revenue,
    AVG(Revenue) AS AvgLineValue
FROM sales
WHERE IsCancellation = 0
GROUP BY CustomerType;


-- =====================================================
-- QUERY 7: Top 10 Customers by Revenue
-- =====================================================
SELECT TOP 10
    [Customer ID],
    Country,
    COUNT(DISTINCT Invoice) AS TotalOrders,
    SUM(Revenue) AS TotalSpent,
    AVG(Revenue) AS AvgLineValue,
    MIN(InvoiceDate) AS FirstPurchase,
    MAX(InvoiceDate) AS LastPurchase
FROM sales
WHERE CustomerType = 'Registered' AND IsCancellation = 0
GROUP BY [Customer ID], Country
ORDER BY TotalSpent DESC;


-- =====================================================
-- QUERY 8: Customer Lifetime Value Distribution
-- =====================================================
WITH CustomerSpend AS (
    SELECT 
        [Customer ID],
        SUM(Revenue) AS LifetimeValue
    FROM sales
    WHERE CustomerType = 'Registered' AND IsCancellation = 0
    GROUP BY [Customer ID]
)
SELECT 
    CASE 
        WHEN LifetimeValue < 100 THEN '1. Under £100'
        WHEN LifetimeValue < 500 THEN '2. £100–£500'
        WHEN LifetimeValue < 1000 THEN '3. £500–£1,000'
        WHEN LifetimeValue < 5000 THEN '4. £1,000–£5,000'
        WHEN LifetimeValue < 10000 THEN '5. £5,000–£10,000'
        ELSE '6. Over £10,000'
    END AS SpendBand,
    COUNT(*) AS Customers,
    SUM(LifetimeValue) AS BandRevenue
FROM CustomerSpend
GROUP BY 
    CASE 
        WHEN LifetimeValue < 100 THEN '1. Under £100'
        WHEN LifetimeValue < 500 THEN '2. £100–£500'
        WHEN LifetimeValue < 1000 THEN '3. £500–£1,000'
        WHEN LifetimeValue < 5000 THEN '4. £1,000–£5,000'
        WHEN LifetimeValue < 10000 THEN '5. £5,000–£10,000'
        ELSE '6. Over £10,000'
    END
ORDER BY SpendBand;


-- =====================================================
-- QUERY 9: Day-of-Week Performance
-- =====================================================
SELECT 
    DayOfWeek,
    COUNT(DISTINCT Invoice) AS Orders,
    SUM(Revenue) AS Revenue,
    AVG(Revenue) AS AvgLineValue
FROM sales
WHERE IsCancellation = 0
GROUP BY DayOfWeek
ORDER BY Revenue DESC;


-- =====================================================
-- QUERY 10: Peak Shopping Hours
-- =====================================================
SELECT 
    Hour,
    COUNT(DISTINCT Invoice) AS Orders,
    SUM(Revenue) AS Revenue
FROM sales
WHERE IsCancellation = 0
GROUP BY Hour
ORDER BY Hour;


