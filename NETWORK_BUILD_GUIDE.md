# Network Access Requirements for Building / متطلبات الوصول للشبكة للبناء

## المشكلة / The Problem

This Android project requires access to Google's Maven repository (`dl.google.com`) to download the Android Gradle Plugin and related dependencies. If you cannot access this domain, the build will fail with errors like:

```
Could not GET 'https://dl.google.com/dl/android/maven2/...'
dl.google.com: No address associated with hostname
```

## الحلول / Solutions

### Solution 1: Use VPN (Recommended / الموصى به)

If `dl.google.com` is blocked in your region:

1. Install a VPN service
2. Connect to a server in a region where Google services are accessible
3. Run the build command:
   ```bash
   ./gradlew assembleDebug
   ```

### Solution 2: Use Mirror Repositories (Chinese Mirrors / المرايا الصينية)

Add mirror repositories to your `settings.gradle.kts`:

```kotlin
pluginManagement {
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/android/m2repository") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/google/m2repository") }
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/android/m2repository") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/google/m2repository") }
        google()
        mavenCentral()
    }
}
```

### Solution 3: Pre-download Dependencies (Offline Build)

If you have access to a machine with internet access:

1. **On a machine with internet access:**
   ```bash
   git clone https://github.com/ahmadox1/Ar.git
   cd Ar
   ./gradlew assembleDebug
   # This will download all dependencies
   ```

2. **Copy the Gradle cache:**
   ```bash
   # Compress the cache
   tar -czf gradle-cache.tar.gz ~/.gradle/caches/
   
   # Transfer gradle-cache.tar.gz to your offline machine
   ```

3. **On the offline machine:**
   ```bash
   # Extract the cache
   tar -xzf gradle-cache.tar.gz -C ~/
   
   # Build offline
   ./gradlew assembleDebug --offline
   ```

### Solution 4: Use Android Studio

Android Studio may have better network handling:

1. Open the project in Android Studio
2. Let it sync and download dependencies
3. Build > Build Bundle(s) / APK(s) > Build APK(s)

### Solution 5: Configure HTTP Proxy

If you have access to an HTTP proxy:

Create or edit `gradle.properties` in your project root:

```properties
systemProp.http.proxyHost=your.proxy.host
systemProp.http.proxyPort=8080
systemProp.https.proxyHost=your.proxy.host
systemProp.https.proxyPort=8080

# If proxy requires authentication:
systemProp.http.proxyUser=username
systemProp.http.proxyPassword=password
systemProp.https.proxyUser=username
systemProp.https.proxyPassword=password
```

## Google Maps API Key Setup / إعداد مفتاح خرائط جوجل

### Get an API Key / الحصول على المفتاح:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable "Maps SDK for Android"
4. Navigate to "Credentials"
5. Create an API Key
6. Restrict the key to Android apps (recommended)

### Add the Key / إضافة المفتاح:

Edit `app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE" />
```

Replace `AIzaSyDummy_Key_Replace_With_Real_One_From_Google_Console` with your actual API key.

**Note:** The app will work without a real API key, but maps functionality will not work properly.

## Verifying Network Access / التحقق من الوصول للشبكة

Test if you can access Google's Maven:

```bash
curl -I https://dl.google.com/dl/android/maven2/
```

If this command returns a connection error, you need one of the solutions above.

## Build Requirements / متطلبات البناء

- **Java:** JDK 11 or higher
- **Android SDK:** Must be installed and `ANDROID_HOME` must be set
- **Internet Access:** Required for first build to download dependencies
- **Disk Space:** ~1GB for Gradle caches and dependencies

## Automated Build Script / سكريبت البناء الآلي

Use the provided build script that attempts multiple strategies:

```bash
chmod +x build_apk.sh
./build_apk.sh
```

The script will:
1. Check for Java and Android SDK
2. Test network connectivity to Google Maven
3. Attempt online build if network is available
4. Fall back to offline build if dependencies are cached

## CI/CD Environments / بيئات CI/CD

For GitHub Actions or other CI systems, ensure:

1. The runner can access `dl.google.com`
2. Or use a caching strategy to preserve Gradle dependencies
3. Or use a self-hosted runner with VPN access

## Still Having Issues? / مازلت تواجه مشاكل؟

If none of these solutions work:

1. Check your network firewall settings
2. Try using mobile hotspot (different network)
3. Contact your network administrator
4. Consider using a cloud build service like GitHub Codespaces
5. Use a pre-built APK if available in releases

---

**Important:** The first build requires internet access and may take 5-15 minutes depending on your connection speed. Subsequent builds will be much faster as dependencies are cached.
