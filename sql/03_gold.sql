-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 03 - GOLD LAYER
-- Business-ready customer purchasing dataset
-- ============================================================

-- ============================================================
-- STEP 1: CREATE CUSTOMER PURCHASE ANALYSIS TABLE
-- ============================================================

CREATE OR REPLACE TABLE workspace.gold.customer_purchase_analysis AS

SELECT
    t.customer_id,
    
    -- Customer demographics
    l.birthday,

    FLOOR(
        MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12
    ) AS age,

    CASE
        WHEN FLOOR(MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12) BETWEEN 18 AND 24 THEN '18-24'
        WHEN FLOOR(MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12) BETWEEN 25 AND 34 THEN '25-34'
        WHEN FLOOR(MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12) BETWEEN 35 AND 44 THEN '35-44'
        WHEN FLOOR(MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12) BETWEEN 45 AND 54 THEN '45-54'
        WHEN FLOOR(MONTHS_BETWEEN(CURRENT_DATE(), l.birthday) / 12) >= 55 THEN '55+'
        ELSE 'Unknown'
    END AS age_group,

    -- Transaction details
    t.transaction_id,
    t.receipt_number,
    t.transaction_date,

    DATE_FORMAT(
        t.transaction_date,
        'yyyy-MM'
    ) AS transaction_month,

    -- Product attributes
    t.product_sku,
    t.product_brand,

    -- Purchase metrics
    t.quantity,
    t.total_unit_price,

    -- Retail attributes
    t.retailer,
    t.branch

FROM workspace.silver.transaction_details_clean t

LEFT JOIN workspace.silver.loyalty_cardholders_clean l
    ON t.customer_id = l.user_id;

-- ============================================================
-- STEP 2: VALIDATE GOLD OUTPUT
-- ============================================================

-- Record counts

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

-- Customers without loyalty match

SELECT
    COUNT(*) AS unmatched_customers
FROM workspace.gold.customer_purchase_analysis
WHERE birthday IS NULL;

-- Null checks

SELECT
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
    SUM(CASE WHEN product_brand IS NULL THEN 1 ELSE 0 END) AS null_product_brand,
    SUM(CASE WHEN retailer IS NULL THEN 1 ELSE 0 END) AS null_retailer
FROM workspace.gold.customer_purchase_analysis;