#!/bin/bash

# Stop on first error
set -e

# Define library module name
LIB_NAME="samplelib"

echo "Cleaning previous builds..."
./gradlew clean

echo "Building AAR for $LIB_NAME..."
./gradlew :$LIB_NAME:assembleRelease

# Path to the output AAR
AAR_PATH="$LIB_NAME/build/outputs/aar/$LIB_NAME-release.aar"

# Check if AAR was built successfully
if [ -f "$AAR_PATH" ]; then
    echo "✅ Build successful! AAR located at:"
    echo "$AAR_PATH"
else
    echo "❌ Build failed!"
    exit 1
fi
