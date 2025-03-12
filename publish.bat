@echo off

set LIB_NAME=samplelib
set GITHUB_REPO=https://github.com/phucanh1939/sample-android-library

echo Cleaning previous builds...
call gradlew clean
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Cleaning failed!
    exit /b %ERRORLEVEL%
)

echo Building AAR for %LIB_NAME%...
call gradlew :%LIB_NAME%:assembleRelease
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Build failed!
    exit /b %ERRORLEVEL%
)

echo Publishing %LIB_NAME% to GitHub Packages...
call gradlew.bat :%LIB_NAME%:publish
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Publish failed!
    exit /b %ERRORLEVEL%
)

echo Publish successful!

echo Check your package at %GITHUB_REPO%/packages
