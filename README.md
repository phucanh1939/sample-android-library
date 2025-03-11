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

### Publish to GitHub using JitPack

1. Push your project to a **public or private** GitHub repository.
2. **Ensure `samplelib` has a `build.gradle.kts` file** and `settings.gradle.kts` includes it.
3. Run `./release.bat <version_tag>` to build and create a Github release (Need to install [Github CLI](https://cli.github.com/) first, then run `gh auth login`)
4. Go to [JitPack](https://jitpack.io/) and enter your GitHub repository URL.
5. Click **"Get it"**, and JitPack will generate the AAR for you.

### JitPack Dependency for Other Projects
Add this to the **root `settings.gradle.kts`** of any project using your library:
```kotlin
maven { url = uri("https://jitpack.io") }
```

Then add the dependency to the module `build.gradle.kts`:
```kotlin
dependencies {
    implementation("com.github.yourusername:YourRepoName:1.0.0")
}
```

## Usage

### Import the Library in Another Project
1. Add JitPack to `settings.gradle.kts`:
   ```kotlin
   dependencyResolutionManagement {
       repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
       repositories {
           google()
           mavenCentral()
           maven { url = uri("https://jitpack.io") }
       }
   }
   ```
2. Add the dependency to `build.gradle.kts`:
   ```kotlin
   dependencies {
       implementation("com.github.yourusername:YourRepoName:1.0.0")
   }
   ```
3. Use the library in code:
   ```java
   import com.fearth.sampleaar.SampleUtils;
   
   String message = SampleUtils.getMessage();
   ```
