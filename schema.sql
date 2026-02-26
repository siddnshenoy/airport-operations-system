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

USE airport_db;

INSERT INTO Airlines (name) VALUES
('Air India'),
('IndiGo'),
('SpiceJet'),
('Emirates'),
('Lufthansa');

INSERT INTO Airports (name, city) VALUES
('Chhatrapati Shivaji International', 'Mumbai'),
('Indira Gandhi International', 'Delhi'),
('Kempegowda International', 'Bangalore'),
('Dubai International', 'Dubai'),
('Frankfurt International', 'Frankfurt');

INSERT INTO Flights
(flight_number, airline_id, origin_airport_id, destination_airport_id,
 departure_time, arrival_time, gate, status, flight_type)
VALUES
('AI101', 1, 1, 2, '2026-03-01 14:00:00', '2026-03-01 16:00:00', 'A1', 'Scheduled', 'Domestic'),
('6E202', 2, 2, 3, '2026-03-01 18:00:00', '2026-03-01 20:00:00', 'A2', 'Scheduled', 'Domestic'),
('SG303', 3, 3, 1, '2026-03-01 22:00:00', '2026-03-02 00:00:00', 'A3', 'Scheduled', 'Domestic'),
('EK404', 4, 1, 4, '2026-03-02 05:00:00', '2026-03-02 08:00:00', 'B1', 'Scheduled', 'International'),
('LH505', 5, 2, 5, '2026-03-02 09:00:00', '2026-03-02 14:00:00', 'B2', 'Scheduled', 'International'),
('AI606', 1, 3, 2, '2026-03-02 11:00:00', '2026-03-02 13:00:00', 'A4', 'Scheduled', 'Domestic'),
('6E707', 2, 1, 3, '2026-03-02 15:00:00', '2026-03-02 17:00:00', 'A5', 'Scheduled', 'Domestic'),
('SG808', 3, 2, 1, '2026-03-02 19:00:00', '2026-03-02 21:00:00', 'A6', 'Scheduled', 'Domestic'),
('EK909', 4, 3, 4, '2026-03-02 23:00:00', '2026-03-03 04:00:00', 'B3', 'Scheduled', 'International'),
('LH010', 5, 1, 5, '2026-03-03 07:00:00', '2026-03-03 13:00:00', 'B4', 'Scheduled', 'International');

DELIMITER $$

CREATE PROCEDURE generate_flights()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE dep DATETIME;

    WHILE i <= 200 DO

        SET dep = DATE_ADD('2026-03-01 00:00:00', INTERVAL i HOUR);

        INSERT INTO Flights
        (flight_number, airline_id, origin_airport_id, destination_airport_id,
         departure_time, arrival_time, gate, status, flight_type)
        VALUES
        (
            CONCAT('FL', LPAD(i, 3, '0')),
            FLOOR(1 + RAND()*5),
            FLOOR(1 + RAND()*5),
            FLOOR(1 + RAND()*5),
            dep,
            DATE_ADD(dep, INTERVAL (1 + FLOOR(RAND()*5)) HOUR),
            CONCAT('G', FLOOR(1 + RAND()*20)),
            'Scheduled',
            IF(RAND() > 0.7, 'International', 'Domestic')
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_flights();

CALL generate_flights();

DELETE FROM Flights WHERE flight_id <= 10;

SELECT COUNT(*) FROM Flights;