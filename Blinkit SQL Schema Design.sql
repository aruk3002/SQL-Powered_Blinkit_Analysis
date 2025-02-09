-- 1. Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    registration_date DATE
);

-- 2. Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10, 2),
    description TEXT
);

-- 3. Inventory Table
CREATE TABLE Inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES Products(product_id),
    stock_quantity INT,
    warehouse_location VARCHAR(100)
);

-- 4. Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20)
);

-- 5. Order_Items Table
CREATE TABLE Order_Items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT,
    price DECIMAL(10, 2)
);

-- 6. Payments Table
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    payment_method VARCHAR(20),
    payment_status VARCHAR(20),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Riders Table
CREATE TABLE Riders (
    rider_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    phone VARCHAR(15),
    assigned_area VARCHAR(100)
);

-- 8. Deliveries Table
CREATE TABLE Deliveries (
    delivery_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES Orders(order_id),
    rider_id INT REFERENCES Riders(rider_id),
    delivery_status VARCHAR(20),
    delivery_time TIMESTAMP
);
