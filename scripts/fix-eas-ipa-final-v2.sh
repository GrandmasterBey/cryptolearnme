#!/bin/bash

set -e

SOURCE_IPA="CryptoLearn_EAS_STANDARD_PNG.ipa"
FIXED_IPA="CryptoLearn_EAS_FINAL_FIXED.ipa"

echo "🎯 Fixing EAS IPA with standard PNG icons while preserving signature..."

# Clean up
rm -rf Payload
rm -f "$FIXED_IPA"

echo "📦 Extracting EAS IPA..."
unzip -q "$SOURCE_IPA"

echo "🎨 Converting icons to standard PNG format..."
# Backup original icons
cp Payload/CryptoLearn.app/AppIcon120x120.png Payload/CryptoLearn.app/AppIcon120x120.png.backup
cp Payload/CryptoLearn.app/AppIcon167x167.png Payload/CryptoLearn.app/AppIcon167x167.png.backup

# Convert icons to standard PNG
sips -s format png Payload/CryptoLearn.app/AppIcon120x120.png --out Payload/CryptoLearn.app/AppIcon120x120.png
sips -s format png Payload/CryptoLearn.app/AppIcon167x167.png --out Payload/CryptoLearn.app/AppIcon167x167.png

echo "🔍 Verifying icon formats..."
file Payload/CryptoLearn.app/AppIcon120x120.png
file Payload/CryptoLearn.app/AppIcon167x167.png

echo "📦 Re-packaging IPA (preserving original signature)..."
zip -r "$FIXED_IPA" Payload/

echo "🧹 Cleaning up..."
rm -rf Payload

echo "✅ Fixed IPA created: $FIXED_IPA"
echo "🚀 Ready for Transporter upload!"
