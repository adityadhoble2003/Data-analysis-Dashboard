create database project;
use project;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = on;
CREATE TABLE banking_data1 (
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

select * from banking_data;
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Transac.csv'
INTO TABLE banking_data1
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
desc banking_data;