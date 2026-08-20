-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 02 - SILVER LAYER
-- Clean, validate, and standardize Bronze data
-- ============================================================

-- ============================================================
-- STEP 1: DATA PROFILING
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT `# customer_id`) AS unique_customers,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    COUNT(DISTINCT product_sku) AS unique_products,
    COUNT(DISTINCT retailer) AS unique_retailers
FROM workspace.bronze.transaction_details_raw;

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT user_id) AS unique_users
FROM workspace.bronze.loyalty_cardholders_raw;

-- ============================================================
-- STEP 2: DATA QUALITY CHECKS
-- ============================================================

-- Missing values: Transactions

SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN `# customer_id` IS NULL THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS missing_transaction_id,
    SUM(CASE WHEN product_sku IS NULL THEN 1 ELSE 0 END) AS missing_product_sku,
    SUM(CASE WHEN product_brand IS NULL THEN 1 ELSE 0 END) AS missing_product_brand,
    SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS missing_quantity,
    SUM(CASE WHEN total_unit_price IS NULL THEN 1 ELSE 0 END) AS missing_unit_price,
    SUM(CASE WHEN retailer IS NULL THEN 1 ELSE 0 END) AS missing_retailer,
    SUM(CASE WHEN branch IS NULL THEN 1 ELSE 0 END) AS missing_branch
FROM workspace.bronze.transaction_details_raw;

-- Missing values: Loyalty

SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS missing_user_id,
    SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) AS missing_birthday,
    SUM(CASE WHEN registered_date IS NULL THEN 1 ELSE 0 END) AS missing_registered_date
FROM workspace.bronze.loyalty_cardholders_raw;

-- Duplicate transactions

SELECT
    *,
    COUNT(*) AS duplicate_count
FROM workspace.bronze.transaction_details_raw
GROUP BY ALL
HAVING COUNT(*) > 1;

-- Duplicate loyalty members

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM workspace.bronze.loyalty_cardholders_raw
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Invalid transaction values

SELECT *
FROM workspace.bronze.transaction_details_raw
WHERE quantity <= 0
   OR total_unit_price <= 0;

-- Invalid loyalty values

SELECT *
FROM workspace.bronze.loyalty_cardholders_raw
WHERE birthday > CURRENT_DATE()
   OR registered_date < birthday;

-- ============================================================
-- STEP 3: STANDARDIZATION
-- ============================================================

CREATE OR REPLACE TEMP VIEW transaction_standardized AS
SELECT
    `# customer_id` AS customer_id,
    transaction_id,
    receipt_date,
    transaction_date,
    receipt_number,
    TRIM(product_sku) AS product_sku,
    UPPER(TRIM(product_brand)) AS product_brand,
    quantity,
    total_unit_price,
    INITCAP(TRIM(retailer)) AS retailer,
    TRIM(branch) AS branch
FROM workspace.bronze.transaction_details_raw;

-- ============================================================
-- STEP 4: CREATE SILVER TABLES
-- ============================================================

CREATE OR REPLACE TABLE workspace.silver.transaction_details_clean AS
SELECT DISTINCT *
FROM transaction_standardized
WHERE customer_id IS NOT NULL
  AND transaction_id IS NOT NULL
  AND quantity > 0
  AND total_unit_price > 0;

CREATE OR REPLACE TABLE workspace.silver.loyalty_cardholders_clean AS
SELECT DISTINCT
    user_id,
    birthday,
    registered_date
FROM workspace.bronze.loyalty_cardholders_raw
WHERE user_id IS NOT NULL
  AND birthday IS NOT NULL
  AND birthday <= CURRENT_DATE()
  AND registered_date >= birthday;

-- ============================================================
-- STEP 5: VALIDATION
-- ============================================================

SELECT
    'Bronze Transactions' AS dataset,
    COUNT(*) AS records
FROM workspace.bronze.transaction_details_raw

UNION ALL

SELECT
    'Silver Transactions',
    COUNT(*)
FROM workspace.silver.transaction_details_clean

UNION ALL

SELECT
    'Bronze Loyalty',
    COUNT(*)
FROM workspace.bronze.loyalty_cardholders_raw

UNION ALL

SELECT
    'Silver Loyalty',
    COUNT(*)
FROM workspace.silver.loyalty_cardholders_clean;

-- Remaining duplicate loyalty members

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM workspace.silver.loyalty_cardholders_clean
GROUP BY user_id
HAVING COUNT(*) > 1;

-- Remaining invalid transaction values

SELECT *
FROM workspace.silver.transaction_details_clean
WHERE quantity <= 0
   OR total_unit_price <= 0;