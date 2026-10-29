# Online Retail Analysis
# Script: Exploratory Data Analysis (EDA)
# Purpose:
# Analyze revenue trends, countries, products, customers,
# invoice activity, and cancellations using Python.

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# Step 1: Load the cleaned dataset
file_path = "../Data/onlineretail_cleaned.csv"

df = pd.read_csv(
    file_path,
    encoding="utf-8-sig",
    parse_dates=["InvoiceDate"]
)

print("Dataset loaded successfully.")
print("Shape:", df.shape)

print("\nFirst 5 rows:")
print(df.head())

# Step 2: Calculate revenue for each transaction line

df["Revenue"] = df["Quantity"] * df["UnitPrice"]

print("\nRevenue column created successfully.")

print("\nSample transactions records:")
print(
    df[["InvoiceNo", "Quantity", "UnitPrice", "Revenue"]]
    .head(10).to_string(index=False)
)

# Step 3: Calculate overall sales metrics

print("\n===== OVERALL SALES SUMMARY =====")

print("Total transaction records:", len(df))
print("Total quantity:", df["Quantity"].sum())
print("Total calculated revenue:", round(df["Revenue"].sum(), 2))
print("Average line revenue:", round(df["Revenue"].mean(), 2))
print("Unique invoices:", df["InvoiceNo"].nunique())


# Step 4: Analyze monthly revenue

df["YearMonth"] = df["InvoiceDate"].dt.to_period("M")

monthly_revenue = (
    df.groupby("YearMonth")["Revenue"]
    .sum()
    .reset_index()
)

print("\n===== MONTHLY REVENUE =====")
print(monthly_revenue.to_string(index=False))

print("\nHighest revenue month:")
print(monthly_revenue.loc[monthly_revenue["Revenue"].idxmax()])

print("\nLowest revenue month:")
print(monthly_revenue.loc[monthly_revenue["Revenue"].idxmin()])


# Step 5: Analyze revenue by country

country_revenue = (
    df.groupby("Country")["Revenue"]
    .sum()
    .sort_values(ascending=False)
    .reset_index()
)

print("\n===== TOP 10 COUNTRIES BY REVENUE =====")
print(country_revenue.head(10).to_string(index=False))


# Step 6: Analyze top products by revenue

product_revenue = (
    df.groupby(["StockCode", "Description"])["Revenue"]
    .sum()
    .sort_values(ascending=False)
    .reset_index()
)

print("\n===== TOP 10 PRODUCTS BY REVENUE =====")
print(product_revenue.head(10).to_string(index=False))


# Step 7: Analyze top customers by revenue

customer_revenue = (
    df.dropna(subset=["CustomerID"])
    .groupby("CustomerID")["Revenue"]
    .sum()
    .sort_values(ascending=False)
    .reset_index()
)

print("\n===== TOP 10 CUSTOMERS BY REVENUE =====")
print(customer_revenue.head(10).to_string(index=False))


# Step 8: Visualize monthly revenue

monthly_chart = monthly_revenue.copy()
monthly_chart["YearMonth"] = monthly_chart["YearMonth"].astype(str)

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_chart["YearMonth"],
    monthly_chart["Revenue"],
    marker="o"
)

plt.title("Monthly Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Calculated Revenue")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()


# Step 9: Visualize top 10 countries by revenue

top_countries = country_revenue.head(10).sort_values(
    by="Revenue",
    ascending=True
)

plt.figure(figsize=(10, 6))

plt.barh(
    top_countries["Country"],
    top_countries["Revenue"]
)

plt.title("Top 10 Countries by Revenue")
plt.xlabel("Calculated Revenue")
plt.ylabel("Country")
plt.ticklabel_format(axis="x", style="plain")
plt.ticklabel_format(axis="x", useOffset=False)
plt.tight_layout()
plt.show()


# Step 10: Visualize top 10 products by revenue

top_products = product_revenue.head(10).sort_values(
    by="Revenue",
    ascending=True
)

plt.figure(figsize=(12, 7))

plt.barh(
    top_products["Description"],
    top_products["Revenue"]
)

plt.title("Top 10 Products by Revenue")
plt.xlabel("Calculated Revenue")
plt.ylabel("Product")
plt.ticklabel_format(axis="x", style="plain")
plt.ticklabel_format(axis="x", useOffset=False)

