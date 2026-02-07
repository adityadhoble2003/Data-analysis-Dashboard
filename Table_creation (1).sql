use credit_debit;
CREATE TABLE banking_data (
    customer_id VARCHAR(50),
    customer_name VARCHAR(100),
    account_number BIGINT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    balance DECIMAL(12,2),
    description VARCHAR(255),
    branch VARCHAR(100),
    transaction_method VARCHAR(50),
    currency VARCHAR(10),
    bank_name VARCHAR(100)
);