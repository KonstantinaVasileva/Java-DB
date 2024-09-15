CREATE DATABASE restaurant_db;
USE restaurant_db;

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    price DECIMAL(10 , 2 ) NOT NULL
);

CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    card VARCHAR(50),
    review TEXT
);

CREATE TABLE tables (
    id INT PRIMARY KEY AUTO_INCREMENT,
    floor INT NOT NULL,
    reserved BOOL,
    capacity INT NOT NULL
);

CREATE TABLE waiters (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    phone VARCHAR(50),
    salary DECIMAL(10 , 2 )
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL,
    order_time TIME NOT NULL,
    payed_status BOOL,
    FOREIGN KEY (table_id)
        REFERENCES tables (id),
    FOREIGN KEY (waiter_id)
        REFERENCES waiters (id)
);

CREATE TABLE orders_clients (
    order_id INT,
    client_id INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE orders_products (
    order_id INT,
    product_id INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
);

INSERT INTO products(name, type, price)
SELECT concat(last_name, ' ', 'specialty'), ' Cocktail', ceiling(salary * 0.01)
FROM waiters
WHERE id > 6;

UPDATE orders 
SET 
    table_id = table_id - 1
WHERE
    id BETWEEN 12 AND 23;

DELETE FROM waiters w
WHERE id NOT IN(
SELECT waiter_id FROM orders
);

SELECT 
    *
FROM
    clients
ORDER BY birthdate DESC , id DESC;

SELECT 
    first_name, last_name, birthdate, review
FROM
    clients
WHERE
    card IS NULL
        AND YEAR(birthdate) BETWEEN 1978 AND 1993
ORDER BY last_name DESC , id
LIMIT 5;

SELECT 
    CONCAT(last_name,
            first_name,
            LENGTH(first_name),
            'Restaurant') AS username,
    REVERSE(SUBSTRING(email, 2, 12)) AS password
FROM
    waiters
WHERE
    salary IS NOT NULL
ORDER BY password DESC;

SELECT 
    id, name, COUNT(order_id) AS count
FROM
    products p
        JOIN
    orders_products op ON op.product_id = p.id
GROUP BY name
HAVING count >= 5
ORDER BY count DESC, name;

SELECT 
    o.table_id,
    t.capacity,
    COUNT(oc.client_id) AS count_clients,
    (CASE
        WHEN capacity - COUNT(o.id) > 0 THEN 'Free seats'
        WHEN capacity - COUNT(o.id) = 0 THEN 'Full'
        WHEN capacity - COUNT(o.id) < 0 THEN 'Extra seats'
    END) AS availability
FROM
    tables t
        JOIN
    orders o ON t.id = o.table_id
        JOIN
    orders_clients oc ON oc.order_id = o.id
WHERE
    t.floor = 1
GROUP BY t.id
ORDER BY t.id DESC;

DELIMITER $$
CREATE FUNCTION udf_client_bill(full_name VARCHAR(50)) 
RETURNS DECIMAL(19, 2)
DETERMINISTIC
BEGIN
	DECLARE bill DECIMAL(19, 2);
    SET bill :=(
    SELECT sum(price) FROM products p
    JOIN orders_products op ON p.id = op.product_id
    JOIN orders_clients oc ON op.order_id = oc.order_id
    JOIN clients c ON c.id = oc.client_id
    WHERE concat(first_name, ' ', last_name) = full_name
    );
    RETURN bill;
END$$

CREATE PROCEDURE udp_happy_hour(type VARCHAR(50))
BEGIN
	UPDATE products p
    SET price = price * 0.8
    WHERE p.type = type AND price >= 10;
END$$
