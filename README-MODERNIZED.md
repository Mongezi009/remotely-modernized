# 🚀 Remotely - Modernized Edition

A remote control and remote scripting solution, built with .NET 8, Blazor, and SignalR Core, featuring a completely modernized user interface.

[![Build Status](https://dev.azure.com/immybot/Remotely/_apis/build/status%2Fimmense.Remotely?branchName=master)](https://dev.azure.com/immybot/Remotely/_build/latest?definitionId=2&branchName=master)
[![Tests](https://github.com/immense/Remotely/actions/workflows/run_tests.yml/badge.svg?branch=master)](https://github.com/immense/Remotely/actions/workflows/run_tests.yml)
[![Docker Pulls](https://img.shields.io/docker/pulls/immybot/remotely)](https://hub.docker.com/r/immybot/remotely)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## ✨ What's New - Modern UI Edition

This modernized version features a completely redesigned interface with:

- 🎨 **Modern Design Language** - Contemporary UI with glass-morphism effects and smooth animations
- 🎯 **Improved User Experience** - Intuitive navigation and better visual hierarchy  
- 📱 **Responsive Design** - Optimized for all screen sizes and devices
- ⚡ **Enhanced Performance** - Optimized assets and improved loading times
- 🎭 **Professional Aesthetics** - Modern color schemes, typography, and iconography
- 🔧 **Better Accessibility** - Improved keyboard navigation and screen reader support

### 🖼️ UI Showcase

**Modern Landing Page**
- Beautiful hero section with feature highlights
- Professional gradient backgrounds
- Smooth animations and micro-interactions

**Redesigned Dashboard**
- Card-based layout for better information organization
- Modern navigation with SVG icons
- Responsive grid system that adapts to any screen size

**Enhanced Navigation**
- Glass-morphism sidebar effects
- Smooth transitions and hover states
- Better visual feedback and user guidance

## 🚀 Quick Start

### Using Docker (Recommended)

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Remotely.git
   cd Remotely
   ```

2. **Quick deployment**
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```
   
   Or manually with Docker Compose:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

3. **Access your instance**
   - Open http://localhost:5000 in your browser
   - Click "Register" to create your admin account
   - Start managing your devices!

### 🐳 Docker Deployment Options

#### Simple Deployment
```bash
# Quick start with SQLite
docker-compose -f docker-compose.prod.yml up -d remotely
```

#### Production with Automatic HTTPS
```bash
# With Traefik reverse proxy and Let's Encrypt SSL
cp .env.example .env
# Edit .env with your domain and email
docker-compose -f docker-compose.prod.yml --profile traefik up -d
```

#### Development Setup
```bash
# For development with hot reload
docker-compose -f docker-compose/docker-compose.yml up -d
```

## 📋 Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
# Basic Configuration
PORT=5000
DOMAIN=yourdomain.com

# Database (SQLite, SQLServer, PostgreSQL)
DB_PROVIDER=SQLite

# Security
FORCE_HTTPS=true
USE_HSTS=true

# SMTP (optional)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Supported Databases

- **SQLite** (default) - Perfect for small to medium deployments
- **PostgreSQL** - Recommended for larger deployments  
- **SQL Server** - Enterprise-grade option

## 🏗️ Architecture

### Core Components

- **Server** - ASP.NET Core 8.0 web application with Blazor UI
- **Agent** - Cross-platform background service for target machines
- **Desktop Apps** - Native remote control applications for Windows/Linux
- **Shared Library** - Common models and utilities

### Modern Tech Stack

- **.NET 8** - Latest LTS version with improved performance
- **Blazor Server** - Real-time UI with SignalR
- **Modern CSS** - Inter font, contemporary colors, smooth animations
- **Docker** - Containerized deployment with multi-stage builds
- **SignalR** - Real-time communication between components

## 🔧 Development

### Prerequisites

- Visual Studio 2022 or VS Code
- .NET 8 SDK
- Node.js (for asset building)
- Docker (for containerized development)

### Local Development

```bash
# Clone with submodules
git clone https://github.com/yourusername/Remotely.git --recurse-submodules

# Restore dependencies
dotnet restore

# Run the server
dotnet run --project Server

# Access at https://localhost:5001
```

### Building

```bash
# Build all projects
dotnet build

# Run tests  
dotnet test

# Publish for deployment
dotnet publish Server -c Release -o ./publish
```

## 📦 Deployment

### Docker Production Deployment

1. **Prepare configuration**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

2. **Deploy with automatic HTTPS**
   ```bash
   docker-compose -f docker-compose.prod.yml --profile traefik up -d
   ```

3. **Monitor deployment**
   ```bash
   docker-compose -f docker-compose.prod.yml logs -f
   ```

### Manual Deployment

1. **Publish the application**
   ```bash
   dotnet publish Server -c Release -o ./deploy
   ```

2. **Copy to server and configure reverse proxy**
   - Use Caddy, Nginx, or IIS as reverse proxy
   - Ensure proper forwarded headers configuration
   - Configure SSL/TLS certificates

### Health Checks

The application includes built-in health checks at `/api/healthcheck` for monitoring and load balancer configuration.

## 🔐 Security Features

- **HTTPS enforcement** with HSTS support
- **2FA authentication** support
- **Role-based access control** with organizations
- **API key authentication** for integrations
- **Session management** with automatic timeouts
- **Secure WebSocket** connections for real-time features

## 🌐 Platform Support

### Server Requirements
- **Windows Server** 2019/2022
- **Linux** (Ubuntu 20.04+ LTS recommended)
- **Docker** (any platform supporting Docker)

### Agent Support
- **Windows** 10/11, Server 2019/2022
- **Linux** (Ubuntu, CentOS, RHEL, etc.)
- **macOS** (Intel and Apple Silicon)

### Remote Control Clients
- **Windows** - Native WPF application
- **Linux** - Native application with X11 support
- **Web** - Browser-based viewer (all modern browsers)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📚 Documentation

- [Installation Guide](docs/INSTALL.md)
- [API Documentation](https://localhost:5001/swagger) (when running)
- [Configuration Reference](docs/CONFIG.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)

## 🆘 Support

- **Documentation**: Check our comprehensive docs
- **Community**: Join discussions in GitHub Discussions
- **Issues**: Report bugs or request features via GitHub Issues

## 📄 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original Remotely project by Immense Networks
- Modern UI inspired by contemporary design systems
- Community contributors and testers
- Open source libraries and frameworks that make this possible

---

**Made with ❤️ for the open source community**

🌟 If you find this project useful, please consider starring the repository!