USE online_retail;
-- Query 1: Customer_revenue_concentration

WITH customer_revenue AS (
    SELECT
         CustomerID,
         SUM(Quantity * UnitPrice) AS customer_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL AND
          InvoiceNo NOT LIKE "C%"
    GROUP BY CustomerID
),

ranked_customers AS (
    SELECT 
        CustomerID,
        customer_sales,
        ROW_NUMBER() OVER(
            ORDER BY customer_sales DESC, CustomerID
        ) AS customer_rank,
        SUM(customer_sales) OVER(
            ORDER BY customer_sales DESC, CustomerID
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS cummulative_sales,
        SUM(customer_sales) over() total_customer_sales,
        COUNT(*) OVER() AS total_customers
    FROM customer_revenue
)

SELECT 
    CustomerID,
    ROUND(customer_sales, 2) AS customer_sales,
    customer_rank,
    ROUND(
        100.0 * customer_sales / NULLIF(total_customer_sales, 0),
        2
    ) AS individual_sales_pct,
    ROUND(
        100.0 * cummulative_sales / NULLIF(total_customer_sales, 0),
        2
    ) AS cummulative_sales_pct,
    ROUND(
        100.0 * customer_rank / total_customers,
        2
    ) AS cummulative_customer_pct
FROM ranked_customers
ORDER BY customer_rank
LIMIT 50;

 -- Customer_concentration_more_precisely

WITH customer_revenue AS (
    SELECT
        CustomerID,
        SUM(Quantity * UnitPrice) AS customer_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
ranked_customers AS (
    SELECT
        CustomerID,
        customer_sales,
        ROW_NUMBER() OVER (
            ORDER BY customer_sales DESC, CustomerID
        ) AS customer_rank,
        COUNT(*) OVER () AS total_customers,
        SUM(customer_sales) OVER () AS total_customer_sales
    FROM customer_revenue
)
SELECT
    ROUND(
        100.0 * SUM(
            CASE WHEN customer_rank <= CEIL(total_customers * 0.01)
                 THEN customer_sales ELSE 0 END
        ) / MAX(total_customer_sales), 2
    ) AS top_1_pct_revenue,
    ROUND(
        100.0 * SUM(
            CASE WHEN customer_rank <= CEIL(total_customers * 0.05)
                 THEN customer_sales ELSE 0 END
        ) / MAX(total_customer_sales), 2
    ) AS top_5_pct_revenue,
    ROUND(
        100.0 * SUM(
            CASE WHEN customer_rank <= CEIL(total_customers * 0.10)
                 THEN customer_sales ELSE 0 END
        ) / MAX(total_customer_sales), 2
    ) AS top_10_pct_revenue,
    ROUND(
        100.0 * SUM(
            CASE WHEN customer_rank <= CEIL(total_customers * 0.20)
                 THEN customer_sales ELSE 0 END
        ) / MAX(total_customer_sales), 2
    ) AS top_20_pct_revenue
FROM ranked_customers;


/*
QUERY 1: CUSTOMER REVENUE CONCENTRATION

Key findings:
- Top 1% of customers contribute 32.00% of sales.
- Top 5% contribute 50.38%.
- Top 10% contribute 61.38%.
- Top 20% contribute 74.62%.

Business recommendation:
Prioritize retention strategies for high-value customers.

Caveat:
Sales exclude cancellation invoices and customers with missing IDs.
Cancellation invoices are not reconciled against original invoices.
*/

-- Query 2: Customer_value_segmentation

SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales,
    ROUND(
        SUM(Quantity * UnitPrice) /
        NULLIF(COUNT(DISTINCT InvoiceNo), 0),
        2
    ) AS average_sales_per_order
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY total_sales DESC
LIMIT 20;

-- Customer_segmentation_threshold


WITH customer_metrics AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS total_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
ranked_metrics AS (
    SELECT
        total_orders,
        total_sales,
        ROW_NUMBER() OVER (ORDER BY total_orders) AS order_rank,
        ROW_NUMBER() OVER (ORDER BY total_sales) AS sales_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_metrics
)
SELECT
    MAX(CASE
        WHEN order_rank = FLOOR((total_customers + 1) / 2)
        THEN total_orders
    END) AS median_orders,
    MAX(CASE
        WHEN sales_rank = FLOOR((total_customers + 1) / 2)
        THEN ROUND(total_sales, 2)
    END) AS median_sales
FROM ranked_metrics;



WITH customer_metrics AS (
    SELECT
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS total_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
    GROUP BY CustomerID
),
ranked_metrics AS (
    SELECT
        total_orders,
        total_sales,
        ROW_NUMBER() OVER (ORDER BY total_orders) AS order_rank,
        ROW_NUMBER() OVER (ORDER BY total_sales) AS sales_rank,
        COUNT(*) OVER () AS total_customers
    FROM customer_metrics
),
thresholds AS (
    SELECT
        AVG(CASE
            WHEN order_rank IN (
                FLOOR((total_customers + 1) / 2),
                FLOOR((total_customers + 2) / 2)
            )
            THEN total_orders
        END) AS median_orders,
        AVG(CASE
            WHEN sales_rank IN (
                FLOOR((total_customers + 1) / 2),
                FLOOR((total_customers + 2) / 2)
            )
            THEN total_sales
        END) AS median_sales
    FROM ranked_metrics
),
segmented_customers AS (
    SELECT
        cm.CustomerID,
        cm.total_orders,
        cm.total_sales,
        CASE
            WHEN cm.total_sales >= t.median_sales
             AND cm.total_orders >= t.median_orders
                THEN 'High Value, Frequent'
            WHEN cm.total_sales >= t.median_sales
             AND cm.total_orders < t.median_orders
                THEN 'High Value, Infrequent'
            WHEN cm.total_sales < t.median_sales
             AND cm.total_orders >= t.median_orders
                THEN 'Lower Value, Frequent'
            ELSE 'Lower Value, Infrequent'
        END AS customer_segment
    FROM customer_metrics cm
    CROSS JOIN thresholds t
)
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage,
    ROUND(SUM(total_sales), 2) AS segment_sales
FROM segmented_customers
GROUP BY customer_segment
ORDER BY segment_sales DESC;

-- Query 3 : Product_sales_vs_customer_reach

-- Product_sales_and_customer_reach

SELECT
    StockCode,
    Description,
    ROUND(
        SUM(Quantity * UnitPrice),
        2
    ) AS product_sales,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT InvoiceNo) AS total_orders
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND StockCode IS NOT NULL
GROUP BY StockCode, Description
HAVING SUM(Quantity * UnitPrice) > 0
ORDER BY product_sales DESC
LIMIT 20;

-- Identify_products_above_median_sales


WITH product_metrics AS (
    SELECT
        StockCode,
        Description,
        SUM(Quantity * UnitPrice) AS product_sales,
        COUNT(DISTINCT CustomerID) AS unique_customers,
        COUNT(DISTINCT InvoiceNo) AS total_orders
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
    GROUP BY StockCode, Description
    HAVING SUM(Quantity * UnitPrice) > 0
),
ranked_products AS (
    SELECT
        product_metrics.*,
        ROW_NUMBER() OVER (
            ORDER BY product_sales
        ) AS sales_rank,
        ROW_NUMBER() OVER (
            ORDER BY unique_customers
        ) AS reach_rank,
        COUNT(*) OVER () AS total_products
    FROM product_metrics
),
thresholds AS (
    SELECT
        AVG(CASE
            WHEN sales_rank IN (
                FLOOR((total_products + 1) / 2),
                FLOOR((total_products + 2) / 2)
            )
            THEN product_sales
        END) AS median_sales,
        AVG(CASE
            WHEN reach_rank IN (
                FLOOR((total_products + 1) / 2),
                FLOOR((total_products + 2) / 2)
            )
            THEN unique_customers
        END) AS median_customers
    FROM ranked_products
)
SELECT
    rp.StockCode,
    rp.Description,
    ROUND(rp.product_sales, 2) AS product_sales,
    rp.unique_customers,
    rp.total_orders,
    ROUND(t.median_sales, 2) AS median_product_sales,
    t.median_customers
FROM ranked_products rp
CROSS JOIN thresholds t
WHERE rp.product_sales > t.median_sales
  AND rp.unique_customers < t.median_customers
ORDER BY rp.product_sales DESC
LIMIT 20;

-- Investigate_stockcode_22502_transactions

SELECT
    InvoiceNo,
    InvoiceDate,
    CustomerID,
    Quantity,
    UnitPrice,
    ROUND(Quantity * UnitPrice, 2) AS line_sales,
    Country
FROM online_retail_transactions
WHERE StockCode = '22502'
ORDER BY InvoiceDate, InvoiceNo;

-- Verify_stock_code_level_totals

SELECT
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT InvoiceNo) AS distinct_invoices,
    COUNT(DISTINCT CustomerID) AS unique_identified_customers,
    SUM(Quantity) AS total_quantity,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail_transactions
