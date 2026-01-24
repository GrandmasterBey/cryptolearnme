#!/bin/bash

set -e

echo "🎯 Creating FINAL properly signed IPA with standard PNG icons..."

# Configuration
SOURCE_IPA="CryptoLearn_EAS_LATEST.ipa"
FINAL_IPA="CryptoLearn_FINAL_FIXED.ipa"
BUNDLE_ID="com.cryptolearn.app"
TEAM_ID="M9QP95G3R6"

# Clean up previous attempts
rm -rf Payload
rm -f "$FINAL_IPA"

echo "📦 Extracting original EAS IPA..."
unzip -q "$SOURCE_IPA"

echo "🗑️ Removing existing signature..."
codesign --remove-signature Payload/CryptoLearn.app

echo "🎨 Converting icons to standard PNG format..."
# Convert icons from CgBI to standard PNG
if [ -f "Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    echo "Converting AppIcon120x120.png..."
    sips -s format png Payload/CryptoLearn.app/AppIcon120x120.png --out Payload/CryptoLearn.app/AppIcon120x120.png
fi

if [ -f "Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    echo "Converting AppIcon167x167.png..."
    sips -s format png Payload/CryptoLearn.app/AppIcon167x167.png --out Payload/CryptoLearn.app/AppIcon167x167.png
fi

echo "🔍 Verifying icon formats..."
file Payload/CryptoLearn.app/AppIcon120x120.png
file Payload/CryptoLearn.app/AppIcon167x167.png

echo "✍️ Re-signing with Apple Development certificate..."
# Find Apple Development certificate (since we don't have Distribution)
DEV_CERT=$(security find-identity -v -p codesigning | grep "Apple Development" | head -1 | awk -F'"' '{print $2}')

if [ -z "$DEV_CERT" ]; then
    echo "❌ No Apple Development certificate found!"
    echo "Available certificates:"
    security find-identity -v -p codesigning
    exit 1
fi

echo "Using certificate: $DEV_CERT"

# Re-sign the app with proper entitlements
codesign --force --sign "$DEV_CERT" --entitlements entitlements.plist Payload/CryptoLearn.app

echo "🔍 Verifying signature..."
codesign -dv Payload/CryptoLearn.app

echo "📦 Creating final IPA..."
zip -r "$FINAL_IPA" Payload/

echo "🧹 Cleaning up..."
rm -rf Payload

echo "✅ Final IPA created: $FINAL_IPA"
echo "🚀 Ready for Transporter upload!"
