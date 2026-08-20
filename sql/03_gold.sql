

    CREATE OR REPLACE TABLE gold_customer_transactions AS
SELECT
    t.cleaned_receipt_number,
    t.transaction_date,
    t.receipt_date,
    t.transaction_id,
    t.transaction_month,
    t.branch_upper,
    t.cleaned_product_sku,
    t.cleaned_product_brand,
    t.quantity,
    t.total_unit_price,
    t.unit_price,
    t.retailer,
    t.customer_id,
   
    c.birthday_formatted,
    c.age_at_registration,
    c.registered_date
FROM
    silver_trans_details t
LEFT JOIN
    silver_loyalty_cardholders c
    -- FIX 2: Strip hidden spaces and enforce matching text cases to guarantee the join connects
    ON t.customer_id  = c.user_id ;




SELECT *
from gold_customer_transactions;
