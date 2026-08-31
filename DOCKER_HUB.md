# opensim-database2mcp

`opensim-database2mcp` bridges JDBC-accessible databases to MCP using the OpenLink JDBC MCP server.

It is intended to be used as part of the **OpenSim Stack** project:
**"A docker stack to get an AI integrated virtual world up and running in minutes."**

## What This Image Does

- Builds and runs the OpenLink `mcp-jdbc-server`
- Exposes database query and schema tools over MCP
- Runs MCP in SSE mode for broad client compatibility
- Includes the MariaDB JDBC driver out of the box

## Quick Start

Run the container and point it at your MariaDB/OpenSim database:

```bash
docker run --rm \
  -e DATABASE_MCP_TRANSPORT=sse \
  -e DATABASE_MCP_HOST=0.0.0.0 \
  -e DATABASE_MCP_PORT=8080 \
  -e DATABASE_MCP_SSE_ROOT_PATH=/mcp \
  -e JDBC_URL=jdbc:mariadb://host.docker.internal:3306/opensim \
  -e JDBC_USER=opensim \
  -e JDBC_PASSWORD=opensim \
  -p 8080:8080 \
  bithatch/opensim-database2mcp:latest
```

Then connect your MCP client to:

- `http://localhost:8080/mcp/sse`

## Project Links

- Main AI Stack (`opensim-ai-docker`): https://github.com/opensim-stack/opensim-ai-docker
- `opensim-database2mcp` on GitHub: https://github.com/opensim-stack/opensim-database2mcp
- Upstream JDBC MCP server (`mcp-jdbc-server`): https://github.com/OpenLinkSoftware/mcp-jdbc-server
