// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        mavenCentral()
        maven { url = uri("https://jitpack.io") }
    }
    dependencies {
        // Note: Android Gradle Plugin requires Google Maven repository
        // Due to network restrictions, manual setup may be needed
        // classpath("com.android.tools.build:gradle:7.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20")
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}

