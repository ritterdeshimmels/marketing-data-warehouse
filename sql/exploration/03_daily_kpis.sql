-- Daily users, sessions, purchases, revenue.
-- Cost: scans ~1.04 GB (BigQuery dry run).

with events as (
  select
    parse_date('%Y%m%d', event_date) as day,
    user_pseudo_id,
    event_name,
    (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
    ecommerce.purchase_revenue_in_usd as revenue
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where _table_suffix between '20201101' and '20210131'
)

select
  day,
  count(distinct user_pseudo_id)                                       as users,
  count(distinct concat(user_pseudo_id, cast(session_id as string)))   as sessions,
  countif(event_name = 'purchase')                                     as purchases,
  round(sum(if(event_name = 'purchase', revenue, 0)), 2)               as revenue
from events
group by day
order by day;
