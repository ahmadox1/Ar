# تعليمات البناء التفصيلية / Detailed Build Instructions

## المتطلبات الأساسية / Prerequisites

### 1. تثبيت Android Studio
- قم بتحميل [Android Studio](https://developer.android.com/studio) أحدث إصدار
- ثبت البرنامج مع Android SDK

### 2. إعداد Java Development Kit (JDK)
- Android Studio يأتي مع JDK مدمج
- أو قم بتثبيت JDK 11 أو أحدث من [Oracle](https://www.oracle.com/java/technologies/downloads/) أو [OpenJDK](https://openjdk.org/)

### 3. تكوين Android SDK
في Android Studio:
1. اذهب إلى `File > Settings > Appearance & Behavior > System Settings > Android SDK`
2. تأكد من تثبيت:
   - Android SDK Platform 34
   - Android SDK Build-Tools 34.0.0
   - Android SDK Platform-Tools
   - Google Play Services

## طريقة البناء 1: استخدام Android Studio (الموصى بها)

### الخطوات:

1. **فتح المشروع**
   ```
   File > Open > اختر مجلد المشروع
   ```

2. **انتظر Gradle Sync**
   - سيقوم Android Studio تلقائياً بمزامنة Gradle
   - انتظر حتى تكتمل عملية التحميل (قد تستغرق عدة دقائق في المرة الأولى)

3. **إضافة Google Maps API Key** (اختياري للخريطة)
   - احصل على مفتاح من [Google Cloud Console](https://console.cloud.google.com/)
   - افتح `app/src/main/AndroidManifest.xml`
   - استبدل `YOUR_GOOGLE_MAPS_API_KEY` بمفتاحك

4. **بناء APK**
   ```
   Build > Build Bundle(s) / APK(s) > Build APK(s)
   ```

5. **العثور على APK**
   - بعد اكتمال البناء، ستظهر رسالة في الأسفل
   - اضغط على "locate" للذهاب إلى المجلد
   - أو ابحث في: `app/build/outputs/apk/debug/app-debug.apk`

## طريقة البناء 2: استخدام سطر الأوامر (Command Line)

### على Windows:

```cmd
# في مجلد المشروع
gradlew.bat clean
gradlew.bat assembleDebug

# سيتم إنشاء الملف في:
# app\build\outputs\apk\debug\app-debug.apk
```

### على macOS/Linux:

```bash
# إعطاء صلاحيات التنفيذ (مرة واحدة فقط)
chmod +x gradlew

# تنظيف وبناء
./gradlew clean
./gradlew assembleDebug

# سيتم إنشاء الملف في:
# app/build/outputs/apk/debug/app-debug.apk
```

### بناء APK للإصدار (Release):

```bash
# بناء نسخة release موقعة
./gradlew assembleRelease

# الملف في: app/build/outputs/apk/release/app-release.apk
```

## حل المشاكل الشائعة / Troubleshooting

### مشكلة: لا يمكن الوصول إلى مستودعات Google

**الحل:**

1. **تحقق من الاتصال بالإنترنت**
   ```bash
   ping dl.google.com
   ```

2. **استخدم VPN إذا كان الموقع محظوراً**

3. **استخدم وضع Offline (إذا سبق التحميل)**
   ```bash
   ./gradlew assembleDebug --offline
   ```

4. **استخدم مرآة (Mirror) بديلة**
   في `build.gradle.kts`:
   ```kotlin
   repositories {
       maven { url = uri("https://maven.aliyun.com/repository/google") }
       maven { url = uri("https://maven.aliyun.com/repository/public") }
       google()
       mavenCentral()
   }
   ```

### مشكلة: خطأ في Gradle Sync

**الحل:**
```bash
# حذف ملفات Gradle المؤقتة
rm -rf .gradle
rm -rf app/build
rm -rf build

# إعادة المحاولة
./gradlew clean build
```

### مشكلة: نفاد الذاكرة (Out of Memory)

**الحل:**
أضف في `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError
```

### مشكلة: تعارض إصدارات المكتبات

**الحل:**
```bash
# عرض شجرة المكتبات
./gradlew app:dependencies

# تحديث جميع المكتبات
./gradlew --refresh-dependencies
```

## التوقيع على APK (للنشر)

### 1. إنشاء Keystore:

```bash
keytool -genkey -v -keystore my-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias my-key-alias
```

### 2. تكوين التوقيع في `app/build.gradle.kts`:

```kotlin
android {
    signingConfigs {
        create("release") {
            storeFile = file("path/to/my-release-key.jks")
            storePassword = "password"
            keyAlias = "my-key-alias"
            keyPassword = "password"
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}
```

### 3. بناء APK موقع:

```bash
./gradlew assembleRelease
```

## التحقق من APK

### التحقق من التوقيع:
```bash
jarsigner -verify -verbose -certs app/build/outputs/apk/release/app-release.apk
```

### عرض معلومات APK:
```bash
aapt dump badging app/build/outputs/apk/debug/app-debug.apk
```

## تثبيت APK على الجهاز

### باستخدام ADB:
```bash
# تفعيل USB Debugging على الهاتف
adb install app/build/outputs/apk/debug/app-debug.apk

# أو لإعادة التثبيت:
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

### نقل الملف يدوياً:
1. انسخ ملف APK إلى الهاتف
2. افتح مدير الملفات
3. اضغط على APK لتثبيته
4. قد تحتاج لتفعيل "تثبيت من مصادر غير معروفة"

## أوامر Gradle المفيدة

```bash
# عرض المهام المتاحة
./gradlew tasks

# تنظيف المشروع
./gradlew clean

# بناء المشروع
./gradlew build

# بناء وتشغيل الاختبارات
./gradlew test

# التحقق من التبعيات
./gradlew app:dependencies

# تحديث Gradle Wrapper
./gradlew wrapper --gradle-version 8.2
```

## متطلبات الجهاز لتشغيل التطبيق

- Android 7.0 (API Level 24) أو أحدث
- جهاز يدعم ARCore ([قائمة الأجهزة المدعومة](https://developers.google.com/ar/devices))
- كاميرا خلفية
- GPS/Location Services
- مساحة تخزين 50 MB على الأقل

## مصادر إضافية

- [Android Developers Guide](https://developer.android.com/guide)
- [ARCore Documentation](https://developers.google.com/ar)
- [Kotlin Documentation](https://kotlinlang.org/docs/home.html)
- [Gradle Build Tool](https://gradle.org/)

---

**ملاحظة**: إذا استمرت المشاكل، يرجى التحقق من:
1. اتصال الإنترنت
2. إصدار Java/JDK
3. إصدار Android SDK
4. ملفات LOG في Android Studio (View > Tool Windows > Build)
