#!/bin/bash

# Script to sign the unsigned IPA from GitHub Actions
# Run this locally after downloading the artifacts

set -e

IPA_NAME="CryptoLearn_Unsigned.ipa"
SIGNED_IPA_NAME="CryptoLearn_Signed.ipa"
APP_BUNDLE_DIR="Payload/CryptoLearn.app"

echo "🔧 Signing iOS IPA locally..."

# Check if IPA exists
if [ ! -f "$IPA_NAME" ]; then
    echo "❌ Error: $IPA_NAME not found"
    echo "Please download the ios-ipa-unsigned artifact from GitHub Actions first"
    exit 1
fi

# Extract IPA
echo "📦 Extracting IPA..."
unzip -q "$IPA_NAME"

# Check if app bundle exists
if [ ! -d "$APP_BUNDLE_DIR" ]; then
    echo "❌ Error: App bundle not found in IPA"
    exit 1
fi

# Sign the app bundle
echo "✍️ Signing app bundle..."
codesign --force --sign "Apple Development: Corey Drew (QDQF5R4TM5)" "$APP_BUNDLE_DIR"

# Verify signature
echo "🔍 Verifying signature..."
codesign -dv "$APP_BUNDLE_DIR"

# Create signed IPA
echo "📦 Creating signed IPA..."
zip -r "$SIGNED_IPA_NAME" Payload/ > /dev/null 2>&1

# Cleanup
rm -rf Payload/

echo "✅ Signed IPA created: $SIGNED_IPA_NAME"
echo "🚀 Ready for Transporter upload!"
