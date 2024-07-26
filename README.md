# Plausible on Dokku

Based on Plausible on Dokku (https://github.com/d1ceward/plausible_on_dokku/blob/master/Dockerfile)
Check for latest version

## Postgres certificate

postgres.crt should be replaced by Sunday, 25 May 2031. It can be downloaded from the DigitalOcean console.

## Backup

For now we run a FULL clickhouse backup once every three days at 3 am. Clickhouse backups could become pretty large in teh future. In that case we should start using incremental backups (and only make a full new backup once a month or so).

### Misc

- Enter container: dokku enter web /bin/sh
- Check logs when application won't start: dokku logs
