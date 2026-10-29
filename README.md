# Marketing Data Warehouse

Ein Marketing-Data-Stack auf öffentlichen GA4-Daten: von rohen Events über ein
Sessionmodell bis zum Vergleich von Attributionsmodellen.

**Stack:** BigQuery · SQL · dbt · Python · Looker Studio

## Problem

Plattformen wie Google Ads und Meta rechnen sich ihre Conversions jeweils selbst zu.
Wer Budget verteilt, braucht eine eigene, neutrale Sicht auf die Daten: Welcher Kanal
bringt wirklich Kunden, und wie stark hängt die Antwort vom Attributionsmodell ab?

## Daten

[GA4-Beispieldatensatz](https://developers.google.com/analytics/bigquery/web-ecommerce-demo-dataset)
des Google Merchandise Store (`bigquery-public-data.ga4_obfuscated_sample_ecommerce`),
Nov 2020 bis Jan 2021. Öffentlich, keine Firmendaten.

## Architektur (Ziel)

```
GA4-Export (BigQuery)
   └─ staging      Events bereinigen, Parameter entpacken
       └─ intermediate   Sessions, Nutzer, Touchpoints
           └─ marts      Attribution (First Click, Last Click, linear) pro Kanal
                └─ Looker Studio Dashboard
```

## Struktur

| Ordner | Inhalt |
|--------|--------|
| `sql/exploration/` | 01–05: Datensatz kennenlernen |
| `sql/analysis/` | 06–10: eigene Analysen |
| `dbt/` | Datenmodell (ab Woche 7) |
| `python/` | Ad-Spend-Daten und Analysen (ab Woche 10) |
| `docs/` | Lernlog, Datenqualität |

## Roadmap

- [x] Repo-Struktur und Explorationsabfragen
- [ ] Fünf eigene SQL-Analysen (Woche 3)
- [ ] Sessionmodell, Kohortenanalyse, Datenlücken dokumentiert (Woche 6)
- [ ] dbt-Projekt mit drei Attributionsmodellen, Dashboard (Woche 9)

## Ergebnisse

_Folgt mit Screenshot des Dashboards._
