CREATE DATABASE AirportTicketingSystemsssss

USE AirportTicketingSystemsssss
GO

CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) CHECK (Role IN ('Ticketing Staff', 'Ticketing Supervisor'))
);

INSERT INTO Employee (Name, Email, Username, PasswordHash, Role)
VALUES 
('Hannah Brown', 'hannah.brown@example.com', 'brownh', '8765432', 'Ticketing Staff'),
('Isaac Turner', 'isaac.turner@example.com', 'turneri', '7654321', 'Ticketing Supervisor'),
('Jasmine Clarke', 'jasmine.clarke@example.com', 'clarkej', '6543210', 'Ticketing Staff'),
('Kyle Bennett', 'kyle.bennett@example.com', 'bennettk', '5432109', 'Ticketing Staff'),
('Lena Hughes', 'lena.hughes@example.com', 'hughesl', '4321098', 'Ticketing Supervisor'),
('Marcus Young', 'marcus.young@example.com', 'youngm', '3210987', 'Ticketing Staff'),
('Natalie Scott', 'natalie.scott@example.com', 'scottn', '2109876', 'Ticketing Staff');

SELECT *
FROM Employee


CREATE TABLE Passenger (
    PassengerID INT PRIMARY KEY IDENTITY(1,1),
    PNR VARCHAR(20) UNIQUE NOT NULL,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DoB DATE,
    Meal VARCHAR(20) CHECK (Meal IN ('Vegetarian', 'Non-Vegetarian')),
    EmergencyContact VARCHAR(15) NULL
);

INSERT INTO Passenger (PNR, FirstName, LastName, Email, DoB, Meal, EmergencyContact)
VALUES
('PNR015N97', 'Liam', 'Anderson', 'liam.anderson@example.com', '1990-07-12', 'Non-Vegetarian', '07123456789'),
('PNR016O98', 'Sophia', 'Clark', 'sophia.clark@example.com', '1995-11-03', 'Vegetarian', NULL),
('PNR017P99', 'William', 'Roberts', 'william.roberts@example.com', '1988-02-27', 'Non-Vegetarian', '07234567890'),
('PNR018Q00', 'Ava', 'Walker', 'ava.walker@example.com', '1992-09-09', 'Vegetarian', '07345678901'),
('PNR019R01', 'Jacob', 'Hall', 'jacob.hall@example.com', '1983-05-15', 'Non-Vegetarian', NULL),
('PNR020S02', 'Emily', 'Young', 'emily.young@example.com', '1999-12-31', 'Vegetarian', '07456789012'),
('PNR021T03', 'Michael', 'King', 'michael.king@example.com', '1979-06-06', 'Non-Vegetarian', '07567890123');

SELECT * 
FROM Passenger


CREATE TABLE Flight (
    FlightID INT PRIMARY KEY IDENTITY(1,1),
    FlightNumber VARCHAR(20) UNIQUE NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    Origin VARCHAR(50),
    Destination VARCHAR(50)
);

INSERT INTO Flight (FlightNumber, DepartureTime, ArrivalTime, Origin, Destination)
VALUES
('LH320', '2025-06-08 07:30:00', '2025-06-08 10:15:00', 'London Heathrow', 'Frankfurt'),
('BA450', '2025-06-09 14:20:00', '2025-06-09 16:55:00', 'Manchester', 'Madrid'),
('AF789', '2025-06-10 05:50:00', '2025-06-10 08:20:00', 'Bristol', 'Paris Charles de Gaulle'),
('EK010', '2025-06-11 21:45:00', '2025-06-12 07:30:00', 'London Gatwick', 'Dubai'),
('QR306', '2025-06-12 11:10:00', '2025-06-12 19:50:00', 'London Heathrow', 'Doha'),
('SU102', '2025-06-13 08:25:00', '2025-06-13 14:00:00', 'Edinburgh', 'Moscow'),
('JL404', '2025-06-14 17:35:00', '2025-06-15 13:15:00', 'London Heathrow', 'Tokyo Haneda');

SELECT * 
FROM Flight


CREATE TABLE Reservation (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    PNR VARCHAR(20) FOREIGN KEY REFERENCES Passenger(PNR),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID),
    ReservationDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    ReservationStatus VARCHAR(20) CHECK (ReservationStatus IN ('Confirmed', 'Pending', 'Cancelled')),
    PreferredSeat VARCHAR(10) NULL,
    CONSTRAINT chk_reservation_date CHECK (ReservationDate >= CAST(GETDATE() AS DATE))
);

