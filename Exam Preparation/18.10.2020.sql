CREATE DATABASE SoftUni_Stores_System;
USE SoftUni_Stores_System;

CREATE TABLE pictures (
    id INT PRIMARY KEY AUTO_INCREMENT,
    url VARCHAR(100) NOT NULL,
    added_on DATETIME NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    best_before DATE,
    price DECIMAL(10 , 2 ) NOT NULL,
    description TEXT,
    category_id INT NOT NULL,
    picture_id INT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES categories (id),
    FOREIGN KEY (picture_id)
        REFERENCES pictures (id)
);

CREATE TABLE towns (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    town_id INT NOT NULL,
    FOREIGN KEY (town_id)
        REFERENCES towns (id)
);

CREATE TABLE stores (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL UNIQUE,
    rating FLOAT NOT NULL,
    has_parking BOOLEAN DEFAULT 0,
    address_id INT NOT NULL,
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);

CREATE TABLE products_stores (
    product_id INT NOT NULL,
    store_id INT NOT NULL,
    PRIMARY KEY (store_id , product_id),
    FOREIGN KEY (product_id)
        REFERENCES products (id),
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(15) NOT NULL,
    middle_name CHAR(1),
    last_name VARCHAR(20) NOT NULL,
    salary DECIMAL(19 , 2 ) DEFAULT 0,
    hire_date DATE NOT NULL,
    manager_id INT,
    store_id INT NOT NULL,
    FOREIGN KEY (manager_id)
        REFERENCES employees (id),
    FOREIGN KEY (store_id)
        REFERENCES stores (id)
);

INSERT INTO products_stores
SELECT id, 1 FROM products
WHERE id NOT IN (
SELECT product_id FROM products_stores
);

UPDATE employees 
SET 
    manager_id = 3,
    salary = salary - 500
WHERE
    YEAR(hire_date) >= 2003
        AND store_id NOT IN (5 , 14);
        
DELETE FROM employees 
WHERE
    salary >= 6000 AND id <> manager_id;
    
SELECT 
    first_name, middle_name, last_name, salary, hire_date
FROM
    employees
ORDER BY hire_date DESC;

SELECT 
    name,
    price,
    best_before,
    CONCAT(LEFT(description, 10), '...') AS short_description,
    url
FROM
    products p
        JOIN
    pictures p2 ON p.picture_id = p2.id
WHERE
    LENGTH(description) > 100
        AND YEAR(added_on) < 2019
        AND price > 20
ORDER BY price DESC;

SELECT 
    s.name,
    COUNT(p.id) AS product_count,
    ROUND(AVG(price), 2) AS avg
FROM
    stores s
        LEFT JOIN
    products_stores ps ON ps.store_id = s.id
        LEFT JOIN
    products p ON p.id = ps.product_id
GROUP BY s.id
ORDER BY product_count DESC , avg DESC , s.id;

SELECT 
    CONCAT(first_name, ' ', last_name) AS Full_name,
    s.name,
    a.name AS Address,
    salary AS Salary
FROM
    employees e
        JOIN
    stores s ON e.store_id = s.id
        JOIN
    addresses a ON s.address_id = a.id
WHERE
    salary < 4000 AND a.name LIKE '%5%'
        AND LENGTH(s.name) > 8
        AND last_name LIKE '%n';
        
SELECT 
    REVERSE(s.name) AS reversed_name,
    CONCAT(UPPER(t.name), '-', a.name) AS full_address,
    COUNT(e.id) AS employees_count
FROM
    stores s
        JOIN
    addresses a ON a.id = s.address_id
        JOIN
    employees e ON s.id = e.store_id
        JOIN
    towns t ON t.id = a.town_id
GROUP BY store_id
HAVING employees_count >= 1
ORDER BY full_address;

DELIMITER $$
CREATE FUNCTION udf_top_paid_employee_by_store(store_name VARCHAR(50)) 
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
 DECLARE full_info VARCHAR(255);
	SET full_info:=(
    SELECT concat(first_name, ' ', middle_name, '.',' ', last_name, ' works in store for ', 2020 - year(hire_date), ' years')
    FROM employees e
    JOIN stores s ON s.id = e.store_id
    WHERE s.name = store_name AND salary = (SELECT max(salary) FROM employees e2
    JOIN stores s2 ON s2.id = e2.store_id
    WHERE s2.name = store_name
    ));
 RETURN full_info;
 END$$
 
 CREATE PROCEDURE udp_update_product_price (address_name VARCHAR (50))
 BEGIN
	UPDATE products p
    JOIN products_stores ps ON ps.product_id = p.id
    JOIN stores s ON s.id = ps.store_id
    JOIN addresses a ON a.id = s.address_id
    SET price = price + if(left(address_name, 1) = '0', 100, 200)
    WHERE address_name = address_name;
 END$$

