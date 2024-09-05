SELECT 
    e.employee_id, e.job_title, e.address_id, a.address_text
FROM
    employees e
        JOIN
    addresses a ON a.address_id = e.address_id
ORDER BY a.address_id
LIMIT 5;

SELECT e.first_name, e.last_name, t.name AS town, a.address_text
FROM employees e
JOIN addresses a
ON e.address_id = a.address_id
JOIN towns t
ON t.town_id = a.town_id
ORDER BY first_name, last_name
Limit 5;

SELECT 
    employee_id, first_name, last_name, d.name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    d.name IN ('Sales')
ORDER BY e.employee_id DESC;

SELECT 
    employee_id, first_name, salary, d.name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.salary > 15000
ORDER BY d.department_id DESC
LIMIT 5;

SELECT 
    e.employee_id, e.first_name
FROM
    employees e
        LEFT JOIN
    employees_projects ep ON e.employee_id = ep.employee_id
WHERE
    project_id IS NULL
ORDER BY employee_id DESC
LIMIT 3;

SELECT 
    e.first_name, e.last_name, e.hire_date, d.name
FROM
    employees e
        JOIN
    departments d ON e.department_id = d.department_id
WHERE
    e.hire_date > '1999-01-01'
        AND d.name IN ('Sales' , 'Finance')
ORDER BY hire_date;

SELECT 
    e.employee_id, e.first_name, p.name
FROM
    employees e
        JOIN
    employees_projects ep ON ep.employee_id = e.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    DATE(p.start_date) > '2002-08-13'
        AND p.end_date IS NULL
ORDER BY first_name , p.name
LIMIT 5;

SELECT 
    e.employee_id,
    e.first_name,
    IF(YEAR(p.start_date) >= 2005,
        NULL,
        p.name) AS project_name
FROM
    employees e
        JOIN
    employees_projects ep ON ep.employee_id = e.employee_id
        JOIN
    projects p ON ep.project_id = p.project_id
WHERE
    e.employee_id = 24
ORDER BY project_name;

SELECT 
    e.employee_id,
    e.first_name,
    e.manager_id,
    e1.first_name AS manager_name
FROM
    employees e
        JOIN
    employees e1 ON e.manager_id = e1.employee_id
WHERE
    e.manager_id IN (3 , 7)
ORDER BY e.first_name;

SELECT 
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(e1.first_name, ' ', e1.last_name) AS manager_name,
    d.name AS department_name
FROM
    employees e
        JOIN
    employees e1 ON e.manager_id = e1.employee_id
        JOIN
    departments d ON e.department_id = d.department_id
ORDER BY e.employee_id
LIMIT 5;

SELECT 
    AVG(salary) AS min_average_salary
FROM
    employees
GROUP BY department_id
ORDER BY min_average_salary
LIMIT 1;

SELECT 
    c.country_code, m.mountain_range, p.peak_name, p.elevation
FROM
    countries c
        JOIN
    mountains_countries mc ON c.country_code = mc.country_code
        JOIN
    mountains m ON mc.mountain_id = m.id
        JOIN
    peaks p ON m.id = p.mountain_id
WHERE
    c.country_code = 'BG'
        AND p.elevation > 2835
ORDER BY p.elevation DESC;

SELECT 
    country_code, COUNT(m.mountain_range) AS mountain_range
FROM
    mountains_countries mc
        JOIN
    mountains m ON mc.mountain_id = m.id
GROUP BY country_code
HAVING country_code IN ('US' , 'BG', 'RU')
ORDER BY mountain_range DESC;

SELECT 
    country_name, river_name
FROM
    countries c
        LEFT JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        LEFT JOIN
    rivers r ON cr.river_id = r.id
WHERE
    continent_code = 'AF'
ORDER BY country_name
LIMIT 5;

SELECT 
    c.continent_code,
    c.currency_code,
    COUNT(*) AS currency_useage
FROM
    countries c
GROUP BY continent_code , currency_code
HAVING currency_useage > 1
    AND currency_useage = (SELECT 
        COUNT(*) AS max_use
    FROM
        countries
    WHERE
        continent_code = c.continent_code
    GROUP BY currency_code
    ORDER BY max_use DESC
    LIMIT 1)
ORDER BY continent_code , currency_code
;

SELECT 
    COUNT(*) AS country_count
FROM
    countries c
        LEFT JOIN
    mountains_countries mc ON mc.country_code = c.country_code
WHERE
    mc.mountain_id IS NULL;

SELECT 
    c.country_name,
    MAX(p.elevation) AS highest_peak_elevation,
    MAX(length) longest_river_length
FROM
    countries c
        JOIN
    mountains_countries mc ON mc.country_code = c.country_code
        JOIN
    peaks p ON p.mountain_id = mc.mountain_id
        JOIN
    countries_rivers cr ON c.country_code = cr.country_code
        JOIN
    rivers r ON cr.river_id = r.id
GROUP BY country_name
ORDER BY highest_peak_elevation DESC , longest_river_length DESC , country_name
LIMIT 5;







