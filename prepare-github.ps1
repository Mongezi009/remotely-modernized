# Remotely - GitHub Preparation Script
# This script prepares the modernized Remotely project for GitHub upload

Write-Host "🚀 Preparing Remotely for GitHub upload..." -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check if Git is installed
try {
    git --version | Out-Null
    Write-Host "✅ Git is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    Write-Host "Download from: https://git-scm.com/download/windows" -ForegroundColor Yellow
    exit 1
}

# Initialize Git repository if not already initialized
if (-not (Test-Path ".git")) {
    Write-Host "📝 Initializing Git repository..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
} else {
    Write-Host "✅ Git repository already exists" -ForegroundColor Green
}

# Create initial commit if no commits exist
$commitCount = git rev-list --count HEAD 2>$null
if (-not $commitCount -or $commitCount -eq "0") {
    Write-Host "📦 Creating initial commit..." -ForegroundColor Yellow
    
    # Stage all files
    git add .
    
    # Create initial commit
    git commit -m "🎨 Initial commit: Modernized Remotely with contemporary UI

Features:
- Modern glass-morphism design with gradients and animations
- Responsive layout optimized for all devices  
- Updated navigation with SVG icons and smooth transitions
- Contemporary color scheme and typography using Inter font
- Enhanced dashboard with card-based layout
- Improved accessibility and user experience
- Docker-ready with production deployment configurations
- Comprehensive documentation and deployment guides

Tech Stack:
- .NET 8 with Blazor Server
- Modern CSS with Inter font and contemporary colors
- SignalR for real-time communication
- Docker with multi-stage builds
- GitHub Actions for CI/CD"
    
    Write-Host "✅ Initial commit created" -ForegroundColor Green
} else {
    Write-Host "✅ Repository already has commits" -ForegroundColor Green
}

# Check for uncommitted changes
$status = git status --porcelain
if ($status) {
    Write-Host "📝 Found uncommitted changes. Staging and committing..." -ForegroundColor Yellow
    git add .
    git commit -m "🔄 Update: Latest changes to modernized UI and deployment configuration"
    Write-Host "✅ Changes committed" -ForegroundColor Green
}

Write-Host ""
Write-Host "🎉 Repository is ready for GitHub!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Create a new repository on GitHub" -ForegroundColor White
Write-Host "   - Go to https://github.com/new" -ForegroundColor Gray
Write-Host "   - Repository name: remotely-modernized (or your preferred name)" -ForegroundColor Gray
Write-Host "   - Description: Modern remote control solution with contemporary UI" -ForegroundColor Gray
Write-Host "   - Make it public or private as needed" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Add the remote and push:" -ForegroundColor White
Write-Host "   git remote add origin https://github.com/yourusername/remotely-modernized.git" -ForegroundColor Gray
Write-Host "   git branch -M main" -ForegroundColor Gray
Write-Host "   git push -u origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Configure GitHub Actions (optional):" -ForegroundColor White
Write-Host "   - The .github/workflows/docker-build.yml is already included" -ForegroundColor Gray
Write-Host "   - It will automatically build and test on push/PR" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Docker Hub (optional):" -ForegroundColor White
Write-Host "   - Create account at https://hub.docker.com" -ForegroundColor Gray
Write-Host "   - Configure GitHub Actions secrets for auto-deployment" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation included:" -ForegroundColor Cyan
Write-Host "- README-MODERNIZED.md - Comprehensive project documentation" -ForegroundColor White
Write-Host "- DEPLOYMENT.md - Complete deployment guide" -ForegroundColor White
Write-Host "- WARP.md - Development guidance for WARP" -ForegroundColor White
Write-Host "- .env.example - Environment configuration template" -ForegroundColor White
Write-Host "- deploy.sh - Quick deployment script" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Your modernized Remotely is ready to deploy!" -ForegroundColor Green

# Show repository status
Write-Host ""
Write-Host "📊 Repository Status:" -ForegroundColor Cyan
git log --oneline -5
Write-Host ""
Write-Host "📁 Files ready for GitHub:" -ForegroundColor Cyan
git ls-files | Select-Object -First 20
$fileCount = (git ls-files | Measure-Object).Count
if ($fileCount -gt 20) {
    Write-Host "... and $($fileCount - 20) more files" -ForegroundColor Gray
}