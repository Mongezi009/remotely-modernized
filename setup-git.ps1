# Remotely - GitHub Setup Script
Write-Host "🚀 Setting up Git repository..." -ForegroundColor Cyan

# Check if Git is installed
try {
    git --version | Out-Null
    Write-Host "✅ Git is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Git is not installed. Please install Git first." -ForegroundColor Red
    exit 1
}

# Initialize Git repository if not already initialized
if (-not (Test-Path ".git")) {
    Write-Host "📝 Initializing Git repository..." -ForegroundColor Yellow
    git init
    git branch -M main
    Write-Host "✅ Git repository initialized" -ForegroundColor Green
}

# Stage and commit all files
Write-Host "📦 Staging files..." -ForegroundColor Yellow
git add .

$commitMessage = @"
🎨 Modernized Remotely with contemporary UI

- Modern glass-morphism design with gradients
- Responsive layout for all devices
- Updated navigation with SVG icons
- Contemporary typography with Inter font
- Enhanced dashboard with card layout
- Docker-ready deployment configuration
- Comprehensive documentation
"@

git commit -m $commitMessage

Write-Host "✅ Files committed to Git" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "1. Create repository on GitHub" -ForegroundColor White
Write-Host "2. Add remote: git remote add origin YOUR-REPO-URL" -ForegroundColor White
Write-Host "3. Push: git push -u origin main" -ForegroundColor White