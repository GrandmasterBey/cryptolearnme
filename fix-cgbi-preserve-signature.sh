#!/bin/bash

# Post-build script to fix CgBI PNG issue while preserving signature
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
    # Get original file permissions and size
    ORIGINAL_PERM=$(stat -f "%Mp%Lp" "Payload/CryptoLearn.app/AppIcon120x120.png")
    ORIGINAL_SIZE=$(stat -f "%z" "Payload/CryptoLearn.app/AppIcon120x120.png")
    
    # Create a new standard PNG
    sips -s format png "Payload/CryptoLearn.app/AppIcon120x120.png" --out "temp_standard_120.png"
    
    # Replace file while preserving metadata
    cp "temp_standard_120.png" "Payload/CryptoLearn.app/AppIcon120x120.png"
    
    # Restore original file permissions
    chmod "$ORIGINAL_PERM" "Payload/CryptoLearn.app/AppIcon120x120.png"
    
    echo "Converted AppIcon120x120.png while preserving signature metadata"
fi

# Convert 167x167 icon  
if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    # Get original file permissions and size
    ORIGINAL_PERM=$(stat -f "%Mp%Lp" "Payload/CryptoLearn.app/AppIcon167x167.png")
    ORIGINAL_SIZE=$(stat -f "%z" "Payload/CryptoLearn.app/AppIcon167x167.png")
    
    # Create a new standard PNG
    sips -s format png "Payload/CryptoLearn.app/AppIcon167x167.png" --out "temp_standard_167.png"
    
    # Replace file while preserving metadata
    cp "temp_standard_167.png" "Payload/CryptoLearn.app/AppIcon167x167.png"
    
    # Restore original file permissions
    chmod "$ORIGINAL_PERM" "Payload/CryptoLearn.app/AppIcon167x167.png"
    
    echo "Converted AppIcon167x167.png while preserving signature metadata"
fi

echo "Creating new IPA..."
zip -r "../$OUTPUT_PATH" Payload/

echo "Cleaning up..."
cd ..
rm -rf temp_extract

echo "Done! Fixed IPA created: $OUTPUT_PATH"
