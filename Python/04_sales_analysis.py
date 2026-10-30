# Online Retail Analysis
# Script: Sales Analysis
# Purpose: Analyse sales performance and identify important business trends.

import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# Load cleaned dataset
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "Data" / "onlineretail_cleaned.csv"

df = pd.read_csv(DATA_PATH, encoding="utf-8-sig")

# Prepare columns
df["InvoiceNo"] = df["InvoiceNo"].astype(str)
df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])
df["Revenue"] = df["Quantity"] * df["UnitPrice"]

# Identify cancellations and special adjustments
is_cancellation = df["InvoiceNo"].str.startswith("C")
is_adjustment = df["Description"].eq("Adjust bad debt")

# Keep ordinary sales transactions
sales_df = df[~is_cancellation & ~is_adjustment].copy()

print("Sales Analysis")
print("-" * 40)
print("Total sales records:", len(sales_df))
print("Total sales revenue:", round(sales_df["Revenue"].sum(), 2))
print("Unique sales invoices:", sales_df["InvoiceNo"].nunique())

# Monthly Sales Analysis

sales_df["Month"] = sales_df["InvoiceDate"].dt.to_period("M")

monthly_sales = (
    sales_df.groupby("Month")
    .agg(
        Total_Revenue=("Revenue", "sum"),
        Total_Invoices=("InvoiceNo", "nunique")
    )
    .reset_index()
)

monthly_sales["Month"] = monthly_sales["Month"].astype(str)

print("\nMonthly Sales Performance")
print("-" * 40)
print(monthly_sales.to_string(index=False))

# Identify highest and lowest revenue months
highest_month = monthly_sales.loc[monthly_sales["Total_Revenue"].idxmax()]
lowest_month = monthly_sales.loc[monthly_sales["Total_Revenue"].idxmin()]

print("\nHighest Sales Month:")
print(highest_month.to_string())

print("\nLowest Sales Month:")
print(lowest_month.to_string())

# Monthly Average Revenue per Invoice
monthly_sales["Avg_Revenue_Per_Invoice"] = (
    monthly_sales["Total_Revenue"] / monthly_sales["Total_Invoices"]
)

print("\nMonthly Average Revenue per Invoice")
print("-" * 40)
print(
    monthly_sales[
        ["Month", "Avg_Revenue_Per_Invoice"]
    ].round(2).to_string(index=False)
)

highest_avg = monthly_sales.loc[
    monthly_sales["Avg_Revenue_Per_Invoice"].idxmax()
]

lowest_avg = monthly_sales.loc[
    monthly_sales["Avg_Revenue_Per_Invoice"].idxmin()
]

print("\nHighest Average Revenue per Invoice:")
print(highest_avg.to_string())

print("\nLowest Average Revenue per Invoice:")
print(lowest_avg.to_string())

# Monthly Revenue Trend
plt.figure(figsize=(12, 5))

plt.plot(
    monthly_sales["Month"],
    monthly_sales["Total_Revenue"],
    marker="o"
)

plt.title("Monthly Sales Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()

# Final Business Summary
print("\nSALES ANALYSIS - KEY FINDINGS")
print("-" * 40)

print(
    f"Total Sales Revenue: "
    f"{sales_df['Revenue'].sum():,.2f}"
)

print(
    f"Highest Revenue Month: "
    f"{highest_month['Month']}"
)

print(
    f"Lowest Revenue Month: "
    f"{lowest_month['Month']}"
)

print(
    f"Highest Average Revenue per Invoice: "
    f"{highest_avg['Month']} "
    f"({highest_avg['Avg_Revenue_Per_Invoice']:.2f})"
)

print(
    f"Lowest Average Revenue per Invoice: "
    f"{lowest_avg['Month']} "
    f"({lowest_avg['Avg_Revenue_Per_Invoice']:.2f})"
)