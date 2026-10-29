-- Which keys live inside event_params, and in which value type?
-- Limited to one month to save sandbox quota.

select
  p.key,
  count(*)                                 as occurrences,
  countif(p.value.string_value is not null) as as_string,
  countif(p.value.int_value    is not null) as as_int,
  countif(p.value.double_value is not null) as as_double
from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
  unnest(event_params) as p
where _table_suffix between '20201201' and '20201231'
group by 1
order by 2 desc;
