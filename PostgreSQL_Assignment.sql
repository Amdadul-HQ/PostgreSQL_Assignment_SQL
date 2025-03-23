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

-- Create a customers Table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each customer
    name TEXT NOT NULL,  -- Customer's full name (required)
    email TEXT UNIQUE NOT NULL,  -- Email address (must be unique)
    joined_date DATE DEFAULT CURRENT_DATE NOT NULL  -- Date of registration (defaults to the current date)
);

-- Create an orders Table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,  -- Unique identifier for each order
    customer_id INT REFERENCES customers(id) ON DELETE CASCADE,  -- Foreign key referencing the customers table 
    book_id INT REFERENCES books(id) ON DELETE CASCADE,  -- Foreign key referencing the books table
    quantity INT CHECK (quantity > 0) NOT NULL,  -- Ensures quantity is greater than zero
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL  -- Defaults to the current timestamp
);
