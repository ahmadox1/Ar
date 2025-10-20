@echo off
REM AR Memory - Build Script for Windows
REM هذا السكريبت يساعد في بناء التطبيق على Windows

echo ================================
echo AR Memory - Build Script
echo ================================
echo.

REM Check for Java
where java >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Java is not installed. Please install JDK 11 or higher.
    pause
    exit /b 1
)

java -version 2>&1 | findstr /C:"version"
echo ✅ Java found

REM Check for Android SDK
if "%ANDROID_HOME%"=="" if "%ANDROID_SDK_ROOT%"=="" (
    echo ⚠️  Warning: ANDROID_HOME not set. This may cause build issues.
    echo    Please set ANDROID_HOME to your Android SDK location.
)

REM Clean previous builds
echo.
echo Cleaning previous builds...
call gradlew.bat clean

REM Build APK
echo.
echo Building APK...
echo This may take several minutes on first run...
call gradlew.bat assembleDebug

REM Check if APK was created
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ================================
    echo ✅ Build successful!
    echo ================================
    echo.
    echo APK location: app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo To install on device:
    echo   adb install app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo Or copy the APK to your Android device and install manually.
) else (
    echo.
    echo ❌ Build failed. APK not found.
    echo Check build logs above for errors.
    pause
    exit /b 1
)

pause
