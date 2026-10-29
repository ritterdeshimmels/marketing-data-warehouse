-- 03 Traffic-Quellen und Conversion Rate
-- Frage: Aus welchen Quellen kommen die Nutzer und welche Quelle kauft am häufigsten?
-- Achtung: traffic_source ist die ERSTE Akquisitionsquelle des Nutzers (First Touch),
-- nicht die Quelle der jeweiligen Session.

WITH nutzer AS (
  -- Schritt 1: eine Zeile pro Nutzer
  SELECT
    user_pseudo_id,
    ANY_VALUE(traffic_source.source)             AS quelle,
    ANY_VALUE(traffic_source.medium)             AS medium,
    MAX(IF(event_name = 'purchase', 1, 0))       AS hat_gekauft
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
  GROUP BY user_pseudo_id
)

-- Schritt 2: Nutzer pro Quelle/Medium zusammenfassen
SELECT
  quelle,
  medium,
  COUNT(*)                                             AS nutzer,
  SUM(hat_gekauft)                                     AS kaeufer,
  ROUND(SAFE_DIVIDE(SUM(hat_gekauft), COUNT(*)) * 100, 2) AS conversion_rate_pct
FROM nutzer
GROUP BY quelle, medium
ORDER BY nutzer DESC;
