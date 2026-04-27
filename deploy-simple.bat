@echo off
cls
echo.
echo ========================================
echo   DEPLOY TO GITHUB
echo ========================================
echo.
echo This will push your app to GitHub for automatic building
echo.

set /p username="Enter your GitHub username: "
set /p reponame="Enter repository name: "

echo.
echo Removing old remote...
git remote remove origin 2>nul

echo Adding GitHub remote...
git remote add origin https://github.com/%username%/%reponame%.git

echo.
echo Pushing to GitHub...
echo (You may need to enter your GitHub credentials)
echo.

git push -u origin master

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   SUCCESS! CODE PUSHED TO GITHUB
    echo ========================================
    echo.
    echo Next steps:
    echo 1. Go to: https://github.com/%username%/%reponame%
    echo 2. Click "Actions" tab
    echo 3. Wait 3-5 minutes for build
    echo 4. Download APK from Artifacts
    echo.
    echo Opening GitHub repository...
    start https://github.com/%username%/%reponame%
) else (
    echo.
    echo ========================================
    echo   PUSH FAILED
    echo ========================================
    echo.
    echo Make sure:
    echo 1. Repository exists at https://github.com/%username%/%reponame%
    echo 2. You have access to push
    echo 3. Create repo at: https://github.com/new
    echo.
)

echo.
pause
