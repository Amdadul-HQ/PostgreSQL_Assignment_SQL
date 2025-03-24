-- ==============================
--  CREATE TABLES
-- ==============================

-- Create a "books" table to store book details
CREATE TABLE books (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each book
    title TEXT NOT NULL,  -- Book name (required)
    author TEXT NOT NULL, -- Author name (required)
    price NUMERIC(10,2) CHECK (price >= 0) NOT NULL,  -- Ensures price is non-negative
    stock INT CHECK (stock >= 0) NOT NULL,  -- Ensures stock is non-negative
    published_year SMALLINT CHECK (published_year >= 1000 AND published_year <= EXTRACT(YEAR FROM CURRENT_DATE)) NOT NULL
);

-- Insert books data
INSERT INTO books (title, author, price, stock, published_year) 
VALUES
    ('The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
    ('Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
    ('You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
    ('Refactoring', 'Martin Fowler', 50.00, 3, 1999),
    ('Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- View all books
SELECT * FROM books;


-- Create a "customers" table to store customer details
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each customer
    name TEXT NOT NULL,  -- Customer's full name (required)
    email TEXT UNIQUE NOT NULL,  -- Email address (must be unique)
    joined_date DATE DEFAULT CURRENT_DATE NOT NULL  -- Date of registration (defaults to the current date)
);

-- Insert customers data
INSERT INTO customers (name, email, joined_date)
VALUES
    ('Alice', 'alice@email.com', '2023-01-10'),
    ('Bob', 'bob@email.com', '2022-05-15'),
    ('Charlie', 'charlie@email.com', '2023-06-20');

-- View all customers
SELECT * FROM customers;


-- Create an "orders" table to store book orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each order
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,  -- Foreign key referencing customers table
    book_id INT REFERENCES books(id) ON DELETE CASCADE,  -- Foreign key referencing books table
    quantity INT CHECK (quantity > 0) NOT NULL,  -- Ensures quantity is greater than zero
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL  -- Defaults to the current timestamp
);

-- Insert order data
INSERT INTO orders (customer_id, book_id, quantity, order_date)
VALUES
    (1, 2, 1, '2024-03-10'),
    (2, 1, 1, '2024-02-20'),
    (1, 3, 2, '2024-03-05');

-- View all orders
SELECT * FROM orders;


-- ==============================
--   QUERIES & DATA ANALYSIS
-- ==============================

--  Find books that are out of stock
SELECT title FROM books 
WHERE books.stock = 0;

--  Retrieve the most expensive book in the store
SELECT * FROM books 
ORDER BY price DESC 
LIMIT 1;

--  Find the total number of orders placed by each customer
SELECT 
    customers.name, 
    COUNT(orders.id) AS total_orders 
FROM orders 
JOIN customers ON customers.id = orders.customer_id 
GROUP BY customers.name;

--  Calculate the total revenue generated from book sales
SELECT SUM(books.price * orders.quantity) AS total_revenue 
FROM orders 
JOIN books ON books.id = orders.book_id;

--  List all customers who have placed more than one order
SELECT 
    customers.name, 
    COUNT(*) AS orders_count 
FROM customers 
JOIN orders ON orders.customer_id = customers.id 
GROUP BY customers.id 
HAVING COUNT(*) > 1;

--  Find the average price of books in the store
SELECT ROUND(AVG(price), 2) AS avg_book_price 
FROM books;

--  Increase the price of all books published before the year 2000 by 10%
UPDATE books 
SET price = ROUND(price * 1.10, 2)
WHERE published_year < 2000;

--  Delete customers who haven't placed any orders
DELETE FROM customers
WHERE NOT EXISTS (
    SELECT 1 FROM orders WHERE orders.customer_id = customers.id
);
