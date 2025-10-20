#!/bin/bash

# AR Memory - Build Script
# هذا السكريبت يساعد في بناء التطبيق

echo "================================"
echo "AR Memory - Build Script"
echo "================================"
echo ""

# Check for Java
if ! command -v java &> /dev/null; then
    echo "❌ Java is not installed. Please install JDK 11 or higher."
    exit 1
fi

echo "✅ Java found: $(java -version 2>&1 | head -n 1)"

# Check for Android SDK
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    echo "⚠️  Warning: ANDROID_HOME not set. This may cause build issues."
    echo "   Please set ANDROID_HOME to your Android SDK location."
fi

# Make gradlew executable
chmod +x gradlew
echo "✅ Made gradlew executable"

# Check internet connectivity to Google Maven
echo ""
echo "Checking internet connectivity to required repositories..."
if curl -s --head --max-time 5 https://dl.google.com/dl/android/maven2/ > /dev/null; then
    echo "✅ Google Maven repository accessible"
    USE_GOOGLE=true
else
    echo "❌ Cannot access Google Maven repository (dl.google.com)"
    echo "   This may cause build failures. Consider using VPN or mirror."
    USE_GOOGLE=false
fi

# Clean previous builds
echo ""
echo "Cleaning previous builds..."
./gradlew clean

# Build APK
echo ""
echo "Building APK..."
echo "This may take several minutes on first run..."

if [ "$USE_GOOGLE" = true ]; then
    ./gradlew assembleDebug
else
    echo "Attempting offline build..."
    ./gradlew assembleDebug --offline || {
        echo ""
        echo "❌ Build failed. Possible reasons:"
        echo "   1. No internet access to download dependencies"
        echo "   2. Dependencies not cached locally"
        echo ""
        echo "Solutions:"
        echo "   - Connect to internet and run: ./gradlew assembleDebug"
        echo "   - Use VPN if dl.google.com is blocked"
        echo "   - Configure mirrors in settings.gradle.kts"
        exit 1
    }
fi

# Check if APK was created
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo "================================"
    echo "✅ Build successful!"
    echo "================================"
    echo ""
    echo "APK location: $APK_PATH"
    echo "APK size: $(du -h $APK_PATH | cut -f1)"
    echo ""
    echo "To install on device:"
    echo "  adb install $APK_PATH"
    echo ""
    echo "Or copy the APK to your Android device and install manually."
else
    echo ""
    echo "❌ Build failed. APK not found."
    echo "Check build logs above for errors."
    exit 1
fi
