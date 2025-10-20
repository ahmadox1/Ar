#!/bin/bash

# Enhanced Build Script with Network Diagnostics
# سكريبت بناء محسّن مع تشخيص الشبكة

set -e

echo "====================================="
echo "AR Memory - Enhanced Build Script"
echo "====================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check Java
echo "Checking Java installation..."
if ! command -v java &> /dev/null; then
    print_error "Java is not installed"
    echo "Please install JDK 11 or higher"
    echo "Download from: https://adoptium.net/"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
if [ "$JAVA_VERSION" -ge 11 ]; then
    print_status "Java $JAVA_VERSION found"
else
    print_warning "Java version $JAVA_VERSION found (JDK 11+ recommended)"
fi

# Check Android SDK
echo ""
echo "Checking Android SDK..."
if [ -z "$ANDROID_HOME" ] && [ -z "$ANDROID_SDK_ROOT" ]; then
    print_warning "ANDROID_HOME not set"
    echo "Attempting to detect Android SDK..."
    
    # Common Android SDK locations
    POSSIBLE_LOCATIONS=(
        "$HOME/Android/Sdk"
        "$HOME/Library/Android/sdk"
        "/usr/local/lib/android/sdk"
        "C:/Users/$USER/AppData/Local/Android/Sdk"
    )
    
    for loc in "${POSSIBLE_LOCATIONS[@]}"; do
        if [ -d "$loc" ]; then
            export ANDROID_HOME="$loc"
            print_status "Found Android SDK at: $ANDROID_HOME"
            break
        fi
    done
    
    if [ -z "$ANDROID_HOME" ]; then
        print_error "Could not find Android SDK"
        echo "Please set ANDROID_HOME environment variable"
        exit 1
    fi
else
    print_status "Android SDK found at: ${ANDROID_HOME:-$ANDROID_SDK_ROOT}"
fi

# Create local.properties
echo ""
echo "Creating local.properties..."
cat > local.properties << EOF
sdk.dir=${ANDROID_HOME:-$ANDROID_SDK_ROOT}
EOF
print_status "Created local.properties"

# Make gradlew executable
chmod +x gradlew
print_status "Made gradlew executable"

# Test network connectivity
echo ""
echo "====================================="
echo "Network Connectivity Tests"
echo "====================================="

test_url() {
    local url=$1
    local name=$2
    if curl -s --head --max-time 5 "$url" > /dev/null 2>&1; then
        print_status "$name accessible"
        return 0
    else
        print_error "$name not accessible"
        return 1
    fi
}

GOOGLE_MAVEN_OK=false
MAVEN_CENTRAL_OK=false
ALIYUN_OK=false

if test_url "https://dl.google.com/dl/android/maven2/" "Google Maven"; then
    GOOGLE_MAVEN_OK=true
fi

if test_url "https://repo1.maven.org/maven2/" "Maven Central"; then
    MAVEN_CENTRAL_OK=true
fi

if test_url "https://maven.aliyun.com/repository/google" "Aliyun Mirror"; then
    ALIYUN_OK=true
fi

echo ""

# Determine build strategy
if [ "$GOOGLE_MAVEN_OK" = true ]; then
    echo "====================================="
    echo "Building with Google Maven (Online)"
    echo "====================================="
    BUILD_MODE="online"
elif [ "$ALIYUN_OK" = true ]; then
    echo "====================================="
    echo "Building with Aliyun Mirror"
    echo "====================================="
    BUILD_MODE="mirror"
    
    # Update settings to use Aliyun
    print_warning "Temporarily configuring Aliyun mirror..."
    # Note: This would require modifying settings.gradle.kts
    echo "Please manually add Aliyun mirrors to settings.gradle.kts as shown in NETWORK_BUILD_GUIDE.md"
else
    echo "====================================="
    echo "Attempting Offline Build"
    echo "====================================="
    BUILD_MODE="offline"
    print_warning "No internet access detected"
    print_warning "Build will fail if dependencies are not cached"
    echo ""
    echo "Recommendations:"
    echo "1. Use VPN to access Google Maven"
    echo "2. Download dependencies on another machine (see NETWORK_BUILD_GUIDE.md)"
    echo "3. Configure mirror repositories"
    echo ""
    read -p "Continue with offline build? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Build cancelled"
        exit 1
    fi
fi

# Clean previous builds
echo ""
echo "Cleaning previous builds..."
./gradlew clean || print_warning "Clean failed (may not matter)"

# Build APK
echo ""
echo "Building APK..."
echo "This may take 5-15 minutes on first run..."
echo ""

if [ "$BUILD_MODE" = "offline" ]; then
    ./gradlew assembleDebug --offline --stacktrace
else
    ./gradlew assembleDebug --stacktrace
fi

# Check result
APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
echo ""
if [ -f "$APK_PATH" ]; then
    echo "====================================="
    print_status "BUILD SUCCESSFUL!"
    echo "====================================="
    echo ""
    print_status "APK Location: $APK_PATH"
    print_status "APK Size: $(du -h "$APK_PATH" | cut -f1)"
    echo ""
    echo "Next steps:"
    echo "1. Transfer APK to Android device"
    echo "2. Install: adb install $APK_PATH"
    echo "3. Or manually install from device"
    echo ""
    echo "Don't forget to add your Google Maps API key!"
    echo "See: app/src/main/AndroidManifest.xml"
else
    echo "====================================="
    print_error "BUILD FAILED"
    echo "====================================="
    echo ""
    echo "Common solutions:"
    echo "1. Check build log above for specific errors"
    echo "2. Ensure internet access to dl.google.com"
    echo "3. Try using VPN"
    echo "4. See NETWORK_BUILD_GUIDE.md for detailed solutions"
    exit 1
fi
