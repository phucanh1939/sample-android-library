@echo off
setlocal enabledelayedexpansion

:: Check if version argument is provided
if "%~1"=="" (
    echo [ERROR] No version specified! Usage: release.bat VERSION
    exit /b 1
)

set VERSION=%1
set LIB_NAME=samplelib
set AAR_PATH=%LIB_NAME%\build\outputs\aar\%LIB_NAME%-release.aar
set AAR_VERSIONED=%LIB_NAME%-%VERSION%.aar
set ZIP_FILE=%LIB_NAME%-%VERSION%.zip
set RELEASE_MSG="Release version %VERSION%"

:: Run the build script
call build.bat
if %errorlevel% neq 0 (
    echo [ERROR] Build failed!
    exit /b 1
)

:: Rename the AAR with the version
copy "%AAR_PATH%" "%AAR_VERSIONED%" /Y

:: Zip the AAR
powershell -Command "Compress-Archive -Path %AAR_VERSIONED% -DestinationPath %ZIP_FILE% -Force"
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create zip file!
    exit /b 1
)

:: Check if the tag exists
git fetch --tags
git tag | findstr /C:"%VERSION%" >nul
if %errorlevel% neq 0 (
    echo Creating new tag: %VERSION%
    git tag %VERSION%
    git push origin %VERSION%
) else (
    echo Tag %VERSION% already exists. Updating release...
)

:: Create or update GitHub release
for /f "tokens=*" %%i in ('git remote get-url origin') do set GIT_REPO=%%i
gh release create %VERSION% %ZIP_FILE% --title "Version %VERSION%" --notes %RELEASE_MSG% --latest --repo %GIT_REPO%
if %errorlevel% neq 0 (
    echo Updating existing release...
    gh release upload %VERSION% %ZIP_FILE% --repo %GIT_REPO%
)

echo Release %VERSION% published successfully!

del "%AAR_VERSIONED%" /F /Q
del "%ZIP_FILE%" /F /Q

exit /b 0
