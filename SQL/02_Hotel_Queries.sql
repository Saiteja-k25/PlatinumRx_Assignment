-- =============================================================
--  PlatinumRx Assignment | Hotel Management System
--  File : 02_Hotel_Queries.sql
--  Phase: 1 — Queries for Part A (Questions 1–5)
-- =============================================================


-- -------------------------------------------------------------
-- Q1: For every user, get user_id and their last booked room_no
-- -------------------------------------------------------------
-- Logic: Use a correlated subquery to find the booking with the
--        MAX (latest) booking_date per user, then join back to
--        retrieve room_no. LEFT JOIN keeps users with no bookings.
-- -------------------------------------------------------------

SELECT
    u.user_id,
    u.name,
    b.room_no         AS last_booked_room
FROM users u
LEFT JOIN bookings b
    ON b.booking_id = (
        SELECT b2.booking_id
        FROM   bookings b2
        WHERE  b2.user_id = u.user_id
        ORDER  BY b2.booking_date DESC
        LIMIT  1
    );


-- -------------------------------------------------------------
-- Q2: booking_id and total billing amount for bookings in Nov 2021
-- -------------------------------------------------------------
-- Logic: Join booking_commercials → items to compute line amounts,
--        then join bookings to filter by booking_date in Nov 2021.
--        GROUP BY booking_id and SUM(rate * quantity).
-- -------------------------------------------------------------

SELECT
    bc.booking_id,
    SUM(i.item_rate * bc.item_quantity) AS total_billing_amount
FROM   booking_commercials bc
JOIN   items    i ON i.item_id    = bc.item_id
JOIN   bookings b ON b.booking_id = bc.booking_id
WHERE  b.booking_date >= '2021-11-01'
  AND  b.booking_date  < '2021-12-01'
GROUP  BY bc.booking_id
ORDER  BY total_billing_amount DESC;


-- -------------------------------------------------------------
-- Q3: bill_id and bill amount of bills raised in Oct 2021 with amount > 1000
-- -------------------------------------------------------------
-- Logic: Filter on bill_date in booking_commercials for October,
--        aggregate per bill_id, then use HAVING to keep only > 1000.
-- -------------------------------------------------------------

SELECT
    bc.bill_id,
    SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM   booking_commercials bc
JOIN   items i ON i.item_id = bc.item_id
WHERE  bc.bill_date >= '2021-10-01'
  AND  bc.bill_date  < '2021-11-01'
GROUP  BY bc.bill_id
HAVING SUM(i.item_rate * bc.item_quantity) > 1000
ORDER  BY bill_amount DESC;


-- -------------------------------------------------------------
-- Q4: Most ordered AND least ordered item of each month in 2021
-- -------------------------------------------------------------
-- Logic:
--   Step 1 (monthly_totals CTE): Aggregate total quantity per
--          item per month for year 2021.
--   Step 2 (ranked CTE): Apply RANK() twice — DESC for most
--          ordered, ASC for least ordered — partitioned by month.
--   Step 3: Pivot the two ranks into columns using CASE + MAX.
-- -------------------------------------------------------------

WITH monthly_totals AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m') AS month,
        bc.item_id,
        i.item_name,
        SUM(bc.item_quantity)              AS total_qty
    FROM   booking_commercials bc
    JOIN   items i ON i.item_id = bc.item_id
    WHERE  YEAR(bc.bill_date) = 2021
    GROUP  BY DATE_FORMAT(bc.bill_date, '%Y-%m'), bc.item_id, i.item_name
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS rk_most,
        RANK() OVER (PARTITION BY month ORDER BY total_qty ASC)  AS rk_least
    FROM monthly_totals
)
SELECT
    month,
    MAX(CASE WHEN rk_most  = 1 THEN item_name END) AS most_ordered_item,
    MAX(CASE WHEN rk_least = 1 THEN item_name END) AS least_ordered_item
FROM   ranked
WHERE  rk_most = 1 OR rk_least = 1
GROUP  BY month
ORDER  BY month;


-- -------------------------------------------------------------
-- Q5: Customers with the second highest bill value each month in 2021
-- -------------------------------------------------------------
-- Logic:
--   Step 1 (user_monthly CTE): Compute total bill value per user
--          per month for year 2021.
--   Step 2 (ranked CTE): DENSE_RANK() descending so rank 1 =
--          highest bill value. DENSE_RANK (not RANK) ensures ties
--          at rank 1 don't skip rank 2.
--   Step 3: Filter WHERE dr = 2, then join users for names.
-- -------------------------------------------------------------

WITH user_monthly AS (
    SELECT
        DATE_FORMAT(bc.bill_date, '%Y-%m')      AS month,
        b.user_id,
        SUM(i.item_rate * bc.item_quantity)     AS bill_value
    FROM   booking_commercials bc
    JOIN   items    i ON i.item_id    = bc.item_id
    JOIN   bookings b ON b.booking_id = bc.booking_id
    WHERE  YEAR(bc.bill_date) = 2021
    GROUP  BY DATE_FORMAT(bc.bill_date, '%Y-%m'), b.user_id
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY month
            ORDER BY bill_value DESC
        ) AS dr
    FROM user_monthly
)
SELECT
    r.month,
    u.name       AS customer_name,
    r.user_id,
    r.bill_value AS second_highest_bill_value
FROM   ranked r
JOIN   users u ON u.user_id = r.user_id
WHERE  r.dr = 2
ORDER  BY r.month;
