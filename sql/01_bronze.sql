-- ============================================================
-- RETAIL TRANSACTIONS + LOYALTY CUSTOMER DATA PIPELINE
-- 00 - PROJECT SETUP
-- ============================================================
USE CATALOG workspace;

-- Bronze: preserves raw source data
CREATE SCHEMA IF NOT EXISTS workspace.bronze
COMMENT 'Raw and preserved retail transaction and loyalty source data';

-- Silver: cleaned and standardized data
CREATE SCHEMA IF NOT EXISTS workspace.silver
COMMENT 'Cleaned and standardized transaction and loyalty data';

-- Quality: rejected, suspicious, and validation records
CREATE SCHEMA IF NOT EXISTS workspace.quality
COMMENT 'Data quality findings and rejected or suspicious records';

-- Gold: business-ready analytical tables
CREATE SCHEMA IF NOT EXISTS workspace.gold
COMMENT 'Business-ready tables for purchasing behavior analysis';

-- Bronze layer
-- Keeps the original transaction and loyalty data before cleaning.

USE CATALOG workspace;
USE SCHEMA bronze;

-- Landing area for source files
CREATE VOLUME IF NOT EXISTS workspace.bronze.source_files;

-- Raw transaction data
-- One row represents one product line from a transaction.
CREATE TABLE IF NOT EXISTS workspace.bronze.transaction_details_raw (
    `# customer_id` BIGINT,
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

-- Raw loyalty data
-- One row represents one registered loyalty member.
CREATE TABLE IF NOT EXISTS workspace.bronze.loyalty_cardholders_raw (
    user_id BIGINT,
    birthday DATE,
    registered_date TIMESTAMP
);

-- Check current row counts
SELECT
    'Transaction Details' AS source,
    COUNT(*) AS row_count
FROM workspace.bronze.transaction_details_raw

UNION ALL

SELECT
    'Loyalty Cardholders' AS source,
    COUNT(*) AS row_count
FROM workspace.bronze.loyalty_cardholders_raw;

-- Bronze layer
-- Keeps the original transaction and loyalty data before cleaning.

USE CATALOG workspace;
USE SCHEMA bronze;

-- Landing area for source files
CREATE VOLUME IF NOT EXISTS workspace.bronze.source_files;

-- Raw transaction data
-- One row represents one product line from a transaction.
CREATE TABLE IF NOT EXISTS workspace.bronze.transaction_details_raw (
    `# customer_id` BIGINT,
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

-- Raw loyalty data
-- One row represents one registered loyalty member.
CREATE TABLE IF NOT EXISTS workspace.bronze.loyalty_cardholders_raw (
    user_id BIGINT,
    birthday DATE,
    registered_date TIMESTAMP
);

-- Check current row counts
SELECT
    'Transaction Details' AS source,
    COUNT(*) AS row_count
FROM workspace.bronze.transaction_details_raw

UNION ALL

SELECT
    'Loyalty Cardholders' AS source,
    COUNT(*) AS row_count
FROM workspace.bronze.loyalty_cardholders_raw;
