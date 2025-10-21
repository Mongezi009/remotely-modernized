#!/bin/bash

# Remotely Quick Deployment Script
# This script helps deploy the modernized Remotely application using Docker

set -e

echo "🚀 Remotely Deployment Script"
echo "=============================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Function to use the appropriate docker compose command
docker_compose_cmd() {
    if command -v docker-compose &> /dev/null; then
        docker-compose "$@"
    else
        docker compose "$@"
    fi
}

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your configuration."
    echo "   You can continue with default settings or press Ctrl+C to edit now."
    read -p "Press Enter to continue with default settings..."
fi

echo ""
echo "🔧 Deployment Options:"
echo "1. Quick start (basic setup with SQLite)"
echo "2. Production setup with Traefik (automatic HTTPS)"
echo "3. Development setup"
echo "4. Build only"
echo "5. Stop and remove containers"

read -p "Select option [1-5]: " choice

case $choice in
    1)
        echo "🏃 Starting quick deployment..."
        docker_compose_cmd -f docker-compose.prod.yml up -d remotely
        ;;
    2)
        echo "🌐 Starting production deployment with Traefik..."
        docker_compose_cmd -f docker-compose.prod.yml --profile traefik up -d
        ;;
    3)
        echo "🛠️ Starting development deployment..."
        docker_compose_cmd -f docker-compose/docker-compose.yml up -d
        ;;
    4)
        echo "🔨 Building Docker image..."
        docker build -t remotely:latest -f Server/Dockerfile .
        echo "✅ Build completed!"
        exit 0
        ;;
    5)
        echo "🛑 Stopping and removing containers..."
        docker_compose_cmd -f docker-compose.prod.yml down
        docker_compose_cmd -f docker-compose/docker-compose.yml down 2>/dev/null || true
        echo "✅ Containers stopped and removed."
        exit 0
        ;;
    *)
        echo "❌ Invalid option selected."
        exit 1
        ;;
esac

echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Check if the service is running
if docker_compose_cmd -f docker-compose.prod.yml ps | grep -q "remotely-server.*Up"; then
    echo "✅ Remotely is running!"
    echo ""
    echo "🌍 Access your Remotely instance at:"
    
    # Get the port from environment or default
    PORT=${PORT:-5000}
    echo "   http://localhost:$PORT"
    
    if [ "$choice" == "2" ]; then
        DOMAIN=${DOMAIN:-localhost}
        echo "   https://$DOMAIN (once SSL is configured)"
        echo ""
        echo "📊 Traefik dashboard: http://localhost:8080"
    fi
    
    echo ""
    echo "📝 First time setup:"
    echo "   1. Visit the URL above"
    echo "   2. Click 'Register' to create the first admin account"
    echo "   3. Configure your organization settings"
    echo ""
    echo "📚 View logs: docker-compose -f docker-compose.prod.yml logs -f"
    echo "🛑 Stop: docker-compose -f docker-compose.prod.yml down"
    
else
    echo "❌ Failed to start Remotely. Check the logs:"
    docker_compose_cmd -f docker-compose.prod.yml logs remotely
    exit 1
fi