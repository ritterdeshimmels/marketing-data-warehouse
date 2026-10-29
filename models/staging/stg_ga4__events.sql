-- One row per GA4 event, nested params flattened into columns.

with source as (
    select *
    from {{ source('ga4', 'events') }}
    where _table_suffix between '{{ var("start_date") }}' and '{{ var("end_date") }}'
)

select
    parse_date('%Y%m%d', event_date)               as event_date,
    timestamp_micros(event_timestamp)              as event_ts,
    event_name,
    user_pseudo_id,

    {{ event_param('ga_session_id', 'int_value') }}     as ga_session_id,
    {{ event_param('ga_session_number', 'int_value') }} as ga_session_number,
    {{ event_param('page_location') }}                  as page_location,

    -- session-level acquisition (set on some events only)
    {{ event_param('source') }}                    as event_source,
    {{ event_param('medium') }}                    as event_medium,
    {{ event_param('campaign') }}                  as event_campaign,

    -- user-level first touch
    traffic_source.source                          as first_user_source,
    traffic_source.medium                          as first_user_medium,
    traffic_source.name                            as first_user_campaign,

    device.category                                as device_category,
    geo.country                                    as country,

    ecommerce.transaction_id                       as transaction_id,
    ecommerce.purchase_revenue_in_usd              as purchase_revenue

from source
