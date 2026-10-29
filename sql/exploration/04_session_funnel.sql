-- 04 Session-Funnel
-- Frage: Wie viele Sessions erreichen welchen Schritt bis zum Kauf?
-- Neu hier: UNNEST. GA4 speichert Parameter wie ga_session_id in einem verschachtelten
-- Feld (event_params). Mit UNNEST holt man einen einzelnen Wert heraus.
-- Eine Session ist eindeutig erst durch user_pseudo_id + ga_session_id.

WITH events AS (
  SELECT
    user_pseudo_id,
    (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id') AS session_id,
    event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
    AND event_name IN ('session_start', 'view_item', 'add_to_cart', 'begin_checkout', 'purchase')
),

sessions AS (
  -- eine Zeile pro Session, je Schritt 1 = erreicht, 0 = nicht erreicht
  SELECT
    CONCAT(user_pseudo_id, '-', CAST(session_id AS STRING)) AS session_key,
    MAX(IF(event_name = 'view_item', 1, 0))      AS view_item,
    MAX(IF(event_name = 'add_to_cart', 1, 0))    AS add_to_cart,
    MAX(IF(event_name = 'begin_checkout', 1, 0)) AS begin_checkout,
    MAX(IF(event_name = 'purchase', 1, 0))       AS purchase
  FROM events
  WHERE session_id IS NOT NULL  -- Events ohne Session-ID sind eine bekannte Datenlücke
  GROUP BY session_key
)

SELECT
  COUNT(*)            AS sessions,
  SUM(view_item)      AS sessions_view_item,
  SUM(add_to_cart)    AS sessions_add_to_cart,
  SUM(begin_checkout) AS sessions_begin_checkout,
  SUM(purchase)       AS sessions_purchase,
  ROUND(SAFE_DIVIDE(SUM(purchase), COUNT(*)) * 100, 2) AS session_conversion_rate_pct
FROM sessions;
