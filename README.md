# Online Retail Sales & Business Performance Analysis

## Project Overview

This portfolio project analyzes transactions from a UK-based online retailer to understand sales performance, customer purchasing behavior, product trends, and business performance.

The project uses Excel and SQL to investigate data quality, analyze transactions, identify purchasing patterns, and answer business questions using structured data analysis.

## Objectives

- Investigate data quality issues and transaction anomalies.
- Analyze sales performance across months, quarters, countries, and products.
- Understand customer purchasing behavior, retention, and revenue concentration.
- Identify high-performing products and frequently purchased product combinations.
- Examine customer value segments and periods of declining product sales.
- Evaluate cancellations, missing customer information, and unusual transactions.
- Translate analytical findings into actionable business insights.

## Tools & Technologies

- **Microsoft Excel** — Data quality investigation, PivotTables, charts, KPI cards, and dashboard development.
- **SQL / MySQL** — Data quality checks, sales analysis, customer and product analysis, time-series analysis, and advanced business queries.
- **Python** — Planned data analysis using Pandas, NumPy, Matplotlib, and Seaborn.
- **Power BI** — Planned project reporting and interactive visualization deliverables.

## Project Structure

- `Data/` — Original dataset, stored locally and excluded from Git.
- `Excel/` — Excel analysis, documentation, and dashboard deliverables.
- `Sql/` — SQL scripts for data quality, sales, customer, product, time and seasonal, and advanced business analysis.
- `Python/` — Python-based analysis deliverables.
- `PowerBI/` — Power BI reports and dashboard deliverables.

## Dataset

**Source:** UCI Machine Learning Repository — Online Retail Dataset

[View the dataset](https://archive.ics.uci.edu/dataset/352/online+retail)

The dataset contains transactions from a UK-based online retailer between December 2010 and December 2011. It includes invoice numbers, product codes and descriptions, quantities, invoice dates, unit prices, customer IDs, and countries.

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

### Selected Findings

- **Customer revenue concentration:** The top 10% of identified customers accounted for approximately 61.38% of customer revenue in the analyzed data.
- **Repeat purchasing:** Approximately 65.57% of identified customers with eligible non-cancelled purchases made purchases across multiple invoices.
- **Monthly sales trends:** November 2011 had the highest monthly sales among the observed months, excluding cancellation invoice rows.
- **Product combinations:** The combination of the pink and red retrospot jumbo bags appeared together in 825 invoices.
- **Customer inactivity:** 1,449 of 4,339 identified customers had no eligible purchase in the final 90 days of the dataset period.

These findings describe the analyzed historical dataset and should not be interpreted as current business performance.

## Data Handling and Limitations

- Cancellation invoice rows are excluded in many sales analyses; this does not fully reconcile each cancellation with its original transaction.
- Some negative quantities may represent stock corrections or other operational adjustments.
- Customer-level analysis is limited to transactions with an identified `CustomerID`.
- The dataset ends on December 9, 2011, so December 2011 is incomplete.
- Quarterly comparisons involving the fourth quarter of 2010 require caution because the dataset contains only December for that quarter.
- Results may differ depending on transaction filters and the treatment of cancellations, adjustments, and missing customer IDs.

## Project Status

- **Excel:** Completed.
- **SQL:** Completed — six analysis scripts committed to the repository.
- **Python:** Project deliverables to be finalized.
- **Power BI:** Project deliverables to be finalized.

The project is being developed as a practical Data Analyst portfolio demonstrating data quality investigation, SQL querying, business analysis, and data visualization.
