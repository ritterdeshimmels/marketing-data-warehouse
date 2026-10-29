-- What's in the dataset? Date range, volume, event types.
-- Cost: scans ~244 MB (BigQuery dry run).

select
  min(event_date)                 as first_day,
  max(event_date)                 as last_day,
  count(*)                        as events,
  count(distinct user_pseudo_id)  as users,
  count(distinct event_name)      as event_types
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _table_suffix between '20201101' and '20210131';

select event_name, count(*) as events
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _table_suffix between '20201101' and '20210131'
group by 1
order by 2 desc;
