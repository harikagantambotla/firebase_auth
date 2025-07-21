plugins {
    id 'com.android.application'
    id 'kotlin-android'
    id 'com.google.gms.google-services' // ✅ Firebase plugin
}

android {
    namespace "com.example.firebase_auth_app"
    compileSdk 34

    defaultConfig {
        applicationId "com.example.firebase_auth_app"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"

        multiDexEnabled true
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib:1.9.0"
    implementation platform('com.google.firebase:firebase-bom:32.7.3')
    implementation 'com.google.firebase:firebase-auth'
}
