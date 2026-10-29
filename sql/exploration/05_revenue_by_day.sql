-- 05 Umsatz pro Tag
-- Frage: Wie entwickeln sich Käufe, Umsatz und Warenkorbwert über den Dezember?
-- ecommerce ist ein STRUCT, auf seine Felder greift man mit Punkt zu.

SELECT
  PARSE_DATE('%Y%m%d', event_date)                      AS tag,
  COUNT(*)                                              AS kaeufe,
  ROUND(SUM(ecommerce.purchase_revenue_in_usd), 2)      AS umsatz_usd,
  ROUND(SAFE_DIVIDE(SUM(ecommerce.purchase_revenue_in_usd), COUNT(*)), 2) AS warenkorb_usd
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
  AND event_name = 'purchase'
GROUP BY tag
ORDER BY tag;
