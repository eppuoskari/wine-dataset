# Wine Analysis — SQL Mini Project

**Team Slytherin** — Eppu • Levent • María • Nodir • Lucie

---

## 🧠 Project Overview
We built a normalized **MySQL** database from a, previously cleaned by us, wine dataset and used **SQL + Python** to investigate how **origin, closure type, and tasting characteristics** relate to **price**. The workflow covers data loading (staging), transformation, modeling (ERD), and reproducible analysis.

---

## 🎯 Objectives (Hypotheses)
1) **Where do the most expensive wines come from?**  
2) **Does the closure (cork, screwcap, etc.) correlate with price?**  
3) **What characteristics are shared by expensive wines?**

---

## 🗺️ Data & Modeling
- **Data prep:** cleaned CSV → **staging table** → transformed into a normalized schema.  
- **Schema (core tables):** `main` (facts), `wine_info` (titles, descriptions, vintage), lookups `type`, `closure`, `primary_grape`, and the many-to-many pair `characteristic` ↔ `wine_characteristic`.  
- **ERD approach:** primary/foreign keys with `wine_id` at the center, enabling joins for region, closure, grapes, and characteristics.

---

## 🔍 Methodology
- Load cleaned CSV to **staging** (pandas / Workbench Wizard).  
- Transform and normalize into the ERD tables.  
- Write analytical SQL (**GROUP BY**, **JOIN**, **WINDOW** functions like `NTILE`) for premium tiers and comparisons.  
- Validate with quick sanity checks (row counts, NULLs, types), then export compact result tables for presentation.

---

## 📊 Key Findings (Short)
- **Premium origins:** a consistent set of regions leads average prices when a minimum sample per region is enforced.  
- **Closures & price:** **natural cork** wines are **meaningfully pricier on average** than screwcap/others.  
- **Expensive-wine traits:** notes like **citrus/green apple, vanilla/spice, bread/biscuit** appear frequently among higher-priced bottles.  
- **Regional flavor signatures:** cool areas skew **citrus/green-apple**; warmer red regions show **black fruit + vanilla/spice**; rosé regions show **red fruit/strawberry/peach**.  
- **Price concentration:** a **small top slice of wines drives most of total price** (Pareto-style concentration).

---

## 🧰 Tech Stack
- **Database:** MySQL (Workbench for ERD/inspection; SQLAlchemy + PyMySQL from Jupyter).  
- **Python:** pandas for cleaning and exports; Jupyter for the ETL + analysis notebook.

---

## 🗂️ Repository Structure
```
wine dataset/
├─ data/
│
├─ database/
│  
├─ erd/
│
├─ sql/
│
├─ notebooks/
---


## 🙌 Credits
Team Slytherin — analysis, modeling, and presentation.

---


