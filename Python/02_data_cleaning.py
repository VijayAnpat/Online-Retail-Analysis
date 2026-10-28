#Load the dataset for cleaning

import pandas as pd

file_path = "../Data/onlineretail.csv"

df = pd.read_csv(file_path, encoding="utf-8-sig")

#Create a separate working copy

df_clean = df.copy()

print("Original dataset shape:", df.shape)
print("Working copy shape:", df_clean.shape)

#  Step 1: Remove exact duplicate rows

print("\nDuplicates before removal:", df_clean.duplicated().sum())

df_clean = df_clean.drop_duplicates()

print("Shape after removing duplicates:", df_clean.shape)
print("Duplicates remaining:", df_clean.duplicated().sum())

# Step 2: Checking missing values after duplicate removal

print("\nMissing values after removing duplicates:")
print(df_clean.isnull().sum())

# Step 3: Inspect missing descriptions

missing_desc = df_clean[df_clean["Description"].isna()]

print("\nRecords with missing descriptions:", len(missing_desc))

print("\nMost common stock codes with missing descriptions:" )
print(missing_desc["StockCode"].value_counts().head(10))

print("\nExamples of records with missing descriptions:")
print(
    missing_desc[
        ["InvoiceNo", "StockCode", "Quantity", "UnitPrice", "Country"]
    ].head(10).to_string(index=False)
)

# Step 4: Check missing descriptions with non-zero prices

missing_desc_nonzero_price = df_clean[
    df_clean["Description"].isna()
    & (df_clean["UnitPrice"] != 0)
]

print(
    "\nMissing descriptions with non-zero prices:",
    len(missing_desc_nonzero_price)
)

print("\nExamples:")
print(
    missing_desc_nonzero_price[
        ["InvoiceNo", "StockCode", "Quantity", "UnitPrice", "Country"]
    ].head(10).to_string(index=False)
)

# Step 5: Inspect records with missing CustomerID

missing_customer = df_clean[df_clean["CustomerID"].isna()]

print("\nRecords with missing CustomerID:", len(missing_customer))

print("\nMissing CustomerID records with positive quantity:")
print((missing_customer["Quantity"] > 0).sum())

print("\nMissing CustomerID records with negative quantity:")
print((missing_customer["Quantity"] < 0).sum())

print("\nMissing CustomerID records with zero quantity:")
print((missing_customer["Quantity"] == 0).sum())

# Step 6: Check cancellation invoices with missing CustomerID

missing_customer = df_clean[df_clean["CustomerID"].isna()]

cancelled_missing_customer = missing_customer[
    missing_customer["InvoiceNo"].str.startswith("C")
]

print(
    "\nCancellation records with missing CustomerID:",
    len(cancelled_missing_customer)
)

print(
    "Other records with missing CustomerID:",
    len(missing_customer) - len(cancelled_missing_customer)
)

# Step 7: Count cancellation invoices

cancelled = df_clean[df_clean["InvoiceNo"].str.startswith("C")]

print("\nCancellation records:", len(cancelled))
print("Unique cancellation invoices:", cancelled["InvoiceNo"].nunique())

# Step 8: Recheck unusual numeric values

print("\nNegative quantities:", (df_clean["Quantity"] < 0).sum())
print("Zero quantities:", (df_clean["Quantity"] == 0).sum())
print("Negative unit prices:", (df_clean["UnitPrice"] < 0).sum())
print("Zero unit prices:", (df_clean["UnitPrice"] == 0).sum())

#Step 7: Cleaning checkpoint

print("\n--- Cleaning checkpoint ---")
print("Rows in cleaned working dataset:", len(df_clean))
print("Columns:", df_clean.shape[1])
print("Exact duplicates remaining:", df_clean.duplicated().sum())
print("Missing descriptions:", df_clean["Description"].isna().sum())
print("Missing Customer IDs:", df_clean["CustomerID"].isna().sum())

# Step 10: Save cleaned dataset

output_path = "../Data/onlineretail_cleaned.csv"

df_clean.to_csv(output_path, index=False, encoding="utf-8-sig")

print("\nCleaned dataset saved successfully.")
print("File path:", output_path)

# Step 11: Verify the saved cleaned dataset

df_check = pd.read_csv(
    "../Data/onlineretail_cleaned.csv",
    encoding="utf-8-sig"
)

print("\nSaved dataset shape:", df_check.shape)
print("Duplicates in saved dataset:", df_check.duplicated().sum())

# Step 12: Inspect invoice number format

print("\nSample invoice numbers:")
print(df_clean["InvoiceNo"].head(10).to_list())

print("\nInvoice numbers starting with C:")
print(
    df_clean.loc[df_clean["InvoiceNo"].str.startswith("C"),
    "InvoiceNo"].head(10).tolist()
)

# Step 13: Separate regular and cancellation records

is_cancelled = df_clean["InvoiceNo"].str.startswith("C")

print("\nRegular invoice records:", (~is_cancelled).sum())
print("Cancellation invoice records:", is_cancelled.sum())
print("Total records:", len(df_clean))

# Step 14: Investigate zero-price records

zero_price = df_clean[df_clean["UnitPrice"] == 0]

print("\nTotal zero-price records:", len(zero_price))

print(
    "Zero-price records with positive quantity:",
    (zero_price["Quantity"] > 0).sum()
)

print(
    "Zero-price records with negative quantity:",
    (zero_price["Quantity"] < 0).sum()
)

