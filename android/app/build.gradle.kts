plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // Ubah nama di sini sesuai Firebase lu
    namespace = "com.example.fitcore_app"
    
    // Naikin SDK & NDK sesuai permintaan terminal
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    defaultConfig {
            // Ubah nama di sini juga
            applicationId = "com.example.fitcore_app"
            minSdk = flutter.minSdkVersion  // <--- UBAH JADI ANGKA INI AJA BIAR AMAN
            targetSdk = 34
            versionCode = 1
            versionName = "1.0.0"
            multiDexEnabled = true
        }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("com.google.firebase:firebase-bom:33.0.0")
}

flutter {
    source = "../.."
}
