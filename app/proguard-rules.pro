# Add project specific ProGuard rules here.
-keep public class com.google.ar.core.** { *; }
-keep class com.google.ar.sceneform.** { *; }
-keepattributes *Annotation*
-keepclassmembers class * {
    @androidx.room.* <methods>;
}
