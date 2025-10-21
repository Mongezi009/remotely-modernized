# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Remotely is a remote control and remote scripting solution built with .NET 8, Blazor, and SignalR Core. It consists of multiple components that work together to provide remote access capabilities across Windows, Linux, and macOS platforms.

## Development Commands

### Building and Running
```powershell
# Build entire solution
dotnet build

# Run the server (from Server directory)
dotnet run --project Server

# Run server with specific configuration
dotnet run --project Server --environment Development
```

### Testing
```powershell
# Run all tests
dotnet test

# Run specific test project
dotnet test Tests/Server.Tests/Server.Tests.csproj
dotnet test Tests/Shared.Tests/Shared.Tests.csproj

# Run tests with coverage
dotnet test --collect:"XPlat Code Coverage"
```

### Publishing and Deployment
```powershell
# Use the utility script to publish all components
Utilities/Publish.ps1

# Publish server for specific runtime
dotnet publish --runtime win-x64 --self-contained --configuration Release --output ./publish Server/

# Publish agents for multiple platforms
dotnet publish --runtime win-x64 --self-contained --configuration Release Agent/
dotnet publish --runtime linux-x64 --self-contained --configuration Release Agent/
dotnet publish --runtime osx-x64 --self-contained --configuration Release Agent/
```

### Docker Operations
```powershell
# Start with Docker Compose (from docker-compose directory)
docker-compose up -d

# View logs
docker-compose logs -f remotely

# Stop containers
docker-compose down
```

### Database Management
```powershell
# Add new migration (from Server directory)
dotnet ef migrations add [MigrationName] --context ApplicationDbContext

# Update database
dotnet ef database update --context ApplicationDbContext

# Remove last migration
dotnet ef migrations remove --context ApplicationDbContext
```

## Architecture Overview

### Core Components

**Server (ASP.NET Core 8.0)**
- Web application with Blazor Server UI
- SignalR hubs for real-time communication (DesktopHub, ViewerHub, AgentHub)
- Entity Framework Core for data persistence (SQLite, SQL Server, PostgreSQL support)
- API endpoints with Swagger documentation
- Authentication and authorization with ASP.NET Core Identity

**Agent (Console Application)**
- Background service that runs on target machines
- Maintains persistent SignalR connection to server
- Cross-platform support (Windows Service, systemd, launchd)
- PowerShell integration for script execution
- Automatic updates and self-management capabilities

**Desktop Components**
- **Desktop.Shared**: Common desktop functionality and SignalR client logic
- **Desktop.Win**: Windows-specific desktop application using WinUI/WPF
- **Desktop.Linux**: Linux desktop application with X11 integration
- **Desktop.UI**: Cross-platform UI components
- **Desktop.Core**: Core screen capture and input injection services
- **Desktop.Native**: Native platform-specific functionality

**Shared Library**
- Common models, enums, and interfaces
- MessagePack serialization for efficient communication
- Platform detection utilities
- Shared business logic and validation

### Communication Architecture

The system uses a hub-and-spoke model with SignalR:

1. **AgentHub**: Manages connections from background agents
2. **DesktopHub**: Handles desktop streaming applications
3. **ViewerHub**: Manages viewer web clients

Remote control sessions can be:
- **Attended**: Temporary session with user consent (9-digit session ID)
- **Unattended**: Persistent access for managed devices

### Database Schema

The system supports multiple database providers configured via `ApplicationOptions.DbProvider`:
- SQLite (default for development/small deployments)
- SQL Server (enterprise deployments)
- PostgreSQL (cross-platform alternative)

Key entities include Device, User, Organization, RemoteLog, and ScriptResult.

## Development Guidelines

### Project Structure Conventions
- Each major component has its own project (Agent, Server, Desktop.*)
- Platform-specific code is isolated in dedicated projects/folders
- Shared code goes in the Shared project
- Tests are organized in the Tests/ folder

### SignalR Hub Development
- All hubs implement strongly-typed client interfaces (IAgentHubClient, IDesktopHubClient, etc.)
- Use dependency injection for accessing services
- Handle connection state changes and errors gracefully
- Log operations with appropriate scoped logging

### Cross-Platform Development
- Use `OperatingSystem.IsWindows()`, `OperatingSystem.IsLinux()`, etc. for platform detection
- Implement platform-specific services with common interfaces
- Use conditional compilation only when absolutely necessary
- Test on all supported platforms when making system-level changes

### Configuration Management
- Server configuration through appsettings.json and environment variables
- Agent configuration through command-line arguments and registry/config files
- Docker environment variables follow the pattern `Remotely_Section__Key`
- Use strongly-typed configuration models

### Error Handling and Logging
- Use structured logging with Serilog
- Include scoped logging for hub operations
- Handle SignalR connection failures and implement retry logic
- Log security events appropriately

## Debugging and Development Setup

### Local Development
- Server runs on https://localhost:5001 by default
- Agent connects to localhost in development mode
- First user registration becomes server admin
- All connecting agents assigned to first organization in development

### Remote Control Testing
- Use attended sessions for quick testing (9-digit session ID)
- Desktop applications can be launched via agent for unattended testing
- Multiple viewers can connect to the same session

### Docker Development
- Use docker-compose for consistent development environment
- Mount `/app/AppData` for persistent data
- Configure reverse proxy (Caddy recommended) for external access

## Security Considerations

### Authentication and Authorization
- Uses ASP.NET Core Identity for user management
- API access requires authentication tokens
- Organizations provide multi-tenancy isolation
- 2FA support available

### Network Security
- HTTPS required for production deployments
- SignalR uses secure WebSocket connections
- Agent validates server certificates
- Support for reverse proxy configurations (proper forwarded headers required)

### Data Protection
- Sensitive data encrypted at rest
- Remote control sessions can be recorded if enabled
- Logs contain device information and session data (respect data retention policies)

## Platform-Specific Notes

### Windows Development
- Requires Visual Studio 2022 with specific workloads (see README.md)
- Uses Windows Services for agent deployment
- Secure Attention Sequence (SAS) registry configuration for Ctrl+Alt+Del simulation
- Code signing supported for release builds

### Linux Development
- Tested primarily on Ubuntu LTS
- Requires X11 development libraries for desktop functionality
- Uses systemd for service management
- AppImage packaging for desktop applications

### macOS Development
- Limited testing compared to Windows/Linux
- Uses launchd for service management
- Separate builds for x64 and ARM64 architectures
