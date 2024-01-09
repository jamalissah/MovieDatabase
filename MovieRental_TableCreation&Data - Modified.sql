-- Create a new schema/database
CREATE DATABASE IF NOT EXISTS movie_rentals;
USE movie_rentals;

-- Create Address table
CREATE TABLE Address (
    AddressID INT PRIMARY KEY AUTO_INCREMENT,
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    ZipCode VARCHAR(20),
    PhoneNumber VARCHAR(20),
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Staff table (References Address)
CREATE TABLE Staff (
    StaffID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    AddressID INT,
    Email VARCHAR(100),
    ManagerID INT,
    Active BOOLEAN,
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Create Store table (References Address, Staff)
CREATE TABLE Store (
    StoreID INT PRIMARY KEY AUTO_INCREMENT,
    ManagerStaffID INT,
    AddressID INT,
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ManagerStaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Create Film table
CREATE TABLE Film (
    FilmID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(255),
    Synopsis TEXT,
    ReleaseYear YEAR,
    RentalDuration INT,
    RentalRate DECIMAL(5, 2),
    FilmLength VARCHAR(20),
    Rating VARCHAR(10),
    ReplacementCost DECIMAL(6, 2),
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Customer table (References Store, Address)
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    StoreID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    AddressID INT,
    CreationDate DATE,
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    Active BOOLEAN,
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID),
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Create Inventory table (References Film, Store)
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY AUTO_INCREMENT,
    FilmID INT,
    StoreID INT,
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (FilmID) REFERENCES Film(FilmID),
    FOREIGN KEY (StoreID) REFERENCES Store(StoreID)
);

-- Create Rental table (References Inventory, Customer, Staff)
CREATE TABLE Rental (
    RentalID INT PRIMARY KEY AUTO_INCREMENT,
    RentalDate DATE,
    ReturnDate DATE,
    InventoryID INT,
    CustomerID INT,
    StaffID INT,
    LastUpdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (InventoryID) REFERENCES Inventory(InventoryID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

-- Create Payment table (References Customer, Staff, Rental)
CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    StaffID INT,
    RentalID INT,
    Amount DECIMAL(10, 2),
    PaymentDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (StaffID) REFERENCES Staff(StaffID),
    FOREIGN KEY (RentalID) REFERENCES Rental(RentalID)
);

-- Insert example records into Address table
INSERT INTO Address (AddressLine1, City, ZipCode, PhoneNumber)
VALUES 
    ('123 Main St', 'Anytown', '12345', '555-1234'),
    ('456 Elm St', 'Another City', '67890', '555-5678'),
    ('789 Oak St', 'Different City', '13579', '555-2468'),
    ('101 Pine St', 'New City', '24680', '555-9876'),
    ('246 Broadway', 'Metropolis', '54321', '555-1357'),
    ('369 Park Ave', 'Gotham', '98765', '555-7890'),
    ('808 State St', 'Springfield', '97531', '555-4321'),
    ('21 Jump St', 'Hill Valley', '12345', '555-6789'),
    ('555 Oak Ave', 'Smallville', '54321', '555-9876'),
    ('321 Main St', 'Nowheretown', '13425', '555-1234');

-- Insert example records into Staff table
INSERT INTO Staff (FirstName, LastName, AddressID, Email, ManagerID, Active)
VALUES 
    ('John', 'Doe', 1, 'john@example.com', 5, 1),
    ('Jane', 'Smith', 2, 'jane@example.com', 7, 1),
    ('Mike', 'Johnson', 3, 'mike@example.com', NULL, 1),
    ('Emily', 'Williams', 4, 'emily@example.com', NULL, 1),
    ('Sarah', 'Adams', 5, 'sarah@example.com', NULL, 1),
    ('Michael', 'Browaddressn', 6, 'michael@example.com', 5, 1),
    ('Olivia', 'Clark', 7, 'olivia@example.com', NULL, 1),
    ('David', 'Evans', 8, 'david@example.com', 4, 1),
    ('Sophia', 'Fisher', 9, 'sophia@example.com', 3, 1),
    ('Devin', 'Gonzalez', 10, 'devin@example.com', 4, 1);

-- Insert example records into Store table
INSERT INTO Store (ManagerStaffID, AddressID)
VALUES 
    (3, 1),
    (5, 2),
    (7, 3),
    (4, 4);

-- Insert example records into Film table
INSERT INTO Film (Title, Synopsis, ReleaseYear, RentalDuration, RentalRate, FilmLength, Rating, ReplacementCost)
VALUES 
    ('The Matrix', 'A computer hacker learns about the true nature of reality and his role in the war against its controllers.', 1999, 7, 2.99, '136 min', 'R', 9.99),
    ('Inception', 'A thief who steals corporate secrets through the use of dream-sharing technology.', 2010, 5, 3.49, '148 min', 'PG-13', 12.99),
    ('Pulp Fiction', 'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine.', 1994, 4, 2.79, '154 min', 'R', 11.99),
    ('The Shawshank Redemption', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.', 1994, 3, 2.49, '142 min', 'R', 10.99),
    ('Forrest Gump', 'The story of a man with a low IQ who accomplished great things.', 1994, 6, 2.99, '142 min', 'PG-13', 10.99),
    ('The Dark Knight', 'Batman faces a new villain, the Joker, who wreaks havoc on Gotham City.', 2008, 7, 3.49, '152 min', 'PG-13', 13.99),
    ('Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.', 2014, 5, 3.29, '169 min', 'PG-13', 11.99),
    ('The Godfather', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.', 1972, 5, 2.79, '175 min', 'R', 12.99),
    ('Fight Club', 'An insomniac office worker forms an underground fight club.', 1999, 6, 3.29, '139 min', 'R', 10.99),
    ('Inglourious Basterds', 'In Nazi-occupied France during World War II, a plan to assassinate Nazi leaders by a group of Jewish U.S. soldiers coincides with a theatre owner\'s vengeful plans.', 2009, 5, 3.99, '153 min', 'R', 14.99);

-- Insert example records into Customer table
INSERT INTO Customer (StoreID, FirstName, LastName, Email, AddressID, CreationDate, LastUpdate, Active)
VALUES 
    (1, 'Alice', 'Johnson', 'alice@example.com', 1, '2023-01-01', CURRENT_TIMESTAMP, 1),
    (2, 'Bob', 'Smith', 'bob@example.com', 2, '2023-02-15', CURRENT_TIMESTAMP, 1),
    (3, 'Eve', 'Brown', 'eve@example.com', 3, '2023-03-20', CURRENT_TIMESTAMP, 1),
    (4, 'Charlie', 'Davis', 'charlie@example.com', 4, '2023-04-10', CURRENT_TIMESTAMP, 1),
    (3, 'Grace', 'Wilson', 'grace@example.com', 5, '2023-05-05', CURRENT_TIMESTAMP, 1),
    (1, 'Oliver', 'Thompson', 'oliver@example.com', 6, '2023-06-10', CURRENT_TIMESTAMP, 1),
    (3, 'Sophie', 'Wright', 'sophie@example.com', 7, '2023-07-15', CURRENT_TIMESTAMP, 1),
    (4, 'Henry', 'King', 'henry@example.com', 8, '2023-08-20', CURRENT_TIMESTAMP, 1),
    (2, 'Lily', 'Lee', 'lily@example.com', 9, '2023-09-25', CURRENT_TIMESTAMP, 1),
    (2, 'Max', 'Miller', 'max@example.com', 10, '2023-10-30', CURRENT_TIMESTAMP, 1);

-- Insert example records into Inventory table
INSERT INTO Inventory (FilmID, StoreID)
VALUES 
    (1, 3),
    (2, 4),
    (3, 3),
    (4, 1),
    (5, 4),
    (6, 2),
    (7, 2),
    (8, 2),
    (9, 3),
    (10, 1);

-- Insert example records into Rental table
INSERT INTO Rental (RentalDate, ReturnDate, InventoryID, CustomerID, StaffID, LastUpdate)
VALUES 
    ('2023-01-05', '2023-01-10', 1, 1, 1, CURRENT_TIMESTAMP),
    ('2023-02-20', '2023-02-25', 2, 2, 2, CURRENT_TIMESTAMP),
    ('2023-03-25', '2023-03-28', 3, 3, 3, CURRENT_TIMESTAMP),
    ('2023-04-15', '2023-04-20', 4, 4, 4, CURRENT_TIMESTAMP),
    ('2023-05-10', '2023-05-15', 5, 5, 5, CURRENT_TIMESTAMP),
    ('2023-06-15', '2023-06-20', 6, 6, 6, CURRENT_TIMESTAMP),
    ('2023-07-20', '2023-07-25', 7, 7, 7, CURRENT_TIMESTAMP),
    ('2023-08-25', '2023-08-30', 8, 8, 8, CURRENT_TIMESTAMP),
    ('2023-09-30', '2023-10-05', 9, 9, 9, CURRENT_TIMESTAMP),
    ('2023-10-05', '2023-10-10', 10, 10, 10, CURRENT_TIMESTAMP);
    
-- Insert example records into Payment table
INSERT INTO Payment (CustomerID, StaffID, RentalID, Amount, PaymentDate)
VALUES 
    (1, 1, 1, 14.95, '2023-01-10'),
    (2, 2, 2, 17.45, '2023-02-25'),
    (3, 3, 3, 11.19, '2023-03-28'),
    (4, 4, 4, 13.47, '2023-04-20'),
    (5, 5, 5, 14.95, '2023-05-15'),
    (6, 6, 6, 17.45, '2023-06-20'),
    (7, 7, 7, 11.19, '2023-07-25'),
    (8, 8, 8, 13.47, '2023-08-30'),
    (9, 9, 9, 16.99, '2023-09-30'),
    (10, 10, 10, 19.99, '2023-10-10');


-- REQUIRED QUERIES

-- Basic
-- Returns all rows with a StoreID of 5.
SELECT * FROM customer WHERE StoreID = 5;

-- With order by
-- Returns the title and release year of films with a rental duration longer than 5 days, ordered by the year they were released in descending order.
SELECT Title, ReleaseYear 
	FROM film WHERE RentalDuration > 5
	ORDER BY ReleaseYear DESC;

-- DISTINCT
-- Select each distinct address of the rental company’s customers. (Some customers may have the same address as others.
SELECT DISTINCT CONCAT(a.AddressLine1, ",", a.City, ",", a.ZipCode) as Address
	FROM customer c
	JOIN address a ON c.AddressID = a.AddressID;

-- AND/OR in the WHERE clause
-- Select customers who were added to the movie rental database between the months of April and August 2023.
SELECT CustomerID, concat(FirstName, " ", LastName) AS Name, Email, AddressID
	FROM customer
    WHERE CreationDate>="2023-04-30" AND CreationDate<="2023-08-01";

-- Use of IN
-- Select movies in the database that were released in 1994, 1996, 1999, and 2000.
SELECT * FROM film 
	WHERE ReleaseYear IN (1994, 1996, 1999, 2000);

-- Use of Like
-- Select the name, email address, and staff ID of all staff whose first names begin with “M”.
SELECT StaffID, concat(FirstName," ", LastName) as Name, Email
	FROM staff
	WHERE FirstName LIKE "M%";

-- Aggregate Functions
-- Return the total number of films, the average rental price of the films in the database, the cheapest rate, the highest rate, and their average length of duration.
SELECT COUNT(*) AS "Number of Films",
 FORMAT(AVG(RentalRate), 2) as "Avg Rental Rate", 
 FORMAT(AVG(RentalDuration), 2) as "Average Duration"
 FROM film;
 
-- JOINS

-- Self Join
-- Select staff names, email addresses, and their managers’ names.
SELECT staff.StaffID,
	CONCAT(staff.FirstName, " ", staff.LastName) AS Staff,
    staff.Email as Email,
    CONCAT(manager.FirstName, " ", manager.LastName) AS Manager
FROM staff staff
JOIN staff manager ON staff.ManagerID = manager.StaffID;


-- Inner Join
-- Return the store ID, manager name and phone number of the stores in the database.

SELECT s.StoreID, 
	CONCAT(st.FirstName, " ", st.LastName) AS Manager,
    CONCAT(a.AddressLine1, ",", a.City, ",", a.ZipCode) as Address,
    a.PhoneNumber as PhoneNumber
FROM store s
JOIN staff st ON s.ManagerStaffID = st.StaffID
JOIN address a ON s.AddressID = a.AddressID;

-- Outer Join
-- Select the films in the inventory with their release years and rental rates.

SELECT i.InventoryID,
    f.Title as Title, 
    f.ReleaseYear as ReleaseYear, 
    f.RentalRate as rentalRate
FROM inventory i
RIGHT OUTER JOIN film f ON i.FilmID = f.FilmID;

-- GROUP BY
-- With having
-- Select the release year, average rental duration, average rental rate and average film length, grouped by their release year having an average film length greater than 90 minutes.

SELECT ReleaseYear, FORMAT(AVG(RentalDuration), 2) as Avg_RentalDuration , FORMAT(AVG(RentalRate), 2) as Avg_RentalRate , AVG(FilmLength) as Avg_FilmLength
	FROM film
    GROUP BY ReleaseYear 
    HAVING AVG(FilmLength) > 90
    ORDER BY ReleaseYear ASC;

-- VIEWS

-- A view of the filsm available for rent, their rental durations, rates and replacement costs.
CREATE VIEW films_for_rent(Title, RentalDuration, RentalRate, ReplacementCost)
	AS (SELECT Title, RentalDuration, RentalRate, ReplacementCost FROM film);

-- A view of stores in the database, their addresses, managers, and phone numbers.
CREATE VIEW film_stores(StoreID, Address, Manager, PhoneNumber)
	AS (SELECT s.StoreID, 
    CONCAT(a.AddressLine1, ",", a.City, ",", a.ZipCode) as Address,
    CONCAT(st.FirstName, " ", st.LastName) AS Manager,
    a.PhoneNumber as PhoneNumber
FROM store s
JOIN staff st ON s.ManagerStaffID = st.StaffID
JOIN address a ON s.AddressID = a.AddressID);

-- A view of staff members who work under a manager with their names, emails, addresses and manager names.
CREATE VIEW staff_roster(StaffID, Name, Email, Address, Manager)
	AS (SELECT staff.StaffID,
	CONCAT(staff.FirstName, " ", staff.LastName) AS Staff,
    staff.Email AS Email,
    CONCAT(address.AddressLine1, ",", address.City, ",", address.ZipCode) AS Address,
    CONCAT(manager.FirstName, " ", manager.LastName) AS Manager
FROM staff staff
JOIN staff manager ON staff.ManagerID = manager.StaffID
JOIN address address ON staff.AddressID = address.AddressID);



-- TRIGGERS

-- Insert a current timestamp into the “LastUpdate” row when an entry is made in the “customer” table.
CREATE TRIGGER update_customer_lastupdate
BEFORE INSERT ON Customer
FOR EACH ROW
SET NEW.LastUpdate = CURRENT_TIMESTAMP;


-- Increase the CustomerID automatically when a new entry is made.
CREATE TRIGGER auto_increment_customer_id
BEFORE INSERT ON Customer
FOR EACH ROW
SET NEW.CustomerID = IFNULL((SELECT MAX(CustomerID) FROM Customer), 0) + 1;

-- Set the default CreationDate in the “customer” table to the current date when new entries are made.
CREATE TRIGGER set_default_creation_date
BEFORE INSERT ON Customer
FOR EACH ROW
SET NEW.CreationDate = COALESCE(NEW.CreationDate, CURRENT_DATE);
