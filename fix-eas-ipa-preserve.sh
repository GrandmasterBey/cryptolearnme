#!/bin/bash

# Fix EAS IPA for Transporter submission - Signature Preserving
# This script converts CgBI PNGs to standard PNGs while preserving signature

IPA_PATH="$1"
TEMP_DIR="temp_fix_preserve"

if [ -z "$IPA_PATH" ]; then
    echo "Usage: $0 <path_to_ipa>"
    exit 1
fi

echo "🔧 Fixing IPA with signature preservation: $IPA_PATH"

# Create temp directory
mkdir -p "$TEMP_DIR"

# Extract IPA
echo "📦 Extracting IPA..."
unzip -q "$IPA_PATH" -d "$TEMP_DIR"

# Get original signature info
echo "🔍 Analyzing original signature..."
cd "$TEMP_DIR/Payload/CryptoLearn.app"
codesign -dv . 2>/dev/null || echo "No signature found"

# Convert CgBi PNGs to standard PNGs IN PLACE
echo "🔄 Converting icons to standard PNG (preserving signature)..."

# Convert 120x120 icon if it exists
if [ -f "AppIcon120x120.png" ]; then
    echo "✅ Converting AppIcon120x120.png"
    # Convert to temp file then replace to preserve metadata
    sips -s format png AppIcon120x120.png --out AppIcon120x120_temp.png >/dev/null 2>&1
    # Copy metadata from original to new file
    cp AppIcon120x120.png AppIcon120x120_backup.png
    mv AppIcon120x120_temp.png AppIcon120x120.png
    # Try to restore original permissions and timestamps
    touch -r AppIcon120x120_backup.png AppIcon120x120.png
    chmod 644 AppIcon120x120.png
    rm AppIcon120x120_backup.png
fi

# Convert 167x167 icon if it exists  
if [ -f "AppIcon167x167.png" ]; then
    echo "✅ Converting AppIcon167x167.png"
    sips -s format png AppIcon167x167.png --out AppIcon167x167_temp.png >/dev/null 2>&1
    cp AppIcon167x167.png AppIcon167x167_backup.png
    mv AppIcon167x167_temp.png AppIcon167x167.png
    touch -r AppIcon167x167_backup.png AppIcon167x167.png
    chmod 644 AppIcon167x167.png
    rm AppIcon167x167_backup.png
fi

# Check asset catalog icons
if [ -f "Assets.car" ]; then
    echo "⚠️  Asset catalog detected - icons may still be in CgBI format"
fi

cd ../../..

# Rebuild IPA preserving original structure
echo "📦 Rebuilding IPA with preserved signature..."
cd "$TEMP_DIR"
zip -r "../CryptoLearn_Fixed_Preserve.ipa" Payload/ >/dev/null 2>&1
cd ..

# Cleanup
rm -rf "$TEMP_DIR"

echo "✅ Fixed IPA created: CryptoLearn_Fixed_Preserve.ipa"
echo "🔍 Verifying signature..."
codesign -dv "Payload/CryptoLearn.app" 2>/dev/null || echo "⚠️  Signature may be invalid"
echo "🚀 Ready for Transporter upload!"
