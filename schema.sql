CREATE DATABASE IF NOT EXISTS airport_db;
USE airport_db;

CREATE TABLE Airlines (
    airline_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE Airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(100)
);

CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(20) NOT NULL,
    airline_id INT,
    origin_airport_id INT,
    destination_airport_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    gate VARCHAR(10),
    status ENUM('Scheduled','Delayed','Cancelled','Boarding','Departed') DEFAULT 'Scheduled',
    flight_type ENUM('Domestic','International'),
    FOREIGN KEY (airline_id) REFERENCES Airlines(airline_id),
    FOREIGN KEY (origin_airport_id) REFERENCES Airports(airport_id),
    FOREIGN KEY (destination_airport_id) REFERENCES Airports(airport_id)
);

CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    phone VARCHAR(20),
    entry_time DATETIME
);

CREATE TABLE Tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    seat_number VARCHAR(5),
    issued_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (flight_id, seat_number),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Departments (
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE Crew (
    crew_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    department_id INT,
    role VARCHAR(100),
    shift_start DATETIME,
    shift_end DATETIME,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);