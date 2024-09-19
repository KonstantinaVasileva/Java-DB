CREATE DATABASE SoftUni_Taxi_Company;
USE SoftUni_Taxi_Company;

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

CREATE TABLE drivers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    rating FLOAT DEFAULT 5.5
);

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(20) NOT NULL,
    model VARCHAR(20),
    year INT NOT NULL DEFAULT 0,
    mileage INT DEFAULT 0,
    `condition` CHAR(1) NOT NULL,
    category_id INT NOT NULL,
    FOREIGN KEY (category_id)
        REFERENCES categories (id)
);

CREATE TABLE courses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    from_address_id INT NOT NULL,
    start DATETIME NOT NULL,
    bill DECIMAL(10 , 2 ) DEFAULT 10,
    car_id INT NOT NULL,
    client_id INT NOT NULL,
    FOREIGN KEY (from_address_id)
        REFERENCES addresses (id),
    FOREIGN KEY (car_id)
        REFERENCES cars (id),
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE cars_drivers (
    car_id INT NOT NULL,
    driver_id INT NOT NULL,
    PRIMARY KEY (car_id , driver_id),
    FOREIGN KEY (car_id)
        REFERENCES cars (id),
    FOREIGN KEY (driver_id)
        REFERENCES drivers (id)
);

INSERT INTO clients (full_name, phone_number)
SELECT concat(first_name, ' ', last_name), concat('(088) 9999', id * 2)
FROM drivers
WHERE id BETWEEN 10 and 20;

UPDATE cars 
SET 
    `condition` = 'C'
WHERE
    (mileage >= 800000 OR mileage IS NULL)
        AND year <= 2010
        AND make NOT LIKE '%Mercedes-Benz%';

DELETE FROM clients 
WHERE
    LENGTH(full_name) > 3
    AND id NOT IN (SELECT 
        client_id
    FROM
        courses);

  SELECT make, model, `condition` FROM cars;
  
 SELECT 
    first_name, last_name, make, model, mileage
FROM
    drivers d
        JOIN
    cars_drivers cd ON cd.driver_id = d.id
        JOIN
    cars c ON c.id = cd.car_id
WHERE
    mileage IS NOT NULL
ORDER BY mileage DESC , first_name;

SELECT 
    (c.id) AS car_id,
    c.make,
    c.mileage,
    COUNT(cr.start) AS count_of_courses,
    ROUND(AVG(bill), 2) AS avg_bill
FROM
    cars c
        LEFT JOIN
    courses cr ON cr.car_id = c.id
GROUP BY c.id
HAVING count_of_courses <> 2
ORDER BY count_of_courses DESC , c.id;

SELECT 
    full_name,
    COUNT(car_id) AS count_of_cars,
    SUM(bill) AS total_sum
FROM
    clients c
        JOIN
    courses cr ON cr.client_id = c.id
GROUP BY client_id
HAVING count_of_cars > 1
    AND full_name LIKE '_a%'
ORDER BY full_name;

SELECT 
    a.name,
    IF(HOUR(c.start) BETWEEN 6 AND 20,
        'Day',
        'Night') AS day_time,
    c.bill,
    cl.full_name,
    make,
    model,
    ctg.name AS category_name
FROM
    addresses a
        JOIN
    courses c ON c.from_address_id = a.id
        JOIN
    clients cl ON cl.id = c.client_id
        JOIN
    cars ON cars.id = c.car_id
        JOIN
    categories ctg ON ctg.id = cars.category_id
ORDER BY c.id;

DELIMITER $$
CREATE FUNCTION udf_courses_by_client (phone_num VARCHAR (20)) 
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE count_courses INT;
	SET count_courses:=(
    SELECT count(c.id) FROM courses c
    JOIN clients cl ON c.client_id = cl.id
    WHERE cl.phone_number = phone_num
    GROUP BY cl.id
    );
RETURN count_courses;
END$$

Create procedure udp_courses_by_address (address_name VARCHAR (100))
BEGIN
	SELECT a.name, cl.full_name, (
    CASE
    WHEN bill <= 20 THEN 'Low'
    WHEN bill <= 30 THEN 'Medium'
    ELSE 'High'
    END
    ) AS level_of_bill, make, c.`condition`, c2.name AS cat_name
    FROM addresses a
    JOIN courses c3 ON c3.from_address_id = a.id
    JOIN clients cl ON cl.id = c3.client_id
    JOIN cars c ON c.id = c3.car_id
    JOIN categories c2 ON c2.id = c.category_id
    WHERE address_name = a.name
    ORDER BY make, cl.full_name;
END$$
