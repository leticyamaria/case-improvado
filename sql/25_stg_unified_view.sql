-- 25_stg_unified_view.sql
-- Canonical view aligning platforms. add NULLs

create or replace view stg.v_ads_normalized as
select
  date, platform, campaign_id, campaign_name,
  adgroup_id, adgroup_name, ad_id, ad_name,
  impressions, clicks, spend, conversions,
  video_views,
  video_watch_25,
  video_watch_50,
  video_watch_75,
  video_watch_100,
  likes, shares, comments,
  null::numeric(18,6) as conversion_value,
  null::numeric(18,6) as ctr_pct,
  null::numeric(18,6) as avg_cpc,
  null::numeric(18,6) as quality_score,
  null::numeric(18,6) as search_impression_share,
  null::numeric(18,6) as engagement_rate,
  null::bigint        as reach,
  null::numeric(18,6) as frequency,
  currency
from stg.tiktok_ads

union all
select
  date, platform, campaign_id, campaign_name,
  adgroup_id, adgroup_name, ad_id, ad_name,
  impressions, clicks, spend, conversions,
  null::bigint as video_views,
  null::bigint as video_watch_25,
  null::bigint as video_watch_50,
  null::bigint as video_watch_75,
  null::bigint as video_watch_100,
  null::bigint as likes,
  null::bigint as shares,
  null::bigint as comments,
  conversion_value, ctr_pct, avg_cpc, quality_score, search_impression_share,
  null::numeric(18,6) as engagement_rate,
  null::bigint        as reach,
  null::numeric(18,6) as frequency,
  currency
from stg.google_ads

union all
select
  date, platform, campaign_id, campaign_name,
  adgroup_id, adgroup_name, ad_id, ad_name,
  impressions, clicks, spend, conversions,
  video_views,
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
  engagement_rate, reach, frequency,
  currency
from stg.facebook_ads;
