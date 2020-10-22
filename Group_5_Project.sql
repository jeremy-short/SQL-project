/* Create Table and Constraint Statements */

CREATE TABLE location (
store_number INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
street	VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL,
state CHAR(2) NOT NULL,
zip_code INTEGER NOT NULL,
phone_number BIGINT NOT NULL
);

CREATE TABLE customer (
customer_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
street	VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL,
state CHAR(2) NOT NULL,
zip_code INTEGER NOT NULL,
phone_number BIGINT NOT NULL,
email_address VARCHAR(100)
);

CREATE TABLE product (
product_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_name VARCHAR(50) NOT NULL,
calories INTEGER NOT NULL DEFAULT 0,
product_cost DOUBLE NOT NULL,
description TEXT
);

CREATE TABLE ingredient (
ingredient_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
description TEXT,
calories INTEGER NOT NULL DEFAULT 0,
ingredient_cost DOUBLE NOT NULL
);

CREATE TABLE employee (
employee_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
street	VARCHAR(50) NOT NULL,
city VARCHAR(50) NOT NULL,
state CHAR(2) NOT NULL,
zip_code INTEGER NOT NULL,
phone_number BIGINT NOT NULL,
email_address VARCHAR(100),
wage DOUBLE NOT NULL,
manager_id INTEGER,
store_number INTEGER NOT NULL
);

CREATE TABLE `order` (
order_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
order_date DATE NOT NULL,
order_time TIME NOT NULL,
employee_id INTEGER NOT NULL,
customer_id INTEGER
);

CREATE TABLE order_item (
order_item_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
product_id INTEGER,
ingredient_id INTEGER,
order_id INTEGER NOT NULL,
ingredient_quantity DOUBLE NOT NULL,
calories INTEGER NOT NULL DEFAULT 0
);

