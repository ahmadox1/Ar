# دليل البناء اليدوي / Manual Build Guide

## ملاحظة مهمة / Important Note

هذا المشروع يتطلب الوصول إلى الإنترنت لتحميل المكتبات المطلوبة من:
- Google Maven Repository (dl.google.com)
- Maven Central Repository

This project requires internet access to download required libraries from:
- Google Maven Repository (dl.google.com)
- Maven Central Repository

## الطريقة الموصى بها: استخدام Android Studio

### الخطوات:

1. **تحميل وتثبيت Android Studio**
   - اذهب إلى: https://developer.android.com/studio
   - قم بتحميل النسخة المناسبة لنظام التشغيل الخاص بك
   - ثبت البرنامج واتبع تعليمات الإعداد

2. **فتح المشروع**
   - افتح Android Studio
   - اختر `File > Open`
   - حدد مجلد المشروع

3. **انتظر Gradle Sync**
   - سيقوم Android Studio تلقائياً بتحميل جميع المكتبات المطلوبة
   - قد تستغرق هذه العملية 5-10 دقائق في المرة الأولى
   - تأكد من اتصالك بالإنترنت

4. **حل مشاكل الاتصال (إذا لزم الأمر)**
   
   إذا فشل التحميل بسبب مشاكل في الشبكة:
   
   **الحل 1: استخدام VPN**
   - استخدم VPN للوصول إلى dl.google.com
   
   **الحل 2: استخدام مرآة صينية**
   أضف هذا في `settings.gradle.kts`:
   ```kotlin
   pluginManagement {
       repositories {
           maven { url = uri("https://maven.aliyun.com/repository/google") }
           maven { url = uri("https://maven.aliyun.com/repository/public") }
           maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
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
           google()
           mavenCentral()
       }
   }
   ```

5. **إضافة Google Maps API Key**
   - اذهب إلى: https://console.cloud.google.com/
   - أنشئ مشروع جديد
   - فعّل "Maps SDK for Android"
   - احصل على API Key
   - افتح `app/src/main/AndroidManifest.xml`
   - ابحث عن `YOUR_GOOGLE_MAPS_API_KEY`
   - استبدله بالـ API Key الخاص بك

6. **بناء APK**
   ```
   Build > Build Bundle(s) / APK(s) > Build APK(s)
   ```

7. **العثور على APK**
   - بعد اكتمال البناء، اضغط "locate" في الرسالة
   - أو اذهب إلى: `app/build/outputs/apk/debug/app-debug.apk`

## الطريقة البديلة: سطر الأوامر

### المتطلبات:
- JDK 11 أو أحدث
- اتصال بالإنترنت
- Git (لاستنساخ المشروع)

### الخطوات على Linux/macOS:

```bash
# 1. استنساخ المشروع (إذا لم تفعل بعد)
git clone https://github.com/ahmadox1/Ar.git
cd Ar

# 2. إعطاء صلاحيات التنفيذ
chmod +x gradlew

# 3. تنظيف المشروع
./gradlew clean

# 4. بناء APK
./gradlew assembleDebug

# 5. إذا نجح البناء، ستجد APK في:
# app/build/outputs/apk/debug/app-debug.apk
```

### الخطوات على Windows:

```cmd
REM 1. استنساخ المشروع (إذا لم تفعل بعد)
git clone https://github.com/ahmadox1/Ar.git
cd Ar

REM 2. تنظيف المشروع
gradlew.bat clean

REM 3. بناء APK
gradlew.bat assembleDebug

REM 4. إذا نجح البناء، ستجد APK في:
REM app\build\outputs\apk\debug\app-debug.apk
```

## حل المشاكل الشائعة

### مشكلة: "Could not GET 'https://dl.google.com/...'"

**السبب**: لا يمكن الوصول إلى مستودع Google Maven

**الحلول**:

1. **استخدم VPN**
   - بعض الدول تحظر الوصول إلى dl.google.com
   - استخدم VPN للوصول

