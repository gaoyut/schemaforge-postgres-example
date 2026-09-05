ALTER TABLE customer
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE';

CREATE INDEX ix_customer_status ON customer (status);

