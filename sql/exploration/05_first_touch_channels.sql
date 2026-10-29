-- Revenue by the user's FIRST acquisition channel (GA4 traffic_source).
-- Compare later with session-level and multi-touch attribution.

select
  traffic_source.medium                                                  as first_medium,
  traffic_source.source                                                  as first_source,
  count(distinct user_pseudo_id)                                         as users,
  countif(event_name = 'purchase')                                       as purchases,
  round(sum(if(event_name = 'purchase', ecommerce.purchase_revenue_in_usd, 0)), 2) as revenue
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
where _table_suffix between '20201101' and '20210131'
group by 1, 2
order by revenue desc;
