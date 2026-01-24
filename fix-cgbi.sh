#!/bin/bash

# Post-build script to fix CgBI PNG issue
set -e

IPA_PATH="$1"
OUTPUT_PATH="$2"

echo "Extracting IPA..."
mkdir -p temp_extract
cd temp_extract
unzip "../$IPA_PATH"

echo "Converting CgBI PNGs to standard PNG..."
# Convert 120x120 icon
if [ -f "Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon120x120.png" --out "Payload/CryptoLearn.app/AppIcon120x120.png"
    echo "Converted AppIcon120x120.png"
fi

# Convert 167x167 icon  
if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon167x167.png" --out "Payload/CryptoLearn.app/AppIcon167x167.png"
    echo "Converted AppIcon167x167.png"
fi

echo "Creating new IPA..."
zip -r "../$OUTPUT_PATH" Payload/

echo "Cleaning up..."
cd ..
rm -rf temp_extract

echo "Done! Fixed IPA created: $OUTPUT_PATH"
