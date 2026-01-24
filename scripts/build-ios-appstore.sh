#!/bin/bash

# Script to build iOS app with App Store signing
# This requires Apple Distribution certificate and provisioning profile

set -e

echo "🔧 Building iOS app for App Store submission..."

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

# Build iOS app with App Store signing
echo "🔨 Building iOS app for App Store..."
cd ios
xcodebuild -workspace CryptoLearn.xcworkspace \
  -scheme CryptoLearn \
  -configuration Release \
  -destination generic/platform=iOS \
  -archivePath build/CryptoLearn.xcarchive \
  -allowProvisioningUpdates \
  archive

# Export IPA with App Store provisioning
echo "📦 Exporting IPA for App Store..."
cat > build/ExportOptions.plist << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>method</key>
  <string>app-store</string>
  <key>teamID</key>
  <string>M9QP95G3R6</string>
  <key>uploadBitcode</key>
  <false/>
  <key>uploadSymbols</key>
  <true/>
  <key>signingStyle</key>
  <string>automatic</string>
</dict>
</plist>
EOF

xcodebuild -exportArchive \
  -archivePath build/CryptoLearn.xcarchive \
  -exportPath build \
  -exportOptionsPlist build/ExportOptions.plist

# Copy standalone icons to the exported IPA
echo "🔧 Adding standalone icons to IPA..."
cd build
unzip -q CryptoLearn.ipa -d extracted
cp ../CryptoLearn/AppIcon120x120.png extracted/Payload/CryptoLearn.app/
cp ../CryptoLearn/AppIcon167x167.png extracted/Payload/CryptoLearn.app/

# Re-create IPA with icons
cd extracted
zip -r ../CryptoLearn_AppStore.ipa Payload/ > /dev/null 2>&1
cd ..

# Verify final IPA
echo "🔍 Verifying final IPA..."
echo "Checking 120x120 icon:"
unzip -p CryptoLearn_AppStore.ipa "Payload/CryptoLearn.app/AppIcon120x120.png" | file -

echo "Checking 167x167 icon:"
unzip -p CryptoLearn_AppStore.ipa "Payload/CryptoLearn.app/AppIcon167x167.png" | file -

# Check for provisioning profile
echo "Checking for provisioning profile:"
unzip -p CryptoLearn_AppStore.ipa "Payload/CryptoLearn.app/embedded.mobileprovision" | file - || echo "No embedded.mobileprovision found"

cd ../..
echo "✅ App Store IPA created: ios/build/CryptoLearn_AppStore.ipa"
echo "🚀 Ready for Transporter upload!"
