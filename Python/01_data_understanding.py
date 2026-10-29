# Online Retail Analysis
# Script: Data Understanding
# Purpose:
# Inspect the original dataset's structure, columns,
# data types, missing values, and duplicate records.

import pandas as pd

file_path = "../Data/onlineretail.csv"

df = pd.read_csv(file_path, encoding="utf-8-sig")

print("First 5 rows:")
print(df.head())

print("\nDataset shape:")
print(df.shape)

print("\nColumn names:")
print(df.columns.tolist())

#Understanding data types and missing values

print("\nData types:")
print(df.dtypes)

print("\nMissing values in each column:")
print(df.isnull().sum())

print("\nDataset information:")
df.info()

#Check for duplicate rows

print("\nExact duplicate rows:")
print(df.duplicated().sum())

#Check the date range

print("\nInvoice data type before conversion:")
print(df["InvoiceDate"].dtype)

df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])

print("\nEarliest invoice date:")
print(df["InvoiceDate"].min())

print("\nLatest invoice date:")
print(df["InvoiceDate"].max())

#Checking numeric columns

print("\nQuantity summary:")
print(df["Quantity"].describe())

print("\nUnit price summary:")
print(df["UnitPrice"].describe())

print("\nNegative quantities:")
print((df["Quantity"] < 0).sum())

print("\nZero or negative unit prices:")
print((df["UnitPrice"] <= 0).sum())

#Checking negative unit prices

print("\nRecords with negative unit prices:")
print(df[df["UnitPrice"] < 0].head(10))

print("\nCount of negative unit prices:")
print((df["UnitPrice"] < 0).sum())

print("\nCount of zero unit prices:")
print((df["UnitPrice"] == 0).sum())

#Inspecting two negative-price records

print("\nComplete negative-price records:")
print(df[df["UnitPrice"] < 0].to_string(index=False))

#Check zero price records

print("\nExamples of zero price records:")
print(
    df[df["UnitPrice"] == 0][
        ["InvoiceNo", "StockCode", "Description", "Quantity", "UnitPrice", "Country"]
    ].head(10).to_string(index=False)
)

#Checking CustomerID column

print("\nCustomer ID summary:")
print("Known Customer IDs:", df["CustomerID"].notna().sum())
print("Missing Customer IDs:", df["CustomerID"].isna().sum())
print("Unique identified customers:", df["CustomerID"].nunique())

#Checking the country column

print("\nNumber of unique countries:")
print(df["Country"].nunique())

print("\nTop 10 countries by record count:")
print(df["Country"].value_counts().head(10))