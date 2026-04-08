-- USERS
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    status VARCHAR(20)
);

-- DEPARTMENTS
CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- EMPLOYEES
CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary INT,
    department_id INT,
    hire_date DATE
);

-- ORDERS
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    amount INT,
    created_at DATE
);

-- ORDER ITEMS
CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price_per_unit INT
);

-- PRODUCTS
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50)
);
