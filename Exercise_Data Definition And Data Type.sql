CREATE SCHEMA minions;

CREATE TABLE minions (
    id INT,
    name VARCHAR(50),
    age INT
);

CREATE TABLE towns (
    town_id INT,
    name VARCHAR(50)
);

ALTER TABLE minions
ADD CONSTRAINT
PRIMARY KEY (id);

ALTER TABLE towns
ADD CONSTRAINT
PRIMARY KEY (town_id);

ALTER TABLE towns
CHANGE COLUMN town_id id INT NOT NULL;

ALTER TABLE minions
ADD COLUMN town_id INT NOT NULL;

ALTER TABLE minions
ADD CONSTRAINT my_fk
FOREIGN KEY (town_id)
REFERENCES towns (id);

INSERT INTO towns
VALUES (1, "Sofia"),
(2, "Plovdiv"),
(3, "Varna");

INSERT INTO minions
VALUES (1, "Kevin", 22, 1),
(2, "Bob", 15, 3),
(3, "Steward", NULL, 2);

TRUNCATE TABLE minions;

DROP SCHEMA minions;

DROP TABLE minions;
DROP TABLE towns;

CREATE TABLE people (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(200) NOT NULL,
    picture BLOB,
    height DOUBLE(6 , 2 ),
    weight DOUBLE(6 , 2 ),
    gender CHAR(1) NOT NULL,
    birthdate DATE NOT NULL,
    biography BLOB
);

INSERT INTO people 
VALUES (1, "Petyr", 'test', 1.62, 65.85, "m", "1987-06-24", "test"),
 (2, "Ivan", 'test', 1.79, 90.65, "m", "1987-05-11", "test"),
 (3, "Maria", 'test', 1.62, 51.24, "f", "1990-12-24", "test"),
 (4, "Hristo", 'test', 1.72, 80.25, "m", "1995-06-01", "test"),
 (5, "Maq", 'test', 1.50, 45.00, "f", "1993-06-30", "test");

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(30) UNIQUE NOT NULL,
    password VARCHAR(26) NOT NULL,
    profile_picture BLOB,
    last_login_time DATE,
    is_deleted BOOLEAN
);

INSERT INTO users
VALUES (1, "Petyr", "123", "pic", "2024-06-15", false),
 (2, "Ivan", "456", "pic1", "2024-06-13", false),
 (3, "Matia", "789", "pic2", "2024-06-14", false),
 (4, "Hristo", "741", "pic3", "2024-06-12", false),
 (5, "Maq", "852", "pic4", "2024-06-11", false);

ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY (id, username);

UPDATE users 
SET 
    last_login_time = CURRENT_TIME();

ALTER TABLE users
CHANGE last_login_time last_login_time DATETIME DEFAULT NOW();

ALTER TABLE users
DROP PRIMARY KEY,
ADD PRIMARY KEY (id),
CHANGE username username VARCHAR(30) UNIQUE NOT NULL;

CREATE SCHEMA Movies;
USE Movies;
CREATE TABLE directors (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    director_name VARCHAR(50) NOT NULL,
    notes BLOB
);
CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    genre_name VARCHAR(50) NOT NULL,
    notes BLOB
);
CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    notes BLOB
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    title VARCHAR(50) NOT NULL,
    director_id INT,
    copyright_year INT,
    length INT,
    genre_id INT,
    category_id INT,
    rating INT,
    notes TEXT
);

INSERT INTO categories (category_name, notes)
VALUES ("test1", "testNote"),
 ("test2", "testNote"),
 ("test3", "testNote"),
 ("test4", "testNote"),
 ("test5", "testNote");
 
 INSERT INTO directors (director_name, notes)
 VALUES ("name1", "note1"),
  ("name2", "note2"),
  ("name3", "note3"),
  ("name4", "note4"),
  ("name5", "note5");

 INSERT INTO genres (genre_name, notes)
 VALUES ("genre1", "note1"),
  ("genre2", "note2"),
  ("genre3", "note3"),
  ("genre4", "note4"),
  ("genre5", "note5");
  
  INSERT INTO movies 
  VALUES (1, "title1", 1, 2023, 90, 1, 1, 60, "note1"), 
   (2, "title2", 1, 2019, 70, 1, 1, 60, "note2"), 
   (3, "title3", 1, 2005, 50, 1, 1, 60, "note3"), 
   (4, "title4", 1, 2016, 169, 1, 1, 60, "note4"), 
   (5, "title5", 1, 2013, 33, 1, 1, 60, "note5");

