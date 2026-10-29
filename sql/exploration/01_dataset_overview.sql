-- 01 Dataset-Überblick
-- Frage: Welchen Zeitraum deckt der GA4-Beispieldatensatz ab und wie groß ist er?
-- Datensatz: Google Merchandise Store, GA4-Export (obfuskiert), Nov 2020 bis Jan 2021.
-- Kosten: liest nur drei schmale Spalten, daher wenig gescannte Bytes trotz aller Tage.

SELECT
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS erster_tag,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS letzter_tag,
  COUNT(DISTINCT event_date)            AS anzahl_tage,
  COUNT(*)                              AS events,
  COUNT(DISTINCT user_pseudo_id)        AS nutzer,
  COUNT(DISTINCT event_name)            AS event_typen
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;