INSERT INTO Reservation (PNR, FlightID, ReservationStatus, PreferredSeat)
VALUES
('PNR015N97', 1, 'Confirmed', '12C'),
('PNR016O98', 2, 'Pending', NULL),
('PNR017P99', 3, 'Confirmed', '8A'),
('PNR018Q00', 4, 'Cancelled', '20D'),
('PNR019R01', 5, 'Pending', NULL),
('PNR020S02', 6, 'Confirmed', '6F'),
('PNR021T03', 7, 'Confirmed', '15B');

SELECT *
FROM Reservation

CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    ReservationID INT FOREIGN KEY REFERENCES Reservation(ReservationID),
    IssueDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    IssueTime TIME NOT NULL DEFAULT CAST(GETDATE() AS TIME),
    Fare DECIMAL(10,2),
    SeatNumber VARCHAR(10),
    Class VARCHAR(20) CHECK (Class IN ('Business', 'FirstClass', 'Economy')),
    EBoardingNumber VARCHAR(30) UNIQUE NOT NULL,
    IssuedBy INT FOREIGN KEY REFERENCES Employee(EmployeeID)
);

INSERT INTO Ticket (ReservationID, Fare, SeatNumber, Class, EBoardingNumber, IssuedBy)
VALUES
(1, 460.00, '12C', 'Economy', 'EB008-UA808', 1),
(2, 520.75, '14A', 'Economy', 'EB009-TK909', 2),
(3, 730.00, '8A', 'Business', 'EB010-AY010', 3),
(4, 1085.25, '20D', 'FirstClass', 'EB011-CX111', 4),
(5, 310.00, '13F', 'Economy', 'EB012-SQ212', 5),
(6, 610.00, '6F', 'Business', 'EB013-KL313', 6),
(7, 1120.50, '15B', 'FirstClass', 'EB014-AI717', 7);

SELECT *
FROM Ticket

CREATE TABLE AddedService (
    ServiceID INT PRIMARY KEY IDENTITY(1,1),
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID),
    ExtraBaggageKg INT DEFAULT 0,
    MealUpgrade BIT DEFAULT 0,
    PreferredSeat BIT DEFAULT 0
);

INSERT INTO AddedService (TicketID, ExtraBaggageKg, MealUpgrade, PreferredSeat)
VALUES
(1, 7, 1, 1),
(2, 0, 0, 0),
(3, 10, 1, 0),
(4, 20, 1, 1),
(5, 0, 0, 1),
(6, 5, 1, 0),
(7, 18, 1, 1);

SELECT *
FROM AddedService

CREATE TABLE Baggage (
    BaggageID INT PRIMARY KEY IDENTITY(1,1),
    TicketID INT FOREIGN KEY REFERENCES Ticket(TicketID),
    BaggageWeight DECIMAL(5,2),
    BaggageStatus VARCHAR(20) CHECK (BaggageStatus IN ('CheckedIn', 'Loaded'))
);

INSERT INTO Baggage (TicketID, BaggageWeight, BaggageStatus)
VALUES
(1, 22.00, 'CheckedIn'),   
(2, 15.00, 'CheckedIn'),   
(3, 25.00, 'Loaded'),     
(4, 35.00, 'CheckedIn'), 
(5, 15.00, 'Loaded'),     
(6, 20.00, 'CheckedIn'),  
(7, 33.00, 'Loaded');

SELECT * 
FROM Baggage


CREATE TABLE Seat (
    SeatID INT PRIMARY KEY IDENTITY(1,1),
    FlightID INT FOREIGN KEY REFERENCES Flight(FlightID),
    SeatNumber VARCHAR(10) UNIQUE NOT NULL,  
    SeatStatus VARCHAR(20) CHECK (SeatStatus IN ('Available', 'Reserved')) DEFAULT 'Available' ,
    UNIQUE (FlightID, SeatNumber) 
);

INSERT INTO Seat (FlightID, SeatNumber, SeatStatus)
VALUES 
   (1, '12C', 'Reserved'),
    (1, '10B', 'Available'),
    (2, '14A', 'Reserved'),
    (2, '12D', 'Available'),
    (3, '8A', 'Reserved'),
    (3, '4B', 'Available'),
    (4, '20D', 'Reserved'),
    (4, '6F', 'Available'),
    (5, '13F', 'Reserved'),
    (5, '8C', 'Available'),
    (6, '6D', 'Reserved'),
    (6, '2A', 'Available'),
    (7, '15B', 'Reserved'),
    (7, '11D', 'Available');

select *
FROM Seat

