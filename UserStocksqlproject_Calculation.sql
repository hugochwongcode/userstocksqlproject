-- Total amount spent by each user on buying shares
SELECT user_id, SUM(quantity * price_per_share) AS total_spent
FROM Transactions
WHERE transaction_type = 'Buy'
GROUP BY user_id;

-- Total Stock Holdings for Each User
SELECT user_id, SUM(quantity) AS total_stock_holdings
FROM UserStocks
GROUP BY user_id;

-- Daily percentage change of each stock calculated 
SELECT
    stock_id,
    price_date,
    (close_price - open_price) / open_price * 100 AS daily_percentage_change
FROM StockPrices;

-- Total Revenue and Earnings per Share (EPS) Ratio Calculation 
SELECT
    E.company_id,
    SUM(E.revenue) AS total_revenue,
    AVG(E.earnings_per_share) AS avg_eps,
    SUM(E.revenue) / AVG(E.earnings_per_share) AS revenue_eps_ratio
FROM Earnings E
GROUP BY E.company_id;

-- Total value of each user's stock holdings by multiplying the quantity of stocks held by the current price of each stock
SELECT
    US.user_id,
    US.stock_id,
    US.quantity,
    S.current_price,
    US.quantity * S.current_price AS total_value
FROM UserStocks US
JOIN Stocks S ON US.stock_id = S.stock_id;

--  Return on Investment (ROI) Calculation using UserStocks and StockPrices tables
-- Creates a view named ‘UserStocksROI’ encapsulating the logic to calculate the Return on Investment (ROI) for each user's stock holdings. The NULLIF function is employed to handle potential division by zero
-- The second query retrieves all data from the newly created UserStocksROI view, allowing users to easily access and analyze the calculated ROI values for user-stock combinations
CREATE OR REPLACE VIEW UserStocksROI AS
SELECT
    US.user_id,
    US.stock_id,
    SUM(SP.close_price * US.quantity) AS total_investment,
    SUM(SP.open_price * US.quantity) AS total_initial_investment,
    100 * (SUM(SP.close_price * US.quantity) - SUM(SP.open_price * US.quantity)) / NULLIF(SUM(SP.open_price * US.quantity), 0) AS roi_percentage
FROM UserStocks US
JOIN StockPrices SP ON US.stock_id = SP.stock_id
GROUP BY US.user_id, US.stock_id;

SELECT * FROM UserStocksROI;
