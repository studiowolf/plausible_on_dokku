import os
from datetime import datetime
from clickhouse_driver import Client

# Replace these with your actual connection details
connection_string = os.getenv('CLICKHOUSE_DATABASE_URL')
s3_access_key_id = os.getenv('B2_ACCESS_KEY_ID')
s3_secret_access_key = os.getenv('B2_SECRET_ACCESS_KEY')

if not all([connection_string, s3_access_key_id, s3_secret_access_key]):
    raise ValueError("Missing one or more required environment variables.")

# Create a client instance using the connection string
client = Client.from_url(connection_string)

# Generate a timestamp
timestamp = datetime.now().strftime('%Y-%m-%d-%H:%M')

print(timestamp)

# Define the BACKUP query with environment variable credentials
backup_query = f"""
BACKUP DATABASE plausible_events_db TO S3(
    'https://s3.eu-central-003.backblazeb2.com/wolfmaps-clickhouse-backup/{timestamp}/',
    '{s3_access_key_id}',
    '{s3_secret_access_key}'
)
"""

# Execute the query
try:
    result = client.execute(backup_query)
    print("Backup completed successfully.")
except Exception as e:
    print("An error occurred:", e)