-- pending reservations of passengers over 40 years
SELECT p.PNR, p.FirstName, p.LastName, DATEDIFF(YEAR, p.DoB, GETDATE()) AS Age, r.ReservationStatus
FROM Passenger p
JOIN Reservation r ON p.PNR = r.PNR
WHERE r.ReservationStatus = 'Pending'
   AND DATEDIFF(YEAR, p.DoB, GETDATE()) > 40;


-- Search passenger by last name
GO
CREATE PROCEDURE PrintTicketsByLastNames
    @LastName VARCHAR(50)
AS
BEGIN
    SELECT p.PassengerID, p.FirstName, p.LastName, t.TicketID, t.IssueDate, t.IssueTime, t.Class, t.Fare
    FROM Passenger p
    JOIN Reservation r ON p.PNR = r.PNR
    JOIN Ticket t ON r.ReservationID = t.ReservationID
    WHERE p.LastName LIKE @LastName  
    ORDER BY t.IssueDate DESC, t.IssueTime DESC;
END;

EXEC PrintTicketsByLastNames @LastName = '[A-M]%';

-- Business class passengers with meal requirements
GO
CREATE PROCEDURE BusinessPassengersWithReservationsToday
AS
BEGIN
    SELECT p.PassengerID, p.FirstName, p.LastName, p.Meal, r.ReservationDate, t.Class
    FROM Passenger p
    JOIN Reservation r ON p.PNR = r.PNR
    JOIN Ticket t ON r.ReservationID = t.ReservationID
    WHERE r.ReservationDate = CAST(GETDATE() AS DATE)
        AND t.Class = 'Business';
END;

EXEC BusinessPassengersWithReservationsToday;



-- Insert a new employee
GO
CREATE PROCEDURE InsertEmployee
    @Name VARCHAR(100),
    @Email VARCHAR(100),
    @Username VARCHAR(50),
    @Password VARCHAR(255),
    @Role VARCHAR(20)
AS
BEGIN
    -- Insert the new employee into the Employee table
    INSERT INTO Employee (Name, Email, Username, PasswordHash, Role)
    VALUES (@Name, @Email, @Username, @Password, @Role);
    
    SELECT * FROM Employee WHERE Email = @Email;
END;

EXEC InsertEmployee 
    @Name = 'Kane Doe', 
    @Email = 'kane.doe@example.com', 
    @Username = 'kane_doe123', 
    @Password = '0857456', 
    @Role = 'Ticketing Staff';

-- Update passgenger details
GO
CREATE PROCEDURE UpdatePassengerDetail
    @PNR VARCHAR(20),                
    @FirstName VARCHAR(50) = NULL,    
    @LastName VARCHAR(50) = NULL,     
    @Email VARCHAR(100) = NULL,       
    @Meal VARCHAR(20) = NULL,
    @DateofBirth DATE = NULL, 
    @EmergencyContact VARCHAR(15) = NULL         
AS
BEGIN
    -- Update the passenger's details if provided
    UPDATE Passenger
    SET 
        FirstName = COALESCE(@FirstName, FirstName),  
        LastName = COALESCE(@LastName, LastName),     
        Email = COALESCE(@Email, Email),              
        Meal = COALESCE(@Meal, Meal),
        DoB = COALESCE(@DateofBirth, DoB),
        EmergencyContact = COALESCE(@EmergencyContact, EmergencyContact)                 
    WHERE PNR = @PNR;  

    SELECT * FROM Passenger WHERE PNR = @PNR;
END;

EXEC UpdatePassengerDetail 
    @PNR = 'PNR018Q00', 
    @Meal = 'Non-Vegetarian';
GO
-- ======================================
-- View
-- ======================================
CREATE VIEW EmployeeRevenueByFlight AS
SELECT 
    e.EmployeeID,
    e.Name AS EmployeeName,
    t.EBoardingNumber,
    f.FlightID,
    f.FlightNumber,
    t.Fare,
    -- Calculate total baggage fee (assuming each kg costs a fixed rate of 10.00 per kg)
    ISNULL(a.ExtraBaggageKg, 0) * 10 AS BaggageFee,  
    -- Calculate meal upgrade fee (assuming upgrade costs a fixed rate of 20.00)
    CASE 
        WHEN a.MealUpgrade = 1 THEN 20 
        ELSE 0 
    END AS MealUpgradeFee,
    -- Calculating preferred seat fee (assuming a fixed fee of 50.00)
    CASE 
        WHEN a.PreferredSeat = 1 THEN 50 
        ELSE 0 
    END AS SeatFee,
    -- Total revenue = fare + baggage fee + meal upgrade + seat fee
    (t.Fare + 
        ISNULL(a.ExtraBaggageKg, 0) * 10 + 
        CASE WHEN a.MealUpgrade = 1 THEN 20 ELSE 0 END + 
        CASE WHEN a.PreferredSeat = 1 THEN 50 ELSE 0 END
    ) AS TotalRevenue
