# opensim-database2mcp

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-bithatch%2Fopensim--database2mcp-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/repository/docker/bithatch/opensim-database2mcp/general)

Bridges JDBC-compatible databases (including MariaDB) and the MCP protocol through the OpenLink JDBC MCP server.

**For Issues And Discussions see main project [opensim-ai-docker](https://github.com/opensim-stack/opensim-ai-docker)**

*This is part of the [opensim-stack](https://opensim-stack.github.io/) and is intended to be used in conjunction with other parts of the stack. See [Docs](https://opensim-stack.github.io/docs/index.html) for full details.*

## Environment Variables

- `DATABASE_MCP_TRANSPORT` (must be `sse`)
- `DATABASE_MCP_HOST`
- `DATABASE_MCP_PORT`
- `DATABASE_MCP_SSE_ROOT_PATH`
- `JDBC_URL`
- `JDBC_USER`
- `JDBC_PASSWORD`

### Optional variables

- `JDBC_API_KEY`
- `JDBC_MAX_LONG_DATA`
- `DATABASE_MCP_LOG_LEVEL` (for example `INFO`, `DEBUG`)
- `DATABASE_MCP_TRAFFIC_LOGGING` (`true`/`false`)
- `DATABASE_MCP_TRAFFIC_LOGGING_TEXT_LIMIT` (default `100`)
- `DATABASE_MCP_BUILD_REF` (git ref, tag, or commit for `mcp-jdbc-server`, default `main`)