WHERE StockCode = '22502'
  AND InvoiceNo NOT LIKE 'C%';

-- Investigate_inconsistent_descriptions

SELECT
    StockCode,
    Description,
    COUNT(*) AS transaction_rows,
    COUNT(DISTINCT InvoiceNo) AS distinct_invoices,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS product_sales
FROM online_retail_transactions
WHERE StockCode = '22502'
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY StockCode, Description
ORDER BY product_sales DESC;


-- Query 4: Products_with_declining_sales

-- step 1: Calculate_monthly_sales_for_each_product

WITH monthly_product_sales AS (
    SELECT
        StockCode,
        Description,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
      AND InvoiceDate IS NOT NULL
    GROUP BY
        StockCode,
        Description,
        DATE_FORMAT(InvoiceDate, '%Y-%m')
)
SELECT
    StockCode,
    Description,
    sales_month,
    ROUND(monthly_sales, 2) AS monthly_sales
FROM monthly_product_sales
ORDER BY StockCode, sales_month
LIMIT 50;

-- Step 2: Compare_each_months_sales_with_previous_month

WITH monthly_product_sales AS (
    SELECT
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
      AND InvoiceDate IS NOT NULL
      AND Description IS NOT NULL
      AND TRIM(Description) <> ''
    GROUP BY
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m')
),
sales_comparison AS (
    SELECT
        StockCode,
        sales_month,
        monthly_sales,
        LAG(monthly_sales) OVER (
            PARTITION BY StockCode
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_product_sales
)
SELECT
    StockCode,
    sales_month,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(monthly_sales, 2) AS current_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2) AS sales_change
