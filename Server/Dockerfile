# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

# Copy csproj files and restore dependencies
COPY Server/Server.csproj Server/
COPY Shared/Shared.csproj Shared/
COPY Directory.Build.props .
RUN dotnet restore Server/Server.csproj

# Copy everything else and build
COPY . .
RUN dotnet publish Server/Server.csproj -c Release -o out --no-restore

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

# Install curl for health checks and create non-root user
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && groupadd -r remotely && useradd -r -g remotely remotely

# Copy published app from build stage
COPY --from=build-env /app/out .

# Create AppData directory and set permissions
RUN mkdir -p /app/AppData && chown -R remotely:remotely /app

# Switch to non-root user
USER remotely

EXPOSE ${ASPNETCORE_HTTP_PORTS:-5000}

ENTRYPOINT ["dotnet", "Remotely_Server.dll"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:${ASPNETCORE_HTTP_PORTS:-5000}/api/healthcheck || exit 1
