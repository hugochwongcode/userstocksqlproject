--  Retrieving Transactions for a Specific User 
SELECT * FROM Transactions
WHERE user_id = 1;

--  Identify top 5 dates with the Highest Trading Volume
SELECT price_date, MAX(volume) AS max_volume
FROM StockPrices
GROUP BY price_date
ORDER BY max_volume DESC
LIMIT 5;

--  Retrieving Earnings for a Specific Company
SELECT company_id, earnings_date, revenue, earnings_per_share
FROM Earnings
WHERE company_id = 1
ORDER BY earnings_date;

--   Finding Companies with High Earnings per Share
SELECT company_id, MAX(earnings_per_share) AS max_eps
FROM Earnings
GROUP BY company_id
ORDER BY max_eps DESC
LIMIT 5;

--  Retrieve User Information by User’s name 
SELECT user_id, email, registration_date
FROM Users
WHERE username = ' ';

--  Check for duplicate email for Users
SELECT email, COUNT(*)
FROM Users
GROUP BY email
HAVING COUNT(*) > 1;

--  Count the Number of Registered Users
SELECT COUNT(*) AS total_users
FROM Users;

--  Identify the companies followed by a specific user
SELECT Companies.*
FROM Companies
JOIN UserCompanies ON Companies.company_id = UserCompanies.company_id
WHERE UserCompanies.user_id = 1;

--  Identify users following a specific company
SELECT Users.*
FROM Users
JOIN UserCompanies ON Users.user_id = UserCompanies.user_id
WHERE UserCompanies.company_id = 1;

--  Identify the Users Holding a Specific Stock and their total holding for that stock
SELECT user_id, SUM(quantity) AS total_stock_holdings
FROM UserStocks
WHERE stock_id = 1
GROUP BY user_id;

--  Identify Users with Large Stock Holdings (over 50)
SELECT user_id, SUM(quantity) AS total_stock_holdings
FROM UserStocks
GROUP BY user_id
HAVING SUM(quantity) > 50;

--  Identify  Earnings Information for a Specific Stock including earnings date and reported EPS 
SELECT s.stock_id, e.earnings_date, s.reported_eps
FROM StockEarnings s
JOIN Earnings e ON s.earnings_id = e.earnings_id
WHERE s.stock_id = 1;

--  Identify the maximum reported EPS value for top 5 unique stocks
SELECT s.stock_id, e.earnings_date, s.reported_eps
FROM StockEarnings s
JOIN Earnings e ON s.earnings_id = e.earnings_id
WHERE s.stock_id = 1;

-- Identify users and their corresponding transactions
SELECT
    U.user_id,
    U.username,
    UT.transaction_id,
    UT.transaction_type,
    UT.quantity,
    UT.price,
    UT.total_amount
FROM Users U
LEFT JOIN UserTransactions UT ON U.user_id = UT.user_id;

-- Identify stocks and their corresponding stock prices 
SELECT
    S.stock_id,
    S.symbol,
    SP.price_id,
    SP.price_date,
    SP.open_price,
    SP.close_price,
    SP.high_price,
    SP.low_price
FROM Stocks S
RIGHT JOIN StockPrices SP ON S.stock_id = SP.stock_id;
