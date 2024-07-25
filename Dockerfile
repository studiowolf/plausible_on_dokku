ARG PLAUSIBLE_VERSION="v2.1.0"

FROM plausible/community-edition:$PLAUSIBLE_VERSION

USER root
COPY postgres.crt /usr/local/share/ca-certificates/postgres.crt
RUN update-ca-certificates

EXPOSE 5000/tcp

CMD \
  export PORT=5000 && \
  export CLICKHOUSE_DATABASE_URL=$(echo $CLICKHOUSE_URL | sed 's#clickhouse://#http://#' | sed 's#:9000/#:8123/#') && \
  sleep 10 && \
  /entrypoint.sh db migrate && \
  /entrypoint.sh run