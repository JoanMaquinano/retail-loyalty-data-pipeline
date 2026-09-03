-- Check row counts
SELECT
    'Clean Transactions' AS table_name,
    COUNT(*) AS row_count
FROM workspace.silver.clean_transactions

UNION ALL

SELECT
    'Clean Loyalty Cardholders',
    COUNT(*)
FROM workspace.silver.clean_loyalty_cardholders;



-- Check transaction quality flags
SELECT
    data_quality_flag,
    COUNT(*) AS row_count
FROM workspace.silver.clean_transactions
GROUP BY data_quality_flag;



-- Check loyalty birthday status
SELECT
    birthday_cleaning_status,
    COUNT(*) AS row_count
FROM workspace.silver.clean_loyalty_cardholders
GROUP BY birthday_cleaning_status;



-- Check missing brands
SELECT
    COUNT(*) AS missing_product_brand
FROM workspace.silver.clean_transactions
WHERE product_brand IS NULL
   OR TRIM(product_brand) = '';



-- Check missing loyalty IDs
SELECT
    COUNT(*) AS missing_user_id
FROM workspace.silver.clean_loyalty_cardholders
WHERE user_id IS NULL;



-- Check duplicate loyalty IDs
SELECT
    user_id,
    COUNT(*) AS duplicate_count
FROM workspace.silver.clean_loyalty_cardholders
GROUP BY user_id
HAVING COUNT(*) > 1;
