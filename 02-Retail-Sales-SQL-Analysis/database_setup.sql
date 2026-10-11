DROP TABLE IF EXISTS order_items; DROP TABLE IF EXISTS orders; DROP TABLE IF EXISTS products; DROP TABLE IF EXISTS customers;
CREATE TABLE customers (customer_id INTEGER PRIMARY KEY, customer_name VARCHAR(100), state CHAR(2), signup_date DATE);
CREATE TABLE products (product_id INTEGER PRIMARY KEY, product_name VARCHAR(100), category VARCHAR(50), price NUMERIC(10,2), cost NUMERIC(10,2));
CREATE TABLE orders (order_id INTEGER PRIMARY KEY, customer_id INTEGER REFERENCES customers(customer_id), order_date DATE);
CREATE TABLE order_items (order_id INTEGER REFERENCES orders(order_id), product_id INTEGER REFERENCES products(product_id), quantity INTEGER CHECK(quantity>0), PRIMARY KEY(order_id,product_id));