ALTER TABLE `order`
ADD CONSTRAINT order_fk1 FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT order_fk2 FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE employee
ADD CONSTRAINT employee_fk1 FOREIGN KEY (store_number) REFERENCES location(store_number) ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE order_item
ADD CONSTRAINT order_item_fk1 FOREIGN KEY (ingredient_id) REFERENCES ingredient(ingredient_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT order_item_fk2 FOREIGN KEY (product_id) REFERENCES product(product_id) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT order_item_fk3 FOREIGN KEY (order_id) REFERENCES `order`(order_id) ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE employee
ADD CONSTRAINT emplyee_fk2 FOREIGN KEY (manager_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
;

/* Alter table statments to handle the need for an item name and type to filter by */

ALTER TABLE ingredient
ADD ingredient_name VARCHAR(50) NOT NULL
;

ALTER TABLE ingredient
CHANGE description ingredient_type SET("Base", "Protein", "Mix-in", "Sauce", "Topping")
;

/* Removing Calories Field from order_item table as it is duplicate data and adding */

ALTER TABLE order_item
DROP calories
;

/* Query and View SQL Code */

#D-A description of any (several more than three) queries you would need to perform against your database with a brief explanation of why this query is important. After identifying all queries, include the SQL for at least three of these queries. Two of these queries need to demonstrate the joining of two or more tables.

#1First quires will be describe and select all, to be sure that the database has right data types and right quantity of data to be tested.

 

Select* from customer;

select * from employee;

select * from ingredient;

select * from location;

select * from `order`;

select * from `order_item`;

select * from product;


DESCRIBE customer;

DESCRIBE employee;

DESCRIBE ingredient;

DESCRIBE location;

DESCRIBE `order`;

DESCRIBE `order_item`;

DESCRIBE product;

 

#2-Using joins (inner joins and Natural joins) to test database relations and connectivity.

#this query is used to test three tables (customer, employee, and order) connectivity.

Select * 
from customer c
inner join `order` o  on c.customer_id= o.customer_id
inner join employee e on o.employee_id= e.employee_id;

#this query is used to test three tables (order, order_item, ingredients) connectivity

Select * 
from ingredient i
inner join order_item oi  on i.ingredient_id= oi.ingredient_id
inner join `order` o on oi.order_id=o.order_id ;

 
#this query is used to test three tables (location, employee, order, customer) connectivity.

Select * 
from customer c
inner join `order` o  on c.customer_id= o.order_id
inner join employee e  on o.employee_id=e.employee_id
inner join location l on e.store_number=l.store_number;

#this query is used to test three tables (product. Order_item,,order) connectivity.

Select * 
from product p
inner join order_item oi   on p.product_id= oi.product_id
inner join `order` o on oi.order_id=o.order_id;


# this query calculate the calories in an order.

SELECT o.*, (SUM(oi.ingredient_quantity *i.calories) + SUM(oi.ingredient_quantity * p.calories)) as order_calories
from `order` o 
JOIN order_item oi on o.order_id = oi.order_id 
JOIN ingredient i ON i.ingredient_id = oi.ingredient_id
JOIN product p ON p.product_id = oi.product_id
WHERE o.order_id = 50
group by o.order_id;


# this query calculate the order cost.
select o.*, (sum(oi.ingredient_quantity_quantity * p.product_cost) + SUM(oi.ingredient_quantity * i.ingredient_cost)) as order_cost
from order_item oi
join `order` o  on oi.order_id=o.order_id
join product p on oi.product_id=p.product_id
JOIN ingredient i ON oi.ingredient_id = i.ingredient_id
where o.order_id=5
group by o.order_id
order by p.product_cost;

 
#E-A description of any (a few more than one) views you would need to create with a brief explanation of why each view is important. After identifying all views, include the SQL for at least one of these views.

#First view: in this type of business we need to keep the ingredient cost and type as a result we need to make view to hide this information from other users.

CREATE VIEW ingredient_view as
select ingredient_id, ingredient_name
from ingredient;

 #Second view: Most of employee data should be hidden to keep away from other users. It must be for managers only. As a result, we need to use view here.

CREATE VIEW emp_view as
select employee_id, first_name
from employee;

/* Creat User's and Grant Privilages SQL */

CREATE USER `Valle_Josse`
IDENTIFIED BY 'ABCD1234!';

GRANT all
ON `782groupn5.`.*
TO ` Valle_Josse`
WITH GRANT OPTION;

CREATE USER `Amory_Carnihan`
IDENTIFIED BY 'ABCD1234!';

GRANT all
ON `782groupn5.customer `
TO `Amory_Carnihan`
WITH GRANT OPTION;

GRANT Select, Insert, Update
ON `782groupn5.employee`
TO `Amory_Carnihan`;

GRANT all
ON `782groupn5.ingredient`
TO `Amory_Carnihan`
WITH GRANT OPTION;

GRANT all
ON `782groupn5.location`
TO `Amory_Carnihan`
WITH GRANT OPTION;

GRANT all
ON `782groupn5.order`
TO `Amory_Carnihan`
WITH GRANT OPTION;

GRANT all
ON `782groupn5.order_item`
TO `Amory_Carnihan`;

GRANT Select Insert Update
ON `782groupn5.product`
TO `Amory_Carnihan`
WITH GRANT OPTION;

CREATE USER `Tally_Wisbey`
IDENTIFIED BY 'ABCD1234!';

GRANT Select, Insert, Update
ON `782groupn5.customer `
TO `Tally_Wisbey`;

GRANT Select, Insert, Update
ON `782groupn5.ingredient`
TO `Tally_Wisbey`;

GRANT Select, Insert, Update
ON `782groupn5.location`
TO `Tally_Wisbey`;

GRANT Select, Insert, Update
ON `782groupn5.order`
TO `Tally_Wisbey`;

GRANT Select, Insert, Update
ON `782groupn5.order_item`
TO `Tally_Wisbey`;

GRANT Select, Insert, Update
ON `782groupn5.product`
TO `Tally_Wisbey`;

/* Module 3 2B */

# A trigger that checks to see if the order date is earlier than today so that we have an accurate account of which orders were placed on which day.

DELIMITER $$
CREATE TRIGGER order_date
BEFORE INSERT ON `order`
FOR EACH ROW
BEGIN
	IF new.order_date	< Curdate() THEN
	SET new.order_date = Curdate(), new.order_time = CURRENT_TIME();
	END IF;
END$$
DELIMITER ;

# Testing the trigger.
INSERT INTO `order` (order_date, order_time, employee_id, customer_id)
VALUES ("2020-03-01", "10:20:01", 1, 1);

# A procedure that updates ingredient costs by using the ingredient_id and new cost. This is important so that cost can be updated as need to facilitate accurate book keeping. 

DELIMITER $$
CREATE PROCEDURE cost_update (IN vingredient_id INTEGER, IN vingredient_cost DOUBLE)
BEGIN
	UPDATE ingredient
	SET ingredient_cost = vingredient_cost
	WHERE ingredient_id = vingredient_id;
END$$
DELIMITER ;

# Testing the procedure. 

CALL cost_update (1,5.51);

# A procedure to update an emplyee's wage. To make sure that they are being paid correctly.

DELIMITER $$
CREATE PROCEDURE wage_update (IN vemployee_id INTEGER, IN vwage DOUBLE)
BEGIN
	UPDATE employee
	SET wage = vwage
	WHERE employee_id = vemployee_id;
END$$
DELIMITER ;

# Testing the procedure.

CALL wage_update(1, 10.53);

#this query shows the employee information, his/her location and orders information which are 
belonging to this employee
select  l.store_number,l.city,e.first_name, e.last_name, count(o.order_id)
from `order`o
inner join employee e on o.employee_id = e.employee_id
inner join location l on e.store_number= l.store_number
group by l.store_number
order by e.employee_id;

#this query shows  number of customer  in one store(ie.2)  
select  l.store_number, l.city,l.state,count(c.customer_id) as number_of_customers
from customer c 
inner join `order` o on c.customer_id=o.customer_id
inner join employee e on  o.employee_id= e.employee_id
inner join location l on e.store_number=l.store_number
where l.store_number=2
group by c.state
order by l.store_number;

