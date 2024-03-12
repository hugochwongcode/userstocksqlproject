-- Companies with the highest revenue and earnings along with its respective industry
WITH CompanyFinancials AS (
    SELECT
        C.company_id,
        C.company_name,
        C.industry,
        COALESCE(SUM(E.revenue), 0) AS total_revenue,
        COALESCE(SUM(E.earnings_per_share), 0) AS total_earnings
    FROM Companies C
    LEFT JOIN Earnings E ON C.company_id = E.company_id
    GROUP BY
        C.company_id, C.company_name, C.industry
)

SELECT
    company_id,
    company_name,
    industry,
    total_revenue,
    total_earnings
FROM CompanyFinancials
WHERE
    (total_revenue, total_earnings) = (SELECT MAX(total_revenue), MAX(total_earnings)
     FROM CompanyFinancials);

-- Top 8 companies with the highest market capitalization in each industry
WITH RankedCompanies AS (
    SELECT company_id, company_name, industry, market_cap,
    DENSE_RANK() OVER (PARTITION BY industry ORDER BY market_cap DESC) 
    AS rank_within_industry
    FROM Companies
)
SELECT company_id, company_name, industry, market_cap
FROM RankedCompanies
WHERE rank_within_industry <= 8;

-- Identify top 5 gainers
SELECT S.symbol, SP.price_date,
    (SP.close_price - SP.open_price) / SP.open_price * 100 AS percentage_change
FROM Stocks S
JOIN StockPrices SP ON S.stock_id = SP.stock_id
ORDER BY percentage_change DESC
LIMIT 5; 

-- Identify top 4 losers  
SELECT S.symbol, SP.price_date,
    (SP.close_price - SP.open_price) / SP.open_price * 100 AS percentage_change
FROM Stocks S
JOIN StockPrices SP ON S.stock_id = SP.stock_id
ORDER BY percentage_change ASC 
LIMIT 4; 

--  Identify top 10 active users
SELECT U.username,
    COUNT(UT.user_transaction_id) AS transaction_count
FROM Users U
JOIN UserTransactions UT ON U.user_id = UT.user_id
GROUP BY U.username
ORDER BY transaction_count DESC
LIMIT 10

-- Average revenue growth rate for each industry
SELECT C.industry,
AVG((E.revenue - LAG(E.revenue) OVER (PARTITION BY E.company_id ORDER BY E.earnings_date)) / LAG(E.revenue) OVER (PARTITION BY E.company_id ORDER BY E.earnings_date) * 100) AS avg_growth_rate
FROM Companies C
JOIN Earnings E ON C.company_id = E.company_id
GROUP BY C.industry

-- Does the market data like earnings, revenue affect user transactions?
-- It shows whether user transactions are influenced by the financial performance of the companies involved. 
SELECT
    UT.user_id,
    UT.transaction_id,
    UT.transaction_type,
    UT.quantity,
    UT.price,
    UT.total_amount,
    C.company_id,
    C.company_name,
    C.industry,
    E.total_revenue AS highest_total_revenue
FROM UserTransactions UT
JOIN Transactions T ON UT.transaction_id = T.transaction_id
JOIN Stocks S ON T.stock_id = S.stock_id
JOIN Companies C ON S.company_id = C.company_id

