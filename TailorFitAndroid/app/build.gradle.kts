plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
}

android {
    namespace = "com.karthikinformationtechnology.tailorfitandroid"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.karthikinformationtechnology.tailorfitandroid"
        minSdk = 28
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }


    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    buildFeatures {
        viewBinding = true
        dataBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
    kotlinOptions {
        jvmTarget = "1.8"
    }
}

//dependencies {
//    // CameraX dependencies
//    implementation("androidx.camera:camera-core:1.2.0")
//    implementation("androidx.camera:camera-camera2:1.2.0")
//    implementation("androidx.camera:camera-lifecycle:1.2.0")
//    implementation("androidx.camera:camera-view:1.2.0")
//
//    // ML Kit Pose Detection
//    implementation("com.google.mlkit:pose-detection:18.0.0")
//    implementation('com.google.mlkit:pose-detection-legacy:16.0.0')
//}

dependencies {

    // CameraX dependencies
    implementation(libs.androidx.camera.camera2)
    implementation(libs.androidx.camera.lifecycle)
    implementation(libs.androidx.camera.view)
    implementation(libs.androidx.camera.extensions)

    // ML Kit Pose Detection
    implementation(libs.pose.detection)

    //Android dependencies
    implementation(libs.androidx.core.ktx)
    implementation(libs.androidx.appcompat)
    implementation(libs.material)
    implementation(libs.androidx.activity)
    implementation(libs.vision.common)
    implementation(libs.pose.detection.common)
    implementation(libs.mlkit.pose.detection)
    testImplementation(libs.junit)
    androidTestImplementation(libs.androidx.junit)
    androidTestImplementation(libs.androidx.espresso.core)

}