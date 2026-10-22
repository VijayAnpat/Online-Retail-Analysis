USE online_retail;

-- Query 1: Top 10 products by quantity sold
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
ORDER BY total_quantity_sold DESC
LIMIT 10;

-- Query 2: Top 10 products by net sales
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
ORDER BY net_sales DESC
LIMIT 10;

-- Query 3: Products with negative net sales
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
HAVING SUM(Quantity * UnitPrice) < 0
ORDER BY net_sales ASC
LIMIT 10;

-- Query 4: Products with negative net quantities
SELECT
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
HAVING SUM(Quantity) < 0
ORDER BY total_quantity_sold ASC
LIMIT 10;

-- Query 5: Products with the most negative-quantity rows
SELECT
    StockCode,
    Description,
    COUNT(*) AS negative_quantity_rows,
    SUM(Quantity) AS total_negative_quantity,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Quantity < 0
GROUP BY StockCode, Description
ORDER BY negative_quantity_rows DESC
LIMIT 10;

-- Query 6: Monthly sales trend for Paper Craft, Little Birdie
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND StockCode = '23843'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m'), StockCode, Description
ORDER BY sales_month;

-- Query 7: Products affected by cancellation offsets
SELECT
    StockCode,
    Description,
    SUM(
        CASE
            WHEN InvoiceNo NOT LIKE 'C%' THEN Quantity
            ELSE 0
        END
    ) AS quantity_excluding_cancellations,
    SUM(Quantity) AS quantity_all_records,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales_all_records
FROM online_retail_transactions
WHERE StockCode IS NOT NULL
GROUP BY StockCode, Description
HAVING quantity_excluding_cancellations > 0
   AND quantity_all_records <= 0
ORDER BY quantity_excluding_cancellations DESC
LIMIT 10;

-- Query 8: Monthly sales trend for Regency Cakestand 3 Tier
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND StockCode = '22423'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Query 9: Products with the highest average unit price
SELECT
    StockCode,
    Description,
    ROUND(AVG(UnitPrice), 2) AS average_unit_price,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
  AND UnitPrice > 0
GROUP BY StockCode, Description
HAVING SUM(Quantity) >= 100
ORDER BY average_unit_price DESC
LIMIT 10;

-- Query 10: Top 10 products by number of orders
SELECT
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
ORDER BY total_orders DESC
LIMIT 10;

-- Query 11: Products with the largest cancelled quantities
SELECT
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) AS cancellation_orders,
    ABS(SUM(Quantity)) AS cancelled_quantity,
    ROUND(ABS(SUM(Quantity * UnitPrice)), 2) AS cancelled_value
FROM online_retail_transactions
WHERE InvoiceNo LIKE 'C%'
  AND StockCode IS NOT NULL
GROUP BY StockCode, Description
ORDER BY cancelled_quantity DESC
LIMIT 10;

-- Query 12: Products with the highest cancellation order counts
SELECT
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) AS cancellation_orders,
    SUM(ABS(Quantity)) AS cancelled_quantity,
    ROUND(SUM(ABS(Quantity * UnitPrice)), 2) AS cancelled_value
FROM online_retail_transactions
WHERE InvoiceNo LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
ORDER BY cancellation_orders DESC
LIMIT 10;

-- Query 13: Top 10 product-country combinations by net sales
SELECT
    Country,
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
  AND Country IS NOT NULL
GROUP BY Country, StockCode, Description
ORDER BY net_sales DESC
LIMIT 10;

-- Query 14: Top 3 products by net sales within each country
WITH product_country_sales AS (
    SELECT
        TRIM(Country) AS Country,
        StockCode,
        Description,
        SUM(Quantity) AS total_quantity_sold,
        ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
      AND Country IS NOT NULL
    GROUP BY TRIM(Country), StockCode, Description
),
ranked_products AS (
    SELECT
        Country,
        StockCode,
        Description,
        total_quantity_sold,
        net_sales,
        DENSE_RANK() OVER (
            PARTITION BY Country
            ORDER BY net_sales DESC
        ) AS product_rank
    FROM product_country_sales
)
SELECT
    Country,
    product_rank,
    StockCode,
    Description,
    total_quantity_sold,
    net_sales
FROM ranked_products
WHERE product_rank <= 3
ORDER BY Country, product_rank;

-- Query 15: Top 3 physical products by sales in each country
WITH product_country_sales AS (
    SELECT
        TRIM(Country) AS Country,
        StockCode,
        Description,
        SUM(Quantity) AS total_quantity_sold,
        ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
      AND Country IS NOT NULL
      AND StockCode NOT IN ('POST', 'DOT', 'M', 'D', 'C2', 'BANK CHARGES')
    GROUP BY TRIM(Country), StockCode, Description
),
ranked_products AS (
    SELECT
        Country,
        StockCode,
        Description,
        total_quantity_sold,
        net_sales,
        DENSE_RANK() OVER (
            PARTITION BY Country
            ORDER BY net_sales DESC
        ) AS product_rank
    FROM product_country_sales
)
SELECT
    Country,
    product_rank,
    StockCode,
    Description,
    total_quantity_sold,
    net_sales
FROM ranked_products
WHERE product_rank <= 3
ORDER BY Country, product_rank;

