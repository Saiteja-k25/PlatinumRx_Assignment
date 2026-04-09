# PlatinumRx Data Analyst Assignment

## Overview

This repository contains solutions for all three phases of the PlatinumRx Data Analyst assignment:
- **Phase 1 — SQL Proficiency** (Hotel & Clinic Management Systems)
- **Phase 2 — Spreadsheet Proficiency** (Ticket Analysis in Excel)
- **Phase 3 — Python Proficiency** (Time Conversion & String Manipulation)

---

## Folder Structure

```
Data_Analyst_Assignment/
│
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql    ← CREATE TABLE + INSERT for hotel system
│   ├── 02_Hotel_Queries.sql         ← Answers for Part A (Questions 1–5)
│   ├── 03_Clinic_Schema_Setup.sql   ← CREATE TABLE + INSERT for clinic system
│   └── 04_Clinic_Queries.sql        ← Answers for Part B (Questions 1–5)
│
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx         ← 3 sheets: ticket, feedbacks, Analysis
│
├── Python/
│   ├── 01_Time_Converter.py         ← Minutes → human-readable format
│   └── 02_Remove_Duplicates.py      ← Remove duplicate chars using loop
│
└── README.md
```

---

## Phase 1 — SQL

### Tools Required
- MySQL Workbench / PostgreSQL / DB Fiddle / VS Code with SQL extension

### How to Run

1. **Hotel System**
   ```sql
   -- Step 1: Run schema + data
   source SQL/01_Hotel_Schema_Setup.sql;

   -- Step 2: Run queries
   source SQL/02_Hotel_Queries.sql;
   ```

2. **Clinic System**
   ```sql
   source SQL/03_Clinic_Schema_Setup.sql;
   source SQL/04_Clinic_Queries.sql;
   ```

### Query Summary

| File | Question | Approach |
|---|---|---|
| 02_Hotel_Queries.sql | Q1 — Last booked room | Correlated subquery + ORDER BY date DESC LIMIT 1 |
| 02_Hotel_Queries.sql | Q2 — Nov 2021 billing | JOIN 3 tables, SUM(rate × qty), filter booking_date |
| 02_Hotel_Queries.sql | Q3 — Oct 2021 bills > 1000 | SUM per bill_id, HAVING > 1000 |
| 02_Hotel_Queries.sql | Q4 — Most/least ordered item | CTE + RANK() window function (DESC & ASC) |
| 02_Hotel_Queries.sql | Q5 — 2nd highest bill | CTE + DENSE_RANK() DESC, filter dr = 2 |
| 04_Clinic_Queries.sql | B-Q1 — Revenue by channel | GROUP BY sales_channel, SUM(amount) |
| 04_Clinic_Queries.sql | B-Q2 — Top 10 customers | JOIN customer, SUM, ORDER DESC, LIMIT 10 |
| 04_Clinic_Queries.sql | B-Q3 — Monthly P&L | Two CTEs (rev + exp), FULL OUTER JOIN, CASE for status |
| 04_Clinic_Queries.sql | B-Q4 — Most profitable clinic/city | LEFT JOIN profit CTE + RANK() DESC per city |
| 04_Clinic_Queries.sql | B-Q5 — 2nd least profitable/state | LEFT JOIN profit CTE + DENSE_RANK() ASC per state |

### Key Assumptions
- `YEAR()` and `MONTH()` functions used for date filtering — standard MySQL/PostgreSQL syntax.
- `FULL OUTER JOIN` used in B-Q3; a MySQL UNION workaround is provided in the file comments.
- Window functions (`RANK`, `DENSE_RANK`) require MySQL 8.0+ or PostgreSQL.
- `:given_year` and `:month` placeholders in Clinic queries should be replaced with integer values (e.g., `2021`, `9`).

---

## Phase 2 — Spreadsheets

### File: `Spreadsheets/Ticket_Analysis.xlsx`

| Sheet | Purpose |
|---|---|
| `ticket` | Raw ticket data with two auto-calculated helper columns |
| `feedbacks` | Feedback data; column D auto-populated via INDEX/MATCH |
| `Analysis` | Outlet-wise COUNTIFS summary for Q2a (same day) and Q2b (same hour) |

### Formulas Used

**Q1 — ticket_created_at in feedbacks (column D):**
```excel
=IFERROR(INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0)), "Not Found")
```
> Why INDEX/MATCH and not VLOOKUP? The lookup column (cms_id = col E) is to the right of
> the return column (created_at = col B) in the ticket sheet. VLOOKUP cannot look leftward.

**Q2a — Same day flag (ticket sheet, column F):**
```excel
=IF(INT(B2)=INT(C2), 1, 0)
```

**Q2b — Same hour flag (ticket sheet, column G):**
```excel
=IF(INT(B2)=INT(C2), IF(HOUR(B2)=HOUR(C2), 1, 0), 0)
```

**Outlet-wise counts (Analysis sheet):**
```excel
=COUNTIFS(ticket!$D:$D, A5, ticket!$F:$F, 1)   -- same day
=COUNTIFS(ticket!$D:$D, A11, ticket!$G:$G, 1)  -- same hour
```

---

## Phase 3 — Python

### Requirements
- Python 3.x (no external libraries needed)

### How to Run

```bash
python Python/01_Time_Converter.py
python Python/02_Remove_Duplicates.py
```

### Logic

**01_Time_Converter.py**
```
hours   = minutes // 60   (integer division)
minutes = minutes % 60    (modulo for remainder)
```

**02_Remove_Duplicates.py**
```
result = ""
for each char in string:
    if char not in result → append to result
    else → skip
```

---

## Submission Checklist

- [x] All SQL scripts execute without errors
- [x] Schema setup scripts include both CREATE TABLE and INSERT statements
- [x] Window functions used correctly (RANK vs DENSE_RANK where appropriate)
- [x] Excel formulas are live and recalculate dynamically
- [x] INDEX/MATCH used instead of VLOOKUP for cross-sheet left-lookup
- [x] Python scripts handle edge cases (0 mins, empty string, exact hours)
- [x] README documents approach and assumptions
