DELIMITER %%

CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
  SELECT first_name, last_name FROM employees
  WHERE salary > 35000
  ORDER BY first_name, last_name, employee_id;
END%%

CREATE PROCEDURE usp_get_employees_salary_above(exp_salary DECIMAL(19, 4))
BEGIN
  SELECT first_name, last_name FROM employees
  WHERE salary >= exp_salary
  ORDER BY first_name, last_name, employee_id;
END%%

CREATE PROCEDURE usp_get_towns_starting_with (start_str VARCHAR(45))
BEGIN
   SELECT name FROM towns
   WHERE name LIKE CONCAT(start_str, '%')
   ORDER BY name;
END%%

CREATE PROCEDURE usp_get_employees_from_town (town_name VARCHAR(50))
BEGIN 
   SELECT first_name, last_name FROM employees e
   JOIN addresses a
   ON a.address_id = e.address_id
   JOIN towns t
   ON t.town_id = a.town_id
   WHERE t.name = town_name
   ORDER BY first_name, last_name, employee_id;
END%%

CREATE FUNCTION ufn_get_salary_level (exp_salary DECIMAL(19, 4))
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
DECLARE salary_level VARCHAR(50);
   IF exp_salary < 30000 THEN SET salary_level := 'Low';
   ELSEIF exp_salary <= 50000 THEN SET salary_level := 'Average';
   ELSE SET salary_level :='High';
   END IF;
   RETURN salary_level;

END%%

CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR(50))
BEGIN
   SELECT first_name, last_name FROM employees
   WHERE (SELECT ufn_get_salary_level(salary) = salary_level)
   ORDER BY first_name DESC, last_name DESC;
END%%

CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE result INT;
RETURN word REGEXP CONCAT ('^[',set_of_letters,']+$');

END%%

CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN 
   SELECT CONCAT(first_name,' ',  last_name) AS full_name FROM account_holders
   ORDER BY full_name, id; 
END%%

CREATE PROCEDURE usp_get_holders_with_balance_higher_than (supplied_balance DECIMAL(19, 4))
BEGIN
	SELECT first_name, last_name FROM account_holders ah
    JOIN  (
    SELECT account_holder_id, SUM(balance) AS total_balance FROM accounts
    GROUP BY account_holder_id
    HAVING total_balance > supplied_balance) a
	ON ah.id = a.account_holder_id;
END%%

CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL(19, 4), yearly_interest_rate DOUBLE, number_of_years INT)
RETURNS DECIMAL(19, 4)
DETERMINISTIC
BEGIN
	DECLARE future_value DECIMAL(19, 4);
    SET future_value := sum*pow((1+yearly_interest_rate), number_of_years);
    RETURN future_value;
END%%

CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL(19, 4))
BEGIN
    SELECT 
        a.id as account_id, 
        ah.first_name, ah.last_name, 
        a.balance as current_balance,
        ufn_calculate_future_value(a.balance, interest_rate, 5) as balance_in_5_years
    FROM 
        account_holders ah
    JOIN 
        accounts a ON ah.id = a.account_holder_id
    WHERE 
        a.id = id;
END%%

CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
    IF(money_amount <= 0) THEN ROLLBACK;
    ELSE UPDATE accounts SET balance = balance + money_amount;
    END IF;
END%% 

CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL(19, 4))
BEGIN 
	START TRANSACTION;
    IF (money_amount <= 0 OR (SELECT balance FROM accounts WHERE id=account_id) < money_amount) THEN ROLLBACK;
    ELSE UPDATE accounts SET balance = balance - money_amount;
    END IF;
END%%


CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, amount DECIMAL(19, 4))
BEGIN
START TRANSACTION;
IF amount <= 0 OR (SELECT balance FROM accounts WHERE id = from_account_id) < amount
OR from_account_id = to_account_id
OR(SELECT count(id) FROM accounts WHERE id = from_account_id) <> 1
OR (SELECT count(id) FROm accounts WHERE id = to_account_id) <> 1
THEN ROLLBACK;
ELSE
UPDATE accounts SET balance = balance - amount
WHERE id = from_account_id;
UPDATE accounts SET balance = balance + amount
WHERE id = to_account_id;
END IF;
END%%

 
CREATE TABLE logs (
log_id INT PRIMARY KEY AUTO_INCREMENT, 
account_id INT , 
old_sum DECIMAL(19, 4), 
new_sum DECIMAL(19, 4)
)%%

CREATE 
    TRIGGER  tr_accounts_log
 AFTER UPDATE ON accounts FOR EACH ROW 
    INSERT logs (account_id , old_sum , new_sum) VALUES (OLD.id , OLD.balance , NEW.balance)%%


CREATE TABLE notification_emails (
    id INT PRIMARY KEY AUTO_INCREMENT,
    recipient INT,
    subject TEXT,
    body TEXT
)%%

CREATE 
    TRIGGER  tr_new_record_in_log
 AFTER INSERT ON logs FOR EACH ROW 
    INSERT notification_emails (recipient , subject , body) 
    VALUES (NEW.account_id , 
    CONCAT('Balance change for account: ', NEW.account_id) , 
    CONCAT('On ',
            NOW(),
            ' your balance was changed from ',
            NEW.old_sum,
            ' to ',
            NEW.new_sum, '.'))%%

