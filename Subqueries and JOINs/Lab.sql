SELECT 
    d.manager_id AS employee_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    d.department_id,
    d.name AS department_name
FROM
    employees e
        JOIN
    departments d ON d.manager_id = e.employee_id
ORDER BY employee_id
LIMIT 5;

SELECT 
    t.town_id, t.name, address_text
FROM
    towns t
        JOIN
    addresses a ON t.town_id = a.town_id
WHERE
    t.name IN ('San Francisco' , 'Sofia', 'Carnation')
ORDER BY town_id , address_id;

SELECT 
    employee_id, first_name, last_name, department_id, salary
FROM
    employees
WHERE
    manager_id IS NULL;
    
    SELECT 
    COUNT(*) AS count
FROM
    employees
WHERE
    salary > (SELECT 
            AVG(salary)
        FROM
            employees);









