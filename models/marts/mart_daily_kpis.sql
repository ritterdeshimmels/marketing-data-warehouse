-- Daily performance by session source / medium.

select
    session_date,
    session_source,
    session_medium,
    count(*)                                       as sessions,
    count(distinct user_pseudo_id)                 as users,
    sum(pageviews)                                 as pageviews,
    sum(purchases)                                 as purchases,
    round(sum(revenue), 2)                         as revenue,
    safe_divide(countif(purchases > 0), count(*))  as session_conversion_rate
from {{ ref('int_sessions') }}
group by 1, 2, 3
