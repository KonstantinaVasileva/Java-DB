CREATE DATABASE online_stores’s ;
USE online_stores’s ;

CREATE TABLE brands (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    content TEXT,
    rating DECIMAL(10 , 2) NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    published_at DATETIME NOT NULL
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    price DECIMAL(19 , 2) NOT NULL,
    quantity_in_stock INT,
    description TEXT,
    brand_id INT NOT NULL,
    category_id INT NOT NULL,
    review_id INT,
    FOREIGN KEY (brand_id)
        REFERENCES brands (id),
    FOREIGN KEY (category_id)
        REFERENCES categories (id),
    FOREIGN KEY (review_id)
        REFERENCES reviews (id)
);

CREATE TABLE customers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20) NOT NULL,
    phone VARCHAR(30) NOT NULL UNIQUE,
    address VARCHAR(60) NOT NULL,
    discount_card BIT(1) NOT NULL DEFAULT 0
);

CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_datetime DATETIME NOT NULL,
    customer_id INT NOT NULL,
    FOREIGN KEY (customer_id)
        REFERENCES customers (id)
);

CREATE TABLE orders_products (
    order_id INT,
    product_id INT,
    FOREIGN KEY (order_id)
        REFERENCES orders (id),
    FOREIGN KEY (product_id)
        REFERENCES products (id)
);

INSERT INTO reviews (content, picture_url, published_at, rating)
SELECT substring(description, 1, 15), reverse(name), '2010-10-10', price / 8
FROM products
WHERE id >= 5;

UPDATE products 
SET 
    quantity_in_stock = quantity_in_stock - 5
WHERE
    quantity_in_stock BETWEEN 60 AND 70;

DELETE FROM customers c
WHERE id NOT IN(
SELECT customer_id FROM orders
);

SELECT 
    *
FROM
    categories
ORDER BY name DESC;

SELECT 
    id, brand_id, name, quantity_in_stock
FROM
    products
WHERE
    price > 1000 AND quantity_in_stock < 30
ORDER BY quantity_in_stock , id;

SELECT 
    *
FROM
    reviews
WHERE
    content LIKE 'My%'
        AND LENGTH(content) > 61
ORDER BY rating DESC;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    address,
    order_datetime
FROM
    customers c
        JOIN
    orders o ON c.id = o.customer_id
WHERE
    YEAR(order_datetime) <= 2018
ORDER BY full_name DESC;

SELECT 
    COUNT(p.id) AS items_count,
    c.name,
    SUM(quantity_in_stock) AS total_quantity
FROM
    categories c
        JOIN
    products p ON p.category_id = c.id
GROUP BY category_id
ORDER BY items_count DESC , total_quantity
LIMIT 5;

DELIMITER $$
CREATE FUNCTION udf_customer_products_count(name VARCHAR(30))
RETURNS INT
DETERMINISTIC
BEGIN 
	DECLARE total_products INT;
    SET total_products := (
    SELECT count(p.id) FROM products p
    JOIN orders_products op ON op.product_id = p.id
    JOIN orders o ON op.order_id = o.id
    JOIN customers c ON c.id = o.customer_id
    WHERE first_name = name
    );
RETURN total_products ;
END$$

CREATE PROCEDURE udp_reduce_price (category_name VARCHAR(50))
BEGIN
	UPDATE products p
	JOIN reviews r ON r.id = p.review_id
    JOIN categories c ON c.id = p.category_id
    SET price = price * 0.70
    WHERE rating <= 4 AND category_name = c.name;
END$$