FROM Ticket t
JOIN Reservation r ON t.ReservationID = r.ReservationID
JOIN Employee e ON t.IssuedBy = e.EmployeeID
JOIN Flight f ON r.FlightID = f.FlightID
LEFT JOIN AddedService a ON t.TicketID = a.TicketID;
GO

SELECT * 
FROM EmployeeRevenueByFlight
WHERE EmployeeID IN (1, 2, 3);  

-- ======================================
-- Update seat status
-- ======================================
GO
CREATE TRIGGER ReserveSeatOnTicket
ON Ticket
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE S
    SET S.SeatStatus = 'Reserved'
    FROM Seat S
    INNER JOIN (
        SELECT 
            I.SeatNumber,
            R.FlightID
        FROM INSERTED I
        INNER JOIN Reservation R ON I.ReservationID = R.ReservationID
        WHERE I.SeatNumber IS NOT NULL
    ) AS Temp ON S.SeatNumber = Temp.SeatNumber AND S.FlightID = Temp.FlightID
    WHERE S.Seatstatus = 'Available';  -- Safeguard: only update available seats
END;

-- Testing trigger
INSERT INTO Passenger (PNR, FirstName, LastName, Email, DoB, Meal, EmergencyContact)
VALUES ('PNR009H93', 'Alice', 'Smith', 'alice.smith@example.com', '1989-03-25', 'Vegetarian', '07123456789');

INSERT INTO Reservation (PNR, FlightID, ReservationStatus, PreferredSeat)
VALUES ('PNR009H93', 1, 'Pending', '10B');

INSERT INTO Ticket (ReservationID, Fare, SeatNumber, Class, EBoardingNumber, IssuedBy)
VALUES ((SELECT ReservationID FROM Reservation WHERE PNR = 'PNR009H93'), 550.00, '10B', 'Economy', 'EB009-AC103', 1);

INSERT INTO AddedService (TicketID, ExtraBaggageKg, MealUpgrade, PreferredSeat)
VALUES ((SELECT TicketID FROM Ticket WHERE EBoardingNumber = 'EB009-AC103'), 10, 1, 0);

SELECT * 
FROM Seat 
WHERE SeatNumber = '10B' AND FlightID = 1;


-- =============================================
-- Total Number of Baggages Checked in
-- =============================================
GO
CREATE VIEW CheckedInBaggageByDateView AS
SELECT F.FlightID, F.FlightNumber, COUNT(B.BaggageID) AS TotalCheckedInBaggage, CAST(T.IssueDate AS DATE) AS TicketDate
FROM Flight F
JOIN Reservation R ON F.FlightID = R.FlightID
JOIN Ticket T ON R.ReservationID = T.ReservationID
JOIN Baggage B ON T.TicketID = B.TicketID
WHERE B.BaggageStatus = 'CheckedIn'
GROUP BY F.FlightID, F.FlightNumber, CAST(T.IssueDate AS DATE);
GO

SELECT TotalCheckedInBaggage
FROM CheckedInBaggageByDateView
WHERE FlightID = 1
AND TicketDate = CAST(GETDATE() AS DATE);


-- Flight occupancy
GO
CREATE VIEW FlightsOccupancys AS
SELECT 
    f.FlightID,
    f.FlightNumber,
    f.Origin,
    f.Destination,
    COUNT(s.SeatID) AS TotalSeats, -- Total number of seats for the flight
    COUNT(t.TicketID) AS ReservedSeats, -- Total number of reserved seats (tickets issued)
    COUNT(CASE WHEN s.SeatStatus = 'Available' THEN 1 END) AS SeatsRemaining -- Number of available seats
FROM Flight f
LEFT JOIN Seat s ON f.FlightID = s.FlightID
LEFT JOIN Reservation r ON f.FlightID = r.FlightID
LEFT JOIN Ticket t ON t.ReservationID = r.ReservationID AND t.SeatNumber = s.SeatNumber
GROUP BY f.FlightID, f.FlightNumber, f.Origin, f.Destination;
GO

SELECT * FROM FlightsOccupancys WHERE FlightID = 1;

-- Get passenger itinerary
Go 
CREATE PROCEDURE GetPassengerItinerary 
@PNR VARCHAR(10)
AS
BEGIN
    SELECT 
        p.FirstName, p.LastName, f.FlightNumber, f.Origin, f.Destination, f.DepartureTime
    FROM Passenger p
    JOIN Reservation r ON p.PNR = r.PNR
    JOIN Flight f ON r.FlightID = f.FlightID
    WHERE p.PNR = @PNR;
