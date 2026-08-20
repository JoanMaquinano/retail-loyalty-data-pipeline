-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 05 - DASHBOARD QUERIES
-- Business analysis using the Gold layer
-- ============================================================

-- ============================================================
-- MONTHLY SALES TREND
-- ============================================================

SELECT
    transaction_month,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY transaction_month
ORDER BY transaction_month;

-- ============================================================
-- SALES BY AGE GROUP
-- ============================================================

SELECT
    age_group,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY age_group
ORDER BY sales DESC;

-- ============================================================
-- SALES BY RETAILER
-- ============================================================

SELECT
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY retailer
ORDER BY sales DESC;

-- ============================================================
-- TOP PRODUCT BRANDS
-- ============================================================

SELECT
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY product_brand
ORDER BY sales DESC;

-- ============================================================
-- AGE GROUP × PRODUCT BRAND
-- ============================================================

SELECT
    age_group,
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY age_group, product_brand
ORDER BY age_group, sales DESC;

-- ============================================================
-- AGE GROUP × RETAILER
-- ============================================================

SELECT
    age_group,
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY age_group, retailer
ORDER BY age_group, sales DESC;

-- ============================================================
-- MONTHLY SALES BY RETAILER
-- ============================================================

SELECT
    transaction_month,
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY transaction_month, retailer
ORDER BY transaction_month, sales DESC;

-- ============================================================
-- MONTHLY SALES BY PRODUCT BRAND
-- ============================================================

SELECT
    transaction_month,
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY transaction_month, product_brand
ORDER BY transaction_month, sales DESC;

-- ============================================================
-- CUSTOMER PURCHASE FREQUENCY
-- ============================================================

SELECT
    customer_id,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY customer_id
ORDER BY transactions DESC;

-- ============================================================
-- TOP 10 CUSTOMERS BY SPEND
-- ============================================================

SELECT
    customer_id,
    age_group,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS total_sales
FROM workspace.gold.customer_purchase_analysis
GROUP BY customer_id, age_group
ORDER BY total_sales DESC
LIMIT 10;


