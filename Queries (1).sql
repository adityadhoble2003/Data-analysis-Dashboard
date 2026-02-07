use project;
-- Query-1
-- 1-Total Credit Amount:
SELECT SUM(Amount) AS Total_Credit_Amount
FROM banking_data  
WHERE `Transaction_Type` = 'Credit';
-- Query-2
-- 2-Total Debit Amount:
select sum(Amount) as Total_debit_Amount
from banking_data
where transaction_type="Debit";
-- Query-3
-- 3-Credit to Debit Ratio:
-- way1
select 
(select sum(Amount) as total_credit_amount from banking_data where transaction_type="credit")/
(select sum(Amount) as total_debit_amount from banking_data where transaction_type="debit") as credit_to_debit_ratio
from banking_data limit 1;
-- way2
SELECT 
    SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END) /
    SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END) 
        AS Credit_to_Debit_Ratio
FROM banking_data;
-- query 4
-- 4-Net Transaction Amount:
-- way1
SELECT 
    SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END) -
    SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END) 
        AS Credit_to_Debit_Ratio
FROM banking_data;
-- way2
select 
(select sum(Amount) as total_credit_amount from banking_data where transaction_type="credit")-
(select sum(Amount) as total_debit_amount from banking_data where transaction_type="debit") as credit_to_debit_ratio
from banking_data limit 1;

-- 5-Account Activity Ratio:
create view Account_Activity_Ratio as SELECT 
    Account_Number,
    COUNT(*) AS Number_of_Transactions,
    Balance,
    COUNT(*) / Balance AS Account_Activity_Ratio
FROM banking_data
GROUP BY account_number,Balance;

-- displaying view
select * from Account_Activity_Ratio;

-- Query-6
-- 6-Transactions per Day/Week/Month:
call project.Transactions_Count();

-- Query-7
-- 7-Total Transaction Amount by Branch:
 select 
 branch,sum(amount) as Total_Amount
 from banking_data 
 group by branch;

-- Query-8
select 
bank_name,sum(amount) as total_Amount
from banking_data
group by bank_name;

-- Query-9
-- 9-Transaction Method Distribution:
select
transaction_method,count(*) 
from banking_data 
group by
 transaction_method;
-- Query-10
-- 10-Branch Transaction Growth:
call project.Branch_Transaction_Growth('month', '2024/11/03');
-- Query 11
-- 11-High-Risk Transaction Flag:
SELECT
  b.customer_id,
  b.Account_Number,
  b.Transaction_Date,
  b.Transaction_Type,
  b.Amount,
  b.Branch,
  CASE
    WHEN b.Amount > 1 * stats.avg_amt THEN 'High Risk'
    ELSE 'Normal'
  END AS Risk_Flag
FROM banking_data b
JOIN (
  SELECT Account_Number, AVG(Amount) AS avg_amt
  FROM banking_data
  GROUP BY Account_Number
) stats
  ON b.Account_Number = stats.Account_Number;
  
  -- altering
ALTER TABLE banking_data1
ADD COLUMN Risk_Flag VARCHAR(20) DEFAULT 'Normal';
UPDATE banking_data1
SET Risk_Flag = 
    CASE
        WHEN Amount > 100000 
             OR (Transaction_Type = 'Debit' AND Amount > 5000)
             OR (Transaction_Type = 'Credit' AND Amount > 2000)
        THEN 'High Risk'
        ELSE 'Normal'
    END;
    select branch,risk_flag from banking_data1;

-- Query 12
-- 12-Suspicious Transaction Frequency:
call project.suspecious_transaction_frequency('week');



