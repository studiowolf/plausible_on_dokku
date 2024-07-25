ARG PLAUSIBLE_VERSION="v2.1.1"

FROM plausible/community-edition:$PLAUSIBLE_VERSION

ADD postgres.crt /app/postgres.crt

# Add python for backup script
USER root

RUN apk add --no-cache python3 py3-pip
RUN pip install clickhouse-connect

USER plausible

EXPOSE 5000/tcp

CMD \
  export PORT=5000 && \
  export CLICKHOUSE_DATABASE_URL=$(echo $CLICKHOUSE_URL | sed 's#clickhouse://#http://#' | sed 's#:9000/#:8123/#') && \
  sleep 10 && \
  /entrypoint.sh db migrate && \
  /entrypoint.sh run