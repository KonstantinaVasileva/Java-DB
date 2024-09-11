CREATE TABLE students (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    age INT,
    phone_number VARCHAR(20) UNIQUE
);

CREATE TABLE instructors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(40) NOT NULL,
    last_name VARCHAR(40) NOT NULL UNIQUE,
    has_a_license_from DATE NOT NULL
);

CREATE TABLE instructors_students (
    instructor_id INT NOT NULL,
    student_id INT NOT NULL,
    CONSTRAINT fk_is_i FOREIGN KEY (instructor_id)
        REFERENCES instructors (id),
    CONSTRAINT fk_is_s FOREIGN KEY (student_id)
        REFERENCES students (id)
);

CREATE TABLE cars (
    id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(20) NOT NULL,
    model VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE cities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE driving_schools (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL UNIQUE,
    night_time_driving BOOLEAN NOT NULL,
    average_lesson_price DECIMAL(10 , 2 ),
    car_id INT NOT NULL,
    city_id INT NOT NULL,
    CONSTRAINT fk_ds_cars FOREIGN KEY (car_id)
        REFERENCES cars (id),
    CONSTRAINT fk_ds_cities FOREIGN KEY (city_id)
        REFERENCES cities (id)
);

CREATE TABLE instructors_driving_schools (
    instructor_id INT,
    driving_school_id INT NOT NULL,
    CONSTRAINT fk_ids_i FOREIGN KEY (instructor_id)
        REFERENCES instructors (id),
    CONSTRAINT fk_ids_ds FOREIGN KEY (driving_school_id)
        REFERENCES driving_schools (id)
);

INSERT INTO students (first_name, last_name, age, phone_number)
SELECT reverse(lower(first_name)), 
REVERSE(lower(last_name)), 
CONCAT(age + LEFT(phone_number, 1)),
CONCAT('1+', phone_number) FROM students
WHERE age < 20;

UPDATE driving_schools 
SET 
    average_lesson_price = average_lesson_price + 30
WHERE
    city_id = 5 AND night_time_driving = 1;

DELETE FROM driving_schools 
WHERE
    night_time_driving = 0;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, age
FROM
    students
WHERE
    first_name LIKE ('%a%')
        AND age = (SELECT 
            MIN(age)
        FROM
            students)
ORDER BY id;

SELECT 
    ds.id, ds.name, c.brand
FROM
    driving_schools ds
        JOIN
    cars c ON c.id = ds.car_id
        LEFT JOIN
    instructors_driving_schools ids ON ds.id = ids.driving_school_id
WHERE
    instructor_id IS NULL
ORDER BY brand
LIMIT 5;

SELECT 
    i.first_name,
    i.last_name,
    COUNT(ist.student_id) AS student_count,
    c.name
FROM
    instructors i
        JOIN
    instructors_students ist ON ist.instructor_id = i.id
        JOIN
    instructors_driving_schools ids ON i.id = ids.instructor_id
        JOIN
    driving_schools ds ON ds.id = ids.driving_school_id
        JOIN
    cities c ON c.id = ds.city_id
GROUP BY i.id , c.name
HAVING student_count > 1
ORDER BY student_count DESC , first_name;

SELECT 
    c.name, COUNT(ids.instructor_id) AS instructors_count
FROM
    cities c
        JOIN
    driving_schools ds ON c.id = ds.city_id
        JOIN
    instructors_driving_schools ids ON ids.driving_school_id = ds.id
GROUP BY c.id
ORDER BY instructors_count DESC , c.name;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    CASE
        WHEN
            YEAR(has_a_license_from) >= 1980
                AND YEAR(has_a_license_from) < 1990
        THEN
            'Specialist'
        WHEN
            YEAR(has_a_license_from) >= 1990
                AND YEAR(has_a_license_from) < 2000
        THEN
            'Advanced'
        WHEN
            YEAR(has_a_license_from) >= 2000
                AND YEAR(has_a_license_from) < 2008
        THEN
            'Experienced'
        WHEN
            YEAR(has_a_license_from) >= 2008
                AND YEAR(has_a_license_from) < 2015
        THEN
            'Qualified'
        WHEN
            YEAR(has_a_license_from) >= 2015
                AND YEAR(has_a_license_from) < 2020
        THEN
            'Provisional'
        WHEN YEAR(has_a_license_from) >= 2020 THEN 'Trainee'
    END AS level
FROM
    instructors
ORDER BY YEAR(has_a_license_from) , first_name;

DELIMITER %%
CREATE FUNCTION udf_average_lesson_price_by_city (name VARCHAR(40))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
DECLARE average_lesson_price DECIMAL(10, 2);
SET average_lesson_price :=
	(SELECT AVG(ds.average_lesson_price) FROM cities c
    JOIN driving_schools ds ON c.id = ds.city_id
    WHERE c.name = name);
    RETURN average_lesson_price;
END%%

CREATE PROCEDURE udp_find_school_by_car(brand VARCHAR(20))
BEGIN
	SELECT name, average_lesson_price FROM driving_schools ds
    JOIN cars c ON ds.car_id = c.id
    WHERE c.brand = brand
    ORDER BY average_lesson_price DESC;
END%%



 