2. **استخدم مرآة (Mirror)**
   - استخدم المرآة الصينية (Aliyun) كما هو موضح أعلاه

3. **تحميل المكتبات مسبقاً**
   - على جهاز آخر له إنترنت، قم ببناء المشروع
   - انسخ مجلد `.gradle/caches/` إلى جهازك
   - استخدم `--offline`:
     ```bash
     ./gradlew assembleDebug --offline
     ```

### مشكلة: "Unsupported class file major version"

**السبب**: إصدار Java غير متوافق

**الحل**:
```bash
# تحقق من إصدار Java
java -version

# يجب أن يكون Java 11 أو أحدث
# إذا كان أقل، قم بتحديث Java
```

### مشكلة: "SDK location not found"

**الحل**:
أنشئ ملف `local.properties` في جذر المشروع:
```properties
sdk.dir=/path/to/Android/Sdk
```

على Windows:
```properties
sdk.dir=C\:\\Users\\YourName\\AppData\\Local\\Android\\Sdk
```

على macOS:
```properties
sdk.dir=/Users/YourName/Library/Android/sdk
```

على Linux:
```properties
sdk.dir=/home/YourName/Android/Sdk
```

### مشكلة: نفاد الذاكرة أثناء البناء

**الحل**:
أضف في `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096m -Xms512m -XX:MaxPermSize=1024m
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

## تثبيت APK على الجهاز

### باستخدام ADB (Android Debug Bridge):

1. **تفعيل USB Debugging على الهاتف**:
   - اذهب إلى الإعدادات
   - حول الهاتف
   - اضغط على "رقم الإصدار" 7 مرات
   - ارجع للإعدادات > خيارات المطور
   - فعّل "تصحيح USB"

2. **وصل الهاتف بالكمبيوتر**

3. **ثبت APK**:
   ```bash
   adb install app/build/outputs/apk/debug/app-debug.apk
   ```

### التثبيت اليدوي:

1. انسخ `app-debug.apk` إلى هاتفك
2. افتح مدير الملفات
3. اضغط على APK
4. قد يطلب منك تفعيل "تثبيت من مصادر غير معروفة"
5. اتبع التعليمات لإكمال التثبيت

## متطلبات الجهاز

- **نظام التشغيل**: Android 7.0 (API 24) أو أحدث
- **ARCore**: جهاز يدعم ARCore ([قائمة الأجهزة](https://developers.google.com/ar/devices))
- **الذاكرة**: 2 GB RAM على الأقل
- **التخزين**: 100 MB مساحة فارغة
- **الأجهزة**: كاميرا، GPS

## اختبار التطبيق

بعد التثبيت:

1. **افتح التطبيق**
2. **امنح الأذونات المطلوبة**:
   - إذن الكاميرا
   - إذن الموقع
3. **جرب الوظائف**:
   - اضغط "فتح الكاميرا" لإضافة ذكرى
   - اضغط "عرض الخريطة" لرؤية الذكريات

## دعم ARCore

إذا لم يكن جهازك يدعم ARCore:
- التطبيق سيعمل بدون ميزات AR
- يمكنك استخدام الكاميرا العادية
- جميع الوظائف الأخرى ستعمل بشكل طبيعي

## مصادر المساعدة

- **ARCore**: https://developers.google.com/ar
- **Android Developers**: https://developer.android.com
- **Kotlin**: https://kotlinlang.org
- **Room Database**: https://developer.android.com/training/data-storage/room

## الحصول على المساعدة

إذا واجهت مشاكل:
1. افتح Issue على GitHub
2. أرفق:
   - نص الخطأ الكامل
   - إصدار Java (`java -version`)
   - إصدار Gradle (`./gradlew --version`)
   - نظام التشغيل
   - خطوات إعادة المشكلة

---

**ملاحظة**: البناء الناجح يتطلب اتصال إنترنت جيد في المرة الأولى لتحميل جميع المكتبات (حوالي 200-300 MB).
