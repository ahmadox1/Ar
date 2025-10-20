# AR Memory App - Project Configuration

## Project Information
- **Name**: AR Memory
- **Package**: com.ar.memory
- **Min SDK**: 24 (Android 7.0 Nougat)
- **Target SDK**: 34 (Android 14)
- **Compile SDK**: 34
- **Language**: Kotlin
- **Build Tool**: Gradle 7.5 / 8.2

## Required API Keys

### Google Maps API Key
1. Go to: https://console.cloud.google.com/
2. Create a new project or select existing
3. Enable "Maps SDK for Android"
4. Create credentials (API Key)
5. Restrict the key to Android apps
6. Add SHA-1 fingerprint:
   ```bash
   # Get debug key SHA-1
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```
7. Update AndroidManifest.xml:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_ACTUAL_API_KEY_HERE" />
   ```

## Environment Setup

### Java Development Kit (JDK)
- **Required**: JDK 11 or higher
- **Recommended**: JDK 17
- **Check**: `java -version`

### Android SDK Components
Install via Android Studio SDK Manager:
```
- Android SDK Platform 34
- Android SDK Build-Tools 34.0.0
- Android SDK Platform-Tools
- Android SDK Tools
- Google Play Services
- Google Repository
- Android Support Repository
```

### Gradle
- **Version**: 7.5 or 8.2
- **Check**: `./gradlew --version`

## Dependencies

### Core Dependencies
```kotlin
// AndroidX
androidx.core:core-ktx:1.12.0
androidx.appcompat:appcompat:1.6.1
com.google.android.material:material:1.10.0
androidx.constraintlayout:constraintlayout:2.1.4

// ARCore
com.google.ar:core:1.40.0
com.google.ar.sceneform:core:1.17.1

// Camera
androidx.camera:camera-core:1.3.0
androidx.camera:camera-camera2:1.3.0
androidx.camera:camera-lifecycle:1.3.0
androidx.camera:camera-view:1.3.0

// Google Maps & Location
com.google.android.gms:play-services-maps:18.2.0
com.google.android.gms:play-services-location:21.0.1

// Room Database
androidx.room:room-runtime:2.6.0
androidx.room:room-ktx:2.6.0
androidx.room:room-compiler:2.6.0 (kapt)

// Lifecycle
androidx.lifecycle:lifecycle-runtime-ktx:2.6.2
androidx.lifecycle:lifecycle-viewmodel-ktx:2.6.2
androidx.lifecycle:lifecycle-livedata-ktx:2.6.2

// Coroutines
org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3
```

### Plugin Dependencies
```kotlin
com.android.tools.build:gradle:7.4.2
org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20
```

## Network Requirements

### Maven Repositories
The build requires access to:
1. **Google Maven Repository**
   - URL: https://dl.google.com/dl/android/maven2/
   - Used for: Android Gradle Plugin, Google Play Services, ARCore

2. **Maven Central**
   - URL: https://repo.maven.apache.org/maven2/
   - Used for: Kotlin, AndroidX libraries

3. **JitPack** (Optional)
   - URL: https://jitpack.io
   - Used for: Third-party libraries

### Mirror Repositories (For Restricted Networks)
If you can't access Google Maven, use:

```kotlin
// In settings.gradle.kts
repositories {
    maven { url = uri("https://maven.aliyun.com/repository/google") }
    maven { url = uri("https://maven.aliyun.com/repository/public") }
    google()
    mavenCentral()
}
```

## Build Variants

### Debug Build
```bash
./gradlew assembleDebug
```
- **Output**: `app/build/outputs/apk/debug/app-debug.apk`
- **Signed**: Debug keystore (automatic)
- **Minified**: No
- **Debuggable**: Yes

### Release Build
```bash
./gradlew assembleRelease
```
- **Output**: `app/build/outputs/apk/release/app-release.apk`
- **Signed**: Requires release keystore
- **Minified**: Yes (ProGuard)
- **Debuggable**: No

## ProGuard Configuration

The app uses ProGuard rules for:
- ARCore library preservation
- Room database annotation preservation
- Google Play Services optimization

See: `app/proguard-rules.pro`

## Signing Configuration

### Debug Signing
Automatic, uses `~/.android/debug.keystore`

### Release Signing
Create keystore:
```bash
keytool -genkey -v -keystore release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias release-key-alias
```

Add to `app/build.gradle.kts`:
```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("../release-key.jks")
            storePassword = System.getenv("KEYSTORE_PASSWORD")
            keyAlias = System.getenv("KEY_ALIAS")
            keyPassword = System.getenv("KEY_PASSWORD")
        }
    }
}
```

## Device Requirements

### Minimum Requirements
- Android 7.0 (API 24) or higher
- 2 GB RAM
- Rear camera
- GPS capability
- 100 MB free storage

### ARCore Requirements
- ARCore supported device
- Check compatibility: https://developers.google.com/ar/devices
- OpenGL ES 3.0 support

### Recommended
- Android 10.0 (API 29) or higher
- 4 GB RAM
- ARCore compatible device
- GPS with high accuracy

## Permissions

### Runtime Permissions (Must Request)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

### Normal Permissions (Auto-granted)
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Features
```xml
<uses-feature android:name="android.hardware.camera.ar" android:required="true" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
<uses-feature android:glEsVersion="0x00030000" android:required="true" />
```

## Build Configuration

### gradle.properties
```properties
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
kotlin.code.style=official
android.nonTransitiveRClass=false
```

### settings.gradle.kts
```kotlin
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
```

## Troubleshooting

### Build Fails - "Could not GET Google Maven"
**Solution**: Check internet connection or use VPN/mirror

### "ARCore not supported"
**Solution**: Test on ARCore compatible device

### "Location not available"
**Solution**: Enable GPS and grant location permission

### "Out of Memory"
**Solution**: Increase heap size in gradle.properties:
```properties
org.gradle.jvmargs=-Xmx4096m
```

## CI/CD Configuration

### GitHub Actions (Example)
```yaml
name: Android CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Set up JDK 11
        uses: actions/setup-java@v1
        with:
          java-version: 11
      - name: Build with Gradle
        run: ./gradlew assembleDebug
```

## Version Control

### .gitignore
Important paths to ignore:
```
*.apk
*.aab
build/
.gradle/
local.properties
*.iml
.idea/
*.jks
*.keystore
```

## Support & Resources

- **Android Developers**: https://developer.android.com
- **ARCore**: https://developers.google.com/ar
- **Kotlin**: https://kotlinlang.org
- **Room**: https://developer.android.com/training/data-storage/room
- **Google Maps**: https://developers.google.com/maps/documentation/android-sdk

## License
Open source - Free for personal and educational use

---

**Last Updated**: October 2025
**Configuration Version**: 1.0
