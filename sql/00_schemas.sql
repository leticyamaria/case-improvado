-- Create schemas for different layers of the data warehouse

create schema if not exists raw;   -- raw CSV as-is
create schema if not exists stg;   -- typing + normalization
create schema if not exists mart;  -- unified facts + KPI views
