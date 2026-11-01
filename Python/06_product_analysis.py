# Online Retail Analysis
# Script: Product Analysis
# Purpose:

import pandas as pd
from pathlib import Path

# Load cleaned dataset
project_dir = Path(__file__).resolve().parent.parent
file_path = project_dir / "Data" / "onlineretail_cleaned.csv"

df = pd.read_csv(file_path)

# Prepare columns
df["InvoiceNo"] = df["InvoiceNo"].astype(str)
df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])
df["Revenue"] = df["Quantity"] * df["UnitPrice"]

# Exclude cancelled invoices and bad debt adjustments
sales_df = df[
    (~df["InvoiceNo"].str.startswith("C")) &
    (df["Description"] != "Adjust bad debt")
].copy()

# Keep valid product records
product_df = sales_df.dropna(
    subset=["StockCode", "Description"]
).copy()

print("Product Analysis Data Preparation")
print("----------------------------------")
print("Total product records:", len(product_df))
print("Unique products:", product_df["StockCode"].nunique())
print("Total product revenue:", round(product_df["Revenue"].sum(), 2))

# Analysis 1: Top 10 Products By Revenue

top_products_revenue = (
    product_df.groupby(["StockCode", "Description"])
    .agg(
        Total_Revenue=("Revenue", "sum"),
        Total_Quantity=("Quantity", "sum"),
        Total_Invoices=("InvoiceNo", "nunique")
    )
    .sort_values("Total_Revenue", ascending=False)
    .head(10)
    .reset_index()
)

print("\nTop 10 Products by Revenue")
print("--------------------------")
print(top_products_revenue.to_string(index=False))


# Analysis 2: Top 10 Products by Quantity Sold

top_products_quantity = (
    product_df[product_df["Quantity"] > 0]
    .groupby(["StockCode", "Description"])
    .agg(
        Total_Quantity_Sold=("Quantity", "sum"),
        Total_Revenue=("Revenue", "sum"),
        Total_Invoices=("InvoiceNo", "nunique")
    )
    .sort_values("Total_Quantity_Sold", ascending=False)
    .head(10)
    .reset_index()
)

print("\nTop 10 Products by Quantity Sold")
print("--------------------------------")
print(top_products_quantity.to_string(index=False))

# Analysis 3: Top 10 Products by Purchase Frequency

top_products_frequency = (
    product_df.groupby(["StockCode", "Description"])
    .agg(
        Total_Invoices=("InvoiceNo", "nunique"),
        Unique_Customers=("CustomerID", "nunique"),
        Total_Revenue=("Revenue", "sum")
    )
    .sort_values("Total_Invoices", ascending=False)
    .head(10)
    .reset_index()
)

print("\nTop 10 Products by Purchase Frequency")
print("--------------------------------------")
print(top_products_frequency.to_string(index=False))

# Analysis 4: Product Revenue Contribution

product_revenue = (
    product_df.groupby(["StockCode", "Description"])["Revenue"]
    .sum()
    .reset_index()
)

total_revenue = product_revenue["Revenue"].sum()

product_revenue["Revenue_Contribution_Pct"] = (
    product_revenue["Revenue"] / total_revenue * 100
)

top_revenue_contribution = (
    product_revenue
    .sort_values("Revenue", ascending=False)
    .head(10)
)

print("\nTop 10 Products by Revenue Contribution")
print("---------------------------------------")
print(
    top_revenue_contribution[
        ["StockCode", "Description", "Revenue", "Revenue_Contribution_Pct"]
    ].to_string(index=False)
)

print("\nTotal Product Revenue:", round(total_revenue, 2))

# Final Validation

print("\nFinal Validation")
print("----------------")
print("Product records:", len(product_df))
print("Unique products:", product_df["StockCode"].nunique())
print("Revenue in product data:", round(product_df["Revenue"].sum(), 2))
print("Revenue in grouped products:", round(product_revenue["Revenue"].sum(), 2))

# Validation checks
assert not product_df["InvoiceNo"].str.startswith("C").any()
assert not product_df["Description"].eq("Adjust bad debt").any()
assert round(product_df["Revenue"].sum(), 2) == round(
    product_revenue["Revenue"].sum(), 2
)

print("All validation checks passed.")