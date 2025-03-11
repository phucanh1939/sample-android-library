@echo off
setlocal enabledelayedexpansion

:: Define library module name
set LIB_NAME=samplelib

echo Cleaning previous builds...
call gradlew clean

echo Building AAR for %LIB_NAME%...
call gradlew :%LIB_NAME%:assembleRelease

:: Path to the output AAR
set AAR_PATH=%LIB_NAME%\build\outputs\aar\%LIB_NAME%-release.aar

:: Check if AAR was built successfully
if exist "%AAR_PATH%" (
    echo Build successful! AAR located at:
    echo %AAR_PATH%
) else (
    echo Build failed!
    exit /b 1
)

exit /b 0
