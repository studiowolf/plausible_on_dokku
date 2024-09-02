# Migreren

Voor bijvoorbeeld het wijzigen van namen van onze custom events

- Alvorens migraties uit te voren, voer een back-up uit
- Update statements eerst lokaal testen
- Tabel als volgt lokaal laden

RESTORE TABLE plausible_events_db.sessions_v2 AS sessions_v3
FROM
  S3(
    'https://s3.eu-central-003.backblazeb2.com/wolfmaps-clickhouse-backup/{TIMESTAMP}',
    'key_id',
    'secret_key'
  )

- Plausible stoppen
- Daaran zijn ze gemaakte queries direct op de productiedatabase uit te voeren
- Plausible weer starten