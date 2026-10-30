# Online Retail Analysis
# Script: Customer Analysis
# Purpose: Analyse customer purchasing behaviour and value.

import pandas as pd
from pathlib import Path

# Load cleaned dataset
BASE_DIR = Path(__file__).resolve().parent.parent
DATA_PATH = BASE_DIR / "Data" / "onlineretail_cleaned.csv"

df = pd.read_csv(DATA_PATH, encoding="utf-8-sig")

# Prepare columns
df["InvoiceNo"] = df["InvoiceNo"].astype(str)
df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])
df["Revenue"] = df["Quantity"] * df["UnitPrice"]

# Exclude cancellations and accounting adjustments
is_cancellation = df["InvoiceNo"].str.startswith("C")
is_adjustment = df["Description"].eq("Adjust bad debt")

customer_df = df[~is_cancellation & ~is_adjustment].copy()

# Exclude transactions without CustomerID
customer_df = customer_df.dropna(subset=["CustomerID"])

print("Customer Analysis")
print("-" * 40)
print("Total customer transactions:", len(customer_df))
print("Unique customers:", customer_df["CustomerID"].nunique())
print("Total customer revenue:", round(customer_df["Revenue"].sum(), 2))

# Analysis 1: Top 10 Customers by Revenue

top_customers = (
    customer_df.groupby("CustomerID")
    .agg(
        Total_Revenue=("Revenue", "sum"),
        Total_Invoices=("InvoiceNo", "nunique")
    )
    .sort_values("Total_Revenue", ascending=False)
    .head(10)
    .reset_index()
)

print("\nTop 10 Customers by Revenue")
print("-" * 40)
print(top_customers.to_string(index=False))

# Customer Revenue Contribution

top_customers["Revenue_Contribution_Pct"] = (
    top_customers["Total_Revenue"]
    / customer_df["Revenue"].sum()
) * 100

print("\nTop 10 Customer Revenue Contribution")
print("-" * 40)

print(
    top_customers[
        ["CustomerID", "Total_Revenue", "Revenue_Contribution_Pct"]
    ].round(2).to_string(index=False)
)

print(
    "\nTop 10 Customers Combined Contribution:",
    round(top_customers["Revenue_Contribution_Pct"].sum(), 2),
    "%"
)

# Analysis 2: Repeat Customer Analysis

customer_frequency = (
    customer_df.groupby("CustomerID")["InvoiceNo"]
    .nunique()
)

one_time_customers = (customer_frequency == 1).sum()
repeat_customers = (customer_frequency > 1).sum()
total_customers = len(customer_frequency)

repeat_customer_rate = (
    repeat_customers / total_customers
) * 100

print("\nRepeat Customer Analysis")
print("-" * 40)
print("One-time Customers:", one_time_customers)
print("Repeat Customers:", repeat_customers)
print("Total Customers:", total_customers)
print("Repeat Customer Rate:", round(repeat_customer_rate, 2), "%")

# Analysis 3: Purchase Frequency

purchase_frequency = (
    customer_df.groupby("CustomerID")["InvoiceNo"]
    .nunique()
)

print("\nPurchase Frequency Analysis")
print("-" * 40)
print("Average Invoices per Customer:",
      round(purchase_frequency.mean(), 2))
print("Maximum Invoices by a Customer:",
      purchase_frequency.max())

print("\nTop 10 Frequent Customers:")
print(purchase_frequency.sort_values(
    ascending=False
).head(10).to_string())

# Analysis 4: Customer Recency

reference_date = customer_df["InvoiceDate"].max()

customer_recency = (
    customer_df.groupby("CustomerID")
    .agg(
        Last_Purchase_Date=("InvoiceDate", "max")
    )
    .reset_index()
)

customer_recency["Recency_Days"] = (
    reference_date - customer_recency["Last_Purchase_Date"]
).dt.days

print("\nCustomer Recency Analysis")
print("-" * 40)
print("Reference Date:", reference_date)

print("\nMost Recently Active Customers:")
print(
    customer_recency.sort_values("Recency_Days")
    .head(10).to_string(index=False)
)

print("\nAverage Customer Recency:",
      round(customer_recency["Recency_Days"].mean(), 2),
      "days")

# Analysis 5: RFM Customer Segmentation

rfm = (
    customer_df.groupby("CustomerID")
    .agg(
        Recency=("InvoiceDate", lambda x: (reference_date - x.max()).days),
        Frequency=("InvoiceNo", "nunique"),
        Monetary=("Revenue", "sum")
    )
    .reset_index()
)

# RFM Scores
rfm["R_Score"] = pd.qcut(
    rfm["Recency"].rank(method="first"),
    5,
    labels=[5, 4, 3, 2, 1]
).astype(int)

rfm["F_Score"] = pd.qcut(
    rfm["Frequency"].rank(method="first"),
    5,
    labels=[1, 2, 3, 4, 5]
).astype(int)

rfm["M_Score"] = pd.qcut(
    rfm["Monetary"].rank(method="first"),
    5,
    labels=[1, 2, 3, 4, 5]
).astype(int)

rfm["RFM_Score"] = (
    rfm["R_Score"].astype(str)
    + rfm["F_Score"].astype(str)
    + rfm["M_Score"].astype(str)
)

print("\nRFM Customer Segmentation")
print("-" * 40)
print(rfm.head(10).to_string(index=False))

# Create Customer Segments

def assign_segment(row):
    if row["R_Score"] >= 4 and row["F_Score"] >= 4 and row["M_Score"] >= 4:
        return "Champions"
    elif row["F_Score"] >= 4:
        return "Loyal Customers"
    elif row["M_Score"] == 5:
        return "Big Spenders"
    elif row["R_Score"] <= 2 and row["F_Score"] >= 3:
        return "At Risk"
    elif row["R_Score"] <= 2 and row["F_Score"] <= 2:
        return "Hibernating"
    elif row["R_Score"] >= 4 and row["F_Score"] >= 2:
        return "Potential Loyalists"
    else:
        return "Others"


rfm["Customer_Segment"] = rfm.apply(assign_segment, axis=1)

# Segment Summary
segment_summary = (
    rfm.groupby("Customer_Segment")
    .agg(
        Total_Customers=("CustomerID", "count"),
        Total_Revenue=("Monetary", "sum")
    )
    .reset_index()
    .sort_values("Total_Customers", ascending=False)
)

print("\nRFM Customer Segment Summary")
print("-" * 40)
print(segment_summary.to_string(index=False))

# Final Validation
print("\nCustomer Analysis Validation")
print("-" * 40)

print("Total RFM customers:", len(rfm))
print("Total segmented customers:",
      segment_summary["Total_Customers"].sum())

print("Total customer revenue:",
      round(customer_df["Revenue"].sum(), 2))

print("Total segmented revenue:",
      round(segment_summary["Total_Revenue"].sum(), 2))