# wine-dataset
🧠 Project Overview

We took a cleaned wine dataset and built a normalized MySQL database to answer three questions about price, closures, and tasting characteristics. The source subset contains 1,266 wines from 26 countries. 

🎯 Objectives (Hypotheses)

Where do the most expensive wines come from?

Does the closure (cork, screwcap, etc.) correlate with price?

What characteristics are shared by expensive wines? 

🗺️ Data & Modeling

Preparation roadmap: data selection, cleaning/standardization in pandas, ERD design, SQL query development, analysis. 

Schema (core tables): main (facts), wine_info, lookups type, closure, primary_grape, and the M:N pair characteristic ↔ wine_characteristic. 

🔍 Methodology ( How we worked )

Loaded the cleaned CSV into a staging table, then transformed into the normalized tables.

Wrote analytical SQL (GROUP BY, JOINs, window functions like NTILE for premium tiers).

Verified results and exported compact tables for the final visuals. 

📊 Key Findings

Premium regions (avg £/L): consistent leaders include Tuscany, Burgundy, South Australia, Bordeaux, California (min wines per region applied). 

Closures & price: Natural cork wines are expensive on average (£35), over 2× screwcap (£16); natural cork dominates share of the portfolio. 

Traits of expensive wines (>£50): top notes are Bread (90), Citrus Fruit (66), Vanilla (57), Biscuit (50), Green Apple (48). 

Characteristics by region: clear climate/style clusters—citrus/green-apple in cool zones; black fruit + vanilla/spice in warmer red regions; rosé shows red fruit/strawberry/peach. 

Price concentration: a small top slice of wines accounts for most of total price (curve far from the equal-share diagonal). 

🧰 Tech Stack

MySQL (Workbench + SQL)

Python: pandas, SQLAlchemy (connection/ETL)

Jupyter Notebook (reproducible pipeline)
