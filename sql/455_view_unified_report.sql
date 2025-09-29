-- 45_view_unified_report.sql
-- Single-source reporting view for Looker.
-- Grain: (date, platform, campaign_id, campaign_name)
-- Use it for both daily trends and campaign tables (date filter still works).

create or replace view mart.v_report_base as
select
  date,
  platform,
  campaign_id,
  campaign_name,
  -- core aggregates
  sum(impressions)::bigint            as impressions,
  sum(clicks)::bigint                 as clicks,
  sum(spend)::numeric(18,6)           as spend,
  sum(conversions)::bigint            as conversions,
  sum(video_views)::bigint            as video_views,
  -- KPIs (ratios/costs as numeric)
  case when sum(impressions) > 0
       then (sum(clicks)::numeric(18,6) / sum(impressions)::numeric(18,6))
       else null end                  as ctr,
  case when sum(clicks) > 0
       then (sum(spend) / nullif(sum(clicks),0))
       else null end                  as cpc,
  case when sum(impressions) > 0
       then ((sum(spend) * 1000) / nullif(sum(impressions),0))
       else null end                  as cpm,
  case when sum(conversions) > 0
       then (sum(spend) / nullif(sum(conversions),0)::numeric(18,6))
       else null end                  as cpa
from mart.fact_ads
group by 1,2,3,4;