FROM sales_comparison
ORDER BY StockCode, sales_month
LIMIT 50;


-- Step 3: Products_with_declining_sales_across_consecutive_calendar_months

WITH monthly_product_sales AS (
    SELECT
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
      AND InvoiceDate IS NOT NULL
      AND Description IS NOT NULL
      AND TRIM(Description) <> ''
    GROUP BY
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m')
),
sales_comparison AS (
    SELECT
        StockCode,
        sales_month,
        monthly_sales,
        LAG(sales_month) OVER (
            PARTITION BY StockCode
            ORDER BY sales_month
        ) AS previous_month,
        LAG(monthly_sales) OVER (
            PARTITION BY StockCode
            ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_product_sales
),
declines AS (
    SELECT
        *,
        CASE
            WHEN TIMESTAMPDIFF(
                MONTH,
                STR_TO_DATE(CONCAT(previous_month, '-01'), '%Y-%m-%d'),
                STR_TO_DATE(CONCAT(sales_month, '-01'), '%Y-%m-%d')
            ) = 1
            AND monthly_sales < previous_month_sales
            THEN 1
            ELSE 0
        END AS is_consecutive_decline
    FROM sales_comparison
)
SELECT
    StockCode,
    previous_month,
    sales_month,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(monthly_sales, 2) AS current_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2) AS sales_change
FROM declines
WHERE is_consecutive_decline = 1
ORDER BY StockCode, sales_month
LIMIT 50;

-- Step 4: Identify_at_least_3_consecutive_monthly_declines

