-- Parent Table 1: customers (needed for foreign key)
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);

-- Parent Table 2: products (needed for foreign key)
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100)
);

-- Child Table: online_sales (The target table)
CREATE TABLE online_sales (
    order_id SERIAL PRIMARY KEY, 
    customer_id INT NOT NULL, 
    order_date DATE NOT NULL,
    product_id INT NOT NULL,
    quantity INT,
    unit_price DECIMAL(10, 2),
    -- Using 'total_price' for revenue calculation as per your schema
    total_price DECIMAL(10, 2),
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
); 
-- Insert sample customers and products
INSERT INTO customers (customer_name) VALUES ('Alice'), ('Bob'), ('Charlie');
INSERT INTO products (product_name) VALUES ('Laptop'), ('Mouse'), ('Keyboard');

-- Insert sample sales data across a few months for trend analysis
INSERT INTO online_sales (customer_id, order_date, product_id, total_price) VALUES
-- January 2024
(1, '2024-01-05', 1, 1200.00),
(2, '2024-01-15', 2, 25.00),
(1, '2024-01-20', 3, 75.00), -- Alice made 2 orders in January
-- February 2024
(3, '2024-02-01', 1, 1200.00),
(2, '2024-02-10', 3, 150.00),
-- March 2024 (Higher Volume and Revenue)
(1, '2024-03-01', 1, 1200.00),
(3, '2024-03-05', 2, 50.00),
(2, '2024-03-15', 3, 75.00),
(1, '2024-03-20', 1, 1200.00),
(3, '2024-03-25', 2, 25.00);
SELECT
    -- EXTRACT the year and month for grouping
    EXTRACT(YEAR FROM order_date) AS sales_year,
    EXTRACT(MONTH FROM order_date) AS sales_month,
    
    -- Calculate total revenue (SUM)
    SUM(total_price) AS total_monthly_revenue,
    
    -- Calculate order volume (COUNT DISTINCT order_id)
    COUNT(DISTINCT order_id) AS order_volume
FROM
    online_sales -- Use the correct table name
GROUP BY
    sales_year,
    sales_month -- GROUP BY both year and month for accurate trends
ORDER BY
    sales_year ASC,
    sales_month ASC;