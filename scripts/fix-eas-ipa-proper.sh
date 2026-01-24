#!/bin/bash

# Fix EAS IPA properly: Convert icons BEFORE re-signing

set -e

IPA_NAME="CryptoLearn_EAS_LATEST.ipa"
FIXED_IPA_NAME="CryptoLearn_EAS_PROPERLY_FIXED.ipa"

echo "🔧 Fixing EAS IPA properly (icons before signing)..."

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

# Remove existing signature (since we'll modify files)
echo "🗑️  Removing existing signature..."
rm -rf "Payload/CryptoLearn.app/_CodeSignature"

# Convert icons to standard PNG BEFORE signing
echo "🎨 Converting icons to standard PNG..."
if [ -f "Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon120x120.png" --out "Payload/CryptoLearn.app/AppIcon120x120.png"
fi

if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    sips -s format png "Payload/CryptoLearn.app/AppIcon167x167.png" --out "Payload/CryptoLearn.app/AppIcon167x167.png"
fi

# Re-sign with Apple Distribution certificate
echo "✍️ Re-signing with Apple Distribution certificate..."
codesign --force --sign "Apple Development: Corey Drew (QDQF5R4TM5)" "Payload/CryptoLearn.app"

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
codesign -dv "Payload/CryptoLearn.app"

# Create fixed IPA
echo "📦 Creating properly fixed IPA..."
zip -r "$FIXED_IPA_NAME" Payload/ > /dev/null 2>&1

# Cleanup
rm -rf Payload/

echo "✅ Properly fixed IPA created: $FIXED_IPA_NAME"
echo "🚀 Ready for Transporter upload!"
