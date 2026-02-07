CREATE DEFINER=`root`@`localhost` PROCEDURE `Branch_Transaction_Growth`(
  IN period VARCHAR(10),   -- 'week' | 'month' | 'year'
  IN ref_date DATE         -- any date inside the period to analyze (e.g. '2025-11-10')
)
BEGIN
  DECLARE cur_start DATE;
  DECLARE cur_end   DATE;
  DECLARE prev_start DATE;
  DECLARE prev_end   DATE;

  SET period = LOWER(TRIM(period));

  IF period = 'month' THEN
    -- current month
    SET cur_start = DATE_FORMAT(ref_date, '%Y-%m-01');
    SET cur_end   = LAST_DAY(ref_date);
    -- previous month
    SET prev_start = DATE_SUB(cur_start, INTERVAL 1 MONTH);
    SET prev_end   = DATE_SUB(cur_start, INTERVAL 1 DAY);

  ELSEIF period = 'week' THEN
    -- Make week start Monday (WEEKDAY: 0 = Monday)
    SET cur_start = DATE_SUB(ref_date, INTERVAL WEEKDAY(ref_date) DAY);
    SET cur_end   = DATE_ADD(cur_start, INTERVAL 6 DAY);
    -- previous week
    SET prev_start = DATE_SUB(cur_start, INTERVAL 7 DAY);
    SET prev_end   = DATE_SUB(cur_start, INTERVAL 1 DAY);

  ELSEIF period = 'year' THEN
    SET cur_start = MAKEDATE(YEAR(ref_date), 1);            -- yyyy-01-01
    SET cur_end   = MAKEDATE(YEAR(ref_date), 1) + INTERVAL 1 YEAR - INTERVAL 1 DAY; -- yyyy-12-31
    -- previous year
    SET prev_start = MAKEDATE(YEAR(ref_date) - 1, 1);
    SET prev_end   = MAKEDATE(YEAR(ref_date) - 1, 1) + INTERVAL 1 YEAR - INTERVAL 1 DAY;

  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid period. Use "week", "month" or "year".';
  END IF;

  -- Aggregate totals per branch for current and previous period, then compute growth
  SELECT
    b.Branch,
    COALESCE(c.current_total, 0.00)  AS Current_Total,
    COALESCE(p.previous_total,0.00)  AS Previous_Total,
    CASE
      WHEN COALESCE(p.previous_total,0) = 0 THEN NULL
      ELSE ROUND((c.current_total - p.previous_total) / p.previous_total * 100, 2)
    END AS Growth_Percentage
  FROM
    (SELECT DISTINCT Branch FROM banking_data) b
  LEFT JOIN
    (
      SELECT Branch, SUM(Amount) AS current_total
      FROM banking_data
      WHERE DATE(Transaction_Date) BETWEEN cur_start AND cur_end
      GROUP BY Branch
    ) c ON b.Branch = c.Branch
  LEFT JOIN
    (
      SELECT Branch, SUM(Amount) AS previous_total
      FROM banking_data
      WHERE DATE(Transaction_Date) BETWEEN prev_start AND prev_end
      GROUP BY Branch
    ) p ON b.Branch = p.Branch
  ORDER BY Growth_Percentage DESC;

END