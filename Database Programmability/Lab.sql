DELIMITER $$

CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE count INT;
SET count := (SELECT count(employee_id) 
FROM employees e
JOIN addresses a 
ON a.address_id = e.address_id
join towns t 
ON a.town_id = t.town_id
WHERE name = town_name);
RETURN count;
END$$

delimiter ##
CREATE procedure usp_raise_salaries(department_name varchar(50))

BEGIN
update employees e
JOIN departments d on d.department_id = e.department_id
SET salary = salary * 1.05
where d.name = department_name;
END##

delimiter ##
CREATE PROCEDURE usp_raise_salary_by_id(id INT)
BEGIN
   UPDATE employees
   SET salary = salary * 1.05
   WHERE employee_id = id;
END##

DELIMITER @@
CREATE TABLE deleted_employees(
employee_id INT PRIMARY KEY AUTO_INCREMENT, 
first_name VARCHAR(50),
last_name VARCHAR(50),
middle_name VARCHAR(50),
job_title VARCHAR(50),
department_id INT,
salary DECIMAL(19, 4))@@ 

CREATE TRIGGER tr_deleted_employees
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
   INSERT INTO deleted_employees (first_name, last_name, middle_name, job_title, department_id, salary)
   VALUES(OLD.first_name, OLD.last_name, OLD.middle_name, OLD.job_title, OLD.department_id, OLD.salary);
END@@


