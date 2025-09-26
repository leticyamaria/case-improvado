-- 20_stg_normalize.sql
-- STAGING: strong typing + normalized column names across platforms.

-- TIKTOK -> STG
drop table if exists stg.tiktok_ads;
create table stg.tiktok_ads as
select
  to_date(date, 'YYYY-MM-DD')::date                        as date,
  'tiktok'                                                 as platform,
  campaign_id                                              as campaign_id,
  campaign_name                                            as campaign_name,
  adgroup_id                                               as adgroup_id,
  adgroup_name                                             as adgroup_name,
  null::text                                               as ad_id,
  null::text                                               as ad_name,
  nullif(impressions,'')::bigint                           as impressions,
  nullif(clicks,'')::bigint                                as clicks,
  nullif(replace(cost,',','.'),'')::numeric(18,6)          as spend,
  nullif(conversions,'')::bigint                           as conversions,
  nullif(video_views,'')::bigint                           as video_views,
  nullif(video_watch_25,'')::bigint                        as video_watch_25,
  nullif(video_watch_50,'')::bigint                        as video_watch_50,
  nullif(video_watch_75,'')::bigint                        as video_watch_75,
  nullif(video_watch_100,'')::bigint                       as video_watch_100,
  nullif(likes,'')::bigint                                 as likes,
  nullif(shares,'')::bigint                                as shares,
  nullif(comments,'')::bigint                              as comments,
  null::numeric(18,6)                                      as conversion_value,
  null::numeric(18,6)                                      as ctr_pct,
  null::numeric(18,6)                                      as avg_cpc,
  null::numeric(18,6)                                      as quality_score,
  null::numeric(18,6)                                      as search_impression_share,
  'USD'::text                                              as currency
from raw.tiktok_ads;

create index if not exists idx_stg_tiktok_date on stg.tiktok_ads(date);

-- GOOGLE -> STG
drop table if exists stg.google_ads;
create table stg.google_ads as
select
  to_date(date, 'YYYY-MM-DD')::date                        as date,
  'google'                                                 as platform,
  campaign_id                                              as campaign_id,
  campaign_name                                            as campaign_name,
  ad_group_id                                              as adgroup_id,
  ad_group_name                                            as adgroup_name,
  null::text                                               as ad_id,
  null::text                                               as ad_name,
  nullif(impressions,'')::bigint                           as impressions,
  nullif(clicks,'')::bigint                                as clicks,
  /* If cost is in micros in your CSV, change to: (nullif(cost,'')::numeric / 1e6) */
  nullif(replace(cost,',','.'),'')::numeric(18,6)          as spend,
  nullif(conversions,'')::bigint                           as conversions,     -- COUNT
  null::bigint                                             as video_views,
  null::bigint                                             as video_watch_25,
  null::bigint                                             as video_watch_50,
  null::bigint                                             as video_watch_75,
  null::bigint                                             as video_watch_100,
  null::bigint                                             as likes,
  null::bigint                                             as shares,
  null::bigint                                             as comments,
  nullif(replace(conversion_value,',','.'),'')::numeric(18,6)        as conversion_value,
  nullif(replace(ctr,',','.'),'')::numeric(18,6)                      as ctr_pct,
  nullif(replace(avg_cpc,',','.'),'')::numeric(18,6)                  as avg_cpc,
  nullif(replace(quality_score,',','.'),'')::numeric(18,6)            as quality_score,
  nullif(replace(search_impression_share,',','.'),'')::numeric(18,6)  as search_impression_share,
  'USD'::text                                              as currency
from raw.google_ads;

create index if not exists idx_stg_google_date on stg.google_ads(date);

-- FACEBOOK -> STG
drop table if exists stg.facebook_ads;
create table stg.facebook_ads as
select
  to_date(date, 'YYYY-MM-DD')::date                        as date,
  'facebook'                                               as platform,
  campaign_id                                              as campaign_id,
  campaign_name                                            as campaign_name,
  ad_set_id                                                as adgroup_id,     -- normalized -> adgroup_*
  ad_set_name                                              as adgroup_name,
  null::text                                               as ad_id,
  null::text                                               as ad_name,
  nullif(impressions,'')::bigint                           as impressions,
  nullif(clicks,'')::bigint                                as clicks,
  nullif(replace(spend,',','.'),'')::numeric(18,6)         as spend,
  nullif(conversions,'')::bigint                           as conversions,    -- COUNT
  nullif(video_views,'')::bigint                           as video_views,
  null::bigint                                             as video_watch_25,
  null::bigint                                             as video_watch_50,
  null::bigint                                             as video_watch_75,
  null::bigint                                             as video_watch_100,
  null::bigint                                             as likes,
  null::bigint                                             as shares,
  null::bigint                                             as comments,
  null::numeric(18,6)                                      as conversion_value,
  nullif(replace(engagement_rate,',','.'),'')::numeric(18,6) as engagement_rate,
  nullif(reach,'')::bigint                                 as reach,
  nullif(replace(frequency,',','.'),'')::numeric(18,6)     as frequency,
  'USD'::text                                              as currency
from raw.facebook_ads;

create index if not exists idx_stg_fb_date on stg.facebook_ads(date);

