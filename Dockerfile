ARG PLAUSIBLE_VERSION="v2.1.1"

FROM plausible/community-edition:$PLAUSIBLE_VERSION

# Add PostgreSQL certificate and backup script
COPY postgres.crt backup_clickhouse.py /app/

# Add python for backup script
USER root

# Install Python and necessary dependencies
RUN apk add --no-cache python3 py3-pip gcc musl-dev python3-dev libffi-dev \
    && pip install clickhouse-driver

USER plausible

EXPOSE 5000/tcp

CMD ["sh", "-c", "export PORT=5000 && \
    export CLICKHOUSE_DATABASE_URL=$(echo $CLICKHOUSE_URL | sed 's#clickhouse://#http://#' | sed 's#:9000/#:8123/#') && \
    sleep 10 && \
    /entrypoint.sh db migrate && \
    /entrypoint.sh run"]