END;

EXEC GetPassengerItinerary @PNR = 'PNR021T03';


-- Authorization: 
CREATE ROLE TicketingStaff;
CREATE ROLE TicketingSupervisor;

-- Grant read access
GRANT SELECT ON Passenger TO TicketingStaff;
GRANT SELECT ON Reservation TO TicketingStaff;
GRANT SELECT ON Flight TO TicketingStaff;
GRANT SELECT ON Ticket TO TicketingStaff;
GRANT SELECT ON Seat TO TicketingStaff;
GRANT SELECT ON Baggage TO TicketingStaff;

-- Grant for insert
GRANT INSERT ON Reservation TO TicketingStaff;
GRANT INSERT ON Ticket TO TicketingStaff;
GRANT INSERT ON AddedService TO TicketingStaff;
GRANT INSERT ON Baggage TO TicketingStaff;

-- Grant for staff procedure access
GRANT EXECUTE ON PrintTicketsByLastNames TO TicketingStaff;
GRANT EXECUTE ON UpdatePassengerDetail TO TicketingStaff;
GRANT EXECUTE ON GetPassengerItinerary TO TicketingStaff;

-- SELECT INSERT UPDATE AND DELETE permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON Passenger TO TicketingSupervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON Reservation TO TicketingSupervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON Ticket TO TicketingSupervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON AddedService TO TicketingSupervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON Baggage TO TicketingSupervisor;

-- View and manage employees
GRANT SELECT, INSERT, UPDATE, DELETE ON Employee TO TicketingSupervisor;

-- Grant for supervisor procedure access
GRANT EXECUTE ON PrintTicketsByLastNames TO TicketingSupervisor;
GRANT EXECUTE ON UpdatePassengerDetail TO TicketingSupervisor;
GRANT EXECUTE ON GetPassengerItinerary TO TicketingSupervisor;
GRANT EXECUTE ON InsertEmployee TO TicketingSupervisor;
GRANT EXECUTE ON BusinessPassengersWithReservationsToday TO TicketingSupervisor;

-- Assign all employees to roles based on their job role
DECLARE @Username NVARCHAR(50), @Role NVARCHAR(50), @SQL NVARCHAR(MAX);

DECLARE EmployeeCursor CURSOR FOR
SELECT Username, Role FROM Employee;

OPEN EmployeeCursor;
FETCH NEXT FROM EmployeeCursor INTO @Username, @Role;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = '';

    IF @Role = 'Ticketing Staff'
        SET @SQL = 'EXEC sp_addrolemember ''TicketingStaff'', [' + @Username + '];';
    ELSE IF @Role = 'Ticketing Supervisor'
        SET @SQL = 'EXEC sp_addrolemember ''TicketingSupervisor'', [' + @Username + '];';

    -- check if the user exists before assigning the role
    IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @Username)
        EXEC sp_executesql @SQL;
    ELSE
        PRINT 'User ' + @Username + ' does not exist in the database.';

    FETCH NEXT FROM EmployeeCursor INTO @Username, @Role;
END

CLOSE EmployeeCursor;
DEALLOCATE EmployeeCursor;

-- Data Protection: 
-- BackUp Database AirportTicketSystem
-- Regular Full Backup
BACKUP DATABASE AirportTicketingSystem
TO DISK = 'C:\Backup\AirportTicketingSystem_Full_20250418.bak'
WITH INIT, NAME = 'Full Database Backup';

-- Transaction Log Backup
BACKUP LOG AirportTicketingSystem
TO DISK = 'C:\Backup\AirportTicketingSystem_Log_20250418_1500.trn';

-- Differential Backup
BACKUP DATABASE AirportTicketingSystem
TO DISK = 'C:\Backup\AirportTicketingSystem_Diff_20250418.bak'
WITH DIFFERENTIAL; 

-- TEST BACKUP INTEGRITY
RESTORE VERIFYONLY 
FROM DISK = 'C:\Backup\AirportTicketingSystem_Full_20250418.bak'

-- DISASTER RECOVERY 
RESTORE DATABASE AirportTicketingSystem
FROM DISK = 'C:\Backup\AirportTicketingSystem_Full_20250418.bak'
WITH NORECOVERY; 

RESTORE DATABASE AirportTicketingSystem
FROM DISK = 'C:\Backup\AirportTicketingSystem_LOG_20250418.TRN'
WITH RECOVERY, STOPAT = '2025-04-20T16:30:00'; 