-- 02 Event-Typen
-- Frage: Welche Events gibt es und wie oft kommen sie vor?
-- _TABLE_SUFFIX begrenzt die Abfrage auf Dezember 2020. Die Tabelle ist pro Tag
-- aufgeteilt (events_20201201, events_20201202, ...), der Filter spart also Kosten.

SELECT
  event_name,
  COUNT(*)                       AS events,
  COUNT(DISTINCT user_pseudo_id) AS nutzer
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX BETWEEN '20201201' AND '20201231'
GROUP BY event_name
ORDER BY events DESC;
