Create DATABASE Bank;
USE Bank;

CREATE TABLE branches
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE employees
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20)    not null,
    last_name  VARCHAR(20)    not null,
    salary     DECIMAL(10, 2) NOT NULL,
    started_on DATE           NOT NULL,
    branch_id  INT            NOT NULL,
    FOREIGN KEY (branch_id)
        REFERENCES branches (id)
);

CREATE TABLE clients
(
    id        INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(50) NOT NULL,
    age       INT         NOT NULL
);


CREATE TABLE employees_clients
(
    employee_id INT,
    client_id   INT,
    FOREIGN KEY (employee_id)
        REFERENCES employees (id),
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE bank_accounts
(
    id             INT PRIMARY KEY AUTO_INCREMENT,
    account_number VARCHAR(10)    NOT NULL,
    balance        DECIMAL(10, 2) NOT NULL,
    client_id      INT            NOT NULL UNIQUE,
    FOREIGN KEY (client_id)
        REFERENCES clients (id)
);

CREATE TABLE cards
(
    id              INT PRIMARY KEY AUTO_INCREMENT,
    card_number     VARCHAR(19) NOT NULL,
    card_status     VARCHAR(7)  NOT NULL,
    bank_account_id INT         NOT NULL,
    FOREIGN KEY (bank_account_id)
        REFERENCES bank_accounts (id)
);

INSERT INTO cards(card_number, card_status, bank_account_id)
SELECT REVERSE(full_name), 'Active', id
FROM clients
WHERE id BETWEEN 191 AND 200;

UPDATE employees_clients
SET employee_id =
        (SELECT id
         FROM employees e
                  JOIN employees_clients ec on e.id = ec.employee_id
         GROUP BY id
         ORDER BY COUNT(client_id)
         LIMIT 1)
WHERE employee_id = client_id;

DELETE
FROM employees
WHERE id NOT in (SELECT employee_id
                 FROM employees_clients);

SELECT id, full_name
FROM clients
ORDER BY id;

SELECT id, concat(first_name, ' ', last_name), CONCAT('$', salary) AS salary, started_on
FROM employees
WHERE salary >= 100000
  AND year(started_on) >= 2018
ORDER BY employees.salary DESC;

SELECT c.id, concat(card_number, ' : ', full_name) AS card_token
FROM cards c
         JOIN bank_accounts ba on c.bank_account_id = ba.id
         JOIN clients c2 on c2.id = ba.client_id
ORDER BY c.id DESC;

SELECT concat(first_name, ' ', last_name) AS name, started_on, count(client_id) as count_of_client
FROM employees
         JOIN employees_clients ec on employees.id = ec.employee_id
GROUP BY id
ORDER BY count_of_client DESC, id
LIMIT 5;

SELECT name, count(c2.id) AS count_of_cards
FROM branches
         LEFT JOIN employees e on branches.id = e.branch_id
         LEFT JOIN employees_clients ec on e.id = ec.employee_id
         LEFT JOIN clients c on c.id = ec.client_id
         LEFT JOIN bank_accounts ba on c.id = ba.client_id
         LEFT JOIN cards c2 on ba.id = c2.bank_account_id
GROUP BY name
ORDER BY count_of_cards DESC, name;

DELIMITER %%
CREATE FUNCTION udf_client_cards_count(name VARCHAR(30))
    RETURNS INT
    DETERMINISTIC
BEGIN
    DECLARE number_of_cards INT;
    SET number_of_cards := (SELECT count(c.id)
                            FROM cards c
                                     JOIN bank_accounts ba on ba.id = c.bank_account_id
                                     JOIN clients c2 on c2.id = ba.client_id
                            WHERE c2.full_name = name);
    RETURN number_of_cards;
END %%

CREATE PROCEDURE udp_clientinfo (full_name VARCHAR(30))
BEGIN
    SELECT full_name, age, account_number, concat('$', balance)
        FROM clients c
            JOIN bank_accounts ba on c.id = ba.client_id
    WHERE c.full_name = full_name;
end %%


