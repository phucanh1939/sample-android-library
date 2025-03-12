# Sample Android Library

This sample project demonstrates how to create, build, and publish an Android library.

## Requirement

- Android Studio (latest version)
- GitHub account (for publishing via JitPack)

## Create & Setup Project

### 1. Create an Empty Project
1. Open **Android Studio**
2. Select **"New Project"** → **"No Activity"**
3. Set **Project Name**, **Package Name**, and **Location**
4. Choose **Language: Java** and **Build System: Gradle (Kotlin DSL or Groovy)**
5. Click **Finish**

### 2. Remove unused default module
1. Remove `./app/` directory (default app module Android Studio created)
2. Remove `include(":app")` from `build.gradle.kts`

### 3. Create Library Module
1. Go to **File** → **New** → **New Module**
2. Select **"Android Library"**
3. Set **Module Name** (e.g., `samplelib`)
4. Click **Finish**
5. Remove unused dependencies in `./samplelib/build.gradle.kts` and related unused source code at `./samplelib/src/androidTest` `./samplelib/src/test`
6. Update `plugins` section in `./samplelib/build.gradle.kts` to `id("com.android.library")` to tell gradle to build this module as an android library
    ```kotlin
    plugins {
        id("com.android.library")
    }
    ```

### 4. Create Sample App Module
1. Go to **File** → **New** → **New Module**
2. Select **"Phone & Tablet"** → **"Empty Activity"**
3. Set **Module Name** (e.g., `sampleapp`)
4. Click **Finish**

### 5. Configure `settings.gradle.kts`
Modify `settings.gradle.kts` to include both modules:
```kotlin
rootProject.name = "YourProjectName"
include(":samplelib")
include(":sampleapp")
```

## Import Source File

1. Add your source files inside `samplelib/src/main/java/com/fearth/sample/android/samplelib`
2. Example: Create a simple utility class:
   ```java
   package com.fearth.sample.android.samplelib;
   
   public class SampleUtils {
       public static String getMessage() {
           return "Hello from Sample Library!";
       }
   }
   ```

## Run Sample Module to Test the Library Locally

1. Open `sampleapp/build.gradle.kts` and add dependency on the local library:
   ```kotlin
   dependencies {
       implementation(project(":samplelib"))
   }
   ```
2. In `sampleapp` module, use the library class in `MainActivity.java`:
   ```java
   package com.fearth.sample;
   
   import android.os.Bundle;
   import android.widget.TextView;
   import androidx.appcompat.app.AppCompatActivity;
   import com.fearth.sampleaar.SampleUtils;
   
   public class MainActivity extends AppCompatActivity {
       @Override
       protected void onCreate(Bundle savedInstanceState) {
           super.onCreate(savedInstanceState);
           TextView textView = new TextView(this);
           textView.setText(SampleUtils.getMessage());
           setContentView(textView);
       }
   }
   ```
3. Run the `sample` module and verify the output.

## Build

### Using Android Studio
1. Click **"Build" → "Make Project"**
2. The AAR will be generated in `samplelib/build/outputs/aar/samplelib-release.aar`

### Using Build Script
1. Run `./build.sh` (MacOS) or `./build.bat` to build the library (release version)
2. The output `aar` can be found at `samplelib/build/outputs/aar/samplelib-release.aar`
  
## Publishing

### Publish to GitHub Packages (Maven)

1. Update `./samplelib/build.gradle.kts` for publishing
```kotlin
publishing {
    repositories {
        maven {
            name = "GitHubPackages"
            url = uri("https://maven.pkg.github.com/YOUR_GITHUB_USERNAME/YOUR_REPO")
            credentials {
                username = project.findProperty("gpr.usr") as String? ?: System.getenv("GITHUB_USERNAME")
                password = project.findProperty("gpr.key") as String? ?: System.getenv("GITHUB_TOKEN")
            }
        }
    }

    publications {
        create<MavenPublication>("release") {
            from(components["release"]) // This tells Gradle to publish the release AAR

            groupId = "com.fearth.sample.android"  // Change this to match your package
            artifactId = "samplelib" // Library name
            version = "1.0.0"

            artifact("$buildDir/outputs/aar/samplelib-release.aar") // Path to AAR
        }
    }
}
```

2. Setup your github username & token in `config.bat` (create from template if needed) or `config.sh`. To create Github token:
    - Go [here](https://github.com/settings/tokens) add choose create `Classic Token`
    - Set these permissions: repo, write:packages, read:packages

3. Run `publish.bat` or `publish.sh` to build and publish the library to GitHub Packages

4. Check the published package:
    - Go to Github repo page and check for `Packages` next to `Releases`
    - Example: [Example Github Package Page](https://github.com/phucanh1939/sample-android-library/packages)

## Usage

### Using Github Packages

### Gradle 

A sample project (using Gradle) can be found [here](https://github.com/phucanh1939/sample-android-library-test)

1. Create `Github Personal Token` on consumer github account
    - Go [here](https://github.com/settings/tokens) add choose create `Classic Token`
    - Set these permissions: read:packages

2. Add Github Packages Repository to `settings.gradle.kts`:
   ```kotlin
    dependencyResolutionManagement {
        repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
        repositories {
            maven {
                url = uri("https://maven.pkg.github.com/phucanh1939/sample-android-library") // url to your github package
                credentials {
                    username = providers.gradleProperty("gpr.usr").getOrNull() ?: System.getenv("GITHUB_USERNAME") // consumer github account (not the owner)
                    password = providers.gradleProperty("gpr.key").getOrNull() ?: System.getenv("GITHUB_TOKEN") // consummer github token (not the owner)
                }
            }
            google()
            mavenCentral()
        }
    }
   ```

3. Add the dependency to `build.gradle.kts`:
   ```kotlin
   dependencies {
        implementation("com.fearth.sample.android:samplelib:1.0.0") // format: <groupId>:<artifactId>:<version>
   }
   ```

4. Use the library in code:
   ```java
   import com.fearth.sampleaar.SampleUtils;
   
   String message = SampleUtils.getMessage();
   ```

### Apache Maven Registry

Please follow the [Github Apache Mave Registry Guideline](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry)