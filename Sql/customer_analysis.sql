USE online_retail;

-- Query 1: Repeated customers
SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        CustomerID
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) AS customer_orders;

-- Query 2: Total unique customers
SELECT
     COUNT(DISTINCT CustomerID) AS total_unique_custmers
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL;

-- Query 3: Repeat-customer percentage
SELECT
    ROUND(
        100.0 * COUNT(*)/
        (SELECT COUNT(DISTINCT CustomerID)
        FROM online_retail_transactions
        WHERE CustomerID IS NOT NULL
    ),
    2
    ) AS repeat_customer_percentage
FROM (
    SELECT CustomerID
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) > 1
) AS repeat_customer_list;

-- Query 4: Customers with only one purchase
SELECT
    COUNT(*) AS one_time_customers
FROM (
    SELECT
        CustomerID
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
    HAVING COUNT(DISTINCT InvoiceNo) = 1
) AS one_time_customer_list;

-- Query 5: Top 10 customers by net sales
SELECT
    CustomerID,
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID, Country
ORDER BY net_sales DESC
LIMIT 10;

-- Query 6: Top 10 customers by number of orders
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_orders DESC, net_sales DESC
LIMIT 10;

-- Query 7: Top 10 customers by average net sales per order
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales,
    ROUND(
        SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_sales_per_order
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) >= 5
ORDER BY average_sales_per_order DESC
LIMIT 10;

-- Query 8: Customer count by country
SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS total_customers
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
GROUP BY Country
ORDER BY total_customers DESC
LIMIT 10;

-- Query 9: Customer purchase frequency distribution
SELECT
    order_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
) AS customer_order_summary
GROUP BY order_count
ORDER BY order_count;

-- Query 10: Customer retention summary
SELECT
    COUNT(*) AS customers_with_purchases,
    SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END)
        AS one_time_customers,
    SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS repeat_customer_percentage
FROM (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS order_count
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
) AS customer_order_summary;

-- Query 11: Customers with the longest purchase history
SELECT
    CustomerID,
    MIN(InvoiceDate) AS first_purchase,
    MAX(InvoiceDate) AS last_purchase,
    DATEDIFF(
        MAX(InvoiceDate),
        MIN(InvoiceDate)
    ) AS purchase_span_days,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
HAVING COUNT(DISTINCT InvoiceNo) > 1
ORDER BY purchase_span_days DESC, total_orders DESC
LIMIT 10;

-- Query 12: Top 10 customers by total quantity purchased
SELECT
    CustomerID,
    SUM(Quantity) AS total_quantity,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_quantity DESC
LIMIT 10;