-- Query 16: Total sales and quantity by country
SELECT
    TRIM(REPLACE(REPLACE(Country, '\r', ''), '\n', '')) AS Country,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Country IS NOT NULL
GROUP BY TRIM(REPLACE(REPLACE(Country, '\r', ''), '\n', ''))
ORDER BY net_sales DESC
LIMIT 15;

-- Query 17: Average sales per order by country
SELECT
    TRIM(REPLACE(REPLACE(Country, '\r', ''), '\n', '')) AS Country,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales,
    ROUND(
        SUM(Quantity * UnitPrice) /
        COUNT(DISTINCT InvoiceNo),
        2
    ) AS avg_sales_per_order
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Country IS NOT NULL
GROUP BY TRIM(REPLACE(REPLACE(Country, '\r', ''), '\n', ''))
HAVING COUNT(DISTINCT InvoiceNo) >= 5
ORDER BY avg_sales_per_order DESC
LIMIT 15;

-- Query 18: Products with highest average quantity per order
SELECT
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(
        SUM(Quantity) / COUNT(DISTINCT InvoiceNo),
        2
    ) AS avg_quantity_per_order,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
HAVING COUNT(DISTINCT InvoiceNo) >= 20
ORDER BY avg_quantity_per_order DESC
LIMIT 10;

-- Query 19: Products purchased by the most distinct customers
SELECT
    StockCode,
    Description,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS net_sales
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
  AND CustomerID IS NOT NULL
GROUP BY StockCode, Description
ORDER BY unique_customers DESC
LIMIT 10;

-- Query 20: Products with the most repeat-purchasing customers
WITH customer_product_orders AS (
    SELECT
        StockCode,
        Description,
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS customer_orders
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
      AND CustomerID IS NOT NULL
    GROUP BY StockCode, Description, CustomerID
)
SELECT
    StockCode,
    Description,
    COUNT(*) AS repeat_customers,
    SUM(customer_orders) AS orders_from_repeat_customers
FROM customer_product_orders
WHERE customer_orders >= 2
GROUP BY StockCode, Description
ORDER BY repeat_customers DESC
LIMIT 10;

-- Query 21: Product repeat-purchase rate
WITH customer_product_orders AS (
    SELECT
        StockCode,
        Description,
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS customer_orders
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
      AND CustomerID IS NOT NULL
    GROUP BY StockCode, Description, CustomerID
)
SELECT
    StockCode,
    Description,
    COUNT(*) AS unique_customers,
    SUM(CASE WHEN customer_orders >= 2 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(CASE WHEN customer_orders >= 2 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS repeat_purchase_rate_pct
FROM customer_product_orders
GROUP BY StockCode, Description
HAVING COUNT(*) >= 100
ORDER BY repeat_purchase_rate_pct DESC
LIMIT 10;

-- Query 22: Products with the highest negative quantities
SELECT
    StockCode,
    Description,
    SUM(CASE
        WHEN Quantity < 0 THEN ABS(Quantity)
        ELSE 0
    END) AS negative_quantity_units,
    COUNT(CASE
        WHEN Quantity < 0 THEN 1
    END) AS negative_quantity_rows,
    ROUND(
        SUM(CASE
            WHEN Quantity < 0 THEN ABS(Quantity * UnitPrice)
            ELSE 0
        END),
        2
    ) AS negative_quantity_value
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND Description IS NOT NULL
GROUP BY StockCode, Description
HAVING SUM(CASE WHEN Quantity < 0 THEN 1 ELSE 0 END) > 0
ORDER BY negative_quantity_units DESC
LIMIT 10;

-- Query 23: Monthly sales trend for a selected product
SELECT
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
    SUM(Quantity) AS total_quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS sales_excluding_cancellations,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND StockCode = '85123A'
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY sales_month;

-- Query 24: Product contribution to total sales
WITH product_sales AS (
    SELECT
        StockCode,
        Description,
        SUM(Quantity * UnitPrice) AS product_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
    GROUP BY StockCode, Description
),
total_sales AS (
    SELECT SUM(product_sales) AS overall_sales
    FROM product_sales
)
SELECT
    p.StockCode,
    p.Description,
    ROUND(p.product_sales, 2) AS product_sales,
    ROUND(
        100.0 * p.product_sales / t.overall_sales,
        2
    ) AS sales_contribution_pct
FROM product_sales p
CROSS JOIN total_sales t
ORDER BY p.product_sales DESC
LIMIT 10;

-- Query 25: Overall product analysis summary
WITH product_summary AS (
    SELECT
        StockCode,
        Description,
        SUM(Quantity) AS total_quantity,
        SUM(Quantity * UnitPrice) AS product_sales,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND Description IS NOT NULL
    GROUP BY StockCode, Description
)
SELECT
    COUNT(*) AS distinct_product_codes,
    SUM(total_quantity) AS total_quantity_sold,
    ROUND(SUM(product_sales), 2) AS total_sales_excluding_cancellations,
    SUM(total_orders) AS sum_of_product_order_counts,
    ROUND(AVG(product_sales), 2) AS average_sales_per_product,
    SUM(CASE WHEN total_quantity < 0 THEN 1 ELSE 0 END)
        AS products_with_negative_net_quantity
FROM product_summary;