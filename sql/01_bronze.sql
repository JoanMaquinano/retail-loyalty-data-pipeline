-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 01 - BRONZE LAYER
-- Raw data ingestion and storage
-- ============================================================

-- ============================================================
-- SETUP
-- ============================================================

USE CATALOG workspace;

CREATE SCHEMA IF NOT EXISTS retail_pipeline;

USE SCHEMA retail_pipeline;

-- ============================================================
-- RAW TRANSACTION TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS workspace.retail_pipeline.transaction_details_raw (
    customer_id BIGINT,
    transaction_id BIGINT,
    receipt_date STRING,
    transaction_date TIMESTAMP,
    receipt_number STRING,
    product_sku STRING,
    product_brand STRING,
    quantity BIGINT,
    total_unit_price DOUBLE,
    retailer STRING,
    branch STRING
);

-- ============================================================
-- RAW LOYALTY TABLE
-- ============================================================

CREATE TABLE IF NOT EXISTS workspace.retail_pipeline.loyalty_cardholders_raw (
    user_id BIGINT,
    birthday DATE,
    registered_date TIMESTAMP
);

-- ============================================================
-- LOAD VALIDATION
-- ============================================================

SELECT
    'Transaction Details' AS dataset,
    COUNT(*) AS records
FROM workspace.retail_pipeline.transaction_details_raw

UNION ALL

SELECT
    'Loyalty Cardholders' AS dataset,
    COUNT(*) AS records
FROM workspace.retail_pipeline.loyalty_cardholders_raw;