# المساهمة في المشروع / Contributing Guide

## شكراً لاهتمامك بالمساهمة! / Thank you for your interest!

هذا المشروع مفتوح للمساهمات من الجميع.

This project is open for contributions from everyone.

## كيفية المساهمة / How to Contribute

### 1. Fork المشروع

اضغط على زر "Fork" في أعلى الصفحة

Click the "Fork" button at the top of the page

### 2. استنسخ نسختك / Clone Your Fork

```bash
git clone https://github.com/YOUR_USERNAME/Ar.git
cd Ar
```

### 3. أنشئ فرع جديد / Create a New Branch

```bash
git checkout -b feature/amazing-feature
```

أو للإصلاحات / Or for fixes:
```bash
git checkout -b fix/bug-description
```

### 4. قم بالتعديلات / Make Your Changes

اتبع معايير الكود / Follow code standards:
- استخدم Kotlin style guide
- اكتب تعليقات واضحة بالعربية أو الإنجليزية
- اختبر تعديلاتك قبل الإرسال

### 5. Commit التعديلات / Commit Changes

```bash
git add .
git commit -m "Add: description of your changes"
```

استخدم رسائل commit واضحة:
- `Add:` للميزات الجديدة
- `Fix:` لإصلاح الأخطاء
- `Update:` للتحديثات
- `Remove:` للحذف

### 6. Push للفرع / Push to Branch

```bash
git push origin feature/amazing-feature
```

### 7. افتح Pull Request / Open Pull Request

1. اذهب إلى صفحة GitHub الخاصة بك
2. اضغط "Compare & pull request"
3. اكتب وصف واضح للتغييرات
4. انتظر المراجعة

## أفكار للمساهمة / Ideas for Contributing

### ميزات جديدة / New Features
- [ ] تحسين واجهة المستخدم
- [ ] إضافة فلاتر للذكريات
- [ ] مشاركة الذكريات عبر الشبكات الاجتماعية
- [ ] إضافة الصور مع الذكريات
- [ ] نظام التقييم للذكريات
- [ ] خاصية البحث
- [ ] تصدير الذكريات

### تحسينات / Improvements
- [ ] تحسين أداء AR
- [ ] تحسين استهلاك البطارية
- [ ] تحسين دقة تحديد الموقع
- [ ] إضافة اختبارات Unit Tests
- [ ] تحسين التوثيق

### إصلاحات / Bug Fixes
- راجع قائمة Issues وساعد في حل المشاكل
- أبلغ عن أخطاء جديدة

## معايير الكود / Code Standards

### Kotlin

```kotlin
// استخدم أسماء واضحة / Use clear names
class MemoryManager {
    private val memories: List<Memory> = listOf()
    
    // دوال قصيرة ومحددة / Short, specific functions
    fun saveMemory(memory: Memory) {
        // Implementation
    }
}
```

### XML Layouts

```xml
<!-- استخدم IDs واضحة / Use clear IDs -->
<Button
    android:id="@+id/btnSaveMemory"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"
    android:text="@string/save_memory" />
```

### Strings

```xml
<!-- أضف النصوص في strings.xml / Add strings to strings.xml -->
<resources>
    <string name="save_memory">حفظ الذكرى</string>
    <string name="save_memory_en">Save Memory</string>
</resources>
```

## اختبار التعديلات / Testing Changes

قبل إرسال Pull Request:

Before sending a Pull Request:

1. **بناء المشروع / Build Project**
   ```bash
   ./gradlew build
   ```

2. **اختبار على جهاز حقيقي / Test on Real Device**
   - ثبت APK على جهاز اندرويد
   - اختبر الميزة الجديدة
   - تأكد من عدم كسر الميزات القديمة

3. **اختبار الأذونات / Test Permissions**
   - تأكد من طلب الأذونات المطلوبة
   - اختبر السلوك عند رفض الأذونات

## الإبلاغ عن الأخطاء / Reporting Bugs

عند الإبلاغ عن خطأ، يرجى تضمين:

When reporting a bug, please include:

### معلومات الجهاز / Device Information
- موديل الجهاز / Device model
- إصدار Android / Android version
- هل يدعم ARCore؟ / ARCore support?

### وصف المشكلة / Problem Description
- ما الذي حدث؟ / What happened?
- ما كنت تتوقع؟ / What did you expect?
- خطوات إعادة المشكلة / Steps to reproduce

### Logs
```bash
# احصل على logs باستخدام / Get logs using:
adb logcat | grep "ar.memory"
```

### Screenshots
أرفق صور إذا أمكن / Attach screenshots if possible

## طلب ميزات جديدة / Requesting Features

لطلب ميزة جديدة:

To request a new feature:

1. افتح Issue جديد / Open new Issue
2. استخدم عنوان "[Feature Request]"
3. اشرح الميزة بالتفصيل
4. لماذا هذه الميزة مفيدة؟
5. هل لديك أفكار للتنفيذ؟

## مراجعة الكود / Code Review

عند مراجعة Pull Requests:

When reviewing Pull Requests:

- كن محترماً ومفيداً
- اشرح سبب اقتراحاتك
- ركز على جودة الكود وليس على الأشخاص
- قدّر المجهود المبذول

## الاتصال / Contact

- **GitHub Issues**: للأخطاء والطلبات
- **Pull Requests**: للمساهمات
- **Discussions**: للأسئلة العامة

## الترخيص / License

بالمساهمة في هذا المشروع، أنت توافق على أن مساهمتك ستكون مرخصة تحت نفس ترخيص المشروع.

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

---

## شكراً لمساهمتك! / Thank You for Contributing!

كل مساهمة، صغيرة أو كبيرة، تساعد في تحسين المشروع.

Every contribution, small or large, helps improve the project.
