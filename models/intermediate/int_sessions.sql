-- One row per session: acquisition, landing page, engagement, outcome.

with events as (
    select *
    from {{ ref('stg_ga4__events') }}
    where ga_session_id is not null
)

select
    concat(user_pseudo_id, '-', cast(ga_session_id as string)) as session_key,
    user_pseudo_id,
    ga_session_id,

    min(event_date)                                as session_date,
    min(event_ts)                                  as session_start_ts,
    max(ga_session_number)                         as session_number,

    coalesce(array_agg(event_source   ignore nulls order by event_ts limit 1)[safe_offset(0)], '(not set)') as session_source,
    coalesce(array_agg(event_medium   ignore nulls order by event_ts limit 1)[safe_offset(0)], '(not set)') as session_medium,
    coalesce(array_agg(event_campaign ignore nulls order by event_ts limit 1)[safe_offset(0)], '(not set)') as session_campaign,

    array_agg(if(event_name = 'page_view', page_location, null) ignore nulls order by event_ts limit 1)[safe_offset(0)] as landing_page,

    any_value(device_category)                     as device_category,
    any_value(country)                             as country,

    countif(event_name = 'page_view')              as pageviews,
    countif(event_name = 'add_to_cart')            as add_to_carts,
    countif(event_name = 'purchase')               as purchases,
    coalesce(sum(if(event_name = 'purchase', purchase_revenue, 0)), 0) as revenue

from events
group by 1, 2, 3
