-- E-commerce funnel: how many users reach each step?
-- Cost: scans ~145 MB (BigQuery dry run).

with user_steps as (
  select
    user_pseudo_id,
    countif(event_name = 'view_item')      > 0 as viewed_item,
    countif(event_name = 'add_to_cart')    > 0 as added_to_cart,
    countif(event_name = 'begin_checkout') > 0 as began_checkout,
    countif(event_name = 'purchase')       > 0 as purchased
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where _table_suffix between '20201101' and '20210131'
  group by 1
)

select
  countif(viewed_item)    as view_item,
  countif(added_to_cart)  as add_to_cart,
  countif(began_checkout) as begin_checkout,
  countif(purchased)      as purchase,
  round(100 * safe_divide(countif(purchased), countif(viewed_item)), 2) as view_to_purchase_pct
from user_steps;
