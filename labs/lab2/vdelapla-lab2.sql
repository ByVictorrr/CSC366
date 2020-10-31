-- Lab 2
-- vdelapla
-- Sep 27, 2020

USE `vdelapla`;
-- DDL-1
-- A single computer is allocated to each engineer. Not all engineers have a computer and some computers are unallocated.
DROP TABLE IF EXISTS computer;
DROP TABLE IF EXISTS engineer;

CREATE TABLE IF NOT EXISTS engineer(
	emp_id VARCHAR(4) PRIMARY KEY,
	name VARCHAR(1) NOT NULL

);

CREATE TABLE IF NOT EXISTS computer(
	id INTEGER PRIMARY KEY,
	label VARCHAR(255) NOT NULL,
	assigned_to VARCHAR(4),
	FOREIGN KEY (assigned_to) REFERENCES engineer(emp_id) 
);
/* TC 1: good 
insert into engineer (emp_id, name) values ('E001', 'A');
*/
/* TC 2: good
insert into engineer (emp_id, name) values ('E001', 'A');
insert into engineer (emp_id, name) values ('E001', 'B');
*/

/* TC 3 : good
insert into engineer (emp_id, name) values ('E001', 'A');
insert into computer (id, label, emp_id) values (1, '#1', 'E001');
*/

/*TC 4: good
insert into engineer (emp_id, name) values ('E001', 'A');
insert into computer (id, label, emp_id) values (1, '#1', 'E001');
insert into computer (id, label, emp_id) values (99, '#99', 'E999')
*/
/* TC 5 and 6: working 
insert into engineer (emp_id, name) values ('E001', 'A');
insert into computer (id, label, emp_id) values (1, '#1', 'E001');
insert into computer (id, label, emp_id) values (2, '#2', null);
insert into computer (id, label, emp_id) values (1, '#1', 'E001');
delete from engineer where emp_id = 'E001'
/*
insert into computer (id, label, assigned_to) values (99, '#99', 'E999')
insert into computer (id, label, emp_id) values (2, '#2', null);
*/;


USE `vdelapla`;
-- DDL-2
-- Orders may be placed for one or more products. For each product ordered, the database must store a customer-chosen quantity and size.
DROP TABLE IF EXISTS order_line;
DROP TABLE IF EXISTS `order`;
DROP TABLE IF EXISTS product;


CREATE TABLE `order` (
	id INTEGER PRIMARY KEY,
	order_date DATE NOT NULL
);
CREATE TABLE product(
	sku INTEGER PRIMARY KEY,
	description VARCHAR(1),
	price FLOAT
);
CREATE TABLE order_line(
	order_id INTEGER,
	sku INTEGER,
	quantity INTEGER NOT NULL,
	size VARCHAR(1) NOT NULL, /* NOT entirely sure */

	PRIMARY KEY (order_id, sku),
	FOREIGN KEY (order_id) REFERENCES `order`(id),
	FOREIGN KEY (sku) REFERENCES product(sku)
);


USE `vdelapla`;
-- DDL-3
-- A rail station may connect to any number of other stations. Each station is located in exactly one city, and is owned by a single country.
DROP TABLE IF EXISTS rail_connect;
DROP TABLE IF EXISTS rail_station;
DROP TABLE IF EXISTS city;
DROP TABLE IF EXISTS country;



CREATE TABLE country(
	name VARCHAR(20) PRIMARY KEY
);

CREATE TABLE city(
	name VARCHAR(20) PRIMARY KEY,
	country VARCHAR(20) NOT NULL,
	FOREIGN KEY (country) REFERENCES country(name)
	
);
CREATE TABLE rail_station(
	code VARCHAR(1) PRIMARY KEY,
	location VARCHAR(20) NOT NULL,
	owned_by VARCHAR(20) NOT NULL,
	FOREIGN KEY (location) REFERENCES city(name),
	FOREIGN KEY (owned_by) REFERENCES country(name)
	
);
CREATE TABLE rail_connect(
	from_station VARCHAR(1),
	to_station VARCHAR(1),
	PRIMARY KEY (from_station, to_station),
	FOREIGN KEY (from_station) REFERENCES rail_station(code),
	FOREIGN KEY (to_station) REFERENCES rail_station(code)
);


USE `vdelapla`;
-- DDL-4
-- Each technician assigned to a project works at only one location for that project, but can be at a different location for a different project. At a given location, an employee works on only one project. At a particular location there can be many employees assigned to a given project.
DROP TABLE IF EXISTS assigned_to;
DROP TABLE IF EXISTS technician;
DROP TABLE IF EXISTS project;
DROP TABLE IF EXISTS location;

CREATE TABLE technician(
	id INTEGER PRIMARY KEY
);

CREATE TABLE project(
	name VARCHAR(1) PRIMARY KEY
);

CREATE TABLE location(
	name VARCHAR(1) PRIMARY KEY
);

CREATE TABLE assigned_to(
	technician INTEGER,
	project VARCHAR(1) NOT NULL UNIQUE,
	location VARCHAR(2) NOT NULL UNIQUE,
	PRIMARY KEY(technician, project, location),
	FOREIGN KEY (technician) REFERENCES technician(id),
	FOREIGN KEY (project) REFERENCES project(name),
	FOREIGN KEY (location) REFERENCES location(name)
	
	
);


