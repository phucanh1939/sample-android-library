plugins {
    id("com.android.library")
    id("maven-publish")
}

android {
    namespace = "com.fearth.sample.android.samplelib"
    compileSdk = 34

    defaultConfig {
        minSdk = 21
        consumerProguardFiles("consumer-rules.pro")
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
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

dependencies {

}

publishing {
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/phucanh1939/sample-android-library")
            credentials {
                username = project.findProperty("gpr.usr") as String? ?: System.getenv("GITHUB_USERNAME")
                password = project.findProperty("gpr.key") as String? ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }

    publications {
        create<MavenPublication>("release") {
            groupId = "com.fearth.sample.android"  // Change this to match your package
            artifactId = "samplelib" // Library name
            version = "1.0.0"
            artifact("$buildDir/outputs/aar/samplelib-release.aar") // Path to AAR
        }
    }
}