# Looker Studio – Data Source & Dashboard Guide

**Stack:** Supabase (Postgres) + SQL + Looker Studio  
**Primary source:** `mart.v_report_base` 

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

**CTR (percent)**
```sql 
SUM(clicks) / SUM (impressions)
```

**CPC (currency)**
```sql 
SUM(spend) / SUM (clicks)
```

**CPM (currency)**
```sql 
(SUM(spend)*1000) / SUM (impressions)
```

**CPA (currency)**
```sql 
SUM(spend) / SUM (conversions)
```

**VW25_rate (percent)**
```sql 
SUM(video_watch_25)  / SUM(video_views)
```
**VW50_rate (percent)**
```sql 
SUM(video_watch_50)  / SUM(video_views)
```
**VW75_rate (percent)**
```sql 
SUM(video_watch_75)  / SUM(video_views)
```
**VW100_rate (percent)**
```sql 
SUM(video_watch_100)  / SUM(video_views)
```
**frequency_calc (number)**
```sql 
SUM(impressions) / NULLIF(SUM(reach), 0)
```
**engagement_rate_calc (percent)**
```sql 
SUM(engagement_rate * impressions) / SUM(impressions)
```
