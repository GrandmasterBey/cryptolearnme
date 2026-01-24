#!/bin/bash

# Build with EAS using our working icon solution
# EAS handles App Store provisioning automatically

set -e

echo "🔧 Building with EAS (App Store provisioning included)..."

# Create standalone PNG icons first
echo "🎨 Creating standalone PNG icons..."
sips -z 120 120 assets/icon.png --out ios/CryptoLearn/AppIcon120x120.png
sips -z 167 167 assets/icon.png --out ios/CryptoLearn/AppIcon167x167.png

# Verify icon format
echo "🔍 Verifying icon format..."
file ios/CryptoLearn/AppIcon120x120.png
file ios/CryptoLearn/AppIcon167x167.png

# Build with EAS
echo "🔨 Building with EAS..."
eas build --platform ios --profile production

echo "✅ EAS build complete!"
echo "📱 Download IPA from EAS dashboard"
echo "🚀 Icons should be in standard PNG format"
