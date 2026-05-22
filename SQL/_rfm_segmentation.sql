CREATE VIEW vw_RFM_Segments AS
WITH 
RFM_Base AS (
    SELECT 
        [Customer ID],
        MAX(Country) AS Country,
        DATEDIFF(DAY, MAX(TRY_CAST(InvoiceDate AS DATETIME)), '20111210') AS Recency,
        COUNT(DISTINCT Invoice) AS Frequency,
        SUM(Revenue) AS Monetary
    FROM sales
    WHERE CustomerType = 'Registered' 
      AND IsCancellation = 0
    GROUP BY [Customer ID]
),
RFM_Scores AS (
    SELECT 
        [Customer ID],
        Country,
        Recency,
        Frequency,
        Monetary,
        6 - NTILE(5) OVER (ORDER BY Recency) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency) AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary) AS M_Score
    FROM RFM_Base
)
SELECT 
    [Customer ID],
    Country,
    Recency,
    Frequency,
    Monetary,
    R_Score,
    F_Score,
    M_Score,
    CASE 
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN '01. Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 AND M_Score >= 3 THEN '02. Loyal Customers'
        WHEN R_Score >= 4 AND F_Score <= 2 THEN '03. New Customers'
        WHEN R_Score >= 3 AND F_Score <= 2 AND M_Score >= 3 THEN '04. Promising'
        WHEN R_Score = 3 AND F_Score = 3 THEN '05. Needs Attention'
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score >= 3 THEN '06. At Risk'
        WHEN R_Score <= 2 AND F_Score >= 4 AND M_Score >= 4 THEN '07. Cant Lose Them'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN '08. Lost'
        ELSE '09. Others'
    END AS CustomerSegment
FROM RFM_Scores;
GO

-- Verify the view works
SELECT CustomerSegment, COUNT(*) AS Customers 
FROM vw_RFM_Segments 
GROUP BY CustomerSegment 
ORDER BY CustomerSegment;