# Retail Transactions + Loyalty Customer Data Pipeline

## Project Overview

This project builds a repeatable data pipeline in Databricks using SQL.

The pipeline processes two datasets:

- Retail Transaction Details
- Loyalty Cardholders

The objective is to transform raw data into clean, validated, and business-ready data for analytics.

### Business Question

> How does purchasing behavior differ by customer age group, retailer, product brand, and month?

---

## Pipeline Architecture

```text
transaction_details_raw
loyalty_cardholders_raw
            ↓
transaction_details_clean
loyalty_cardholders_clean
            ↓
customer_purchase_analysis
            ↓
validation checks
            ↓
dashboard insights
```

---

## Bronze Layer

The Bronze layer stores raw source data exactly as received.

### Tables

- `workspace.retail_pipeline.transaction_details_raw`
- `workspace.retail_pipeline.loyalty_cardholders_raw`

### Baseline Record Counts

| Dataset | Row Count |
|----------|---------:|
| Transaction Details | 3,167 |
| Loyalty Cardholders | 5,949 |

### Data Quality Findings

| Quality Check | Records |
|----------|---------:|
| Invalid Transactions | 6 |
| Invalid Loyalty Birthdays | 4 |

### Grain

**Transaction Details**

One row represents one purchased product within a transaction.

**Loyalty Cardholders**

One row represents one registered loyalty member.

### Source Data Issues Identified

Transaction records were flagged when:

- Quantity was zero or negative
- Sales value was zero or negative

Loyalty records were flagged when:

- Birthday values could not be parsed into valid dates

---

## Silver Layer

The Silver layer validates, cleans, and standardizes the Bronze data.

### Tables

- `workspace.retail_pipeline.transaction_details_clean`
- `workspace.retail_pipeline.loyalty_cardholders_clean`

### Cleaning Activities

**Transactions**

- Removed records with zero or negative quantities
- Removed records with zero or negative sales values
- Standardized retailer names
- Standardized product brand names
- Removed duplicate records

**Loyalty Members**

- Parsed birthdays stored in `MM/DD/YY` format
- Corrected century interpretation for two-digit birth years
- Removed invalid birthday records
- Removed duplicate records

### Dataset Relationship

The transaction and loyalty datasets are connected using:

```sql
customer_id = user_id
```

### Results

| Dataset | Raw Records | Clean Records | Records Removed |
|----------|-----------:|-----------:|---------------:|
| Transaction Details | 3,167 | 3,161 | 6 |
| Loyalty Cardholders | 5,949 | 5,945 | 4 |

---

## Gold Layer

The Gold layer combines transaction and loyalty data into a business-ready analytical dataset.

### Table

- `workspace.retail_pipeline.customer_purchase_analysis`

### Business Enrichment

The Gold layer derives:

- Customer age
- Customer age group
- Transaction month
- Customer-retailer relationships
- Customer-brand relationships

### Age Groups

- 18–24
- 25–34
- 35–44
- 45–54
- 55+
- Unknown

### Metrics Available

- Sales
- Units Purchased
- Transactions
- Customers
- Average Transaction Value

### Gold Layer Validation

| Metric | Result |
|----------|-------:|
| Total Records | 3,161 |
| Null Customer IDs | 0 |
| Null Transaction IDs | 0 |
| Null Retailers | 0 |
| Null Product Brands | 3 |
| Null Age Groups | 0 |

Three records contained missing product brand values inherited from the source data. These records were retained because they represented valid transactions.

---

## Validation Layer

The Validation layer verifies that data quality rules were successfully applied across the pipeline.

### Record Reconciliation

| Dataset | Records |
|----------|-------:|
| Raw Transactions | 3,167 |
| Clean Transactions | 3,161 |
| Customer Purchase Analysis | 3,161 |
| Raw Loyalty | 5,949 |
| Clean Loyalty | 5,945 |

### Silver Layer Validation

#### Transaction Data

| Check | Result |
|---------|-------:|
| Null Customer IDs | 0 |
| Null Transaction IDs | 0 |
| Invalid Quantities | 0 |
| Invalid Prices | 0 |

#### Loyalty Data

| Check | Result |
|---------|-------:|
| Null User IDs | 0 |
| Null Birthdays | 0 |
| Null Registration Dates | 0 |

### Gold Layer Validation

| Check | Result |
|---------|-------:|
| Null Customer IDs | 0 |
| Null Transaction IDs | 0 |
| Null Product Brands | 3 |
| Null Retailers | 0 |
| Null Age Groups | 0 |

### Age Validation

| Metric | Result |
|---------|-------:|
| Minimum Age | 2 |
| Maximum Age | 77 |

A small number of loyalty members were below 18 years old. These records were retained because no business rule restricting minimum membership age was provided.

---

## Data Quality Summary

### Transactions

- 6 records contained zero quantity or zero sales values and were removed.
- No duplicate transaction records were identified.
- No missing customer IDs or transaction IDs were detected.

### Loyalty Members

- 4 records contained invalid birthday values and were removed.
- No duplicate users were identified.
- No missing user IDs, birthdays, or registration dates were detected.

### Gold Layer

- All 3,161 cleaned transaction records were successfully loaded into the business-ready dataset.
- Three records contained missing product brand values inherited from source data and were retained.

---

## Dashboard

The dashboard answers the project's business question:

> How does purchasing behavior differ by customer age group, retailer, product brand, and month?

### Dashboard Queries

- Monthly Sales Trend
- Sales by Age Group
- Sales by Retailer
- Top Product Brands
- Age Group × Product Brand
- Age Group × Retailer
- Monthly Sales by Retailer
- Monthly Sales by Product Brand
- Average Spend per Transaction by Age Group
- Average Spend per Transaction by Retailer

### Suggested Visualizations

- Monthly Sales Trend Line Chart
- Sales by Age Group Bar Chart
- Sales by Retailer Bar Chart
- Top Product Brands Bar Chart
- Product Brand Heatmap by Age Group
- Retailer Heatmap by Age Group
- Monthly Retailer Sales Trend
- Monthly Product Brand Sales Trend
- KPI Cards (Sales, Transactions, Customers, Units Sold)

---

## SQL Execution Order

Run the SQL files in the following order:

1. `01_bronze.sql`
2. `02_silver.sql`
3. `03_gold.sql`
4. `04_validation.sql`
5. `05_dashboard_queries.sql`

---

## Repository Structure

```text
retail-loyalty-data-pipeline/
│
├── sql/
│   ├── 01_bronze.sql
│   ├── 02_silver.sql
│   ├── 03_gold.sql
│   ├── 04_validation.sql
│   └── 05_dashboard_queries.sql
│
├── dashboard/
│
└── README.md
```

## Skills Demonstrated

- SQL
- Databricks
- Data Cleaning
- Data Quality Validation
- Data Modeling
- Data Transformation
- ETL Pipelines
- Medallion Architecture
- Business Analytics
- Data Documentation