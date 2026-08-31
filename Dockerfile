# syntax=docker/dockerfile:1

FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /workspace

ARG MCP_JDBC_REPO=https://github.com/OpenLinkSoftware/mcp-jdbc-server.git
ARG MCP_JDBC_REF=main
ARG MARIADB_JDBC_VERSION=3.5.6

RUN apk add --no-cache git

RUN git clone --depth 1 --branch "${MCP_JDBC_REF}" "${MCP_JDBC_REPO}" mcp-jdbc-server

WORKDIR /workspace/mcp-jdbc-server

# Force SSE transport support for this image build.
RUN sed -i "s/quarkus-mcp-server-stdio/quarkus-mcp-server-sse/" build.gradle

RUN ./gradlew --no-daemon clean quarkusBuild -x test

RUN wget -q -O /workspace/mariadb-java-client.jar \
    "https://repo1.maven.org/maven2/org/mariadb/jdbc/mariadb-java-client/${MARIADB_JDBC_VERSION}/mariadb-java-client-${MARIADB_JDBC_VERSION}.jar"

RUN cp "$(find build -maxdepth 1 -type f -name '*-runner.jar' | head -n 1)" /workspace/mcp-jdbc-server-runner.jar

FROM eclipse-temurin:25-jre-alpine AS runtime
WORKDIR /opt/opensim-database2mcp

COPY --from=build /workspace/mcp-jdbc-server-runner.jar /opt/opensim-database2mcp/mcp-jdbc-server-runner.jar
COPY --from=build /workspace/mariadb-java-client.jar /opt/opensim-database2mcp/lib/mariadb-java-client.jar
COPY docker/entrypoint.sh /usr/local/bin/opensim-database2mcp-entrypoint.sh
RUN chmod +x /usr/local/bin/opensim-database2mcp-entrypoint.sh

ENV DATABASE_MCP_TRANSPORT=sse \
    DATABASE_MCP_HOST=0.0.0.0 \
    DATABASE_MCP_PORT=8080 \
    DATABASE_MCP_SSE_ROOT_PATH=/mcp \
    JDBC_URL=jdbc:mariadb://mariadb:3306/opensim \
    JDBC_USER=opensim \
    JDBC_PASSWORD=opensim

EXPOSE 8080/tcp
ENTRYPOINT ["/usr/local/bin/opensim-database2mcp-entrypoint.sh"]