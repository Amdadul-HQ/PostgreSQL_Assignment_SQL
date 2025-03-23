-- Active: 1742555082889@@127.0.0.1@5432@bookstre_db
-- Create A books Table 
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

SELECT * FROM books;

-- Create a customers Table
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

-- Create an orders Table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each order
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,  -- Foreign key referencing the customers table 
    book_id INT REFERENCES books(id) ON DELETE CASCADE,  -- Foreign key referencing the books table
    quantity INT CHECK (quantity > 0) NOT NULL,  -- Ensures quantity is greater than zero
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL  -- Defaults to the current timestamp
);

-- Insert Order 
INSERT INTO orders (customer_id, book_id, quantity, order_date)
VALUES
(1, 2, 1, '2024-03-10'),
(2, 1, 1, '2024-02-20'),
(1, 3, 2, '2024-03-05');