WITH monthly_product_sales AS (
    SELECT
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
      AND InvoiceDate IS NOT NULL
      AND Description IS NOT NULL
      AND TRIM(Description) <> ''
    GROUP BY
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m')
),
sales_comparison AS (
    SELECT
        StockCode,
        sales_month,
        monthly_sales,
        LAG(sales_month) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS previous_month,
        LAG(monthly_sales) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_product_sales
),
declines AS (
    SELECT
        *,
        CASE
            WHEN TIMESTAMPDIFF(
                MONTH,
                STR_TO_DATE(CONCAT(previous_month, '-01'), '%Y-%m-%d'),
                STR_TO_DATE(CONCAT(sales_month, '-01'), '%Y-%m-%d')
            ) = 1
            AND monthly_sales < previous_month_sales
            THEN 1 ELSE 0
        END AS is_decline
    FROM sales_comparison
),
decline_streaks AS (
    SELECT
        *,
        LAG(is_decline, 1) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS previous_decline,
        LAG(is_decline, 2) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS two_months_ago_decline
    FROM declines
)
SELECT
    StockCode,
    sales_month,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(monthly_sales, 2) AS current_month_sales,
    ROUND(monthly_sales - previous_month_sales, 2) AS sales_change
FROM decline_streaks
WHERE is_decline = 1
  AND previous_decline = 1
  AND two_months_ago_decline = 1
ORDER BY StockCode, sales_month;


-- Step 5: Summarize_consecutive_monthly_sales_declines

WITH monthly_product_sales AS (
    SELECT
        StockCode,
        DATE_FORMAT(InvoiceDate, '%Y-%m') AS sales_month,
        SUM(Quantity * UnitPrice) AS monthly_sales
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND StockCode IS NOT NULL
      AND InvoiceDate IS NOT NULL
      AND Description IS NOT NULL
      AND TRIM(Description) <> ''
    GROUP BY StockCode, DATE_FORMAT(InvoiceDate, '%Y-%m')
),
sales_comparison AS (
    SELECT
        StockCode,
        sales_month,
        monthly_sales,
        LAG(sales_month) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS previous_month,
        LAG(monthly_sales) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS previous_month_sales
    FROM monthly_product_sales
),
declines AS (
    SELECT *,
        CASE
            WHEN TIMESTAMPDIFF(
                MONTH,
                STR_TO_DATE(CONCAT(previous_month, '-01'), '%Y-%m-%d'),
                STR_TO_DATE(CONCAT(sales_month, '-01'), '%Y-%m-%d')
            ) = 1
            AND monthly_sales < previous_month_sales
            THEN 1 ELSE 0
        END AS is_decline
    FROM sales_comparison
),
streak_groups AS (
    SELECT *,
        SUM(
            CASE WHEN is_decline = 0 THEN 1 ELSE 0 END
        ) OVER (
            PARTITION BY StockCode ORDER BY sales_month
        ) AS streak_group
    FROM declines
),
streak_summary AS (
    SELECT
        StockCode,
        streak_group,
        COUNT(*) AS declining_months,
        MIN(sales_month) AS first_decline_month,
        MAX(sales_month) AS last_decline_month
    FROM streak_groups
    WHERE is_decline = 1
    GROUP BY StockCode, streak_group
)
SELECT
    StockCode,
    declining_months,
    first_decline_month,
    last_decline_month
FROM streak_summary
WHERE declining_months >= 3
ORDER BY declining_months DESC, StockCode
LIMIT 30;


-- Product_descriptions

SELECT
    StockCode,
    GROUP_CONCAT(
        DISTINCT NULLIF(TRIM(Description), '')
        ORDER BY Description
        SEPARATOR ' | '
    ) AS product_descriptions
FROM online_retail_transactions
WHERE StockCode IN (
    '21936', '22196', '47566B', '16016',
    '20665', '21340', '21361', '21749',
    '22059', '22195', '22432', '22479',
    '23051'
)
GROUP BY StockCode
ORDER BY StockCode;



-- QUERY 5: Inactive_Customers

-- Step 1: Each_customer's_last_purchase_date

SELECT
    CustomerID,
    MAX(InvoiceDate) AS last_purchase_date,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_sales
FROM online_retail_transactions
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
  AND InvoiceDate IS NOT NULL
GROUP BY CustomerID
ORDER BY last_purchase_date;


-- Step 2: Latest_transaction_date

SELECT
    MAX(InvoiceDate) AS latest_transaction_date
FROM online_retail_transactions
WHERE InvoiceNo NOT LIKE 'C%'
  AND InvoiceDate IS NOT NULL;


-- Step 3: Identify_customers_inactive_for_more_than_90_days

