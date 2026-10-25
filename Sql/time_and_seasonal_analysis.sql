-- Query 1: Quarterly sales performance
SELECT
    YEAR(InvoiceDate) AS sales_year,
    QUARTER(InvoiceDate) AS sales_quarter,
    ROUND(
        SUM(Quantity * UnitPrice), 2
    ) AS sales_excluding_cancellations,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
GROUP BY
    YEAR(InvoiceDate),
    QUARTER(InvoiceDate)
ORDER BY
    sales_year,
    sales_quarter;

-- Query 2: Month-over-month sales change

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
    GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
),
sales_with_previous_month AS (
    SELECT
        sales_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_sales
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2) AS sales_change,
    ROUND(
        100.0 * (monthly_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0),
        2
    ) AS sales_change_pct
FROM sales_with_previous_month
ORDER BY sales_month;

-- Query 3: Rank months by sales performance

WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
    GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
)
SELECT
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales,
    DENSE_RANK() OVER (
        ORDER BY monthly_sales DESC
    ) AS highest_sales_rank,
    DENSE_RANK() OVER (
        ORDER BY monthly_sales ASC
    ) AS lowest_sales_rank
FROM monthly_sales
ORDER BY monthly_sales DESC;

-- Query 4: Quarter-over-quarter sales change

WITH quarterly_sales AS (
    SELECT
        YEAR(InvoiceDate) AS sales_year,
        QUARTER(InvoiceDate) AS sales_quarter,
        SUM(Quantity * UnitPrice) AS quarter_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
    GROUP BY
        YEAR(InvoiceDate),
        QUARTER(InvoiceDate)
),
quarter_comparison AS (
    SELECT
        sales_year,
        sales_quarter,
        quarter_sales,
        LAG(quarter_sales) OVER (
            ORDER BY sales_year, sales_quarter
        ) AS previous_quarter_sales
    FROM quarterly_sales
)
SELECT
    sales_year,
    sales_quarter,
    ROUND(quarter_sales, 2) AS quarter_sales,
    ROUND(previous_quarter_sales, 2) AS previous_quarter_sales,
    ROUND(
        quarter_sales - previous_quarter_sales, 2
    ) AS sales_change,
    ROUND(
        100.0 * (quarter_sales - previous_quarter_sales)
        / NULLIF(previous_quarter_sales, 0),
        2
    ) AS sales_change_pct
FROM quarter_comparison
ORDER BY sales_year, sales_quarter;