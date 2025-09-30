-- 30_mart_fact_ads.sql
-- MART: unified fact table built directly from STG tables 
-- Aligned columns explicitly and fill non-existent metrics with NULLs.

create table if not exists mart.fact_ads as
select
  date,
  platform,
  campaign_id,
  campaign_name,
  adgroup_id,
  adgroup_name,
  ad_id,
  ad_name,
  impressions,
  clicks,
  spend,
  conversions,
  video_views,
  video_watch_25,
  video_watch_50,
  video_watch_75,
  video_watch_100,
  likes,
  shares,
  comments,
  conversion_value,
  ctr_pct,
  avg_cpc,
  quality_score,
  search_impression_share,
  engagement_rate,
  reach,
  frequency,
  currency
from (
  -- TIKTOK 
  select
    t.date, t.platform, t.campaign_id, t.campaign_name,
    t.adgroup_id, t.adgroup_name, t.ad_id, t.ad_name,
    t.impressions, t.clicks, t.spend, t.conversions,
    t.video_views, t.video_watch_25, t.video_watch_50, t.video_watch_75, t.video_watch_100,
    t.likes, t.shares, t.comments,
    null::numeric(18,6) as conversion_value,
    null::numeric(18,6) as ctr_pct,
    null::numeric(18,6) as avg_cpc,
    null::numeric(18,6) as quality_score,
    null::numeric(18,6) as search_impression_share,
    null::numeric(18,6) as engagement_rate,
    null::bigint        as reach,
    null::numeric(18,6) as frequency,
    t.currency
  from stg.tiktok_ads t

  union all

  -- GOOGLE
  select
    g.date, g.platform, g.campaign_id, g.campaign_name,
    g.adgroup_id, g.adgroup_name, g.ad_id, g.ad_name,
    g.impressions, g.clicks, g.spend, g.conversions,
    null::bigint as video_views,
    null::bigint as video_watch_25,
    null::bigint as video_watch_50,
    null::bigint as video_watch_75,
    null::bigint as video_watch_100,
    null::bigint as likes,
    null::bigint as shares,
    null::bigint as comments,
    g.conversion_value, g.ctr_pct, g.avg_cpc, g.quality_score, g.search_impression_share,
    null::numeric(18,6) as engagement_rate,
    null::bigint        as reach,
    null::numeric(18,6) as frequency,
    g.currency
  from stg.google_ads g

  union all

  -- FACEBOOK 
  select
    f.date, f.platform, f.campaign_id, f.campaign_name,
    f.adgroup_id, f.adgroup_name, f.ad_id, f.ad_name,
    f.impressions, f.clicks, f.spend, f.conversions,
    f.video_views,
    null::bigint as video_watch_25,
    null::bigint as video_watch_50,
    null::bigint as video_watch_75,
    null::bigint as video_watch_100,
    null::bigint as likes,
    null::bigint as shares,
    null::bigint as comments,
    null::numeric(18,6) as conversion_value,
    null::numeric(18,6) as ctr_pct,
    null::numeric(18,6) as avg_cpc,
    null::numeric(18,6) as quality_score,
    null::numeric(18,6) as search_impression_share,
    f.engagement_rate, f.reach, f.frequency,
    f.currency
  from stg.facebook_ads f
) u;

-- Indexes for common BI filters
create index if not exists idx_fact_ads_date_platform on mart.fact_ads(date, platform);
create index if not exists idx_fact_ads_campaign     on mart.fact_ads(campaign_name);
