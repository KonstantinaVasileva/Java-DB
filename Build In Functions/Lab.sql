SELECT title FROM books
WHERE title LIKE ('The%');

SELECT REPLACE( title, 'The', '***') AS title
FROM books
WHERE title like ('The%');

SELECT ROUND(SUM(cost), 2)
FROM books;

SELECT CONCAT(first_name, " ", last_name) AS 'Full Name',
DATEDIFF(died, born) AS 'Days Lived'
FROM authors;

SELECT title FROM books
WHERE title LIKE ('%Harry Potter%');




