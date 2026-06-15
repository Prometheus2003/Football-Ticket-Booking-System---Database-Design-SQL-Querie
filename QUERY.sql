-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
  user_id int PRIMARY KEY,
  full_name varchar(50) NOT NULL,
  email varchar(100) UNIQUE,
  role varchar(20) NOT NULL CHECK (role IN ('Ticket Manager', 'Football Fan')),
  phone_number varchar(20)
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
  match_id int PRIMARY KEY,
  fixture varchar(100) NOT NULL,
  tournament_category varchar(100) NOT NULL,
  base_ticket_price int CHECK (base_ticket_price >= 0),
  match_status varchar(50) NOT NULL CHECK (
    match_status IN (
      'Available',
      'Selling Fast',
      'Sold Out',
      'postponed'
    )
  )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
  booking_id int PRIMARY KEY,
  user_id int,
  match_id int,
  seat_number varchar(50),
  payment_status varchar(50) CHECK (
    payment_status IN ('Pending', 'Confirmed', 'Cancelled', 'Refunded')
    OR payment_status IS NULL
  ),
  total_cost int CHECK (total_cost >= 0),
  FOREIGN key (user_id) REFERENCES Users (user_id),
  FOREIGN key (match_id) REFERENCES Matches (match_id)
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);
--

--
Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.
SELECT
  match_id, fixture, base_ticket_price
FROM
  Matches
WHERE
  tournament_category = 'Champions League'
  AND match_status = 'Available';
-------------------------------------------------
Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
SELECT
  user_id,
  full_name,
  email
FROM
  Users
WHERE
  full_name ILIKE 'Tanvir%'
  OR full_name ILIKE '%Haque%';
-------------------------------------------------
Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
SELECT
  booking_id,
  user_id,
  match_id,
  coalesce(payment_status, 'Action Required') AS systematic_status
FROM
  Bookings
WHERE
  payment_status IS NULL;

-------------------------------------------------------------
Query 4: Retrieve match booking details along with the User full name and the scheduled Match fixture teams.

SELECT
  b.booking_id,
  u.full_name,
  m.fixture,
  b.total_cost
FROM
  Bookings b
  INNER JOIN Users u ON b.user_id = u.user_id
  INNER JOIN Matches m ON b.match_id = m.match_id;

-----------------------------------------------------------


