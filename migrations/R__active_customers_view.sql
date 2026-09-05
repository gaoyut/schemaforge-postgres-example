CREATE OR REPLACE VIEW active_customers AS
SELECT customer_id, customer_code, display_name, created_at
FROM customer
WHERE status = 'ACTIVE';