WITH customer_metrics AS (
    SELECT
        CustomerID,
        MAX(InvoiceDate) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS total_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
    GROUP BY CustomerID
),
dataset_date AS (
    SELECT MAX(InvoiceDate) AS latest_date
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
)
SELECT
    cm.CustomerID,
    cm.last_purchase_date,
    DATEDIFF(dd.latest_date, cm.last_purchase_date) AS inactive_days,
    cm.total_orders,
    ROUND(cm.total_sales, 2) AS total_sales
FROM customer_metrics cm
CROSS JOIN dataset_date dd
WHERE DATEDIFF(dd.latest_date, cm.last_purchase_date) > 90
ORDER BY inactive_days DESC
LIMIT 50;

-- Step 4: Summarize_inactive_customers

WITH customer_metrics AS (
    SELECT
        CustomerID,
        MAX(InvoiceDate) AS last_purchase_date,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS total_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
    GROUP BY CustomerID
),
dataset_date AS (
    SELECT MAX(InvoiceDate) AS latest_date
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
)
SELECT
    COUNT(*) AS total_customers,
    SUM(
        CASE
            WHEN DATEDIFF(dd.latest_date, cm.last_purchase_date) > 90
            THEN 1 ELSE 0
        END
    ) AS inactive_customers,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN DATEDIFF(dd.latest_date, cm.last_purchase_date) > 90
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS inactive_customer_percentage,
    ROUND(
        SUM(
            CASE
                WHEN DATEDIFF(dd.latest_date, cm.last_purchase_date) > 90
                THEN cm.total_sales ELSE 0
            END
        ),
        2
    ) AS historical_sales_from_inactive_customers
FROM customer_metrics cm
CROSS JOIN dataset_date dd;

-- Query 5: Inactive_Customer_Analysis
-- Business Question:
-- Which identified customers have not purchased in the
-- last 90 days of the dataset?

-- Key Findings:
-- Total identified customers: 4,339
-- Inactive customers: 1,449
-- Inactive customer percentage: 33.39%
-- Historical sales from inactive customers: £1,035,270.41

-- Business Insight:
-- Approximately one-third of identified customers were
-- inactive during the final 90 days of the dataset.
-- Customers with high historical sales and multiple orders
-- may be prioritized for re-engagement campaigns.

-- Limitation:
-- Inactivity is measured relative to December 9, 2011,
-- not the present day. Historical sales do not guarantee
-- recoverable revenue.



-- Query 6: New_vs_returning_customer_revenue


-- Query 6: New vs. Returning Customer Revenue by Month

WITH customer_first_purchase AS (
    SELECT
        CustomerID,
        MIN(DATE_FORMAT(InvoiceDate, '%Y-%m')) AS first_purchase_month
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
    GROUP BY CustomerID
),
monthly_customer_sales AS (
    SELECT
        DATE_FORMAT(t.InvoiceDate, '%Y-%m') AS sales_month,
        t.CustomerID,
        SUM(t.Quantity * t.UnitPrice) AS customer_monthly_sales
    FROM online_retail_transactions t
    WHERE t.CustomerID IS NOT NULL
      AND t.InvoiceNo NOT LIKE 'C%'
      AND t.InvoiceDate IS NOT NULL
    GROUP BY
        DATE_FORMAT(t.InvoiceDate, '%Y-%m'),
        t.CustomerID
)
SELECT
    mcs.sales_month,
    ROUND(SUM(
        CASE
            WHEN mcs.sales_month = cfp.first_purchase_month
            THEN mcs.customer_monthly_sales
            ELSE 0
        END
    ), 2) AS new_customer_revenue,
    ROUND(SUM(
        CASE
            WHEN mcs.sales_month > cfp.first_purchase_month
            THEN mcs.customer_monthly_sales
            ELSE 0
        END
    ), 2) AS returning_customer_revenue,
    ROUND(SUM(mcs.customer_monthly_sales), 2) AS total_monthly_revenue
FROM monthly_customer_sales mcs
JOIN customer_first_purchase cfp
    ON mcs.CustomerID = cfp.CustomerID
GROUP BY mcs.sales_month
ORDER BY mcs.sales_month;

-- Key Findings:
-- Highest total monthly revenue: November 2011 (£1,161,817.38)
-- Highest returning customer revenue: November 2011 (£1,025,225.26)
-- Highest new customer revenue: December 2010 (£572,713.89)
-- Returning customers contributed approximately 88.26%
-- of November 2011 identified-customer revenue.

