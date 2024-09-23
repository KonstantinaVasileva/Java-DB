CREATE DATABASE Insta_Influencers;
USE Insta_Influencers;

CREATE TABLE users
(
    id        INT primary key AUTO_INCREMENT,
    username  VARCHAR(30) NOT NULL UNIQUE,
    password  VARCHAR(30) NOT NULL,
    email     VARCHAR(50) NOT NULL,
    gender    CHAR        NOT NULL,
    age       INT         NOT NULL,
    job_title VARCHAR(40) not null,
    ip        VARCHAR(30) NOT NULL
);

CREATE TABLE addresses
(
    id      INT PRIMARY KEY AUTO_INCREMENT,
    address VARCHAR(30) NOT NULL,
    town    VARCHAR(30) NOT NULL,
    country VARCHAR(30) NOT NULL,
    user_id INT         NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES users (id)
);

CREATE TABLE photos
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT     NOT NULL,
    date        DATETIME NOT NULL,
    views       INT      NOT NULL DEFAULT 0
);

CREATE TABLE comments
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    comment  VARCHAR(255) NOT NULL,
    date     DATETIME     NOT NULL,
    photo_id INT          NOT NULL,
    FOREIGN KEY (photo_id)
        REFERENCES photos (id)
);

CREATE TABLE users_photos
(
    user_id  INT NOT NULL,
    photo_id INT NOT NULL,
    FOREIGN KEY (user_id)
        REFERENCES users (id),
    FOREIGN KEY (photo_id)
        REFERENCES photos (id)
);

CREATE TABLE likes
(
    id       INT PRIMARY KEY AUTO_INCREMENT,
    photo_id INT,
    user_id  INT,
    FOREIGN KEY (photo_id)
        REFERENCES photos (id),
    FOREIGN KEY (user_id)
        REFERENCES users (id)
);

INSERT INTO addresses (address, town, country, user_id)
SELECT username, password, ip, age
FROM users
WHERE gender = 'M';

UPDATE addresses
SET country = (
    CASE
        WHEN country LIKE 'B%' THEN 'Blocked'
        WHEN country LIKE 'T%' THEN 'Test'
        WHEN country LIKE 'P%' THEN 'In Progress'
        ELSE country
        END
    );

DELETE
FROM addresses
WHERE MOD(id, 3) = 0;

SELECT username, gender, age
FROM users
ORDER BY age DESC, username;

SELECT p.id, p.date AS date_and_time, description, count(comment) as commentsCount
FROM photos p
         JOIN comments c on p.id = c.photo_id
GROUP BY p.id
ORDER BY commentsCount DESC, p.id
LIMIT 5;

SELECT concat(u.id, ' ', username) AS id_useers, email
FROM users u
         JOIN users_photos up on u.id = up.user_id
WHERE user_id = photo_id
ORDER BY u.id;

SELECT p.id, if(likes_count is NULL, '0', likes_count), if(comments_count is null, '0', comments_count)
FROM photos p
         LEFT JOIN (SELECT photo_id, count(id) AS comments_count
                    FROM comments
                    GROUP BY photo_id) c on p.id = c.photo_id
         LEFT JOIN (SELECT photo_id, count(id) AS likes_count
                    FROM likes
                    GROUP BY photo_id) l on p.id = l.photo_id
ORDER BY likes_count DESC, comments_count DESC, p.id;

SELECT concat(left(description, 30), '...') AS summary, date
FROM photos
WHERE day(date) = 10
ORDER BY date DESC;

DELIMITER $$
CREATE FUNCTION udf_users_photos_count(in_username VARCHAR(30))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE photos_count INT;
    SET photos_count := (SELECT count(up.photo_id)
                         FROM users_photos up
                         JOIN users u on u.id = up.user_id
                         where u.username = in_username
                         );
RETURN photos_count;
end $$

CREATE PROCEDURE udp_modify_user (in_address VARCHAR(30), in_town VARCHAR(30))
BEGIN
    UPDATE users u
    JOIN addresses a on u.id = a.user_id
        SET age = age + 10
    WHERE in_address = address AND in_town = town;
end $$

