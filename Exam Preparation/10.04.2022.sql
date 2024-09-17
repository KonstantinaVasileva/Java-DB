CREATE DATABASE softuni_imdb’s ;
USE softuni_imdb’s ;

CREATE TABLE countries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE,
    continent VARCHAR(30) NOT NULL,
    currency VARCHAR(5) NOT NULL
);

CREATE TABLE genres (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE actors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE NOT NULL,
    height INT,
    awards INT,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id)
        REFERENCES countries (id)
);

CREATE TABLE movies_additional_info (
    id INT PRIMARY KEY AUTO_INCREMENT,
    rating DECIMAL(10 , 2 ) NOT NULL,
    runtime INT NOT NULL,
    picture_url VARCHAR(80) NOT NULL,
    budget DECIMAL(10 , 2 ),
    release_date DATE NOT NULL,
    has_subtitles BOOL,
    description TEXT
);

CREATE TABLE movies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(70) NOT NULL UNIQUE,
    country_id INT NOT NULL,
    movie_info_id INT NOT NULL UNIQUE,
    FOREIGN KEY (country_id)
        REFERENCES countries (id),
    FOREIGN KEY (movie_info_id)
        REFERENCES movies_additional_info (id)
);

CREATE TABLE movies_actors (
    movie_id INT,
    actor_id INT,
    FOREIGN KEY (movie_id)
        REFERENCES movies (id),
    FOREIGN KEY (actor_id)
        REFERENCES actors (id)
);

CREATE TABLE genres_movies (
    genre_id INT,
    movie_id INT,
    FOREIGN KEY (genre_id)
        REFERENCES genres (id),
    FOREIGN KEY (moviE_id)
        REFERENCES movies (id)
);

INSERT INTO actors (first_name, last_name, birthdate, height, awards, country_id)
SELECT reverse(first_name), reverse(last_name), date_add(birthdate, interval -2 day),
height + 10, country_id, 3 FROM actors
WHERE id <= 10;

UPDATE movies_additional_info
SET runtime = runtime - 10
WHERE id between 15 and 25;

DELETE FROM countries 
WHERE
    id NOT IN (SELECT 
        country_id
    FROM
        movies);
        
SELECT 
    *
FROM
    countries
ORDER BY currency DESC , id; 

SELECT 
    mai.id, m.title, runtime, budget, release_date
FROM
    movies_additional_info mai
        JOIN
    movies m ON mai.id = m.movie_info_id
WHERE
    YEAR(release_date) BETWEEN 1996 AND 1999
ORDER BY runtime , mai.id
LIMIT 20;

SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    CONCAT(REVERSE(last_name),
            LENGTH(last_name),
            '@cast.com') AS email,
    2022 - YEAR(birthdate) AS age,
    height
FROM
    actors a
        LEFT JOIN
    movies_actors ma ON a.id = actor_id
WHERE
    movie_id IS NULL
ORDER BY height;

SELECT 
    name, COUNT(m.id) AS movies_count
FROM
    countries c
        JOIN
    movies m ON m.country_id = c.id
GROUP BY country_id
HAVING movies_count >= 7
ORDER BY name DESC;

SELECT 
    title,
    (CASE
        WHEN rating <= 4 THEN 'poor'
        WHEN rating <= 7 THEN 'good'
        ELSE 'excellent'
    END) AS rating,
    IF(has_subtitles = 0, '-', 'english') AS subtitles,
    budget
FROM
    movies_additional_info mai
        RIGHT JOIN
    movies m ON mai.id = m.movie_info_id
ORDER BY budget DESC;

DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE history_movies INT;
    SET history_movies := (
    SELECT count(ma.movie_id) FROM movies_actors ma
    JOIN actors a ON ma.actor_id = a.id
    JOIN genres_movies gm ON gm.movie_id = ma.movie_id
    WHERE concat(first_name, ' ', last_name) = full_name AND
    genre_id = 12
    );
	RETURN history_movies;
END$$

CREATE PROCEDURE udp_award_movie(movie_title VARCHAR(50))
BEGIN 
	UPDATE actors a
    JOIN movies_actors ma ON ma.actor_id = a.id
    JOIN movies m ON m.id = ma.movie_id
    SET awards = awards + 1
    WHERE movie_title = title;
END$$

SET SQL_SAFE_UPDATES = 0;




        
        