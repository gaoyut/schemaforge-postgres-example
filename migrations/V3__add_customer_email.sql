ALTER TABLE customer
    ADD COLUMN email VARCHAR(320);

ALTER TABLE customer
    ADD CONSTRAINT chk_customer_email_nonempty
    CHECK (email IS NULL OR btrim(email) <> '');

CREATE UNIQUE INDEX ux_customer_email_ci
    ON customer (LOWER(email))
    WHERE email IS NOT NULL;
