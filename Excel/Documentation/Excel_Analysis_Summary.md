# Excel Analysis Summary

## Project

**Online Retail Analysis**

Excel is the first analysis phase of this broader data analytics project. The overall project will combine Excel, SQL, Python, and Power BI to investigate sales performance, customer behavior, product trends, and data quality.

## Tools and Techniques

- Microsoft Excel
- Excel formulas and functions
- Data-quality checks
- PivotTables and PivotCharts
- KPI calculations
- Dashboard design and reporting

## Dataset

- **Source:** UCI Machine Learning Repository — Online Retail
- **Period:** 1 December 2010 to 9 December 2011
- **Transaction records:** 541,909
- **Distinct invoice numbers:** 25,900

The dataset contains invoice numbers, stock codes, product descriptions, quantities, invoice dates, unit prices, customer IDs, and countries.

## Analysis Completed

### Data Quality

- Identified 5,268 exact duplicate rows in a separate duplicate-checking workflow.
- Identified 1,454 records with missing product descriptions.
- Identified 135,080 records with missing Customer IDs.
- Identified 9,288 records with invoice numbers beginning with `C`, indicating cancellations.
- Investigated negative quantities and zero or negative unit prices.
- Checked repeated invoice and stock-code combinations separately from exact duplicates.

### Sales and Customer Analysis

- Calculated transaction-level sales using Quantity × Unit Price.
- Analyzed monthly sales trends.
- Compared sales across countries, excluding the United Kingdom in the Top 10 Countries chart.
- Identified the highest-sales customers and products.
- Investigated cancellation records by month.
- Examined sales associated with missing Customer IDs.

## Dashboard

The Excel dashboard contains six KPI cards:

1. Positive Sales Value
2. Total Quantity
3. Total Invoices
4. Cancelled Records
5. Missing Customer IDs
6. Top Customer Sales

It also contains four charts:

- Monthly Sales Trend
- Top 10 Countries by Sales, excluding the United Kingdom
- Top 10 Customers by Sales
- Cancelled Invoice Records by Month

The dashboard uses linked KPI formulas, formatted cards, chart layouts, and a clean worksheet presentation.

## Key Findings

- November 2011 had the highest monthly sales in the available dataset.
- December 2011 had the lowest monthly sales, but the dataset includes only 1–9 December, so this month is incomplete.
- Customer ID `14646` was the highest-sales identified customer, with approximately £279,489.02 in sales.
- DOTCOM POSTAGE was the highest-sales product overall. Excluding it, REGENCY CAKESTAND 3 TIER was the leading merchandise product by sales value.
- EIRE had the highest sales among the countries displayed when the United Kingdom was excluded.
- October 2011 had the highest number of cancellation records.
- Approximately 24.93% of transaction records had missing Customer IDs.
- Approximately 13.57% of the positive sales value was associated with missing Customer IDs.

## Interpretation Notes

- December 2011 is incomplete and should not be compared directly with complete months.
- Missing Customer IDs limit customer-level analysis.
- Negative quantities and cancelled invoices require careful treatment when calculating sales.
- Positive sales value and net sales are different measures. The net sales calculation still requires reconciliation before it is reported as definitive.
- Repeated invoice and stock-code combinations are not automatically duplicates.

## Project Status

The Excel analysis and dashboard phase is complete. The broader project will continue with SQL analysis, Python-based data analysis, and a Power BI report.

## Dataset Source

UCI Machine Learning Repository — Online Retail:

https://archive.ics.uci.edu/dataset/352/online+retail
