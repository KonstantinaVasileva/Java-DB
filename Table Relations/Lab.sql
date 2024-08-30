CREATE TABLE Mountains (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45)
);
CREATE TABLE Peaks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45),
    mountain_id INT,
    CONSTRAINT fk_peak_mountain FOREIGN KEY (mountain_id)
        REFERENCES Mountains (id)
);

SELECT 
    driver_id,
    vehicle_type,
    CONCAT(first_name, ' ', last_name) AS driver_name
FROM
    vehicles v
        JOIN
    campers c ON v.driver_id = c.id;
    
   SELECT 
    starting_point AS route_starting_point,
    end_point AS route_ending_point,
    leader_id,
    CONCAT(first_name, ' ', last_name) AS leader_name
FROM
    routes r
        JOIN
    campers c ON c.id = r.leader_id;
    
DROP TABLE mountains;
DROP TABLE peaks;

CREATE TABLE mountains (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45)
);
CREATE TABLE peaks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(45),
    mountain_id INT,
    CONSTRAINT fk_peak_mountain FOREIGN KEY (mountain_id)
        REFERENCES mountains (id)
        ON DELETE CASCADE
);

CREATE SCHEMA test;
CREATE TABLE clients(
id INT PRIMARY KEY AUTO_INCREMENT,
client_name VARCHAR(100)
);

CREATE TABLE projects(
id INT PRIMARY KEY AUTO_INCREMENT,
client_id INT, 
project_lead_id INT,
CONSTRAINT fk_client_id
FOREIGN KEY (client_id)
REFERENCES clients (id)
);

CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30),
last_name VARCHAR(30),
project_id INT,
CONSTRAINT fk_project_id
FOREIGN KEY (project_id)
REFERENCES projects(id)
);

ALTER TABLE projects
ADD CONSTRAINT fk_project_lead_id
FOREIGN KEY (project_lead_id)
REFERENCES employees(id);