plt.tight_layout()
plt.show()


# Step 11: Visualize top 10 customers by revenue

top_customers = customer_revenue.head(10).sort_values(
    by="Revenue",
    ascending=True
)

plt.figure(figsize=(10, 6))

plt.barh(
    top_customers["CustomerID"].astype(int).astype(str),
    top_customers["Revenue"]
)

plt.title("Top 10 Customers by Revenue")
plt.xlabel("Calculated Revenue")
plt.ylabel("Customer ID")
plt.ticklabel_format(axis="x", style="plain")
plt.ticklabel_format(axis="x", useOffset=False)

plt.tight_layout()
plt.show()

# Step 12: Analyze monthly order volume

monthly_orders = (
    df.groupby("YearMonth")["InvoiceNo"]
    .nunique()
    .reset_index(name="TotalInvoices")
)

print("\n===== MONTHLY ORDER VOLUME =====")
print(monthly_orders.to_string(index=False))

print("\nMonth with highest invoice count:")
print(monthly_orders.loc[monthly_orders["TotalInvoices"].idxmax()])

print("\nMonth with lowest invoice count:")
print(monthly_orders.loc[monthly_orders["TotalInvoices"].idxmin()])


# Step 13: Visualize monthly order volume

monthly_orders_chart = monthly_orders.copy()
monthly_orders_chart["YearMonth"] = (
    monthly_orders_chart["YearMonth"].astype(str)
)

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_orders_chart["YearMonth"],
    monthly_orders_chart["TotalInvoices"],
    marker="o"
)

plt.title("Monthly Order Volume")
plt.xlabel("Month")
plt.ylabel("Number of Unique Invoices")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()


# Step 14: Calculate average revenue per invoice by month

monthly_summary = monthly_revenue.merge(
    monthly_orders,
    on="YearMonth"
)

monthly_summary["AverageRevenuePerInvoice"] = (
    monthly_summary["Revenue"] /
    monthly_summary["TotalInvoices"]
)

print("\n===== MONTHLY REVENUE AND ORDER SUMMARY =====")

print(
    monthly_summary[
        [
            "YearMonth",
            "Revenue",
            "TotalInvoices",
            "AverageRevenuePerInvoice"
        ]
    ].to_string(index=False)
)


# Step 15: Visualize average revenue per invoice

monthly_summary_chart = monthly_summary.copy()
monthly_summary_chart["YearMonth"] = (
    monthly_summary_chart["YearMonth"].astype(str)
)

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_summary_chart["YearMonth"],
    monthly_summary_chart["AverageRevenuePerInvoice"],
    marker="o"
)

plt.title("Monthly Average Revenue per Invoice")
plt.xlabel("Month")
plt.ylabel("Average Revenue per Invoice")
plt.xticks(rotation=45)
plt.grid(True)
plt.tight_layout()
plt.show()



# Step 16: Analyze cancellation activity

cancellations = df[
    df["InvoiceNo"].astype(str).str.startswith("C")
]

print("\n===== CANCELLATION ANALYSIS =====")

print("Cancellation records:", len(cancellations))

print(
    "Unique cancellation invoices:",
    cancellations["InvoiceNo"].nunique()
)

print(
    "Total cancellation quantity:",
    cancellations["Quantity"].sum()
)

print(
    "Total cancellation revenue:",
    round(cancellations["Revenue"].sum(), 2)
)

# Step 17: Analyze monthly cancellation invoices

monthly_cancellations = (
    df.groupby("YearMonth")["InvoiceNo"]
    .nunique()
    .reset_index(name="CancellationInvoices")
)

print("\n===== MONTHLY CANCELLATION INVOICES =====")
print(monthly_cancellations.to_string(index=False))

print("\nMonth with highest cancellation invoices:")
print(
    monthly_cancellations.loc[monthly_cancellations["CancellationInvoices"].idxmax()]
)

print("\nMonth with lowest cancellation invoices:")
print(
    monthly_cancellations.loc[monthly_cancellations["CancellationInvoices"].idxmin()]
)


# Step 17: Verify monthly cancellation invoice counts

cancellations = df[
    df["InvoiceNo"].astype(str).str.startswith("C")
].copy()

