-- =============================================================
--  PlatinumRx Assignment | Clinic Management System
--  File : 03_Clinic_Schema_Setup.sql
--  Phase: 1 — Schema creation + sample data insertion
-- =============================================================

-- -------------------------------------------------------------
-- DROP existing tables (safe re-run)
-- -------------------------------------------------------------
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- -------------------------------------------------------------
-- CREATE TABLES
-- -------------------------------------------------------------

CREATE TABLE clinics (
    cid         VARCHAR(50)  PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

CREATE TABLE customer (
    uid    VARCHAR(50)  PRIMARY KEY,
    name   VARCHAR(100) NOT NULL,
    mobile VARCHAR(15)
);

CREATE TABLE clinic_sales (
    oid           VARCHAR(50)   PRIMARY KEY,
    uid           VARCHAR(50),
    cid           VARCHAR(50),
    amount        DECIMAL(12,2) NOT NULL,
    datetime      DATETIME      NOT NULL,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid         VARCHAR(50)   PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(12,2) NOT NULL,
    datetime    DATETIME      NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- -------------------------------------------------------------
-- INSERT SAMPLE DATA
-- -------------------------------------------------------------

-- Clinics (multiple cities & states for Q4/Q5)
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'Apollo Clinic',    'Mumbai',    'Maharashtra', 'India'),
('cnc-0100002', 'Care Plus',        'Mumbai',    'Maharashtra', 'India'),
('cnc-0100003', 'HealthFirst',      'Mumbai',    'Maharashtra', 'India'),
('cnc-0100004', 'Sunrise Clinic',   'Pune',      'Maharashtra', 'India'),
('cnc-0100005', 'MedLife Clinic',   'Pune',      'Maharashtra', 'India'),
('cnc-0100006', 'City Health',      'Hyderabad', 'Telangana',   'India'),
('cnc-0100007', 'WellCare Clinic',  'Hyderabad', 'Telangana',   'India'),
('cnc-0100008', 'PrimeCare',        'Hyderabad', 'Telangana',   'India');

-- Customers
INSERT INTO customer (uid, name, mobile) VALUES
('cust-001', 'Jon Doe',     '9700000001'),
('cust-002', 'Priya Shah',  '9700000002'),
('cust-003', 'Ravi Kumar',  '9700000003'),
('cust-004', 'Anita Roy',   '9700000004'),
('cust-005', 'Suresh Nair', '9700000005');

-- Clinic Sales (2021 — various months, channels, clinics)
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
-- January
('ord-001', 'cust-001', 'cnc-0100001', 24999, '2021-01-10 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-0100002',  8500, '2021-01-15 11:00:00', 'walkin'),
('ord-003', 'cust-003', 'cnc-0100003', 12000, '2021-01-20 12:00:00', 'sodat'),
-- February
('ord-004', 'cust-001', 'cnc-0100001', 31000, '2021-02-05 09:00:00', 'online'),
('ord-005', 'cust-004', 'cnc-0100004',  9500, '2021-02-14 10:00:00', 'walkin'),
('ord-006', 'cust-005', 'cnc-0100005',  7000, '2021-02-22 14:00:00', 'sodat'),
-- March
('ord-007', 'cust-002', 'cnc-0100006', 15000, '2021-03-08 10:00:00', 'online'),
('ord-008', 'cust-003', 'cnc-0100007',  5500, '2021-03-17 11:00:00', 'walkin'),
('ord-009', 'cust-001', 'cnc-0100001', 22000, '2021-03-25 13:00:00', 'online'),
-- September
('ord-010', 'cust-001', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'sodat'),
('ord-011', 'cust-002', 'cnc-0100002', 18000, '2021-09-10 09:00:00', 'online'),
('ord-012', 'cust-003', 'cnc-0100006',  9200, '2021-09-18 10:00:00', 'walkin'),
-- October
('ord-013', 'cust-004', 'cnc-0100004', 42000, '2021-10-05 11:00:00', 'online'),
('ord-014', 'cust-005', 'cnc-0100007',  6800, '2021-10-12 14:00:00', 'walkin'),
('ord-015', 'cust-001', 'cnc-0100008', 11500, '2021-10-20 10:00:00', 'sodat'),
-- November
('ord-016', 'cust-002', 'cnc-0100001', 27000, '2021-11-03 09:00:00', 'online'),
('ord-017', 'cust-003', 'cnc-0100003', 14500, '2021-11-15 11:00:00', 'walkin'),
-- December
('ord-018', 'cust-004', 'cnc-0100005', 19000, '2021-12-08 10:00:00', 'sodat'),
('ord-019', 'cust-005', 'cnc-0100006', 33000, '2021-12-22 12:00:00', 'online');

-- Expenses (2021)
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-001', 'cnc-0100001', 'staff salaries',         45000, '2021-01-31 00:00:00'),
('exp-002', 'cnc-0100001', 'medical supplies',         8000, '2021-02-28 00:00:00'),
('exp-003', 'cnc-0100002', 'rent',                    20000, '2021-01-31 00:00:00'),
('exp-004', 'cnc-0100002', 'utilities',                3500, '2021-02-28 00:00:00'),
('exp-005', 'cnc-0100003', 'first-aid supplies',        557, '2021-03-31 00:00:00'),
('exp-006', 'cnc-0100004', 'equipment maintenance',   15000, '2021-09-30 00:00:00'),
('exp-007', 'cnc-0100004', 'staff salaries',          30000, '2021-10-31 00:00:00'),
('exp-008', 'cnc-0100005', 'rent',                    18000, '2021-10-31 00:00:00'),
('exp-009', 'cnc-0100006', 'medical supplies',         6200, '2021-09-30 00:00:00'),
('exp-010', 'cnc-0100006', 'utilities',                4100, '2021-10-31 00:00:00'),
('exp-011', 'cnc-0100007', 'staff salaries',          25000, '2021-10-31 00:00:00'),
('exp-012', 'cnc-0100008', 'rent',                    12000, '2021-10-31 00:00:00'),
('exp-013', 'cnc-0100001', 'cleaning services',        2200, '2021-11-30 00:00:00'),
('exp-014', 'cnc-0100005', 'medical supplies',         9500, '2021-12-31 00:00:00');
