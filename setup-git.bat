@echo off
echo 🚀 Setting up Git repository for Remotely...
echo.

git --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Git is not installed. Please install Git first.
    pause
    exit /b 1
)

echo ✅ Git is installed

if not exist .git (
    echo 📝 Initializing Git repository...
    git init
    git branch -M main
    echo ✅ Git repository initialized
) else (
    echo ✅ Git repository already exists
)

echo 📦 Staging all files...
git add .

echo 📝 Creating commit...
git commit -m "🎨 Modernized Remotely with contemporary UI - Modern glass-morphism design - Responsive layout - Updated navigation - Docker-ready deployment"

echo.
echo ✅ Repository is ready!
echo.
echo 📋 Next steps:
echo 1. Create a new repository on GitHub
echo 2. Run: git remote add origin https://github.com/username/repo-name.git
echo 3. Run: git push -u origin main
echo.
pause