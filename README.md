# Online Retail Sales & Business Performance Analysis

## Project Overview

This portfolio project analyzes transactions from a UK-based online retailer to understand sales performance, customer purchasing behavior, product trends, and overall business performance.

The project uses Microsoft Excel, SQL, and Python to investigate data quality, analyze transactions, identify purchasing patterns, and answer business questions using structured data analysis.

## Objectives

- Investigate data quality issues and transaction anomalies.
- Analyze sales performance across months, quarters, countries, and products.
- Understand customer purchasing behavior, repeat purchasing, and revenue concentration.
- Identify high-performing products and frequently purchased product combinations.
- Examine customer value segments and periods of declining product sales.
- Evaluate cancellations, missing customer information, and unusual transactions.
- Translate analytical findings into actionable business insights.

## Tools & Technologies

- **Microsoft Excel** — Data quality investigation, PivotTables, charts, KPI cards, and dashboard development.
- **SQL / MySQL** — Data quality checks, sales analysis, customer and product analysis, time-series analysis, and advanced business queries.
- **Python** — Data cleaning, exploratory data analysis, sales analysis, customer analysis, and product analysis using Pandas, NumPy, Matplotlib, and Seaborn.
- **Power BI** — Final interactive reporting and dashboard development (planned).

## Project Structure

- `Data/` — Original and processed datasets, stored locally and excluded from Git.
- `Excel/` — Excel analysis, documentation, and dashboard deliverables.
- `Sql/` — SQL scripts for data quality, sales, customer, product, time and seasonal, and advanced business analysis.
- `Python/` — Python scripts for data understanding, cleaning, EDA, sales, customer, and product analysis.
- `PowerBI/` — Power BI reports and dashboard deliverables.

## Dataset

**Source:** UCI Machine Learning Repository — Online Retail Dataset

[View the dataset](https://archive.ics.uci.edu/dataset/352/online+retail)

The dataset contains transactions from a UK-based online retailer between December 2010 and December 2011.

It includes invoice numbers, product codes and descriptions, quantities, invoice dates, unit prices, customer IDs, and countries.

The original dataset contains 541,909 records and 8 columns.

## Excel Analysis — Completed

The Excel phase includes data quality investigation, exploratory analysis, PivotTables, visualizations, KPI cards, and a consolidated dashboard.

Key analysis areas include:

- Missing customer IDs and product descriptions.
- Duplicate transaction records.
- Cancelled invoices and negative quantities.
- Sales trends over time.
- Country, product, and customer performance.

### Dashboard and Documentation

- [View Excel Dashboard (PDF)](Excel/Documentation/Excel_Dashboard.pdf)
- [View Excel Analysis Summary](Excel/Documentation/Excel_Analysis_Summary.md)

## SQL Analysis — Completed

The SQL phase uses MySQL to investigate data quality and answer sales and business performance questions.

### SQL Scripts

1. `Sql/data_quality_checks.sql` — Missing values, duplicates, cancellations, and transaction anomalies.
2. `Sql/sales_analysis.sql` — Sales performance by time, country, and product.
3. `Sql/customer_analysis.sql` — Customer revenue, order frequency, and repeat purchasing.
4. `Sql/product_analysis.sql` — Product performance, customer reach, and repeat purchasing.
5. `Sql/time_and_seasonal_analysis.sql` — Monthly and quarterly sales trends and month-over-month changes.
6. `Sql/advanced_business_analysis.sql` — Customer revenue concentration, customer segmentation, declining product sales, inactive customers, new versus returning customer revenue, country-level customer analysis, and frequently purchased product combinations.

- [SQL Business Insights](Sql/Sql_Business_Insights.md) — Summary of business findings, customer analysis, product trends, and recommendations.

### Selected SQL Findings

- **Customer revenue concentration:** The top 10% of identified customers accounted for approximately 61.38% of customer revenue in the analyzed data.
- **Repeat purchasing:** Approximately 65.57% of identified customers with eligible non-cancelled purchases made purchases across multiple invoices.
- **Monthly sales trends:** November 2011 had the highest monthly sales among the observed months, excluding cancellation invoice rows.
- **Product combinations:** The combination of the pink and red retrospot jumbo bags appeared together in 825 invoices.
- **Customer inactivity:** 1,449 of 4,339 identified customers had no eligible purchase in the final 90 days of the dataset period.

## Python Analysis — Completed

The Python phase uses Pandas and NumPy for data preparation and analysis, with Matplotlib and Seaborn for visualization.

### Python Scripts

1. `Python/01_data_understanding.py` — Dataset structure, dimensions, data types, and initial inspection.
2. `Python/02_data_cleaning.py` — Duplicate removal, date conversion, and preparation of the cleaned dataset.
3. `Python/03_eda.py` — Exploratory data analysis, distributions, missing values, and initial business patterns.
4. `Python/04_sales_analysis.py` — Revenue trends, monthly sales performance, invoice counts, and average revenue per invoice.
5. `Python/05_customer_analysis.py` — Top customers, repeat purchasing, purchase frequency, recency, and RFM segmentation.
6. `Python/06_product_analysis.py` — Top products by revenue, quantity sold, purchase frequency, and revenue contribution.

### Selected Python Findings

- **Total sales revenue:** 10,631,048.74 after excluding cancellation invoices and bad-debt adjustments.
- **Monthly sales performance:** November 2011 recorded the highest monthly revenue in the observed period.
- **Customer behaviour:** 2,845 out of 4,339 identified customers were repeat customers, representing a repeat purchase rate of approximately 65.57%.
- **Customer revenue concentration:** The top 10 customers contributed approximately 17.31% of identified-customer revenue.
- **Customer segmentation:** RFM analysis identified Champions, Loyal Customers, Big Spenders, At Risk, Hibernating, Potential Loyalists, and Others.
- **Product performance:** Regency Cake Stand 3 Tier was among the highest-revenue physical products, while Paper Craft Little Birdie recorded unusually high quantity sales in a single invoice.

## Data Handling and Limitations

- Exact duplicate records were removed during data cleaning.
- Cancellation invoices, identified by invoice numbers beginning with `C`, were excluded from ordinary sales analyses.
- Bad-debt adjustment records were excluded from ordinary sales and product performance analyses.
- Postage and other transaction line items were retained in overall transaction revenue where appropriate, but should be excluded when analyzing physical merchandise performance.
- Some negative quantities may represent stock corrections or other operational adjustments and were not automatically removed from the cleaned master dataset.
- Customer-level analysis is limited to transactions with an identified `CustomerID`.
- The dataset ends on December 9, 2011, so December 2011 is incomplete.
- Quarterly comparisons involving the fourth quarter of 2010 require caution because the dataset contains only December for that quarter.
- RFM segments are based on selected scoring thresholds and describe purchasing behavior within the observed dataset period. They do not independently prove customer churn.
- Results may differ depending on transaction filters and the treatment of cancellations, adjustments, and missing customer IDs.

## Project Status

- **Excel:** Completed.
- **SQL:** Completed — six analysis scripts.
- **Python:** Completed — six analysis scripts.
- **Power BI:** Final dashboard development pending.

The project is being developed as a practical Data Analyst portfolio demonstrating data quality investigation, data cleaning, SQL querying, Python analysis, business understanding, and data visualisation.
