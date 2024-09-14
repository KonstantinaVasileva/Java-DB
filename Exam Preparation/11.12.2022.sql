CREATE DATABASE airlines_db;
USE airlines_db;

CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    description TEXT,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE airplanes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    model VARCHAR(50) NOT NULL UNIQUE,
    passengers_capacity INT NOT NULL,
    tank_capacity DECIMAL(19 , 2 ) NOT NULL,
    cost DECIMAL(19 , 2 ) NOT NULL
);

CREATE TABLE passengers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE flights (
    id INT PRIMARY KEY AUTO_INCREMENT,
    flight_code VARCHAR(30) NOT NULL UNIQUE,
    departure_country INT NOT NULL,
    destination_country INT NOT NULL,
    airplane_id INT NOT NULL,
    has_delay BOOLEAN,
    departure DATETIME,
    FOREIGN KEY (departure_country)
        REFERENCES countries (id),
    FOREIGN KEY (destination_country)
        REFERENCES countries (id),
    FOREIGN KEY (airplane_id)
        REFERENCES airplanes (id)
);

CREATE TABLE flights_passengers (
    flight_id INT,
    passenger_id INT,
    FOREIGN KEY (flight_id)
        REFERENCES flights (id),
    FOREIGN KEY (passenger_id)
        REFERENCES passengers (id)
);

INSERT INTO airplanes (model, passengers_capacity , tank_capacity , cost)
SELECT concat(reverse(first_name), '797'), (length(last_name) * 17), id * 790, length(first_name) * 50.6 FROM passengers 
WHERE id <= 5;

UPDATE flights 
SET 
    airplane_id = airplane_id + 1
WHERE
    departure_country = 22;
    
   DELETE f FROM flights f
        LEFT JOIN
    flights_passengers fp ON f.id = fp.flight_id 
WHERE
    fp.passenger_id IS NULL;
    
    SELECT 
    *
FROM
    airplanes
ORDER BY cost DESC , id DESC;
    
  SELECT 
    flight_code, departure_country, airplane_id, departure
FROM
    flights
WHERE
    YEAR(departure) = 2022
ORDER BY airplane_id , flight_code
LIMIT 20;
    
SELECT 
    CONCAT(UPPER(LEFT(p.last_name, 2)),
            p.country_id) AS flight_code,
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    country_id
FROM
    passengers p
        LEFT JOIN
    flights_passengers fp ON p.id = fp.passenger_id
WHERE
    fp.flight_id IS NULL
ORDER BY country_id;

SELECT 
    name, currency, COUNT(*) AS booked_tickets
FROM
    flights_passengers fp
        JOIN
    flights f ON fp.flight_id = f.id
        JOIN
    countries c ON c.id = f.destination_country
GROUP BY destination_country
HAVING booked_tickets >= 20
ORDER BY booked_tickets DESC;

SELECT 
    flight_code,
    departure,
    (CASE
        WHEN HOUR(departure) BETWEEN '5:00' AND '11:59' THEN 'Morning'
        WHEN HOUR(departure) BETWEEN '12:00' AND '16:59' THEN 'Afternoon'
        WHEN HOUR(departure) BETWEEN '17:00' AND '20:59' THEN 'Evening'
        ELSE 'Night'
    END) AS day_part
FROM
    flights
ORDER BY flight_code DESC;

DELIMITER $$
CREATE FUNCTION udf_count_flights_from_country(country VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE flights_count INT;
	SET flights_count :=(
    SELECT count(departure_country) FROM flights f
    JOIN countries c ON c.id = f.departure_country
    WHERE c.name = country
    );
RETURN flights_count;
END$$

CREATE PROCEDURE udp_delay_flight (code VARCHAR(50))
BEGIN
	UPDATE flights
    SET has_delay = 1,
    departure = DATE_ADD(departure, INTERVAL 30 minute)
    WHERE flight_code = code;
END$$
    
    

