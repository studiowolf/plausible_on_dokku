-- Restore a database from our backups (needs to be truncated first)
RESTORE DATABASE plausible_events_db AS plausible FROM S3('https://s3.eu-central-003.backblazeb2.com/wolfmaps-clickhouse-backup/{timestamp}/', 'key', 'secret_key')

-- Truncate a database
TRUNCATE DATABASE plausible;

-- Enter the database
USE plausible;