# Documentation Index / فهرس الوثائق

## 📖 Quick Navigation

### For Users Who Want to Build APK Now
👉 **Start here**: [QUICK_START.md](./QUICK_START.md)

### Having Network/Build Issues?
👉 **Read this**: [BUILD_STATUS.md](./BUILD_STATUS.md)
👉 **Network solutions**: [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md)

### Want Detailed Instructions?
👉 **Step-by-step**: [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)
👉 **Manual guide**: [MANUAL_BUILD_GUIDE.md](./MANUAL_BUILD_GUIDE.md)

### Understanding the Project?
👉 **Overview**: [README.md](./README.md)
👉 **Architecture**: [ARCHITECTURE.md](./ARCHITECTURE.md)
👉 **Configuration**: [PROJECT_CONFIG.md](./PROJECT_CONFIG.md)
👉 **Summary**: [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)

### Want to Contribute?
👉 **Guidelines**: [CONTRIBUTING.md](./CONTRIBUTING.md)

### What Was Done in This PR?
👉 **Work summary**: [WORK_SUMMARY.md](./WORK_SUMMARY.md)

---

## 📄 Document Descriptions

### User-Focused Documents

| Document | Purpose | Language |
|----------|---------|----------|
| [QUICK_START.md](./QUICK_START.md) | Fastest path to building APK | Arabic + English |
| [BUILD_STATUS.md](./BUILD_STATUS.md) | Current build status and all solutions | Arabic + English |
| [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md) | Network-specific build solutions | Arabic + English |
| [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md) | Detailed build instructions | Arabic + English |
| [MANUAL_BUILD_GUIDE.md](./MANUAL_BUILD_GUIDE.md) | Manual build guide | Arabic + English |
| [README.md](./README.md) | Project overview and quick start | Arabic + English |

### Developer-Focused Documents

| Document | Purpose | Language |
|----------|---------|----------|
| [WORK_SUMMARY.md](./WORK_SUMMARY.md) | Summary of changes in this PR | Arabic + English |
| [ARCHITECTURE.md](./ARCHITECTURE.md) | Project architecture details | Arabic + English |
| [PROJECT_CONFIG.md](./PROJECT_CONFIG.md) | Configuration details | Arabic + English |
| [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md) | Complete project summary | Arabic + English |
| [CONTRIBUTING.md](./CONTRIBUTING.md) | How to contribute | Arabic + English |

### Build Scripts

| Script | Purpose |
|--------|---------|
| [enhanced_build.sh](./enhanced_build.sh) | Enhanced build with network diagnostics |
| [build_apk.sh](./build_apk.sh) | Basic build script |
| build_apk.bat | Windows build script |

---

## 🎯 Common Scenarios

### "I just want to build the APK"
1. Read [QUICK_START.md](./QUICK_START.md)
2. Run `./enhanced_build.sh`
3. If it fails, check [BUILD_STATUS.md](./BUILD_STATUS.md)

### "Build is failing with network errors"
1. Check [BUILD_STATUS.md](./BUILD_STATUS.md) - Section "Network Restriction Issue"
2. Read [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md) for solutions
3. Use VPN or mirrors as documented

### "I want to understand how the app works"
1. Start with [README.md](./README.md)
2. Then read [ARCHITECTURE.md](./ARCHITECTURE.md)
3. Check [PROJECT_SUMMARY.md](./PROJECT_SUMMARY.md)

### "I want to contribute to the project"
1. Read [CONTRIBUTING.md](./CONTRIBUTING.md)
2. Check [PROJECT_CONFIG.md](./PROJECT_CONFIG.md)
3. Follow build instructions in [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)

### "What was changed in this PR?"
1. Read [WORK_SUMMARY.md](./WORK_SUMMARY.md)
2. Check git commit history
3. Review [BUILD_STATUS.md](./BUILD_STATUS.md)

---

## 🚀 Quick Commands

```bash
# Quick build (recommended)
./enhanced_build.sh

# Standard build
./gradlew assembleDebug

# Build with offline mode
./gradlew assembleDebug --offline

# Clean and build
./gradlew clean assembleDebug

# Install APK
adb install app/build/outputs/apk/debug/app-debug.apk
```

---

## 🆘 Support

### Build Issues
- Check [BUILD_STATUS.md](./BUILD_STATUS.md)
- Check [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md)

### App Issues
- Check [README.md](./README.md) - "Known Issues" section
- Open GitHub issue with details

### Questions
- Read relevant documentation above
- Check existing GitHub issues
- Open new issue if needed

---

**All documentation is available in both Arabic (العربية) and English.**
