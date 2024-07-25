ARG PLAUSIBLE_VERSION="v2.0.0"

FROM plausible/analytics:$PLAUSIBLE_VERSION

USER root

RUN apk add --no-cache clickhouse-client

EXPOSE 5000/tcp

CMD \
  export PORT=5000 && \
  export CLICKHOUSE_DATABASE_URL=$(echo $CLICKHOUSE_URL | sed 's#clickhouse://#http://#' | sed 's#:9000/#:8123/#') && \
  sleep 10 && \
  /entrypoint.sh db migrate && \
  /entrypoint.sh run