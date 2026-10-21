-- Online Retail Analysis: Initial Setup and Data Quality Checks
-- Database: online_retail

CREATE DATABASE IF NOT EXISTS online_retail;
USE online_retail;

-- Create the main transaction table
CREATE TABLE IF NOT EXISTS online_retail_transactions (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID INT,
    Country VARCHAR(100)
);

-- Verify total rows
SELECT COUNT(*) AS total_transactions
FROM online_retail_transactions;

-- Check date range and missing dates
SELECT
    COUNT(*) AS total_rows,
    SUM(InvoiceDate IS NULL) AS missing_dates,
    MIN(InvoiceDate) AS first_date,
    MAX(InvoiceDate) AS last_date
FROM online_retail_transactions;

-- Check missing values
SELECT
    SUM(InvoiceNo IS NULL) AS missing_invoice_no,
    SUM(StockCode IS NULL) AS missing_stock_code,
    SUM(Description IS NULL) AS missing_description,
    SUM(Quantity IS NULL) AS missing_quantity,
    SUM(UnitPrice IS NULL) AS missing_unit_price,
    SUM(CustomerID IS NULL) AS missing_customer_id,
    SUM(Country IS NULL) AS missing_country
FROM online_retail_transactions;

-- Check numeric ranges and negative values
SELECT
    MIN(Quantity) AS min_quantity,
    MAX(Quantity) AS max_quantity,
    MIN(UnitPrice) AS min_unit_price,
    MAX(UnitPrice) AS max_unit_price,
    SUM(Quantity < 0) AS negative_quantity_rows,
    SUM(UnitPrice < 0) AS negative_price_rows
FROM online_retail_transactions;

-- Preview imported transactions
SELECT InvoiceNo, InvoiceDate, Quantity, UnitPrice
FROM online_retail_transactions
LIMIT 5;