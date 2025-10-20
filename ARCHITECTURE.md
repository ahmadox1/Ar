# بنية التطبيق / Architecture Documentation

## نظرة عامة / Overview

تطبيق AR Memory مبني باستخدام معمارية MVVM (Model-View-ViewModel) مع قاعدة بيانات محلية.

AR Memory app is built using MVVM (Model-View-ViewModel) architecture with local database.

## الطبقات / Layers

```
┌─────────────────────────────────────┐
│         UI Layer (Activities)        │
│   MainActivity, ARCameraActivity,    │
│         MapActivity                  │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│      Data Layer (Repository)         │
│       MemoryRepository               │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│    Database Layer (Room)             │
│  MemoryDatabase, MemoryDao, Memory   │
└─────────────────────────────────────┘
```

## المكونات الرئيسية / Main Components

### 1. Data Models

#### Memory Entity
```kotlin
@Entity(tableName = "memories")
data class Memory(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val text: String,              // نص الذكرى
    val latitude: Double,          // خط العرض
    val longitude: Double,         // خط الطول
    val timestamp: Long            // وقت الإنشاء
)
```

**الحقول / Fields:**
- `id`: معرف فريد تلقائي
- `text`: محتوى الذكرى
- `latitude` & `longitude`: الموقع الجغرافي
- `timestamp`: وقت حفظ الذكرى

### 2. Database Access Object (DAO)

```kotlin
@Dao
interface MemoryDao {
    @Insert
    suspend fun insert(memory: Memory): Long
    
    @Query("SELECT * FROM memories ORDER BY timestamp DESC")
    fun getAllMemories(): Flow<List<Memory>>
    
    @Query("SELECT * FROM memories WHERE id = :id")
    suspend fun getMemoryById(id: Long): Memory?
    
    @Query("DELETE FROM memories WHERE id = :id")
    suspend fun deleteMemory(id: Long)
}
```

**الوظائف / Functions:**
- `insert()`: إضافة ذكرى جديدة
- `getAllMemories()`: جلب كل الذكريات كـ Flow
- `getMemoryById()`: جلب ذكرى محددة
- `deleteMemory()`: حذف ذكرى

### 3. Database

```kotlin
@Database(entities = [Memory::class], version = 1)
abstract class MemoryDatabase : RoomDatabase() {
    abstract fun memoryDao(): MemoryDao
    
    companion object {
        @Volatile
        private var INSTANCE: MemoryDatabase? = null
        
        fun getDatabase(context: Context): MemoryDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    MemoryDatabase::class.java,
                    "memory_database"
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}
```

**خصائص / Features:**
- Singleton Pattern
- Thread-safe
- معزولة عن السياق

### 4. Repository

```kotlin
class MemoryRepository(private val memoryDao: MemoryDao) {
    val allMemories: Flow<List<Memory>> = memoryDao.getAllMemories()
    
    suspend fun insert(memory: Memory): Long {
        return memoryDao.insert(memory)
    }
    
    suspend fun getMemoryById(id: Long): Memory? {
        return memoryDao.getMemoryById(id)
    }
    
    suspend fun deleteMemory(id: Long) {
        memoryDao.deleteMemory(id)
    }
}
```

**المسؤوليات / Responsibilities:**
- تجريد طبقة الوصول للبيانات
- إدارة مصادر البيانات المتعددة (قاعدة بيانات، API، إلخ)

## الأنشطة / Activities

### 1. MainActivity

**المسؤوليات:**
- نقطة الدخول الرئيسية
- طلب الأذونات
- التنقل إلى الشاشات الأخرى

**Flow Chart:**
```
Start
  ↓
Check Permissions
  ↓
┌─────────────┬─────────────┐
│   Camera    │     Map     │
│   Button    │   Button    │
└──────┬──────┴──────┬──────┘
       ↓             ↓
  ARCamera      MapActivity
  Activity
```

### 2. ARCameraActivity

**المسؤوليات:**
- فتح الكاميرا
- عرض واجهة AR
- حفظ الذكريات مع الموقع

**Components:**
- ARFragment: عرض AR
- EditText: إدخال النص
- Buttons: حفظ/إلغاء
- LocationClient: جلب الموقع

**Flow:**
```
Open Activity
  ↓
Request Location
  ↓
Display AR View
  ↓
User Enters Text
  ↓
User Taps Save
  ↓
Save to Database
  ↓
Show Success Message
```

### 3. MapActivity

**المسؤوليات:**
- عرض الخريطة
- إظهار الذكريات كعلامات
- التفاعل مع العلامات

**Components:**
- MapFragment: عرض Google Maps
- Markers: علامات الذكريات

**Flow:**
```
Open Activity
  ↓
Load Map
  ↓
Fetch Memories from DB
  ↓
Add Markers to Map
  ↓
User Can Tap Markers
  ↓
Show Memory Details
```

## إدارة الأذونات / Permission Management

