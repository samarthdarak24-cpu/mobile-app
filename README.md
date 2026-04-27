# AI Micro-Learning App

A Flutter application with Node.js backend for AI-powered micro-learning experiences.

## 🚀 Quick Start

### Backend (Already Running)
```bash
docker-compose up -d
```
Backend API: http://localhost:5000

### Frontend Development
```bash
flutter pub get
flutter run
```

## 📱 Build APK (Cloud Build)

This project uses GitHub Actions to build APKs automatically, bypassing local security restrictions.

### Setup:

1. **Create GitHub Repository**
2. **Push code:**
   ```bash
   git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin YOUR_GITHUB_REPO_URL
   git push -u origin main
   ```

3. **Download APK:**
   - Go to GitHub → Actions tab
   - Click on "Build Android APK" workflow
   - Download artifacts (APK files)

## 📦 Available Builds

GitHub Actions automatically builds:
- ✅ Android APK (arm64-v8a, armeabi-v7a, x86_64, universal)
- ✅ Web App (deployed to GitHub Pages)

## 🔧 Tech Stack

- **Frontend**: Flutter 3.24+
- **Backend**: Node.js + Express
- **Database**: MongoDB Atlas
- **AI**: Google Gemini API
- **Deployment**: Docker + GitHub Actions

## 📱 Install APK on Phone

1. Download APK from GitHub Actions artifacts
2. Transfer to phone
3. Enable "Install from Unknown Sources"
4. Install and run!

## 🌐 Web Version

After pushing to GitHub, web version will be available at:
`https://YOUR_USERNAME.github.io/YOUR_REPO_NAME/`

## 🔗 API Endpoints

- `GET /` - Health check
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user
- `GET /api/lesson/*` - Lesson management
- `GET /api/revision/*` - Revision system

## 📄 License

MIT