-- Business Insight:
-- Returning customers were an important source of revenue,
-- particularly in the later months of the dataset.
-- The business could investigate retention strategies while
-- continuing to attract new customers.

-- Limitation:
-- Only transactions with identified CustomerIDs are included.
-- Cancellation invoices are excluded, and December 2011 is partial.


-- Query 7: Country_Spending_and_Repeat_Purchase_Behavior

WITH customer_country_metrics AS (
    SELECT
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ) AS country,
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS customer_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
      AND Country IS NOT NULL
    GROUP BY
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ),
        CustomerID
)
SELECT
    country,
    COUNT(*) AS identified_customers,
    ROUND(SUM(customer_sales), 2) AS total_sales,
    ROUND(AVG(customer_sales), 2) AS avg_customer_spend,
    SUM(CASE WHEN total_orders > 1 THEN 1 ELSE 0 END)
        AS repeat_customers,
    ROUND(
        100.0 * SUM(
            CASE WHEN total_orders > 1 THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS repeat_purchase_rate_pct
FROM customer_country_metrics
GROUP BY country
ORDER BY total_sales DESC;

-- Key Findings:
-- UK: 3,921 customers; sales £7,308,391.55;
-- repeat purchase rate 65.54%.
-- Netherlands: 9 customers; sales £285,446.34;
-- average customer spend £31,716.26.
-- Australia: 9 customers; repeat purchase rate 100%.
-- Germany: 94 customers; repeat purchase rate 72.34%.
-- France: 87 customers; repeat purchase rate 67.82%.

-- Business Insight:
-- The UK is the core market by customer count and sales.
-- The Netherlands has high average customer spend.
-- Australia shows strong repeat purchasing in this dataset.
-- Germany and France combine meaningful sales with
-- relatively high repeat purchase rates.

-- Limitation:
-- Small customer counts can produce unstable averages
-- and repeat purchase rates. Sales exclude cancellation
-- invoices and include only customers with recorded IDs.




-- Query 8: Products_Frequently_Bought_Together

-- Step 1: Find_product_pairs_appearing_on_the_same_invoice

WITH invoice_products AS (
    SELECT DISTINCT
        InvoiceNo,
        StockCode
    FROM online_retail_transactions
    WHERE InvoiceNo NOT LIKE 'C%'
      AND InvoiceNo IS NOT NULL
      AND StockCode IS NOT NULL
      AND TRIM(StockCode) <> ''
      AND InvoiceDate IS NOT NULL
)
SELECT
    p1.StockCode AS product_1,
    p2.StockCode AS product_2,
    COUNT(DISTINCT p1.InvoiceNo) AS invoices_together
FROM invoice_products p1
JOIN invoice_products p2
    ON p1.InvoiceNo = p2.InvoiceNo
   AND p1.StockCode < p2.StockCode
GROUP BY
    p1.StockCode,
    p2.StockCode
HAVING COUNT(DISTINCT p1.InvoiceNo) >= 10
ORDER BY invoices_together DESC
LIMIT 30;


-- Validate_product_descriptions

SELECT
    StockCode,
    Description,
    COUNT(*) AS transaction_rows
FROM online_retail_transactions
WHERE StockCode IN (
    '22386', '85099B', '22697', '22699',
    '21931', '22411', '20725', '22383',
    '20727', '22726', '22727', '22698'
)
  AND Description IS NOT NULL
  AND TRIM(Description) <> ''
GROUP BY StockCode, Description
ORDER BY StockCode, transaction_rows DESC;

-- Key Findings:
-- Most frequent pair:
-- 22386 Jumbo Bag Pink Polkadot + 85099B Jumbo Bag Red Retrospot
-- Appeared together on 825 invoices.

-- Second most frequent pair:
-- 22697 Green Regency Teacup and Saucer +
-- 22699 Roses Regency Teacup and Saucer
-- Appeared together on 768 invoices.

-- StockCode 85099B (Jumbo Bag Red Retrospot) appears
-- in multiple high-frequency product pairs.

-- Business Insight:
-- Coordinated bag designs, lunch bags, and Regency
-- teacup and saucer designs are candidates for cross-selling
-- recommendations and bundle experiments.

-- Limitation:
-- Same-invoice co-occurrence does not prove a causal
-- relationship or guarantee that a bundle will increase sales.
-- Cancellation invoices are excluded but not reconciled
-- against their original sales.
-- Product descriptions may contain inconsistencies.


-- Query 9: Top_customers_within_each_country


WITH customer_country_sales AS (
    SELECT
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ) AS country,
        CustomerID,
        COUNT(DISTINCT InvoiceNo) AS total_orders,
        SUM(Quantity * UnitPrice) AS total_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
      AND Country IS NOT NULL
    GROUP BY
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ),
        CustomerID
),
ranked_customers AS (
    SELECT
        country,
        CustomerID,
        total_orders,
        total_sales,
        DENSE_RANK() OVER (
            PARTITION BY country
            ORDER BY total_sales DESC
        ) AS customer_rank
    FROM customer_country_sales
)
SELECT
    country,
    CustomerID,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 3
