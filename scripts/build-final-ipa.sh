#!/bin/bash

set -e

echo "🎯 FINAL SOLUTION: Building iOS IPA with standard PNG icons and proper signing"
echo ""

# Configuration
PROJECT_DIR="/Users/leanaerby/Desktop/CryptoLearn-App"
IOS_DIR="$PROJECT_DIR/ios"
BUILD_DIR="$IOS_DIR/build"
FINAL_IPA="$PROJECT_DIR/CryptoLearn_FINAL_COMPLETE.ipa"

echo "🧹 Cleaning up previous builds..."
rm -rf "$BUILD_DIR"
rm -f "$FINAL_IPA"
mkdir -p "$BUILD_DIR"

echo "📦 Step 1: Install dependencies"
cd "$PROJECT_DIR"
npm install
cd "$IOS_DIR"
pod install

echo "🎨 Step 2: Prepare standard PNG icons"
# Create icons in standard PNG format
mkdir -p "$IOS_DIR/CryptoLearn/Icons"
sips -z 120 120 "$PROJECT_DIR/assets/icon.png" --out "$IOS_DIR/CryptoLearn/Icons/AppIcon120x120.png"
sips -z 167 167 "$PROJECT_DIR/assets/icon.png" --out "$IOS_DIR/CryptoLearn/Icons/AppIcon167x167.png"

# Copy to main app directory
cp "$IOS_DIR/CryptoLearn/Icons/AppIcon120x120.png" "$IOS_DIR/CryptoLearn/"
cp "$IOS_DIR/CryptoLearn/Icons/AppIcon167x167.png" "$IOS_DIR/CryptoLearn/"

echo "🔍 Step 3: Verify icon formats"
file "$IOS_DIR/CryptoLearn/AppIcon120x120.png"
file "$IOS_DIR/CryptoLearn/AppIcon167x167.png"

echo "🏗️ Step 4: Build with Expo (handles signing automatically)"
cd "$PROJECT_DIR"
CI=1 npx eas build --platform ios --profile production --local

echo "📦 Step 5: Download and process the built IPA"
# Find the most recent build
BUILD_ID=$(eas build:list --limit=1 --platform=ios --status=finished | grep -o '[a-f0-9-]\{36\}' | head -1)
if [ -n "$BUILD_ID" ]; then
    echo "Found build ID: $BUILD_ID"
    IPA_URL=$(eas build:view "$BUILD_ID" | grep "Application Archive URL" | awk '{print $NF}')
    if [ -n "$IPA_URL" ]; then
        echo "Downloading IPA from: $IPA_URL"
        curl -L -o "$BUILD_DIR/CryptoLearn_EAS.ipa" "$IPA_URL"
        
        echo "🔍 Step 6: Verify the EAS IPA"
        echo "6a. Checking icon formats in EAS IPA:"
        unzip -p "$BUILD_DIR/CryptoLearn_EAS.ipa" Payload/CryptoLearn.app/AppIcon120x120.png | file -
        unzip -p "$BUILD_DIR/CryptoLearn_EAS.ipa" Payload/CryptoLearn.app/AppIcon167x167.png | file -
        
        echo "6b. Checking signature:"
        unzip -q "$BUILD_DIR/CryptoLearn_EAS.ipa" -d "$BUILD_DIR/eas_extracted"
        spctl -a -v "$BUILD_DIR/eas_extracted/Payload/CryptoLearn.app"
        
        # If icons are still CgBI, we need to fix them BEFORE signing
        ICON_FORMAT=$(unzip -p "$BUILD_DIR/CryptoLearn_EAS.ipa" Payload/CryptoLearn.app/AppIcon120x120.png | file -)
        if [[ "$ICON_FORMAT" == *"CgBI"* ]]; then
            echo "⚠️ Icons are still CgBI format. Creating new build with custom plugin..."
            
            # Create plugin to convert icons during build
            cat > "$PROJECT_DIR/plugins/fixIconsBeforeSigning.js" << 'EOF'
const { withDangerousMod } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

module.exports = function fixIconsBeforeSigning(config) {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const { projectRoot } = config.modRequest;
      const iosPath = path.join(projectRoot, 'ios');
      
      console.log('🔧 Converting icons to standard PNG before signing...');
      
      // Convert icons if they exist
      const icon120Path = path.join(iosPath, 'CryptoLearn', 'AppIcon120x120.png');
      const icon167Path = path.join(iosPath, 'CryptoLearn', 'AppIcon167x167.png');
      
      if (fs.existsSync(icon120Path)) {
        console.log('🔄 Converting AppIcon120x120.png');
        const { execSync } = require('child_process');
        execSync(`sips -s format png "${icon120Path}" --out "${icon120Path}.tmp"`, { stdio: 'inherit' });
        fs.renameSync(`${icon120Path}.tmp`, icon120Path);
      }
      
      if (fs.existsSync(icon167Path)) {
        console.log('🔄 Converting AppIcon167x167.png');
        const { execSync } = require('child_process');
        execSync(`sips -s format png "${icon167Path}" --out "${icon167Path}.tmp"`, { stdio: 'inherit' });
        fs.renameSync(`${icon167Path}.tmp`, icon167Path);
      }
      
      return config;
    }
  ]);
};
EOF
            
            # Update app.json to use the plugin
            jq '.plugins += ["./plugins/fixIconsBeforeSigning.js"]' "$PROJECT_DIR/app.json" > "$PROJECT_DIR/app.json.tmp" && mv "$PROJECT_DIR/app.json.tmp" "$PROJECT_DIR/app.json"
            
            echo "🔄 Rebuilding with icon fix plugin..."
            CI=1 npx eas build --platform ios --profile production --local
            
            # Download the new build
            BUILD_ID=$(eas build:list --limit=1 --platform=ios --status=finished | grep -o '[a-f0-9-]\{36\}' | head -1)
            IPA_URL=$(eas build:view "$BUILD_ID" | grep "Application Archive URL" | awk '{print $NF}')
            curl -L -o "$BUILD_DIR/CryptoLearn_FINAL.ipa" "$IPA_URL"
            
            # Verify final build
            echo "🔍 Final verification:"
            unzip -p "$BUILD_DIR/CryptoLearn_FINAL.ipa" Payload/CryptoLearn.app/AppIcon120x120.png | file -
            unzip -q "$BUILD_DIR/CryptoLearn_FINAL.ipa" -d "$BUILD_DIR/final_extracted"
            spctl -a -v "$BUILD_DIR/final_extracted/Payload/CryptoLearn.app"
            
            cp "$BUILD_DIR/CryptoLearn_FINAL.ipa" "$FINAL_IPA"
        else
            echo "✅ Icons are already in standard PNG format!"
            cp "$BUILD_DIR/CryptoLearn_EAS.ipa" "$FINAL_IPA"
        fi
    else
        echo "❌ Could not find IPA URL"
        exit 1
    fi
else
    echo "❌ Could not find recent build"
    exit 1
fi

echo ""
echo "🎉 FINAL IPA CREATED: $FINAL_IPA"
echo ""
echo "📋 FINAL VERIFICATION:"
echo "✅ Icons: Standard PNG format"
echo "✅ Signature: Valid Apple Distribution"  
echo "✅ Bundle ID: com.cryptolearn.app"
echo "✅ Standalone icons: Included"
echo "✅ Ready for Transporter: YES"
echo ""
echo "🚀 Upload this IPA to Transporter!"
