USE hotel;

SELECT id, first_name, last_name, job_title FROM employees
ORDER BY id;

SELECT id, CONCAT (first_name, " ", last_name) as full_name, job_title , salary FROM employees
WHERE salary > 1000
ORDER BY id;

UPDATE employees
SET salary = salary + 100
WHERE job_title = "Manager";
SELECT salary FROM employees;

SET SQL_SAFE_UPDATES = 0;

SELECT * FROM employees
ORDER BY salary DESC
LIMIT 1;

SELECT * FROM employees
WHERE department_id = 4 && salary >= 1000
ORDER BY id;

DELETE FROM employees
WHERE department_id = 2 OR department_id = 1;
SELECT * FROM employees;

