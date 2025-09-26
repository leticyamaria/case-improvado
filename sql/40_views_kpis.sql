-- 40_views_kpis.sql
-- KPI views for reporting/Looker. Ratios/costs as NUMERIC.

create or replace view mart.v_metrics_daily as
select
  date,
  platform,
  sum(impressions)::bigint              as impressions,
  sum(clicks)::bigint                   as clicks,
  sum(spend)::numeric(18,6)             as spend,
  sum(conversions)::bigint              as conversions,
  case when sum(impressions) > 0
       then (sum(clicks)::numeric(18,6) / sum(impressions)::numeric(18,6))
       else null end                     as ctr,
  case when sum(clicks) > 0
       then (sum(spend) / nullif(sum(clicks),0))
       else null end                     as cpc,
  case when sum(impressions) > 0
       then ((sum(spend) * 1000) / nullif(sum(impressions),0))
       else null end                     as cpm,
  case when sum(conversions) > 0
       then (sum(spend) / nullif(sum(conversions),0)::numeric(18,6))
       else null end                     as cpa,
  sum(video_views)::bigint              as video_views
from mart.fact_ads
group by 1,2;

create or replace view mart.v_campaigns_summary as
select
  platform,
  campaign_id,
  campaign_name,
  sum(impressions)::bigint    as impressions,
  sum(clicks)::bigint         as clicks,
  sum(spend)::numeric(18,6)   as spend,
  sum(conversions)::bigint    as conversions
from mart.fact_ads
group by 1,2,3;

