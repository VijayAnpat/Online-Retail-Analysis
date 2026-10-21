USE online_retail;

-- Query 1: Total net sales
SELECT
     SUM(Quantity * UnitPrice) AS total_net_sales
FROM online_retail_transactions;

-- Query 2: Positive line sales
SELECT
    SUM(Quantity * UnitPrice) AS positive_line_sales
FROM online_retail_transactions
WHERE Quantity * UnitPrice > 0; 

-- Query 3: Negative line sales
SELECT
     SUM(Quantity * UnitPrice) AS negative_line_sales
FROM online_retail_transactions
WHERE Quantity * UnitPrice < 0;

-- Query 4 : Monthly net sales
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Best performing country
SELECT
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
GROUP BY Country
ORDER BY net_sales DESC
LIMIT 10;

-- Top selling products
SELECT
     StockCode,
     Description,
     ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
GROUP BY StockCode, Description
ORDER BY net_sales DESC
LIMIT 10;

-- Top customers by net sales
SELECT
    CustomerID,
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID,Country
ORDER BY net_sales DESC
LIMIT 10;

-- Monthly Order Counts
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Average order value 
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    ROUND(
        SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS avg_sales_per_order
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Cancelled Invoices (orders)
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT InvoiceNo) AS cancelled_orders
FROM online_retail_transactions
WHERE InvoiceNo LIKE 'C%'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month; 

-- Monthly cancellation rate 
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    COUNT(DISTINCT CASE
        WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
    END) AS cancelled_orders,
    COUNT(DISTINCT CASE
        WHEN InvoiceNo NOT LIKE 'C%' THEN InvoiceNo
    END) AS non_cancelled_orders,
    ROUND(
        100.0 * COUNT(DISTINCT CASE
            WHEN InvoiceNo LIKE 'C%' THEN InvoiceNo
        END)
        / COUNT(DISTINCT InvoiceNo),
        2
    ) AS cancellation_rate_pct
FROM online_retail_transactions
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;







