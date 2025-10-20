pluginManagement {
    repositories {
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/android/m2repository") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/google/m2repository") }
        mavenCentral()
        gradlePluginPortal()
        maven { url = uri("https://maven.google.com") }
        maven { url = uri("https://jitpack.io") }
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/android/m2repository") }
        maven { url = uri("${System.getenv("ANDROID_HOME")}/extras/google/m2repository") }
        mavenCentral()
        maven { url = uri("https://maven.google.com") }
        maven { url = uri("https://jitpack.io") }
    }
}

rootProject.name = "AR Memory"
include(":app")
