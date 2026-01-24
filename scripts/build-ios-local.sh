#!/bin/bash

# Script to build iOS app locally with Xcode
# This bypasses GitHub Actions signing issues

set -e

echo "🔧 Building iOS app locally..."

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the project root"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install
npx expo install

# Setup iOS
echo "🍎 Setting up iOS..."
cd ios
pod install

# Create standalone PNG icons
echo "🎨 Creating standalone PNG icons..."
cd ..
sips -z 120 120 assets/icon.png --out ios/CryptoLearn/AppIcon120x120.png
sips -z 167 167 assets/icon.png --out ios/CryptoLearn/AppIcon167x167.png

# Verify icon format
echo "🔍 Verifying icon format..."
file ios/CryptoLearn/AppIcon120x120.png
file ios/CryptoLearn/AppIcon167x167.png

# Build iOS app (no signing for now)
echo "🔨 Building iOS app..."
cd ios
xcodebuild -workspace CryptoLearn.xcworkspace \
  -scheme CryptoLearn \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath build/CryptoLearn.xcarchive \
  CODE_SIGNING_ALLOWED=NO \
  archive

# Create IPA manually
echo "📦 Creating IPA manually..."
mkdir -p build/Payload
cp -r build/CryptoLearn.xcarchive/Products/Applications/CryptoLearn.app build/Payload/

# Copy standalone icons to app bundle
cp CryptoLearn/AppIcon120x120.png build/Payload/CryptoLearn.app/
cp CryptoLearn/AppIcon167x167.png build/Payload/CryptoLearn.app/

# Create unsigned IPA
cd build
zip -r CryptoLearn_Unsigned.ipa Payload/ > /dev/null 2>&1

# Verify IPA contents
echo "🔍 Verifying IPA contents..."
echo "Checking 120x120 icon:"
unzip -p CryptoLearn_Unsigned.ipa "Payload/CryptoLearn.app/AppIcon120x120.png" | file -

echo "Checking 167x167 icon:"
unzip -p CryptoLearn_Unsigned.ipa "Payload/CryptoLearn.app/AppIcon167x167.png" | file -

cd ../..
echo "✅ Unsigned IPA created: ios/build/CryptoLearn_Unsigned.ipa"
echo "🚀 Ready for local signing!"
