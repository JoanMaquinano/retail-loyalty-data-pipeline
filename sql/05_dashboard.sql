-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 05 - DASHBOARD QUERIES
-- Business analysis using the Gold layer
-- ============================================================

USE CATALOG workspace;
USE SCHEMA retail_pipeline;

-- ============================================================
-- MONTHLY SALES TREND
-- How does purchasing behavior change over time?
-- ============================================================

SELECT
    transaction_month,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY transaction_month
ORDER BY transaction_month;

-- ============================================================
-- SALES BY AGE GROUP
-- How does purchasing behavior differ across age groups?
-- ============================================================

SELECT
    age_group,
    COUNT(DISTINCT customer_id) AS customers,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY age_group
ORDER BY sales DESC;

-- ============================================================
-- SALES BY RETAILER
-- Which retailers generate the most sales?
-- ============================================================

SELECT
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY retailer
ORDER BY sales DESC;

-- ============================================================
-- TOP PRODUCT BRANDS
-- Which brands are purchased most frequently?
-- ============================================================

SELECT
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY product_brand
ORDER BY sales DESC;

-- ============================================================
-- AGE GROUP × PRODUCT BRAND
-- Which brands are preferred by each age group?
-- ============================================================

SELECT
    age_group,
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY age_group, product_brand
ORDER BY age_group, sales DESC;

-- ============================================================
-- AGE GROUP × RETAILER
-- Which retailers are preferred by each age group?
-- ============================================================

SELECT
    age_group,
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY age_group, retailer
ORDER BY age_group, sales DESC;

-- ============================================================
-- MONTHLY SALES BY RETAILER
-- How do retailer sales change over time?
-- ============================================================

SELECT
    transaction_month,
    retailer,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY transaction_month, retailer
ORDER BY transaction_month, sales DESC;

-- ============================================================
-- MONTHLY SALES BY PRODUCT BRAND
-- How do brand sales change over time?
-- ============================================================

SELECT
    transaction_month,
    product_brand,
    COUNT(DISTINCT transaction_id) AS transactions,
    SUM(total_unit_price) AS sales
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY transaction_month, product_brand
ORDER BY transaction_month, sales DESC;

-- ============================================================
-- AVERAGE SPEND PER TRANSACTION BY AGE GROUP
-- Which age groups spend the most per transaction?
-- ============================================================

SELECT
    age_group,
    ROUND(
        SUM(total_unit_price) /
        COUNT(DISTINCT transaction_id),
        2
    ) AS avg_transaction_value
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY age_group
ORDER BY avg_transaction_value DESC;

-- ============================================================
-- AVERAGE SPEND PER TRANSACTION BY RETAILER
-- Which retailers have the highest basket value?
-- ============================================================

SELECT
    retailer,
    ROUND(
        SUM(total_unit_price) /
        COUNT(DISTINCT transaction_id),
        2
    ) AS avg_transaction_value
FROM workspace.retail_pipeline.customer_purchase_analysis
GROUP BY retailer
ORDER BY avg_transaction_value DESC;