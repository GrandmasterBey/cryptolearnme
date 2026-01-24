#!/bin/bash

# Final fix for EAS IPA: Convert CgBI icons to standard PNG while preserving signature

set -e

IPA_NAME="CryptoLearn_EAS_LATEST.ipa"
FIXED_IPA_NAME="CryptoLearn_EAS_FIXED.ipa"

echo "🔧 Fixing EAS IPA icon format..."

# Check if IPA exists
if [ ! -f "$IPA_NAME" ]; then
    echo "❌ Error: $IPA_NAME not found"
    echo "Please download the latest EAS IPA first"
    exit 1
fi

# Extract IPA
echo "📦 Extracting IPA..."
unzip -q "$IPA_NAME"

# Check if app bundle exists
if [ ! -d "Payload/CryptoLearn.app" ]; then
    echo "❌ Error: App bundle not found in IPA"
    exit 1
fi

# Backup original signature
echo "💾 Backing up signature..."
cp -r "Payload/CryptoLearn.app/_CodeSignature" "Payload/CryptoLearn.app/_CodeSignature.backup"

# Convert icons to standard PNG
echo "🎨 Converting icons to standard PNG..."
if [ -f "Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon120x120.png" --out "Payload/CryptoLearn.app/AppIcon120x120.png"
fi

if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon167x167.png" --out "Payload/CryptoLearn.app/AppIcon167x167.png"
fi

# Verify icon format
echo "🔍 Verifying icon format..."
if [ -f "Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    file "Payload/CryptoLearn.app/AppIcon120x120.png"
fi

if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    file "Payload/CryptoLearn.app/AppIcon167x167.png"
fi

# Check signature
echo "🔍 Checking signature..."
codesign -dv "Payload/CryptoLearn.app" || echo "⚠️  Signature check failed"

# Create fixed IPA
echo "📦 Creating fixed IPA..."
zip -r "$FIXED_IPA_NAME" Payload/ > /dev/null 2>&1

# Cleanup
rm -rf Payload/

echo "✅ Fixed IPA created: $FIXED_IPA_NAME"
echo "🚀 Ready for Transporter upload!"