cancellations["YearMonth"] = (
    cancellations["InvoiceDate"].dt.to_period("M")
)

monthly_cancellations = (
    cancellations.groupby("YearMonth")["InvoiceNo"]
    .nunique()
    .reset_index(name="CancellationInvoices")
)

print("\n===== VERIFIED MONTHLY CANCELLATION INVOICES =====")
print(monthly_cancellations.to_string(index=False))

print("\nTotal unique cancellation invoices:")
print(cancellations["InvoiceNo"].nunique())

# Step 18: Monthly Cancellation Invoice Trend

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_cancellations["YearMonth"].astype(str),
    monthly_cancellations["CancellationInvoices"],
    marker="o"
)

plt.title("Monthly Cancellation Invoice Trend")
plt.xlabel("Month")
plt.ylabel("Number of Cancellation Invoices")
plt.xticks(rotation=45)
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()

# Step 19: Monthly Cancellation Revenue

monthly_cancellation_revenue = (
    cancellations.groupby("YearMonth")["Revenue"]
    .sum()
    .reset_index(name="CancellationRevenue")
)

print("\n===== MONTHLY CANCELLATION REVENUE =====")
print(monthly_cancellation_revenue.to_string(index=False))

# Step 20: Monthly Cancellation Revenue Trend

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_cancellation_revenue["YearMonth"].astype(str),
    monthly_cancellation_revenue["CancellationRevenue"],
    marker="o"
)

plt.title("Monthly Cancellation Revenue Trend")
plt.xlabel("Month")
plt.ylabel("Cancellation Revenue")
plt.xticks(rotation=45)
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()

# Step 21: Monthly Revenue After Cancellations

monthly_revenue_analysis = monthly_revenue.merge(
    monthly_cancellation_revenue,
    on="YearMonth",
    how="left"
)

monthly_revenue_analysis["RevenueAfterCancellations"] = (
    monthly_revenue_analysis["Revenue"]
    + monthly_revenue_analysis["CancellationRevenue"]
)

print("\n===== MONTHLY REVENUE AFTER CANCELLATIONS =====")
print(
    monthly_revenue_analysis[
        [
            "YearMonth",
            "Revenue",
            "CancellationRevenue",
            "RevenueAfterCancellations"
        ]].to_string(index=False)
    )

# Step 22: Monthly Revenue Comparison

plt.figure(figsize=(12, 6))

plt.plot(
    monthly_revenue_analysis["YearMonth"].astype(str),
    monthly_revenue_analysis["Revenue"],
    marker="o",
    label="Revenue Before Cancellation Adjustment"
)

plt.plot(
    monthly_revenue_analysis["YearMonth"].astype(str),
    monthly_revenue_analysis["RevenueAfterCancellations"],
    marker="o",
    label="Revenue After Cancellation Adjustment"
)

plt.title("Monthly Revenue Before and After Cancellation Adjustment")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.xticks(rotation=45)
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()

# Step 23: Country Revenue Contribution

country_revenue = (
    df.groupby("Country")["Revenue"]
    .sum()
    .reset_index()
    .sort_values("Revenue", ascending=False)
)

total_revenue = df["Revenue"].sum()

country_revenue["RevenueContributionPct"] = (
    country_revenue["Revenue"] / total_revenue
) * 100

print("\n===== TOP 10 COUNTRIES BY REVENUE CONTRIBUTION =====")
print(
    country_revenue.head(10).to_string(index=False)
)

# Step 24: Customer Revenue Contribution

customer_revenue = (
    df.dropna(subset=["CustomerID"])
    .groupby("CustomerID")["Revenue"]
    .sum()
    .reset_index()
    .sort_values("Revenue", ascending=False)
)

identified_customer_revenue = customer_revenue["Revenue"].sum()

customer_revenue["RevenueContributionPct"] = (
    customer_revenue["Revenue"] / identified_customer_revenue
) * 100

print("\n===== TOP 10 CUSTOMERS BY REVENUE CONTRIBUTION =====")
print(customer_revenue.head(10).to_string(index=False))

# Step 25: Basic EDA Insights Summary

print("\n===== EDA INSIGHTS SUMMARY =====")

