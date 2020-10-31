-- Lab 3
-- vdelapla
-- Oct 1, 2020

USE `vdelapla`;
-- FD-1
-- Create a table named R1 with columns A and B (any data type.) Populate your table such that the FD A -> B is satisfied, but B -> A is not satisfied.
SELECT * FROM R1;


USE `vdelapla`;
-- FD-2
-- Create a table named R2 with columns A, B, and C (any data type.) Populate your table such that the FDs AB -> C and A->C are satisfied, but B -> C is not satisfied.
DROP TABLE IF EXISTS R2;

CREATE TABLE R2(
	A INTEGER,
	B INTEGER,
	C INTEGER
);

INSERT INTO R2 (A,B,C) VALUES (1,2,3);
INSERT INTO R2 (A,B,C) VALUES (1,0,3);
INSERT INTO R2 (A,B,C) VALUES (4,1,2);
INSERT INTO R2 (A,B,C) VALUES (0,1,3);


USE `vdelapla`;
-- FD-3
-- Create a table named R3 with columns A, B, and C (any data type.) Populate your table such that the FD AB -> C is satisfied, but neither A -> C nor B -> C is satisfied.
DROP TABLE IF EXISTS R3;
CREATE TABLE R3(
	A INTEGER,
	B INTEGER,
	C INTEGER
);
INSERT INTO R3 (A,B,C) VALUES (1,2,3);
INSERT INTO R3 (A,B,C) VALUES (4,1,3);
INSERT INTO R3 (A,B,C) VALUES (1,1,4);


USE `vdelapla`;
-- FD-4
-- Define an empty table named R4 with columns A, B, C, and D (all of data type INTEGER.) Based on the FDs AB->C, C->D, and D->A, define *all* keys using SQL DDL. You may choose any key as the primary key. When running  "Check", your table should not contain any rows.
DROP TABLE IF EXISTS R4;
CREATE TABLE R4(
	A INTEGER,
	B INTEGER,
	C INTEGER,
	D INTEGER,
	PRIMARY KEY (A,B),
	UNIQUE (B,D),
	UNIQUE (B,C)
);


USE `vdelapla`;
-- FD-5
-- Define an empty table named R5 with columns A, B, C, and D (all of data type INTEGER.) Based on the FDs A->B, B->C, C->D, and D->A, define *all* keys using SQL DDL. You may choose any key as the primary key. When running  "Check", your table should not contain any rows.
DROP TABLE IF EXISTS R5;
CREATE TABLE R5(
	A INTEGER NOT NULL,
	B INTEGER NOT NULL,
	C INTEGER NOT NULL,
	D INTEGER NOT NULL,
	PRIMARY KEY (A),
	UNIQUE(B),
	UNIQUE(C),
	UNIQUE(D)
);


