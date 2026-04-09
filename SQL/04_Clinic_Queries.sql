-- =============================================================
--  PlatinumRx Assignment | Clinic Management System
--  File : 04_Clinic_Queries.sql
--  Phase: 1 — Queries for Part B (Questions 1–5)
--
--  NOTE: Replace :given_year / :month values with actual
--        integers when running (e.g. 2021 and 9 for September).
-- =============================================================


-- -------------------------------------------------------------
-- Q1: Revenue from each sales channel in a given year
-- -------------------------------------------------------------
-- Logic: Simple GROUP BY on sales_channel with SUM(amount).
--        Filter by YEAR() on the datetime column.
-- -------------------------------------------------------------

SELECT
    sales_channel,
    SUM(amount)  AS total_revenue
FROM   clinic_sales
WHERE  YEAR(datetime) = 2021          -- change year as needed
GROUP  BY sales_channel
ORDER  BY total_revenue DESC;


-- -------------------------------------------------------------
-- Q2: Top 10 most valuable customers for a given year
-- -------------------------------------------------------------
-- Logic: Join clinic_sales with customer to get names.
--        SUM(amount) per customer, ORDER DESC, LIMIT 10.
-- -------------------------------------------------------------

SELECT
    cs.uid,
    c.name,
    c.mobile,
    SUM(cs.amount) AS total_spent
FROM   clinic_sales cs
JOIN   customer c ON c.uid = cs.uid
WHERE  YEAR(cs.datetime) = 2021
GROUP  BY cs.uid, c.name, c.mobile
ORDER  BY total_spent DESC
LIMIT  10;


-- -------------------------------------------------------------
-- Q3: Month-wise revenue, expense, profit, status for a given year
-- -------------------------------------------------------------
-- Logic:
--   Step 1 (rev CTE) : Aggregate revenue from clinic_sales by month.
--   Step 2 (exp CTE) : Aggregate expenses from expenses table by month.
--   Step 3: FULL OUTER JOIN on month so no month is silently dropped.
--           COALESCE(...,0) handles months with only sales or only expenses.
--           Profit = revenue - expense.
--           Status = 'profitable' if profit >= 0, else 'not-profitable'.
--
--  MySQL note: MySQL does not support FULL OUTER JOIN.
--              Use the UNION workaround provided at the bottom.
-- -------------------------------------------------------------

WITH rev AS (
    SELECT
        MONTH(datetime) AS month,
        SUM(amount)     AS revenue
    FROM   clinic_sales
    WHERE  YEAR(datetime) = 2021
    GROUP  BY MONTH(datetime)
),
exp AS (
    SELECT
        MONTH(datetime) AS month,
        SUM(amount)     AS expense
    FROM   expenses
    WHERE  YEAR(datetime) = 2021
    GROUP  BY MONTH(datetime)
)
SELECT
    COALESCE(r.month, e.month)              AS month,
    COALESCE(r.revenue, 0)                  AS revenue,
    COALESCE(e.expense, 0)                  AS expense,
    COALESCE(r.revenue, 0)
        - COALESCE(e.expense, 0)            AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0)
           - COALESCE(e.expense, 0) >= 0
        THEN 'profitable'
        ELSE 'not-profitable'
    END                                     AS status
FROM   rev r
FULL OUTER JOIN exp e ON e.month = r.month
ORDER  BY month;

-- ── MySQL alternative (no FULL OUTER JOIN) ─────────────────
/*
WITH rev AS (
    SELECT MONTH(datetime) AS month, SUM(amount) AS revenue
    FROM   clinic_sales WHERE YEAR(datetime) = 2021
    GROUP  BY MONTH(datetime)
),
exp AS (
    SELECT MONTH(datetime) AS month, SUM(amount) AS expense
    FROM   expenses WHERE YEAR(datetime) = 2021
    GROUP  BY MONTH(datetime)
),
combined AS (
    SELECT r.month, r.revenue, COALESCE(e.expense,0) AS expense
    FROM   rev r LEFT JOIN exp e ON e.month = r.month
    UNION ALL
    SELECT e.month, COALESCE(r.revenue,0), e.expense
    FROM   exp e LEFT JOIN rev r ON r.month = e.month
    WHERE  r.month IS NULL
)
SELECT
    month,
    revenue,
    expense,
    revenue - expense AS profit,
    CASE WHEN revenue - expense >= 0 THEN 'profitable' ELSE 'not-profitable' END AS status
FROM   combined
ORDER  BY month;
*/


-- -------------------------------------------------------------
-- Q4: For each city, find the most profitable clinic for a given month
-- -------------------------------------------------------------
-- Logic:
--   Step 1: Compute profit per clinic for the target month using
--           LEFT JOINs (clinics that had no sales/expenses still appear).
--   Step 2: RANK() descending on profit, partitioned by city.
--   Step 3: Filter WHERE rk = 1.
--   Change MONTH value (9 = September) as needed.
-- -------------------------------------------------------------

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        COALESCE(SUM(cs.amount), 0)
            - COALESCE(SUM(ex.amount), 0) AS profit
    FROM   clinics cl
    LEFT JOIN clinic_sales cs
           ON cs.cid = cl.cid
          AND YEAR(cs.datetime)  = 2021
          AND MONTH(cs.datetime) = 9        -- change month as needed
    LEFT JOIN expenses ex
           ON ex.cid = cl.cid
          AND YEAR(ex.datetime)  = 2021
          AND MONTH(ex.datetime) = 9
    GROUP  BY cl.cid, cl.clinic_name, cl.city
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY city
            ORDER BY profit DESC
        ) AS rk
    FROM clinic_profit
)
SELECT
    city,
    clinic_name,
    cid,
    profit
FROM   ranked
WHERE  rk = 1
ORDER  BY city;


-- -------------------------------------------------------------
-- Q5: For each state, find the second least profitable clinic for a given month
-- -------------------------------------------------------------
-- Logic:
--   Same profit CTE as Q4 but partitioned by state.
--   DENSE_RANK() with ASC so rank 1 = least profitable,
--   rank 2 = second least profitable.
--   DENSE_RANK (not RANK) ensures ties at rank 1 don't skip rank 2.
-- -------------------------------------------------------------

WITH clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.state,
        COALESCE(SUM(cs.amount), 0)
            - COALESCE(SUM(ex.amount), 0) AS profit
    FROM   clinics cl
    LEFT JOIN clinic_sales cs
           ON cs.cid = cl.cid
          AND YEAR(cs.datetime)  = 2021
          AND MONTH(cs.datetime) = 9        -- change month as needed
    LEFT JOIN expenses ex
           ON ex.cid = cl.cid
          AND YEAR(ex.datetime)  = 2021
          AND MONTH(ex.datetime) = 9
    GROUP  BY cl.cid, cl.clinic_name, cl.state
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY state
            ORDER BY profit ASC             -- ASC: rank 1 = least profitable
        ) AS dr
    FROM clinic_profit
)
SELECT
    state,
    clinic_name,
    cid,
    profit
FROM   ranked
WHERE  dr = 2                               -- second least profitable
ORDER  BY state;
