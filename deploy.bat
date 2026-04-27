@echo off
echo ========================================
echo   AI Micro-Learning App - Quick Deploy
echo ========================================
echo.

echo This script will help you deploy your app to GitHub
echo.

set /p username="Enter your GitHub username: "
set /p reponame="Enter your repository name: "

echo.
echo Adding GitHub remote...
git remote remove origin 2>nul
git remote add origin https://github.com/%username%/%reponame%.git

echo.
echo Pushing code to GitHub...
git push -u origin master

echo.
echo ========================================
echo   DEPLOYMENT STARTED!
echo ========================================
echo.
echo Your code is now on GitHub!
echo.
echo Next steps:
echo 1. Go to: https://github.com/%username%/%reponame%
echo 2. Click "Actions" tab
echo 3. Wait 3-5 minutes for build to complete
echo 4. Download APK from Artifacts section
echo.
echo Web app will be available at:
echo https://%username%.github.io/%reponame%/
echo.
echo Press any key to open GitHub repository...
pause >nul
start https://github.com/%username%/%reponame%
