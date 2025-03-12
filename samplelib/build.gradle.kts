import java.util.Properties

plugins {
    id("com.android.library")
    id("maven-publish")
}

fun loadEnv(): Properties {
    val envFile = rootProject.file(".env")
    val properties = Properties()
    if (envFile.exists()) {
        envFile.inputStream().use { properties.load(it) }
    }
    return properties
}

val env = loadEnv()

fun getEnv(key: String): String? {
    return env.getProperty(key) ?: System.getenv(key)
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
    implementation(libs.jackson.databind)
    implementation(libs.jackson.annotations)
    implementation(libs.jackson.core)
    implementation(libs.okhttp)
}

publishing {
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri(providers.gradleProperty("github.maven.url").get())
            credentials {
                username = getEnv("GITHUB_USERNAME")
                password = getEnv("GITHUB_TOKEN")
            }
        }
    }

    publications {
        create<MavenPublication>("release") {
            groupId = providers.gradleProperty("lib.group").get()
            artifactId = providers.gradleProperty("lib.artifact").get()
            version = providers.gradleProperty("lib.version").get()
            artifact("$buildDir/outputs/aar/${providers.gradleProperty("lib.name").get()}-release.aar")
            pom.withXml {
                val dependenciesNode = asNode().appendNode("dependencies")
                configurations.implementation.get().dependencies.forEach { dependency ->
                    if (dependency.group != null && dependency.version != null) {
                        val dependencyNode = dependenciesNode.appendNode("dependency")
                        dependencyNode.appendNode("groupId", dependency.group)
                        dependencyNode.appendNode("artifactId", dependency.name)
                        dependencyNode.appendNode("version", dependency.version)
                        dependencyNode.appendNode("scope", "runtime")
                    }
                }
            }
        }
    }
}