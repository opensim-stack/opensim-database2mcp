# Building

## Build local Docker image

```bash
docker build -t opensim-database2mcp:local .
```

### Optional build args

- `MCP_JDBC_REF` (default `main`)
- `MARIADB_JDBC_VERSION` (default `3.5.6`)

Example:

```bash
docker build \
  --build-arg MCP_JDBC_REF=main \
  --build-arg MARIADB_JDBC_VERSION=3.5.6 \
  -t opensim-database2mcp:local \
  .
```

## Run local image

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
  opensim-database2mcp:local
```

## Build and publish multiarch image

Create/use a buildx builder once:

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
```

Build and push Linux AMD64 + ARM64:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t bithatch/opensim-database2mcp:latest \
  -t bithatch/opensim-database2mcp:$(date +%Y%m%d) \
  --push \
  .
```
