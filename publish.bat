@echo off
echo Loading configuration...
call config.bat

echo GITHUB_USERNAME: %GITHUB_USERNAME%
echo GITHUB_TOKEN: %GITHUB_TOKEN%

echo Publishing AAR to GitHub Packages...
gradlew.bat :samplelib:publish --stacktrace --info

if %ERRORLEVEL% NEQ 0 (
    echo Publish failed!
    exit /b 1
)

echo Publish successful!