### الأذونات المطلوبة:
1. **CAMERA**: للكاميرا و AR
2. **ACCESS_FINE_LOCATION**: لتحديد الموقع الدقيق
3. **ACCESS_COARSE_LOCATION**: لتحديد الموقع التقريبي

### التدفق:
```
User Clicks Button
  ↓
Check Permission
  ↓
┌──────────┴──────────┐
│ Granted  │  Denied  │
└────┬─────┴─────┬────┘
     ↓           ↓
  Continue   Request
            Permission
                ↓
         ┌──────┴──────┐
         │ Grant │Deny │
         └───┬───┴──┬──┘
             ↓      ↓
         Continue  Show
                  Message
```

## تدفق البيانات / Data Flow

### حفظ ذكرى / Saving Memory

```
User Input (ARCameraActivity)
  ↓
Get Current Location
  ↓
Create Memory Object
  ↓
Repository.insert(memory)
  ↓
MemoryDao.insert(memory)
  ↓
Room Database
  ↓
Return Success
  ↓
Update UI
```

### عرض الذكريات / Displaying Memories

```
MapActivity Started
  ↓
Repository.allMemories (Flow)
  ↓
MemoryDao.getAllMemories()
  ↓
Room Database Query
  ↓
Flow<List<Memory>>
  ↓
Collect in UI
  ↓
Update Map Markers
```

## Coroutines & Threading

### استخدام Coroutines:
```kotlin
lifecycleScope.launch {
    // Database operations on IO thread
    withContext(Dispatchers.IO) {
        repository.insert(memory)
    }
    
    // Update UI on Main thread
    withContext(Dispatchers.Main) {
        showSuccessMessage()
    }
}
```

### Threads:
- **Main Thread**: UI updates
- **IO Thread**: Database operations
- **Default Thread**: Heavy computations

## المكتبات الخارجية / External Libraries

### 1. ARCore
```kotlin
implementation("com.google.ar:core:1.40.0")
```
**الاستخدام:** الواقع المعزز

### 2. Room Database
```kotlin
implementation("androidx.room:room-runtime:2.6.0")
kapt("androidx.room:room-compiler:2.6.0")
```
**الاستخدام:** قاعدة البيانات المحلية

### 3. Google Maps
```kotlin
implementation("com.google.android.gms:play-services-maps:18.2.0")
```
**الاستخدام:** عرض الخريطة

### 4. Location Services
```kotlin
implementation("com.google.android.gms:play-services-location:21.0.1")
```
**الاستخدام:** تحديد الموقع

### 5. Kotlin Coroutines
```kotlin
implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.3")
```
**الاستخدام:** البرمجة غير المتزامنة

## الميزات المستقبلية / Future Features

### 1. Firebase Integration
```
Current: Local Database
  ↓
Add: Firebase Firestore
  ↓
Sync: Local ↔ Cloud
```

### 2. Proximity Notifications
```
Background Service
  ↓
Monitor Location
  ↓
Check Nearby Memories
  ↓
Show Notification
```

### 3. AR Visualization
```
AR Camera
  ↓
Detect Nearby Memory
  ↓
Render 3D Object
  ↓
User Can View
```

## Best Practices

### 1. Lifecycle Awareness
```kotlin
class ARCameraActivity : AppCompatActivity() {
    override fun onPause() {
        super.onPause()
        // Pause AR session
    }
    
    override fun onResume() {
        super.onResume()
        // Resume AR session
    }
}
```

### 2. Memory Management
- استخدام weak references للـ Context
- إلغاء Coroutines عند destroy
- تنظيف الموارد في onDestroy

### 3. Error Handling
```kotlin
try {
    repository.insert(memory)
    showSuccess()
} catch (e: Exception) {
    Log.e(TAG, "Error saving memory", e)
    showError()
}
```

## الاختبارات / Testing

### Unit Tests
```kotlin
@Test
fun testMemoryInsertion() {
    val memory = Memory(text = "Test", lat = 0.0, lng = 0.0)
    val id = repository.insert(memory)
    assertTrue(id > 0)
}
```

### UI Tests
```kotlin
@Test
fun testSaveButton() {
    onView(withId(R.id.btnSaveMemory))
        .perform(click())
    onView(withText("Memory saved"))
        .check(matches(isDisplayed()))
}
```

## الأمان / Security

### 1. Location Privacy
- لا يتم مشاركة الموقع بدون إذن
- البيانات محلية فقط (حالياً)

### 2. Data Validation
```kotlin
fun validateMemory(text: String): Boolean {
    return text.isNotBlank() && text.length <= 500
}
```

### 3. Permission Handling
- طلب الأذونات في الوقت المناسب
- شرح سبب الحاجة للأذونات

---

## المراجع / References

- [Android Architecture Guide](https://developer.android.com/topic/architecture)
- [Room Database](https://developer.android.com/training/data-storage/room)
- [ARCore](https://developers.google.com/ar)
- [Kotlin Coroutines](https://kotlinlang.org/docs/coroutines-overview.html)
