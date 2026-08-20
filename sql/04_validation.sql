-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 04 - VALIDATION
-- Final pipeline validation
-- ============================================================

USE CATALOG workspace;
USE SCHEMA retail_pipeline;

-- ============================================================
-- RECORD COUNT RECONCILIATION
-- ============================================================

SELECT
    'Raw Transactions' AS dataset,
    COUNT(*) AS records
FROM workspace.retail_pipeline.transaction_details_raw

UNION ALL

SELECT
    'Clean Transactions',
    COUNT(*)
FROM workspace.retail_pipeline.transaction_details_clean

UNION ALL

SELECT
    'Customer Purchase Analysis',
    COUNT(*)
FROM workspace.retail_pipeline.customer_purchase_analysis

UNION ALL

SELECT
    'Raw Loyalty',
    COUNT(*)
FROM workspace.retail_pipeline.loyalty_cardholders_raw

UNION ALL

SELECT
    'Clean Loyalty',
    COUNT(*)
FROM workspace.retail_pipeline.loyalty_cardholders_clean;

-- ============================================================
-- SILVER DATA QUALITY CHECKS
-- ============================================================

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN quantity <= 0 THEN 1 ELSE 0 END) AS invalid_quantity,
    SUM(CASE WHEN total_unit_price <= 0 THEN 1 ELSE 0 END) AS invalid_price
FROM workspace.retail_pipeline.transaction_details_clean;

SELECT
    SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
    SUM(CASE WHEN birthday IS NULL THEN 1 ELSE 0 END) AS null_birthday,
    SUM(CASE WHEN registered_date IS NULL THEN 1 ELSE 0 END) AS null_registered_date
FROM workspace.retail_pipeline.loyalty_cardholders_clean;

-- ============================================================
-- DUPLICATE CHECKS
-- ============================================================

SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM workspace.retail_pipeline.loyalty_cardholders_clean
GROUP BY user_id
HAVING COUNT(*) > 1;

SELECT
    transaction_id,
    product_sku,
    COUNT(*) AS duplicate_count
FROM workspace.retail_pipeline.transaction_details_clean
GROUP BY transaction_id, product_sku
HAVING COUNT(*) > 1;

-- ============================================================
-- GOLD DATA QUALITY CHECKS
-- ============================================================

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN product_brand IS NULL THEN 1 ELSE 0 END) AS null_product_brand,
    SUM(CASE WHEN retailer IS NULL THEN 1 ELSE 0 END) AS null_retailer,
    SUM(CASE WHEN age_group IS NULL THEN 1 ELSE 0 END) AS null_age_group
FROM workspace.retail_pipeline.customer_purchase_analysis;

-- Age range validation

SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age
FROM workspace.retail_pipeline.customer_purchase_analysis
WHERE age IS NOT NULL;