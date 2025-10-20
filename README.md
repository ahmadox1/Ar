# AR Memory - تطبيق الذكريات بالواقع المعزز

## نظرة عامة / Overview

تطبيق اندرويد مبني بلغة Kotlin يستخدم تقنية الواقع المعزز (AR) لحفظ ومشاركة الذكريات في المواقع الجغرافية.

An Android application built with Kotlin that uses Augmented Reality (AR) to save and share memories at geographic locations.

## المميزات / Features

### النسخة الحالية (التخزين المحلي)
- ✅ فتح الكاميرا مع واجهة AR
- ✅ كتابة وحفظ الذكريات
- ✅ حفظ الذكريات مع الموقع الجغرافي (GPS)
- ✅ عرض الذكريات على الخريطة
- ✅ قاعدة بيانات محلية (Room Database)
- ✅ طلب أذونات الكاميرا والموقع

### المميزات المستقبلية
- ⏳ مزامنة البيانات مع Firebase
- ⏳ إشعارات القرب من الذكريات
- ⏳ مشاركة الذكريات مع المستخدمين الآخرين
- ⏳ عرض ذكريات المستخدمين الآخرين في AR

## الهيكل التقني / Technical Structure

### التقنيات المستخدمة
- **Kotlin**: لغة البرمجة الأساسية
- **Android SDK 24+**: الحد الأدنى
- **ARCore**: للواقع المعزز
- **Room Database**: قاعدة البيانات المحلية
- **Google Maps**: لعرض الخريطة
- **Location Services**: لتتبع الموقع
- **CameraX**: للكاميرا

### البنية / Architecture

```
com.ar.memory/
├── data/                    # طبقة البيانات
│   ├── Memory.kt           # نموذج البيانات
│   ├── MemoryDao.kt        # واجهة قاعدة البيانات
│   ├── MemoryDatabase.kt   # قاعدة البيانات
│   └── MemoryRepository.kt # مستودع البيانات
├── ui/                      # واجهات المستخدم
│   ├── MainActivity.kt      # الشاشة الرئيسية
│   ├── ARCameraActivity.kt  # شاشة الكاميرا و AR
│   └── MapActivity.kt       # شاشة الخريطة
└── utils/                   # أدوات مساعدة
```

## كيفية البناء / How to Build

### المتطلبات
1. Android Studio Arctic Fox أو أحدث
2. JDK 11 أو أحدث
3. Android SDK 34
4. اتصال بالإنترنت (للمرة الأولى لتحميل المكتبات)

### خطوات البناء

#### في Android Studio:
1. افتح المشروع في Android Studio
2. انتظر تحميل Gradle للمكتبات
3. اختر **Build > Build Bundle(s) / APK(s) > Build APK(s)**
4. ستجد ملف APK في: `app/build/outputs/apk/debug/app-debug.apk`

#### من سطر الأوامر:
```bash
# إعطاء صلاحيات التنفيذ
chmod +x gradlew

# بناء APK
./gradlew assembleDebug

# ستجد الملف في:
# app/build/outputs/apk/debug/app-debug.apk
```

### ملاحظات مهمة للبناء

**⚠️ تنبيه**: يتطلب البناء الوصول إلى مستودعات Google Maven:
- `https://dl.google.com/dl/android/maven2/`

**للحصول على حلول مفصلة لمشاكل البناء والشبكة، راجع:**
- 📖 [دليل البناء مع قيود الشبكة (NETWORK_BUILD_GUIDE.md)](./NETWORK_BUILD_GUIDE.md)
- 🔨 [تعليمات البناء التفصيلية (BUILD_INSTRUCTIONS.md)](./BUILD_INSTRUCTIONS.md)
- 📋 [دليل البناء اليدوي (MANUAL_BUILD_GUIDE.md)](./MANUAL_BUILD_GUIDE.md)

**سكريبت بناء محسّن:**
```bash
chmod +x enhanced_build.sh
./enhanced_build.sh
```

إذا كنت في بيئة محدودة الوصول للإنترنت:
1. استخدم VPN للوصول إلى dl.google.com
2. أو استخدم مرايا Aliyun (انظر NETWORK_BUILD_GUIDE.md)
3. أو قم بتحميل المكتبات مسبقاً على جهاز آخر واستخدم `--offline`

## الأذونات المطلوبة / Required Permissions

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

## كيفية الاستخدام / How to Use

1. **الشاشة الرئيسية**: اختر بين فتح الكاميرا أو عرض الخريطة
2. **شاشة الكاميرا**: 
   - اكتب ذكرى في حقل النص
   - اضغط "حفظ الذكرى" لحفظها في الموقع الحالي
3. **شاشة الخريطة**: عرض جميع الذكريات المحفوظة على الخريطة

## خطة التطوير المستقبلي / Future Development Plan

1. ✅ إعداد المشروع الأساسي
2. ✅ إضافة واجهات المستخدم
3. ✅ تكامل قاعدة البيانات
4. ⏳ تحسين تجربة AR
5. ⏳ إضافة Firebase
6. ⏳ نظام الإشعارات
7. ⏳ مشاركة الذكريات بين المستخدمين

## المشاكل المعروفة / Known Issues

- البناء يتطلب اتصال بالإنترنت للمرة الأولى (أو استخدام VPN إذا كان dl.google.com محظوراً)
- ARCore يتطلب جهاز داعم للواقع المعزز ([قائمة الأجهزة المدعومة](https://developers.google.com/ar/devices))
- خرائط Google تتطلب مفتاح API (انظر أدناه لكيفية الحصول عليه)

**للحلول التفصيلية:**  راجع [NETWORK_BUILD_GUIDE.md](./NETWORK_BUILD_GUIDE.md)

## المساهمة / Contributing

المشروع مفتوح للتطوير والتحسين. يرجى:
1. Fork المشروع
2. إنشاء فرع جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للفرع (`git push origin feature/AmazingFeature`)
5. فتح Pull Request

## الترخيص / License

هذا المشروع مفتوح المصدر ومتاح للاستخدام الشخصي والتعليمي.

---

## ملاحظات للمطورين / Developer Notes

### إعداد Google Maps API Key

**هام**: التطبيق يحتوي على مفتاح وهمي. للحصول على خرائط عاملة:

1. احصل على مفتاح API من [Google Cloud Console](https://console.cloud.google.com/)
   - أنشئ مشروع جديد أو استخدم مشروع موجود
   - فعّل "Maps SDK for Android"
   - انتقل إلى Credentials > Create Credentials > API Key
2. افتح `app/src/main/AndroidManifest.xml`
3. استبدل `AIzaSyDummy_Key_Replace_With_Real_One_From_Google_Console` بمفتاحك الحقيقي

**ملاحظة**: التطبيق سيعمل بدون مفتاح حقيقي، لكن الخرائط لن تظهر بشكل صحيح.

### التبعيات الرئيسية / Main Dependencies

```kotlin
// ARCore
implementation("com.google.ar:core:1.40.0")

// Room Database
implementation("androidx.room:room-runtime:2.6.0")
kapt("androidx.room:room-compiler:2.6.0")

// Google Maps
implementation("com.google.android.gms:play-services-maps:18.2.0")
implementation("com.google.android.gms:play-services-location:21.0.1")

// CameraX
implementation("androidx.camera:camera-core:1.3.0")
implementation("androidx.camera:camera-camera2:1.3.0")
```

## الدعم / Support

إذا واجهت أي مشاكل، يرجى فتح Issue في GitHub.
