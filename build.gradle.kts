// Top-level build file where you can add configuration options common to all sub-projects/modules.
buildscript {
    repositories {
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/android/m2repository") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/google/m2repository") }
        mavenCentral()
        gradlePluginPortal()
        maven { 
            url = uri("https://maven.google.com")
            content {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("com\\.google.*")
                includeGroupByRegex("androidx.*")
            }
        }
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.20")
    }
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}
