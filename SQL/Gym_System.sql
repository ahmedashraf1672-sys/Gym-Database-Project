CREATE DATABASE Gym_System;
USE Gym_System;

-- Customer Table
CREATE TABLE Customer (
    Customer_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);


-- Manager Table
CREATE TABLE Manager (
    Manager_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Phone_Number VARCHAR(20),
    Email VARCHAR(100)
);



-- Gym Table
CREATE TABLE Gym (
    Gym_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100),
    Address VARCHAR(100),
    Street VARCHAR(100),
    City VARCHAR(50),
    Zip_Code VARCHAR(10)
);


-- Employee Table
CREATE TABLE Employee (
    EM_ID INT AUTO_INCREMENT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Hire_Date DATE,
    Phone VARCHAR(20),
    Manager_ID INT,
    Gym_ID INT,
    FOREIGN KEY (Manager_ID) REFERENCES Manager(Manager_ID),
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID)
);


-- Gym Membership Table
CREATE TABLE Gym_membership (
    Mem_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Price DECIMAL(10,2),
    Duration VARCHAR(50),
    Start_Date DATE,
    End_Date DATE,
    Customer_ID INT,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID)
);


-- Workout Class Table
CREATE TABLE Workout_class (
    Class_ID INT AUTO_INCREMENT PRIMARY KEY,
    Class_name VARCHAR(100),
    Class_Date DATE,
    Class_time TIME,
    Gym_ID INT,
    EM_ID INT,
    FOREIGN KEY (Gym_ID) REFERENCES Gym(Gym_ID),
    FOREIGN KEY (EM_ID) REFERENCES Employee(EM_ID)
);


-- Enrolls Table
CREATE TABLE Enrolls (
    Customer_ID INT,
    Class_ID INT,
    PRIMARY KEY (Customer_ID, Class_ID),
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Class_ID) REFERENCES Workout_class(Class_ID)
);

INSERT INTO Customer
(First_name, Last_name, Phone, Email)
VALUES
('Mohamed','Saad','01011111111','ahmed@gmail.com'),
('Mahmoud','Hassan','01022222222','mahmoud@gmail.com'),
('Omar','Khaled','01033333333','omar@gmail.com');
 
INSERT INTO Manager
(First_name, Last_name, Phone_Number, Email)
VALUES
('Ahmed','Ashraf','01104797232','ahmedashraf@gmail.com'),
('Yousef','Adel','01122222222','yousef@gmail.com');

INSERT INTO Gym
(Name, Address, Street, City, Zip_Code)
VALUES
('Giant Fitness Gym','Mobark City','Street 1','Mansoura','12345'),
('Mr.X Gym','Mobark City','Street 2','Mansoura','54321');

INSERT INTO Employee
(First_name, Last_name, Hire_Date, Phone, Manager_ID, Gym_ID)
VALUES
('Hatem','Nabil','2023-01-10','01211111111',1,1),
('Nour','Muhammad','2023-02-15','01222222222',2,2);

INSERT INTO Gym_membership
(Price, Duration, Start_Date, End_Date, Customer_ID)
VALUES
(500,'1 Month','2026-04-01','2026-05-01',1),
(1200,'3 Months','2026-04-01','2026-07-01',2),
(2000,'6 Months','2026-04-01','2026-10-01',3);

INSERT INTO Workout_class
(Class_name, Class_Date, Class_time, Gym_ID, EM_ID)
VALUES
('Boxing','2026-04-25','10:00:00',1,1),
('Cardio','2026-04-26','12:00:00',2,2),
('MMA','2026-04-27','05:00:00',1,2);

INSERT INTO Enrolls VALUES
(1,1),
(2,2),
(3,3);

-- Query 1
-- Purpose: Display customers and the classes they enrolled in

SELECT 
    Customer.First_name,
    Customer.Last_name,
    Workout_class.Class_name,
    Workout_class.Class_Date
FROM Enrolls
JOIN Customer
ON Enrolls.Customer_ID = Customer.Customer_ID
JOIN Workout_class
ON Enrolls.Class_ID = Workout_class.Class_ID;

-- Query 2
-- Purpose: Display employees with their manager names and gym names

SELECT 
    Employee.First_name AS Employee_Name,
    Manager.First_name AS Manager_Name,
    Gym.Name AS Gym_Name
FROM Employee
JOIN Manager
ON Employee.Manager_ID = Manager.Manager_ID
JOIN Gym
ON Employee.Gym_ID = Gym.Gym_ID;

-- Query 3
-- Purpose: Count number of employees in each gym using GROUP BY

SELECT 
    Gym.Name,
    COUNT(Employee.EM_ID) AS Number_Of_Employees
FROM Gym
JOIN Employee
ON Gym.Gym_ID = Employee.Gym_ID
GROUP BY Gym.Name;

-- Query 4
-- Purpose: Find customers who have memberships costing more than average price
-- (Subquery)

SELECT 
    First_name,
    Last_name
FROM Customer
WHERE Customer_ID IN (
    SELECT Customer_ID
    FROM Gym_membership
    WHERE Price > (
        SELECT AVG(Price)
        FROM Gym_membership
    )
);

-- Query 5
-- Purpose: Show total membership revenue grouped by duration

SELECT 
    Duration,
    SUM(Price) AS Total_Revenue
FROM Gym_membership
GROUP BY Duration;