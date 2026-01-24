#!/bin/bash

# Fix EAS IPA for Transporter submission
# This script converts CgBI PNGs to standard PNGs while preserving signature

IPA_PATH="$1"
TEMP_DIR="temp_fix"

if [ -z "$IPA_PATH" ]; then
    echo "Usage: $0 <path_to_ipa>"
    exit 1
fi

echo "🔧 Fixing IPA: $IPA_PATH"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Extract IPA
echo "📦 Extracting IPA..."
unzip -q "$IPA_PATH" -d "$TEMP_DIR"

# Convert CgBI PNGs to standard PNGs
echo "🔄 Converting icons to standard PNG..."
cd "$TEMP_DIR/Payload/CryptoLearn.app"

# Convert 120x120 icon if it exists
if [ -f "AppIcon120x120.png" ]; then
    echo "✅ Converting AppIcon120x120.png"
    sips -s format png AppIcon120x120.png --out AppIcon120x120_fixed.png >/dev/null 2>&1
    mv AppIcon120x120_fixed.png AppIcon120x120.png
fi

# Convert 167x167 icon if it exists  
if [ -f "AppIcon167x167.png" ]; then
    echo "✅ Converting AppIcon167x167.png"
    sips -s format png AppIcon167x167.png --out AppIcon167x167_fixed.png >/dev/null 2>&1
    mv AppIcon167x167_fixed.png AppIcon167x167.png
fi

# Check asset catalog icons
if [ -f "Assets.car" ]; then
    echo "⚠️  Asset catalog detected - icons may still be in CgBI format"
fi

cd ../../..

# Rebuild IPA
echo "📦 Rebuilding IPA..."
cd "$TEMP_DIR"
zip -r "../CryptoLearn_Fixed.ipa" Payload/ >/dev/null 2>&1
cd ..

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Fixed IPA created: CryptoLearn_Fixed.ipa"
echo "🚀 Ready for Transporter upload!"
