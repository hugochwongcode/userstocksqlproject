--  Companies Table
CREATE TABLE Companies (
    company_id INT PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    headquarters_location VARCHAR(255),
    founded_date DATE,
    website_url VARCHAR(255)
);

-- Stocks Table
CREATE TABLE Stocks (
    stock_id INT PRIMARY KEY,
    company_id INT,
    symbol VARCHAR(10) NOT NULL,
    stock_name VARCHAR(100),
    stock_type VARCHAR(50),
    market_cap DECIMAL(20, 2),
    current_price DECIMAL(10, 2),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

-- Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY,
    stock_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    quantity INT,
    price DECIMAL(10, 2),
    total_amount DECIMAL(15, 2),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

-- StockPrices Table
CREATE TABLE StockPrices (
    price_id INT PRIMARY KEY,
    stock_id INT,
    price_date DATE,
    open_price DECIMAL(10, 2),
    close_price DECIMAL(10, 2),
    high_price DECIMAL(10, 2),
    low_price DECIMAL(10, 2),
    volume INT,
    adjusted_close DECIMAL(10, 2),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

-- Earnings Table
CREATE TABLE Earnings (
    earnings_id INT PRIMARY KEY,
    company_id INT,
    earnings_date DATE,
    revenue DECIMAL(20, 2),
    earnings_per_share DECIMAL(10, 2),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

-- Users Table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    registration_date DATE
);

-- UserTransactions Table
CREATE TABLE UserTransactions (
    user_transaction_id INT PRIMARY KEY,
    user_id INT,
    transaction_id INT,
    transaction_type VARCHAR(20),
    transaction_date DATE,
    quantity INT,
    price DECIMAL(10, 2),
    total_amount DECIMAL(15, 2),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)
);

-- UserStocks Table 
CREATE TABLE UserStocks (
    user_stock_id INT PRIMARY KEY,
    user_id INT,
    stock_id INT,
    purchase_date DATE,
    quantity INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id)
);

-- UserCompanies Table 
CREATE TABLE UserCompanies (
    user_company_id INT PRIMARY KEY,
    user_id INT,
    company_id INT,
    following_since DATE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (company_id) REFERENCES Companies(company_id)
);

-- StockEarnings Table 
CREATE TABLE StockEarnings (
    stock_earnings_id INT PRIMARY KEY,
    stock_id INT,
    earnings_id INT,
    reported_eps DECIMAL(10, 2),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_id),
    FOREIGN KEY (earnings_id) REFERENCES Earnings(earnings_id)
);