CREATE SCHEMA car_rental;
USE car_rental;
CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
category VARCHAR(50),
daily_rate DOUBLE,
weekly_rate DOUBLE,
monthly_rate DOUBLE,
weekend_rate DOUBLE
);

INSERT INTO categories (category, daily_rate, weekly_rate, monthly_rate, weekend_rate)
VALUES ("test", 5, 6, 2, 9),
 ("test", 9, 6, 4, 3),
 ("test", 6, 10, 6, 5);

CREATE TABLE cars(
id INT PRIMARY KEY AUTO_INCREMENT,
plate_number VARCHAR(8),
make VARCHAR(20),
model VARCHAR(50),
car_year INT,
category_id INT,
doors INT,
picture BLOB,
car_condition VARCHAR(50),
available BOOLEAN
);

INSERT INTO cars (plate_number)
VALUES ("kp6547pl"),
("PL9632KS"),
("SS9842RE");

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(50),
last_name VARCHAR(50),
title VARCHAR(50),
notes TEXT
);

INSERT INTO employees (first_name, last_name)
VALUES ("Petyr", "Petrov"),
("Ivan", "Ivanov"),
("Maq", "Vasileva");

CREATE TABLE customers(
id INT PRIMARY KEY AUTO_INCREMENT,
driver_licence_number VARCHAR(10),
full_name VARCHAR(50),
address TEXT,
city VARCHAR(20),
zip_code VARCHAR(20),
notes TEXT
);

INSERT INTO customers (driver_licence_number)
VALUES ("15321354"),
("61697695"),
("355468");

CREATE TABLE rental_orders(
id INT PRIMARY KEY AUTO_INCREMENT,
employee_id INT,
customer_id INT,
car_id INT, 
car_condition VARCHAR(50),
tank_level VARCHAR(50),
kilometrage_start INT,
kilometrage_end INT,
total_kilometrage INT,
start_date DATE,
end_date DATE,
total_days INT,
rate_applied DOUBLE,
tax_rate DOUBLE,
order_status VARCHAR(50),
notes TEXT
);

INSERT INTO rental_orders (employee_id, car_id)
VALUES (3, 2),
(1, 2),
(2, 2);

CREATE SCHEMA soft_uni;
USE soft_uni;
CREATE TABLE towns(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
);

CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
address_text TEXT,
town_id INT
);

CREATE TABLE departments(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(20)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(20),
middle_name VARCHAR(20),
last_name VARCHAR(20),
job_title VARCHAR(20),
department_id INT,
hire_date DATE,
salary DOUBLE,
address_id INT
);

ALTER TABLE addresses
ADD CONSTRAINT my_fk
FOREIGN KEY (town_id)
REFERENCES towns (id);

ALTER TABLE employees
ADD CONSTRAINT
FOREIGN KEY (department_id)
REFERENCES departments (id);

ALTER TABLE employees
ADD CONSTRAINT
FOREIGN KEY (address_id)
REFERENCES addresses (id);

INSERT INTO towns (name)
VALUES ("Sofia"),
("Plovdiv"),
("Varna"),
("Burgas");


INSERT INTO departments (name)
VALUES ("Engineering"),
("Sales"),
("Marketing"),
("Software Development"),
("Quality Assurance");

INSERT INTO employees (first_name, middle_name, last_name, job_title, department_id, hire_date, salary)
VALUES ("Ivan", "Ivanov", "Ivanov", ".NET Developer", 4, "2013-02-01", 3500),
 ("Petar", "Petrov", "Petrov", "Senior Engineer", 1, "2004-03-02", 4000),
 ("Maria", "Petrova", "Ivanova", "Intern", 5, "2016-08-28", 525.25),
 ("Georgi", "Terziev", "Ivanov", "CEO", 2, "2007-12-09", 3000),
 ("Peter", "Pan", "Pan", "Intern", 3, "2016-08-28", 599.88);

SELECT * FROM towns;
SELECT * FROM departments;
SELECT * FROM employees;

SELECT * FROM towns
ORDER BY name;

SELECT * FROM departments
ORDER BY name;

SELECT * FROM employees
ORDER BY salary DESC;

SELECT name FROM towns
ORDER BY name;
SELECT name FROM departments
ORDER BY name;
SELECT first_name, last_name, job_title, salary FROM employees
ORDER BY salary DESC;

UPDATE employees
SET salary = salary*1.10;
SELECT salary FROM employees;

SET SQL_SAFE_UPDATES = 0;