print("\nTop 10 descriptions in zero-price records:")
print(zero_price["Description"].value_counts().head(10))

# Step 15: Zero-price records by invoice type

zero_price = df_clean[df_clean["UnitPrice"] == 0]

zero_price_cancelled = zero_price[
    zero_price["InvoiceNo"].str.startswith("C")
]

print("\nZero-price records:", len(zero_price))
print("Zero-price cancellation records:", len(zero_price_cancelled))
print(
    "Zero-price regular invoice records:",
    len(zero_price) - len(zero_price_cancelled)
)

# Step 16: Negative quantities on non-cancellation invoices

negative_qty = df_clean[df_clean["Quantity"] < 0]

negative_qty_non_cancelled = negative_qty[
    ~negative_qty["InvoiceNo"].str.startswith("C")
]

print("\nAll negative-quantity records:", len(negative_qty))
print(
    "Negative quantities on cancellation invoices:",
    (len(negative_qty) - len(negative_qty_non_cancelled))
)
print(
    "Negative quantities on non-cancellation invoices:",
    len(negative_qty_non_cancelled)
)

# Step 17: Inspect negative quantities on non-cancellation invoices

print("\nExamples of negative quantities on non-cancellation invoices:")

print(
    negative_qty_non_cancelled[
        ["InvoiceNo", "StockCode", "Description",
         "Quantity", "UnitPrice", "Country"]
    ].head(15).to_string(index=False)
)

# Step 18: Check unit prices of negative quantities on non-cancellation invoices

print("\nUnitPrice distribution for negative quantities on non-cancellation invoices:")

print(
    negative_qty_non_cancelled["UnitPrice"]
    .value_counts(dropna=False)
)

print(
    "\nNumber of records with non-zero UnitPrice:",
    (negative_qty_non_cancelled["UnitPrice"] != 0).sum()
)

# Step 19: Inspect the highest unit prices

print("\nTop 15 highest unit-price records:")

print(
    df_clean.nlargest(15, "UnitPrice")[
        ["InvoiceNo", "StockCode", "Description",
         "Quantity", "UnitPrice", "Country"]
    ].to_string(index=False)
)

# Step 20: Inspect negative unit-price records

negative_price = df_clean[df_clean["UnitPrice"] < 0]

print("\nRecords with negative UnitPrice:")

print(
    negative_price[
        ["InvoiceNo", "StockCode", "Description",
         "Quantity", "UnitPrice", "Country"]
    ].to_string(index=False)
)

# Step 21: Final missing-value check

print("\nMissing values after duplicate removal:")

print(df_clean.isnull().sum())

print("\nTotal missing values:", df_clean.isnull().sum().sum())

# Step 22: Verify duplicates and dataset size

print("\nFinal duplicate check:")
print("Duplicate rows:", df_clean.duplicated().sum())

print("\nCurrent dataset shape:")
print(df_clean.shape)

print("\nTotal records:", len(df_clean))

# Step 23: Verify column data types

print("\nColumn data types:")
print(df_clean.dtypes)

# Step 24: Convert InvoiceDate to datetime

df_clean["InvoiceDate"] = pd.to_datetime(
    df_clean["InvoiceDate"],
    errors="coerce"
)

print("\nInvoiceDate data type after conversion:")
print(df_clean["InvoiceDate"].dtype)

print("\nMissing dates after conversion:")
print(df_clean["InvoiceDate"].isna().sum())

# Step 25: Verify the date range

print("\nEarliest invoice date:")
print(df_clean["InvoiceDate"].min())

print("\nLatest invoice date:")
print(df_clean["InvoiceDate"].max())

# Step 26: Verify numeric column data types

print("\nNumeric column data types:")

print(
    df_clean[["Quantity", "UnitPrice", "CustomerID"]].dtypes
)

# Step 27: Final validation after data type conversion

print("\nDataset shape:", df_clean.shape)

print(
    "\nMissing dates:",
    df_clean["InvoiceDate"].isna().sum()
)

print(
    "\nMissing CustomerIDs:",
    df_clean["CustomerID"].isna().sum()
)

print(
    "\nMissing Descriptions:",
    df_clean["Description"].isna().sum()
)

# Step 28: Save the cleaned dataset

output_path = "../Data/onlineretail_cleaned.csv"

df_clean.to_csv(
    output_path,
    index=False,
    encoding="utf-8-sig"
)

print("\nCleaned dataset saved successfully.")
print("File path:", output_path)

# Step 29: Verify the saved cleaned dataset

df_check = pd.read_csv(
    output_path,
    encoding="utf-8-sig",
    parse_dates=["InvoiceDate"]
)

print("\nSaved dataset shape:", df_check.shape)
print("Duplicate rows:", df_check.duplicated().sum())
print("Missing dates:", df_check["InvoiceDate"].isna().sum())
print("InvoiceDate type:", df_check["InvoiceDate"].dtype)

# Step 30: Cleaning summary

print("\n===== DATA CLEANING SUMMARY =====")
print("Final rows:", len(df_clean))
print("Final columns:", len(df_clean.columns))
print("Exact duplicates:", df_clean.duplicated().sum())
print("Missing CustomerIDs:", df_clean["CustomerID"].isna().sum())
print("Missing Descriptions:", df_clean["Description"].isna().sum())
print("Missing InvoiceDates:", df_clean["InvoiceDate"].isna().sum())
print("Saved file:", output_path)