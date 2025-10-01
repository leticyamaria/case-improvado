# Looker Studio – Data Source & Dashboard Guide

**Stack:** Supabase (Postgres) + SQL + Looker Studio  
**Primary source:** `mart.v_report_base`  
Link: ['[Case]Improvado_LeticyaC'](https://lookerstudio.google.com/reporting/184c64e4-d4fb-4a58-803a-aa436e2de6b3/page/05hZF)

---

## 1) Connect Looker Studio (PostgreSQL)

1.1) **Create a read-only DB role on supabase**:
```sql
-- Create or reset the BI role (safe)
do $$
begin
  if not exists (select 1 from pg_roles where rolname = 'looker_reader') then
    create role looker_reader login password '<PASSWORD>';
  else
    alter role looker_reader with login password '<PASSWORD>';
  end if;
end $$;

-- Make MART the default search path (helps connectors)
alter role looker_reader in database postgres set search_path = mart, public;

-- Read-only grants
grant usage on schema mart to looker_reader;
grant select on all tables in schema mart to looker_reader;
alter default privileges in schema mart grant select on tables to looker_reader;
```

1.2) **Looker Studio > Create > Report > Add data > PostgreSQL**

Host: <project>.db.supabase.co  
Port: 5432  
Database: postgres  
User: looker_reader  
Password: (<PASSWORD>)  

Schema: mart  
Table: v_report_base  
use custom query: 
```sql 
select * from mart.fact_ads
```

## **2) Fields — Types & Default Aggregations**
One time adjustments on database 

| FIELD | TYPE | AGGREGATION | 
| --- | --- | --- |
| `date` | Date | none|
| `plataform` | text | none|
| `campaing_id` `campaing_name` | text | none |
| `impressions` `clicks` `conversion` `reach` | number (integer) | sum |
| `video_views` `video_watch25/50/75/100` | number (integer) | sum |
| `spend` `conversion_value` | currency | sum | 

> [!NOTE]
> Hide `avg_cpc`,`ctr_pct`, `frequency`, `quality_score`, `engagement_rate`, `search_impression_share`. We are going to recalculate them in looker for better aggregation.

## **3) KPIs calculated in looker**
Ration of sums > correct under any filter group. 

Create the following custom fields in the data source:
```sql 
-- CTR (percent)
SUM(clicks) / SUM (impressions)

-- CPC (currency)
SUM(spend) / SUM (clicks)

-- CPM (currency)
(SUM(spend)*1000) / SUM (impressions)

-- CPA (currency)
SUM(spend) / SUM (conversions)

-- VW25_rate (percent)
SUM(video_watch_25)  / SUM(video_views)

-- VW50_rate (percent)
SUM(video_watch_50)  / SUM(video_views)

-- VW75_rate (percent)
SUM(video_watch_75)  / SUM(video_views)

-- VW100_rate (percent)
SUM(video_watch_100)  / SUM(video_views)

-- frequency_calc (number)
SUM(impressions) / NULLIF(SUM(reach), 0)

-- engagement_rate_calc (percent)
SUM(engagement_rate * impressions) / SUM(impressions)
```


## 4) Layout
- Filters  
  - Dropdowns: `adgroup_name`, `campaign_name`, `platform`
  - Date range selector
- Highlights
  - Best platform by CPA (table, limit=1)
  - Best campaign by CPA (table, limit=1)
  - Best day by CPA (table, limit=1)
- Conversion Funnel
  - Impressions (scorecard)
  - Clicks (scorecard, compared to impressions)
  - Conversions (scorecard, compared to clicks)
- Totals
  - Spend (scorecard)
  - CPC (scorecard)
  - CPA (scorecard)
  - CTR (scorecard)
  - CPM (scorecard)
- Spend vs CPA by platform (combined graph)
- Impressions vs spend by date (combined graph)
- Clicks vs spend by date (combined graph)
- Conversion vs spend by date (combined graph)
- Tiktok performance
  - Funnel
    - video_watch
    - video_watch_25
    - video_watch_50
    - video_watch_75
    - video_watch_100
  - Likes (scorecard)
  - Shares (scorecard)
  - Comments (scorecard)
- Google performance
  - Conversion value (scorecard, sum)
  - Quality score (scorecard, avg)
  - Search impresion share (scorecard, avg)
- Facebook performance
  - Reach (scorecard, sum)
  - Engagement rate (scorecard, avg)
  - Frequency (scorecard, avg)
