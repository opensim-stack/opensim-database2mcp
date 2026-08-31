#!/usr/bin/env sh
set -eu

transport="${DATABASE_MCP_TRANSPORT:-sse}"
transport_lc=$(printf '%s' "$transport" | tr '[:upper:]' '[:lower:]')

if [ "$transport_lc" != "sse" ]; then
  echo "[opensim-database2mcp] Unsupported DATABASE_MCP_TRANSPORT: $transport (only sse is supported)" >&2
  exit 1
fi

JAVA_OPTS_EXTRA="${JAVA_OPTS:-}"

set -- \
  -Djdbc.url="${JDBC_URL:-jdbc:mariadb://mariadb:3306/opensim}" \
  -Djdbc.user="${JDBC_USER:-opensim}" \
  -Djdbc.password="${JDBC_PASSWORD:-opensim}" \
  -Dquarkus.http.host="${DATABASE_MCP_HOST:-0.0.0.0}" \
  -Dquarkus.http.port="${DATABASE_MCP_PORT:-8080}" \
  -Dquarkus.mcp.server.sse.root-path="${DATABASE_MCP_SSE_ROOT_PATH:-/mcp}"

if [ -n "${JDBC_API_KEY:-}" ]; then
  set -- "$@" -Djdbc.api_key="${JDBC_API_KEY}"
fi

if [ -n "${JDBC_MAX_LONG_DATA:-}" ]; then
  set -- "$@" -Djdbc.max_long_data="${JDBC_MAX_LONG_DATA}"
fi

if [ -n "${DATABASE_MCP_LOG_LEVEL:-}" ]; then
  set -- "$@" -Dquarkus.log.level="${DATABASE_MCP_LOG_LEVEL}"
fi

if [ "${DATABASE_MCP_TRAFFIC_LOGGING:-false}" = "true" ]; then
  set -- "$@" \
    -Dquarkus.mcp.server.traffic-logging.enabled=true \
    -Dquarkus.mcp.server.traffic-logging.text-limit="${DATABASE_MCP_TRAFFIC_LOGGING_TEXT_LIMIT:-100}"
fi

if [ -n "$JAVA_OPTS_EXTRA" ]; then
  # Split additional JVM args intentionally.
  set -- "$@" $JAVA_OPTS_EXTRA
fi

exec java "$@" \
  -cp "/opt/opensim-database2mcp/mcp-jdbc-server-runner.jar:/opt/opensim-database2mcp/lib/*" \
  io.quarkus.runner.GeneratedMain
