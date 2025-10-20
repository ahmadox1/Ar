# Quick Start Guide / دليل البدء السريع

## ⚡ For Users Who Want to Build APK Immediately

### 🔴 Problem
Cannot build because `dl.google.com` is blocked in your network.

### 🟢 Fastest Solution (5 minutes)

#### Option 1: VPN Method ⭐ BEST
```bash
# 1. Install and connect VPN
# 2. Run:
./enhanced_build.sh
# 3. APK will be at: app/build/outputs/apk/debug/app-debug.apk
```

#### Option 2: Android Studio Method
```
1. Open Android Studio
2. File > Open > Select this folder
3. Wait for sync (5-10 min)
4. Build > Build APK(s)
5. Click "locate" to find APK
```

### 📱 After Building

1. **Add Google Maps API Key** (otherwise maps won't work):
   - Get key: https://console.cloud.google.com/
   - Edit: `app/src/main/AndroidManifest.xml`
   - Replace: `AIzaSyDummy_Key_Replace_With_Real_One_From_Google_Console`

2. **Install APK**:
   ```bash
   adb install app/build/outputs/apk/debug/app-debug.apk
   # Or copy APK to phone and install manually
   ```

## 📚 Detailed Guides

- **Network Issues**: [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md)
- **Build Status**: [BUILD_STATUS.md](./BUILD_STATUS.md)
- **Complete Work Done**: [WORK_SUMMARY.md](./WORK_SUMMARY.md)
- **Detailed Instructions**: [BUILD_INSTRUCTIONS.md](./BUILD_INSTRUCTIONS.md)

## 🆘 Getting Help

**Build fails?**
1. Check you can access: `curl https://dl.google.com`
2. If fails → Use VPN
3. Still fails → See BUILD_STATUS.md

**Maps don't work?**
1. Add real API key (see above)
2. Check device has internet

**App crashes?**
1. Grant Camera permission
2. Grant Location permission  
3. Check device supports ARCore (optional)

---

**Everything is ready. Just need network access to build! ✨**
