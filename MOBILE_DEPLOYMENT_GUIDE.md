# Mobile Deployment Guide - Complete Instructions

## 🚨 Current Issue

Your Windows system has **Application Control Policy** enabled which is blocking Flutter's build tools:
- `impellerc.exe` (shader compiler)
- `gen_snapshot.exe` (AOT compiler)

This prevents building APK/iOS apps on this machine.

## ✅ Solutions to Deploy Mobile App

### Solution 1: Disable Application Control (Requires Admin)

1. **Open PowerShell as Administrator**
2. **Check current policy:**
   ```powershell
   Get-AppLockerPolicy -Effective
   ```

3. **Temporarily disable (if you have admin rights):**
   ```powershell
   # Stop AppLocker service
   Stop-Service -Name AppIDSvc
   Set-Service -Name AppIDSvc -StartupType Disabled
   ```

4. **Then build APK:**
   ```bash
   cd cp_saad/cp_saad
   flutter build apk --release
   ```

5. **Re-enable after building:**
   ```powershell
   Set-Service -Name AppIDSvc -StartupType Automatic
   Start-Service -Name AppIDSvc
   ```

### Solution 2: Whitelist Flutter Tools (Recommended)

Contact your system administrator to whitelist these executables:
```
C:\Users\darak\Downloads\flutter-master\bin\cache\artifacts\engine\windows-x64\impellerc.exe
C:\Users\darak\Downloads\flutter-master\bin\cache\artifacts\engine\android-arm-profile\windows-x64\gen_snapshot.exe
C:\Users\darak\Downloads\flutter-master\bin\cache\artifacts\engine\android-arm64-profile\windows-x64\gen_snapshot.exe
C:\Users\darak\Downloads\flutter-master\bin\cache\artifacts\engine\android-arm-release\windows-x64\gen_snapshot.exe
C:\Users\darak\Downloads\flutter-master\bin\cache\artifacts\engine\android-arm64-release\windows-x64\gen_snapshot.exe
```

### Solution 3: Build on Another Machine

**Transfer project to a machine without Application Control:**

1. **Zip the project:**
   ```bash
   # Already done - your project is ready
   ```

2. **On the other machine:**
   ```bash
   # Install Flutter
   # Then:
   cd cp_saad/cp_saad
   flutter pub get
   flutter build apk --release
   ```

3. **APK will be at:**
   ```
   build/app/outputs/flutter-apk/app-release.apk
   ```

### Solution 4: Use Cloud Build Services

#### Option A: Codemagic (Free tier available)

1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin YOUR_GITHUB_URL
   git push -u origin main
   ```

2. **Go to codemagic.io**
3. Connect GitHub repo
4. Configure build:
   - Platform: Android
   - Build command: `flutter build apk --release`
5. Download APK from dashboard

#### Option B: GitHub Actions (Free)

Create `.github/workflows/build.yml`:

```yaml
name: Build APK
on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.7'
      - run: flutter pub get
        working-directory: cp_saad/cp_saad
      - run: flutter build apk --release
        working-directory: cp_saad/cp_saad
      - uses: actions/upload-artifact@v3
        with:
          name: app-release
          path: cp_saad/cp_saad/build/app/outputs/flutter-apk/app-release.apk
```

Push to GitHub and download APK from Actions tab.

### Solution 5: Use Online IDE

**Use Replit or Gitpod:**

1. **Push project to GitHub**
2. **Open in Gitpod:** `gitpod.io/#YOUR_GITHUB_URL`
3. **Build APK:**
   ```bash
   flutter build apk --release
   ```
4. **Download APK from workspace**

## 📱 Current Deployment Status

### ✅ What's Working:

1. **Backend API** - Fully deployed and running
   - URL: http://localhost:5000
   - Docker container: `cp_saad-backend-1`
   - Database: Connected to MongoDB Atlas

2. **Android Emulator** - Running and ready
   - Device: `emulator-5554` (sdk gphone64 x86 64)
   - Android 16 (API 36)

### ❌ What's Blocked:

- APK builds (release, debug, profile)
- iOS builds
- Web builds (release mode)
- Windows desktop builds

## 🚀 Quick Deploy After Fixing Security

Once Application Control is disabled or Flutter tools are whitelisted:

```bash
cd cp_saad/cp_saad

# Build Android APK
flutter build apk --release

# Build for iOS (requires Mac)
flutter build ios --release

# Build for Web
flutter build web --release

# Build for Windows
flutter build windows --release
```

## 📦 Install APK on Physical Device

Once you have the APK:

1. **Enable USB Debugging on phone:**
   - Settings → About Phone → Tap "Build Number" 7 times
   - Settings → Developer Options → Enable USB Debugging

2. **Connect phone to computer**

3. **Install APK:**
   ```bash
   flutter install
   # Or manually:
   adb install build/app/outputs/flutter-apk/app-release.apk
   ```

## 🌐 Alternative: Deploy as Web App (Working)

The web version is currently running in Chrome. To deploy it online:

1. **Build web (when security is fixed):**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase Hosting:**
   ```bash
   npm install -g firebase-tools
   firebase login
   firebase init hosting
   # Select build/web as public directory
   firebase deploy
   ```

3. **Or deploy to Netlify:**
   - Drag `build/web` folder to netlify.com/drop

## 📞 Need Help?

Contact your IT administrator with this information:
- **Issue**: Application Control Policy blocking Flutter development tools
- **Required**: Whitelist Flutter SDK executables for mobile app development
- **Impact**: Cannot build mobile applications for business needs

## Current Backend API Endpoints

Your backend is live and accessible:

```bash
# Health check
curl http://localhost:5000

# Register user
curl -X POST http://localhost:5000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","name":"Test User"}'

# Login
curl -X POST http://localhost:5000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

The mobile app will connect to this backend once deployed!
