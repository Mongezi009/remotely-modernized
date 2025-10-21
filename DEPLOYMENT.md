# 🚀 Deployment Guide - Remotely Modernized

This guide covers deploying your modernized Remotely application to production environments.

## 📋 Pre-deployment Checklist

- [ ] Domain name configured and pointing to your server
- [ ] Server with Docker and Docker Compose installed
- [ ] SSL certificates or Let's Encrypt setup
- [ ] Database configured (SQLite, PostgreSQL, or SQL Server)
- [ ] SMTP settings (for email notifications)
- [ ] Firewall configured (ports 80, 443, and your custom port)

## 🐳 Docker Deployment (Recommended)

### Quick Start
```bash
git clone https://github.com/yourusername/remotely-modernized.git
cd remotely-modernized
cp .env.example .env
# Edit .env with your configuration
chmod +x deploy.sh
./deploy.sh
```

### Manual Docker Deployment

1. **Clone and Configure**
   ```bash
   git clone https://github.com/yourusername/remotely-modernized.git
   cd remotely-modernized
   cp .env.example .env
   ```

2. **Edit Configuration**
   ```bash
   nano .env
   ```
   
   Essential settings:
   ```env
   DOMAIN=yourdomain.com
   PORT=5000
   DB_PROVIDER=PostgreSQL  # or SQLite, SQLServer
   ACME_EMAIL=admin@yourdomain.com
   ```

3. **Deploy with Automatic HTTPS**
   ```bash
   docker-compose -f docker-compose.prod.yml --profile traefik up -d
   ```

4. **Monitor Deployment**
   ```bash
   docker-compose -f docker-compose.prod.yml logs -f
   ```

## 🛠️ Manual Deployment

### Server Preparation

1. **Install Prerequisites**
   ```bash
   # Ubuntu/Debian
   wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
   sudo dpkg -i packages-microsoft-prod.deb
   sudo apt update
   sudo apt install dotnet-sdk-8.0 nginx
   ```

2. **Build Application**
   ```bash
   dotnet publish Server -c Release -o /var/www/remotely
   ```

3. **Configure Nginx**
   ```nginx
   server {
       listen 80;
       server_name yourdomain.com;
       return 301 https://$server_name$request_uri;
   }
   
   server {
       listen 443 ssl http2;
       server_name yourdomain.com;
       
       ssl_certificate /path/to/your/cert.pem;
       ssl_certificate_key /path/to/your/key.pem;
       
       location / {
           proxy_pass http://127.0.0.1:5000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_set_header X-Forwarded-Host $host;
           proxy_cache_bypass $http_upgrade;
           
           # WebSocket support
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection "upgrade";
       }
   }
   ```

4. **Create Systemd Service**
   ```bash
   sudo nano /etc/systemd/system/remotely.service
   ```
   
   ```ini
   [Unit]
   Description=Remotely Server
   After=network.target
   
   [Service]
   Type=notify
   ExecStart=/usr/bin/dotnet /var/www/remotely/Remotely_Server.dll
   Restart=always
   RestartSec=5
   KillSignal=SIGINT
   SyslogIdentifier=remotely
   User=www-data
   Environment=ASPNETCORE_ENVIRONMENT=Production
   Environment=ASPNETCORE_URLS=http://localhost:5000
   WorkingDirectory=/var/www/remotely
   
   [Install]
   WantedBy=multi-user.target
   ```

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DOMAIN` | Your domain name | `localhost` |
| `PORT` | HTTP port | `5000` |
| `DB_PROVIDER` | Database type | `SQLite` |
| `FORCE_HTTPS` | Force HTTPS redirects | `false` |
| `SMTP_HOST` | SMTP server | - |
| `SMTP_PORT` | SMTP port | `587` |

### Database Configuration

#### SQLite (Default)
```env
DB_PROVIDER=SQLite
# No additional configuration needed
```

#### PostgreSQL (Recommended for production)
```env
DB_PROVIDER=PostgreSQL
POSTGRESQL_CONNECTION=Host=localhost;Database=remotely;Username=remotely;Password=your_password;
```

#### SQL Server
```env
DB_PROVIDER=SQLServer  
SQL_SERVER_CONNECTION=Server=localhost;Database=Remotely;Trusted_Connection=True;
```

## 🔐 Security Configuration

### SSL/TLS Setup

**With Traefik (Automatic)**
```env
DOMAIN=yourdomain.com
ACME_EMAIL=admin@yourdomain.com
```

**Manual Certificate**
- Place certificates in `/etc/ssl/certs/`
- Configure your reverse proxy
- Set `FORCE_HTTPS=true`

### Firewall Configuration

```bash
# Ubuntu UFW
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# CentOS/RHEL Firewalld
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

## 📊 Monitoring and Maintenance

### Health Checks

**Docker Deployment**
```bash
docker-compose -f docker-compose.prod.yml ps
curl -f http://localhost:5000/api/healthcheck
```

**Manual Deployment**
```bash
systemctl status remotely
curl -f https://yourdomain.com/api/healthcheck
```

### Log Management

**Docker Logs**
```bash
docker-compose -f docker-compose.prod.yml logs -f remotely
```

**System Logs**
```bash
journalctl -u remotely -f
tail -f /var/log/remotely/app.log
```

### Backup Strategy

**Database Backup**
```bash
# SQLite
cp /app/AppData/Remotely.db /backup/remotely-$(date +%Y%m%d).db

# PostgreSQL
pg_dump remotely > /backup/remotely-$(date +%Y%m%d).sql
```

**Application Data**
```bash
tar -czf /backup/remotely-data-$(date +%Y%m%d).tar.gz /app/AppData/
```

## 🚀 Scaling and Performance

### Load Balancing

For high-traffic deployments, use multiple instances behind a load balancer:

```yaml
# docker-compose.scale.yml
version: '3.8'
services:
  remotely:
    scale: 3
    
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

### Database Optimization

**PostgreSQL Settings**
```sql
-- Increase connection limits
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
```

## 🆘 Troubleshooting

### Common Issues

**Port Already in Use**
```bash
sudo lsof -i :5000
sudo kill -9 <PID>
```

**Permission Denied**
```bash
sudo chown -R www-data:www-data /var/www/remotely
sudo chmod -R 755 /var/www/remotely
```

**SSL Certificate Issues**
```bash
# Check certificate validity
openssl x509 -in /path/to/cert.pem -text -noout

# Test SSL configuration
curl -I https://yourdomain.com
```

### Getting Help

1. **Check Logs** - Always start with application and system logs
2. **Verify Configuration** - Double-check environment variables and config files
3. **Test Connectivity** - Ensure ports are open and services are running
4. **Documentation** - Refer to the main README and API documentation
5. **Community** - Open an issue on GitHub with detailed information

## 🔄 Updates and Maintenance

### Updating the Application

**Docker Deployment**
```bash
cd /path/to/remotely
git pull origin main
docker-compose -f docker-compose.prod.yml pull
docker-compose -f docker-compose.prod.yml up -d
```

**Manual Deployment**
```bash
cd /path/to/source
git pull origin main
dotnet publish Server -c Release -o /var/www/remotely
sudo systemctl restart remotely
```

### Database Migrations

Migrations run automatically on startup, but you can run them manually:

```bash
dotnet ef database update --project Server
```

---

**Happy Deploying! 🎉**

For more detailed information, refer to the main [README](README-MODERNIZED.md) and check the [GitHub repository](https://github.com/yourusername/remotely-modernized) for updates.