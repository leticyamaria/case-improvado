-- 30_mart_fact_ads.sql
-- MART: unified fact built from the canonical STG view.

drop table if exists mart.fact_ads;

create table mart.fact_ads as
select *
from stg.v_ads_normalized;

create index if not exists idx_fact_ads_date_platform
  on mart.fact_ads(date, platform);

create index if not exists idx_fact_ads_campaign
  on mart.fact_ads(campaign_name);

