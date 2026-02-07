CREATE DEFINER=`root`@`localhost` PROCEDURE `Transactions_Count`()
BEGIN
    -- Transactions per Day
    SELECT 
        DATE(Transaction_Date) AS Day,
        COUNT(*) AS Transactions_Per_Day
    FROM banking_data
    GROUP BY DATE(Transaction_Date)order by date(transaction_date);

    -- Transactions per Week
    SELECT 
        WEEK(Transaction_Date) AS Week_Number,
        COUNT(*) AS Transactions_Per_Week
    FROM banking_data
    GROUP BY  WEEK(Transaction_Date) order by week(transaction_date);

    -- Transactions per Month
    SELECT 
        MONTH(Transaction_Date) AS Month,
        COUNT(*) AS Transactions_Per_Month
    FROM banking_data
    GROUP BY  MONTH(Transaction_Date) order by month(Transaction_Date);
END