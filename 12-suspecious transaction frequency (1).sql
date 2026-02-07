CREATE DEFINER=`root`@`localhost` PROCEDURE `suspecious_transaction_frequency`(
    IN period VARCHAR(10)   -- 'week', 'month', 'year'
)
BEGIN
    SET period = LOWER(period);

    -- WEEK
    IF period = 'week' THEN
        SELECT 
            WEEK(Transaction_Date,1) AS Week_No,
            COUNT(*) AS Suspicious_Count
        FROM banking_data1
        WHERE Risk_Flag = 'High Risk'
        GROUP BY WEEK(Transaction_Date,1)
        ORDER BY Week_No;

    -- MONTH
    ELSEIF period = 'month' THEN
        SELECT 
            MONTH(Transaction_Date) AS Month_No,
            COUNT(*) AS Suspicious_Count
        FROM banking_data1
        WHERE Risk_Flag = 'High Risk'
        GROUP BY MONTH(Transaction_Date)
        ORDER BY Month_No;

    -- YEAR
    ELSEIF period = 'year' THEN
        SELECT 
            YEAR(Transaction_Date) AS Year_No,
            COUNT(*) AS Suspicious_Count
        FROM banking_data1
        WHERE Risk_Flag = 'High Risk'
        GROUP BY YEAR(Transaction_Date)
        ORDER BY Year_No;

    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Choose: week, month or year';
    END IF;
END