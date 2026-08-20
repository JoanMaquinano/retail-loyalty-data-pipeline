-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 04 - VALIDATION
-- Final validation of Bronze, Silver, and Gold layers
-- ============================================================

-- ============================================================
-- RECORD COUNT RECONCILIATION
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
    'Gold Transactions',
    COUNT(*)
FROM workspace.gold.customer_purchase_analysis

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

-- ============================================================
-- SILVER DATA QUALITY CHECKS
-- ============================================================

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity,
    SUM(CASE WHEN total_unit_price <= 0 THEN 1 ELSE 0 END) AS invalid_price
FROM workspace.silver.transaction_details_clean;

SELECT
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) AS null_birthday,
    SUM(CASE WHEN registered_date IS NULL THEN 1 ELSE 0 END) AS null_registered_date
FROM workspace.silver.loyalty_cardholders_clean;

-- ============================================================
-- DUPLICATE CHECKS
-- ============================================================

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM workspace.silver.loyalty_cardholders_clean
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT
    transaction_id,
    product_sku,
    COUNT(*) AS duplicate_count
FROM workspace.silver.transaction_details_clean
GROUP BY transaction_id, product_sku
HAVING COUNT(*) > 1;

-- ============================================================
-- GOLD LAYER VALIDATION
-- ============================================================

SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT transaction_id) AS unique_transactions,
    COUNT(DISTINCT product_brand) AS unique_brands,
    COUNT(DISTINCT retailer) AS unique_retailers
FROM workspace.gold.customer_purchase_analysis;

-- Age group distribution

SELECT
    age_group,
    COUNT(*) AS records
FROM workspace.gold.customer_purchase_analysis
GROUP BY age_group
ORDER BY age_group;

-- Transactions without loyalty match

SELECT
    COUNT(*) AS unmatched_customers
FROM workspace.gold.customer_purchase_analysis
WHERE birthday IS NULL;

-- Null checks in Gold

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN product_brand IS NULL THEN 1 ELSE 0 END) AS null_product_brand,
    SUM(CASE WHEN retailer IS NULL THEN 1 ELSE 0 END) AS null_retailer,
    SUM(CASE WHEN age_group IS NULL THEN 1 ELSE 0 END) AS null_age_group
FROM workspace.gold.customer_purchase_analysis;