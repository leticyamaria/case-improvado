# Unified Ads Case — SQL-first > Looker Studio
### Senior Marketing Analyst - Technical Assignment

**Goal:** unify **Facebook**, **Google Ads** and **TikTok** campaign data into a single **Supabase (Postgres)** model and publish a **1-page Looker Studio dashboard**. Delivery is fully **SQL-first**, reproducible and documented.

---

Link: ['[Case]Improvado_LeticyaC'](https://lookerstudio.google.com/reporting/184c64e4-d4fb-4a58-803a-aa436e2de6b3/page/05hZF)

---

### 1) Architecture

**Layers**
1. `raw` — CSV as-is (uploaded via Supabase GUI).
2. `stg` — strong typing and normalization (`NULLIF`, casts, no joins).
3. `mart` — canonical fact table `mart.fact_ads`  
   - Grain: `date × platform × campaign × adgroup`  
   - Indexes: `(date, platform)`, `(campaign_name)`

**Optional view**
- `mart.v_report_base` — aggregates by `(date × platform × campaign)` and adds TikTok quartiles.

**BI**
- Looker Studio connects **directly to Postgres** (SSL Required) on `mart.fact_ads`.

---

### 2) Repository structure
```
├── sql
  ├── 00_schemas.sql
  ├──  10_raw_tables.sql
  ├──  20_stg_normalize.sql
  ├──  30_mart_fact_ads.sql
├── dashboard
  └── /README.md
```
---

### 3) Pipeline steps

1. **Create schemas** → `sql/00_schemas.sql`  
2. **Create RAW tables** → `sql/10_raw_tables.sql`
3. **Unify (MART)** → `sql/30_mart_fact_ads.sql`  
5. **Connect Looker** → [connection details](https://github.com/leticyamaria/case-improvado/tree/main/dashboard#readme)
6. **link to dashboard** → ['[Case]Improvado_LeticyaC'](https://lookerstudio.google.com/reporting/184c64e4-d4fb-4a58-803a-aa436e2de6b3/page/05hZF)

---

### 4) Data dictionary

**Common:** `date`, `platform`, `campaign_id/name`, `adgroup_id/name`, `impressions`, `clicks`, `spend`, `conversions`, `currency`  
**TikTok:** `video_views`, `video_watch_25/50/75/100`, `likes`, `shares`, `comments`  
**Facebook:** `video_views`, `engagement_rate`, `reach`, `frequency`  
**Google:** `conversion_value`, `ctr_pct`, `avg_cpc`, `quality_score`, `search_impression_share`  
>[!NOTE]
>Columns not present in a platform = `NULL` in `mart.fact_ads`

---

### 5) Troubleshooting
View dependencies → drop before recreate  
ALTER VIEW add/drop column → recreate (drop view if exists  
Table not listed in Looker → use Custom Query; check SSL and grants  
KPI mismatch → almost always due to wrong aggregation in Looker (must be Sum + ratio-of-sums)  

---



