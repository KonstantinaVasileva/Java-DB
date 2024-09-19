CREATE DATABASE SoftUni_Game_Dev_Branch;
USE SoftUni_Game_Dev_Branch;

CREATE TABLE addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(10) NOT NULL
);

CREATE TABLE offices (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workspace_capacity INT NOT NULL,
    website VARCHAR(50),
    address_id INT NOT NULL,
    FOREIGN KEY (address_id)
        REFERENCES addresses (id)
);

CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    age INT NOT NULL,
    salary DECIMAL(10 , 2 ) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    happiness_level CHAR(1) NOT NULL
);

CREATE TABLE teams (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(40) NOT NULL,
    office_id INT NOT NULL,
    leader_id INT NOT NULL UNIQUE,
    FOREIGN KEY (office_id)
        REFERENCES offices (id),
    FOREIGN KEY (leader_id)
        REFERENCES employees (id)
);

CREATE TABLE games (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    rating FLOAT NOT NULL DEFAULT 5.5,
    budget DECIMAL(10 , 2 ) NOT NULL,
    release_date DATE,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id)
        REFERENCES teams (id)
);

CREATE TABLE games_categories (
    game_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (game_id, category_id),
    FOREIGN KEY (game_id)
        REFERENCES games (id),
    FOREIGN KEY (category_id)
        REFERENCES categories (id)
);

INSERT INTO games(name, rating, budget, team_id)
SELECT reverse(lower(substring(name, 2))), id, leader_id * 1000, id FROM teams
WHERE id between 1 AND 9;

UPDATE employees 
SET 
    salary = salary + 1000
WHERE
    age < 40 AND salary < 5000;

DELETE FROM games 
WHERE
    release_date IS NULL
    AND id NOT IN (SELECT 
        game_id
    FROM
        games_categories);
        
SELECT 
    first_name, last_name, age, salary, happiness_level
FROM
    employees
ORDER BY salary , id;

SELECT 
    t.name, a.name, LENGTH(a.name)
FROM
    teams t
        JOIN
    offices o ON o.id = t.office_id
        JOIN
    addresses a ON a.id = o.address_id
WHERE
    website IS NOT NULL
ORDER BY t.name , a.name;

SELECT 
    c.name,
    COUNT(game_id) AS games_count,
    ROUND(AVG(budget), 2) AS avg_budget,
    MAX(rating) AS max_rating
FROM
    games g
        JOIN
    games_categories gc ON g.id = gc.game_id
        JOIN
    categories c ON c.id = gc.category_id
GROUP BY c.id
HAVING max_rating >= 9.5
ORDER BY games_count DESC , name; 

SELECT 
    g.name,
    release_date,
    CONCAT(SUBSTRING(description, 1, 10), '...') AS summary,
    (CASE
        WHEN MONTH(release_date) IN ('1' , '2', '3') THEN 'Q1'
        WHEN MONTH(release_date) IN ('4' , '5', '6') THEN 'Q2'
        WHEN MONTH(release_date) IN ('7' , '8', '9') THEN 'Q3'
        WHEN MONTH(release_date) IN ('10' , '11', '12') THEN 'Q4'
    END) AS quarter,
    (t.name) AS team_name
FROM
    games g
        JOIN
    teams t ON t.id = g.team_id
WHERE
    g.name LIKE '%2'
        AND MOD(MONTH(release_date), 2) = 0
        AND YEAR(release_date) = 2022
ORDER BY quarter;

SELECT 
    g.name,
    IF(g.budget < 50000,
        'Normal budget',
        'Insufficient budget') AS budget_level,
    t.name AS team_name,
    a.name AS address_name
FROM
    games g
        JOIN
    teams t ON t.id = g.team_id
        JOIN
    offices o ON o.id = t.office_id
        JOIN
    addresses a ON o.address_id = a.id
        LEFT JOIN
    games_categories gc ON gc.game_id = g.id
WHERE
    release_date IS NULL
        AND category_id IS NULL
ORDER BY g.name;

DELIMITER $$
CREATE FUNCTION udf_game_info_by_name (game_name VARCHAR (20))
RETURNS TEXT
DETERMINISTIC
BEGIN 
DECLARE info TEXT;
	SET info:= (SELECT 
    concat('The ', g.name, ' is developed by a ', t.name, ' in an office with an address ', a.name) FROM games g
	JOIN teams t ON t.id = g.team_id
	JOIN offices o ON t.office_id = o.id
	JOIN addresses a ON o.address_id = a.id
    WHERE g.name = game_name
);
	RETURN info;
END$$

CREATE procedure udp_update_budget (min_game_rating FLOAT)
BEGIN 
	UPDATE games g
    LEFT JOIN games_categories gc ON g.id = gc.game_id
    SET budget = budget + 100000,
	release_date = DATE_ADD(release_date, INTERVAL 1 year)
    WHERE category_id is NULL AND rating > min_game_rating;
END$$
        
