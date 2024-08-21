USE soft_uni;

SELECT * FROM departments
ORDER BY department_id;

SELECT name FROM departments
ORDER BY department_id;

SELECT first_name, last_name, salary FROM employees;

SELECT first_name, middle_name, last_name FROM employees;

SELECT CONCAT(first_name, ".", last_name, "@softuni.bg") AS full_email_address FROM employees;

SELECT DISTINCT salary FROM employees;

SELECT * FROM employees
WHERE job_title = "Sales Representative";

SELECT first_name, last_name, job_title FROM employees
WHERE salary BETWEEN 20000 AND 30000;

SELECT concat_ws(" ", first_name, middle_name, last_name) AS `Full Name` FROm employees
WHERE salary = 25000 OR salary = 14000 OR salary = 12500 OR salary = 23600;

SELECT first_name, last_name FROM employees
WHERE manager_id IS null;

SELECT first_name, last_name, salary FROM employees
WHERE salary > 50000
ORDER BY salary DESC;

SELECT first_name, last_name FROM employees
ORDER BY salary DESC
LIMIT 5;

SELECT first_name, last_name FROM employees
WHERE department_id != 4;

SELECT 
    *
FROM
    employees
ORDER BY salary DESC , first_name , last_name DESC , middle_name;

CREATE VIEW v_employees_salaries AS
SELECT first_name, last_name, salary
FROM employees;

SELECT * FROM v_employees_salaries;

CREATE VIEW v_employees_job_titles AS
SELECT CONCAT_WS(" ", first_name, middle_name, last_name) AS full_name, job_title
FROM employees;
SELECT * FROM v_employees_job_titles;

SELECT DISTINCT job_title FROM employees
ORDER BY job_title;

SELECT * FROM projects
ORDER BY start_date, name
LIMIT 10;

SELECT first_name, last_name, hire_date FROm employees
ORDER BY hire_date DESC
LIMIT 7;

UPDATE employees
SET salary = salary * 1.12
WHERE department_id = 1 OR department_id = 2 OR department_id = 4 OR department_id = 11;
SELECT salary FROM employees;

USE geography;

SELECT peak_name FROM peaks
ORDER BY peak_name;

SELECT country_name, population FROM countries
WHERE continent_code = "EU"
ORDER BY population DESC, country_name 
LIMIT 30;

SELECT country_name, country_code, 
CASE 
WHEN currency_code = "EUR" THEN "Euro"
ELSE "Not Euro" 
END AS currency_code
FROM countries
ORDER BY country_name;

USE diablo;

SELECT name FROM characters
ORDER BY name;




