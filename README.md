# Data Cleaning in SQL - Nashville Housing Project

## 1. Overview

This project demonstrates an end-to-end data cleaning process performed entirely in MS SQL Server (T-SQL). The goal is to take a raw Nashville housing dataset, identify and fix inconsistencies, normalize the data, and produce a clean, usable table ready for analysis.

This script includes techniques for handling nulls, splitting string data, removing duplicates, and standardizing columns.

## 2. Tools Used

* **Microsoft SQL Server (T-SQL)**

## 3. Data Cleaning Steps

The `DataCleaning.sql` script performs the following transformations:

### a. Populate Missing Property Address Data

* **Problem:** Some records have a `NULL` `PropertyAddress`, but share a `ParcelID` with other records that *do* have an address.
* **Technique:** A **self-join** is used on the `nashvile` table, matching rows with the same `ParcelID` but different `UniqueID`s.
* **Solution:** The `UPDATE` statement uses `ISNULL()` to fill the `NULL` `PropertyAddress` with the correct address from its corresponding `ParcelID` row.

### b. Split `PropertyAddress` into Individual Columns

* **Problem:** The `PropertyAddress` column contains the street address and city in a single string (e.g., "1808 FOX CHASE DR, GOODLETTSVILLE").
* **Technique:** `SUBSTRING` and `CHARINDEX` are used to locate the comma and split the string into two parts.
* **Solution:** `ALTER TABLE` is used to add two new columns: `PropertySplitAddress` and `PropertySplitCity`. These are then populated with the separated values.

### c. Split `OwnerAddress` into Individual Columns

* **Problem:** The `OwnerAddress` column contains the street, city, and state in a single string (e.g., "1808 FOX CHASE DR, GOODLETTSVILLE, TN").
* **Technique:** A different method is used: `PARSENAME`. This T-SQL function is designed to parse object names but is cleverly used here to split strings separated by periods. `REPLACE` is first used to change all commas to periods.
* **Solution:** `PARSENAME` is used to split the address into three parts (note: `PARSENAME` works from right-to-left). `ALTER TABLE` is used to add `OwnerSplitAddress`, `OwnerSplitCity`, and `OwnerSplitState`, which are then populated.

### d. Remove Duplicates

* **Problem:** The dataset contains duplicate rows with the same `ParcelID`, `PropertyAddress`, `SalePrice`, etc.
* **Technique:** A **Common Table Expression (CTE)** is created using the `ROW_NUMBER()` window function.
* **Solution:** The `ROW_NUMBER()` is partitioned by key columns that should be unique. Any row with a `row_num > 1` is considered a duplicate and is deleted using the CTE.

### e. Remove Unused Columns

* **Problem:** The original, un-normalized columns (`OwnerAddress`, `PropertyAddress`, `TaxDistrict`) are now redundant.
* **Solution:** `ALTER TABLE ... DROP COLUMN` is used to remove these columns, leaving a final, clean table.

## 4. Results

The final output is the modified `nashvile` table, which is now clean, normalized, and free of duplicates. All address information is split into separate, usable columns, and missing data has been populated, making the dataset ready for analysis.

## 5. How to Run

1.  **Set up Database:** This script is written for **MS SQL Server**.
2.  **Import Data:** Import your raw Nashville housing dataset into a database table named `nashvile`.
3.  **Run Script:** Execute the `DataCleaning.sql` file in your SQL Server management tool. The script will perform all cleaning steps in sequence.
