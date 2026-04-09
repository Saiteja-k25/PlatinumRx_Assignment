-- =============================================================
--  PlatinumRx Assignment | Hotel Management System
--  File : 01_Hotel_Schema_Setup.sql
--  Phase: 1 — Schema creation + sample data insertion
-- =============================================================

-- -------------------------------------------------------------
-- DROP existing tables (safe re-run)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- -------------------------------------------------------------
-- CREATE TABLES
-- -------------------------------------------------------------

CREATE TABLE users (
    user_id         VARCHAR(50)  PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

CREATE TABLE bookings (
    booking_id   VARCHAR(50)  PRIMARY KEY,
    booking_date DATETIME     NOT NULL,
    room_no      VARCHAR(50),
    user_id      VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
    item_id   VARCHAR(50)   PRIMARY KEY,
    item_name VARCHAR(100)  NOT NULL,
    item_rate DECIMAL(10,2) NOT NULL
);

CREATE TABLE booking_commercials (
    id            VARCHAR(50)   PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- -------------------------------------------------------------
-- INSERT SAMPLE DATA  (from PDF)
-- -------------------------------------------------------------

INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('21wrcxuy-67erfn', 'John Doe',  '9700000001', 'john.doe@example.com',  'XX, Street Y, ABC City'),
('22abcdef-111111', 'Alice Roy', '9700000002', 'alice.roy@example.com',  'YY, Street Z, XYZ City'),
('23ghijkl-222222', 'Bob Singh', '9700000003', 'bob.singh@example.com', 'ZZ, Street A, PQR City');

INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-a9e8-q8fu',  'Tawa Paratha',    18.00),
('itm-a07vh-aer8', 'Mix Veg',         89.00),
('itm-w978-23u4',  'Paneer Butter',  120.00),
('itm-b123-xyz1',  'Masala Chai',     30.00),
('itm-c456-xyz2',  'Dal Fry',         75.00);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-q034-q4o',   '2021-10-05 09:00:00', 'rm-cx12-bfgh',  '22abcdef-111111'),
('bk-n001-nov1',  '2021-11-03 10:00:00', 'rm-dx34-cijk',  '21wrcxuy-67erfn'),
('bk-n002-nov2',  '2021-11-15 14:00:00', 'rm-ex56-dlmn',  '23ghijkl-222222'),
('bk-n003-nov3',  '2021-11-28 08:00:00', 'rm-fx78-eopq',  '22abcdef-111111'),
('bk-d001-dec1',  '2021-12-10 11:00:00', 'rm-gx90-frst',  '23ghijkl-222222');

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- Sep booking (for Q3 Oct test — same bill raised in Oct)
('bc-001', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3.0),
('bc-002', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1.0),
-- Oct booking — bill > 1000 for Q3
('bc-003', 'bk-q034-q4o',   'bl-oct1-0001',  '2021-10-05 12:05:37', 'itm-w978-23u4',  8.0),
('bc-004', 'bk-q034-q4o',   'bl-oct1-0001',  '2021-10-05 12:05:37', 'itm-a07vh-aer8', 3.0),
-- Nov bookings for Q2, Q4, Q5
('bc-005', 'bk-n001-nov1',  'bl-nov1-0001',  '2021-11-03 09:00:00', 'itm-a9e8-q8fu',  5.0),
('bc-006', 'bk-n001-nov1',  'bl-nov1-0001',  '2021-11-03 09:00:00', 'itm-b123-xyz1',  4.0),
('bc-007', 'bk-n002-nov2',  'bl-nov2-0001',  '2021-11-15 10:00:00', 'itm-w978-23u4',  6.0),
('bc-008', 'bk-n002-nov2',  'bl-nov2-0001',  '2021-11-15 10:00:00', 'itm-c456-xyz2',  2.0),
('bc-009', 'bk-n003-nov3',  'bl-nov3-0001',  '2021-11-28 11:00:00', 'itm-a9e8-q8fu', 10.0),
('bc-010', 'bk-n003-nov3',  'bl-nov3-0001',  '2021-11-28 11:00:00', 'itm-a07vh-aer8', 5.0),
-- Dec booking
('bc-011', 'bk-d001-dec1',  'bl-dec1-0001',  '2021-12-10 08:00:00', 'itm-paneer',     3.0);
