-- raw CSV as-is
-- RAW layer: CSV-friendly structures (TEXT) matching the provided headers.

drop table if exists raw.tiktok_ads;
drop table if exists raw.google_ads;
drop table if exists raw.facebook_ads;

-- TIKTOK RAW
create table raw.tiktok_ads (
  _ingested_at timestamptz default now(),
  date                text,
  campaign_id         text,
  campaign_name       text,
  adgroup_id          text,
  adgroup_name        text,
  impressions         text,
  clicks              text,
  cost                text,
  conversions         text,
  video_views         text,
  video_watch_25      text,
  video_watch_50      text,
  video_watch_75      text,
  video_watch_100     text,
  likes               text,
  shares              text,
  comments            text
);

-- GOOGLE RAW
create table raw.google_ads (
  _ingested_at timestamptz default now(),
  date                    text,
  campaign_id             text,
  campaign_name           text,
  ad_group_id             text,
  ad_group_name           text,
  impressions             text,
  clicks                  text,
  cost                    text,
  conversions             text,
  conversion_value        text,
  ctr                     text,
  avg_cpc                 text,
  quality_score           text,
  search_impression_share text
);

-- FACEBOOK RAW
create table raw.facebook_ads (
  _ingested_at timestamptz default now(),
  date              text,
  campaign_id       text,
  campaign_name     text,
  ad_set_id         text,
  ad_set_name       text,
  impressions       text,
  clicks            text,
  spend             text,
  conversions       text,
  video_views       text,
  engagement_rate   text,
  reach             text,
  frequency         text
);