ORDER BY country, customer_rank;

-- Key Findings:
-- Australia: Customer 12415, 21 orders, £124,914.53 sales.
-- EIRE: Customer 14911, 201 orders, £143,825.06 sales.
-- Netherlands: Customer 14646, 74 orders, £280,206.02 sales.
-- UK: Customer 18102, 60 orders, £259,657.30 sales.
-- UK second-ranked customer 17450 generated £194,550.79.

-- Business Insight:
-- High-value customers in international markets may
-- represent important customer relationships.
-- The UK also has several high-value customers.
-- Customer concentration should be quantified by comparing
-- top-customer sales with total country sales.

-- Limitation:
-- Sales exclude cancellation invoices and customers
-- without a recorded CustomerID.


-- Query 10: Cross-Domain_business_opportunities_and_risks

-- Measure_Top-customer_revenue_concentration_by_country

WITH customer_country_sales AS (
    SELECT
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ) AS country,
        CustomerID,
        SUM(Quantity * UnitPrice) AS customer_sales
    FROM online_retail_transactions
    WHERE CustomerID IS NOT NULL
      AND InvoiceNo NOT LIKE 'C%'
      AND InvoiceDate IS NOT NULL
      AND Country IS NOT NULL
    GROUP BY
        TRIM(
            REPLACE(
                REPLACE(Country, '\r', ''),
                '\n', ''
            )
        ),
        CustomerID
),
ranked_customers AS (
    SELECT
        country,
        CustomerID,
        customer_sales,
        DENSE_RANK() OVER (
            PARTITION BY country
            ORDER BY customer_sales DESC
        ) AS customer_rank
    FROM customer_country_sales
),
country_totals AS (
    SELECT
        country,
        SUM(customer_sales) AS country_sales,
        COUNT(*) AS identified_customers
    FROM customer_country_sales
    GROUP BY country
)
SELECT
    ct.country,
    ct.identified_customers,
    ROUND(ct.country_sales, 2) AS country_sales,
    rc.CustomerID AS top_customer_id,
    ROUND(rc.customer_sales, 2) AS top_customer_sales,
    ROUND(
        100.0 * rc.customer_sales / NULLIF(ct.country_sales, 0),
        2
    ) AS top_customer_sales_pct
FROM country_totals ct
JOIN ranked_customers rc
    ON ct.country = rc.country
WHERE rc.customer_rank = 1
ORDER BY top_customer_sales_pct DESC, ct.country_sales DESC;

-- Key Findings:
-- Netherlands: top customer contributes 98.16% of country sales.
-- Australia: top customer contributes 90.18%.
-- EIRE: top customer contributes 54.16%.
-- UK: top customer contributes 3.55%.
-- Germany: top customer contributes 8.66%.
-- France: top customer contributes 9.04%.

-- Business Risks:
-- High customer concentration in the Netherlands and Australia
-- creates potential exposure if a major customer stops buying.
-- Percentages for countries with very few customers
-- should be interpreted cautiously.

-- Business Opportunities:
-- Protect important customer relationships in concentrated markets.
-- Investigate customer acquisition opportunities in markets
-- with broader customer bases, such as Germany and France.
-- Maintain the UK customer base while exploring international growth.

-- Limitation:
-- Analysis includes identified customers and excludes cancellation
-- invoices, without reconciling cancellations to original sales.
-- High concentration alone does not prove a market is unprofitable
-- or that customer acquisition will succeed.