print("Total transaction records:", len(df))
print("Unique invoices:", df["InvoiceNo"].nunique())
print("Unique identified customers:", df["CustomerID"].nunique())
print("Unique countries:", df["Country"].nunique())

print("Total revenue:", round(df["Revenue"].sum(), 2))
print("Top country:", country_revenue.iloc[0]["Country"])
print("Top country revenue share (%):",
      round(country_revenue.iloc[0]["RevenueContributionPct"], 2))

print("Highest revenue month:",
      monthly_revenue.loc[monthly_revenue["Revenue"].idxmax(), "YearMonth"])

print("Lowest revenue month:",
      monthly_revenue.loc[monthly_revenue["Revenue"].idxmin(), "YearMonth"])

print("Unique cancellation invoices:",
      cancellations["InvoiceNo"].nunique())

print("Total cancellation revenue:",
      round(cancellations["Revenue"].sum(), 2))

# Final Review 1: Revenue Reconciliation

print("\n===== REVENUE RECONCILIATION =====")

print("Total revenue, all records:",
      round(df["Revenue"].sum(), 2))

print("Revenue from cancellation records:",
      round(cancellations["Revenue"].sum(), 2))

print("Revenue excluding cancellation records:",
      round(df.loc[~df["InvoiceNo"].astype(str).str.startswith("C"),
                   "Revenue"].sum(), 2))

# Final Review 2: Inspect Special Adjustment Records

adjustments = df[
    df["Description"].astype(str).str.contains(
        "Adjust bad debt", case=False, na=False
    )
]

print("\n===== SPECIAL ADJUSTMENT RECORDS =====")

print(
    adjustments[
        [
            "InvoiceNo",
            "StockCode",
            "Description",
            "Quantity",
            "UnitPrice",
            "Revenue",
            "Country"
        ]
    ].to_string(index=False)
)

print("\nNumber of adjustment records:", len(adjustments))
print("Total adjustment revenue:", round(adjustments["Revenue"].sum(), 2))

# Final Review 3: Revenue Excluding Cancellations and Bad-Debt Adjustments

is_cancellation = df["InvoiceNo"].astype(str).str.startswith("C")

is_bad_debt_adjustment = (
    df["Description"].astype(str)
    .str.contains("Adjust bad debt", case=False, na=False)
)

ordinary_records = df[
    ~is_cancellation & ~is_bad_debt_adjustment
]

print("\n===== ORDINARY RECORDS REVENUE CHECK =====")
print("Ordinary records:", len(ordinary_records))
print("Ordinary records revenue:",
      round(ordinary_records["Revenue"].sum(), 2))

print("Excluded cancellation revenue:",
      round(df.loc[is_cancellation, "Revenue"].sum(), 2))

print("Excluded bad-debt adjustment revenue:",
      round(df.loc[is_bad_debt_adjustment, "Revenue"].sum(), 2))

# Final Review 4: Zero-Price and Missing-Description Records

zero_price = df["UnitPrice"].eq(0)
missing_description = df["Description"].isna()

print("\n===== ZERO-PRICE AND MISSING-DESCRIPTION CHECK =====")

print("Zero-price records:", int(zero_price.sum()))
print("Missing descriptions:", int(missing_description.sum()))

print("Records with both conditions:",
      int((zero_price & missing_description).sum()))

print("Zero-price records with descriptions:",
      int((zero_price & ~missing_description).sum()))

print("Missing descriptions with non-zero price:",
      int((missing_description & ~zero_price).sum()))

# Final Review 5: Unusual Negative-Quantity Records

is_cancellation = df["InvoiceNo"].astype(str).str.startswith("C")

unusual_negative_quantity = df[
    (df["Quantity"] < 0) & (~is_cancellation)
]

print("\n===== UNUSUAL NEGATIVE-QUANTITY RECORDS =====")

print("Record count:", len(unusual_negative_quantity))
print("Zero-price records:",
      int(unusual_negative_quantity["UnitPrice"].eq(0).sum()))
print("Missing descriptions:",
      int(unusual_negative_quantity["Description"].isna().sum()))
print("Total quantity:",
      int(unusual_negative_quantity["Quantity"].sum()))
print("Total revenue:",
      round(unusual_negative_quantity["Revenue"].sum(), 2))