#!/bin/bash

set -e

echo "🎨 Preparing standard PNG icons for EAS build..."

# Create icons directory if it doesn't exist
mkdir -p assets/icons

# Convert existing icons to standard PNG format
if [ -f "assets/icon.png" ]; then
    echo "Converting main icon to standard PNG..."
    sips -s format png assets/icon.png --out assets/icons/AppIcon120x120.png
    sips -z 167 167 assets/icon.png --out assets/icons/AppIcon167x167.png
else
    echo "❌ assets/icon.png not found!"
    exit 1
fi

# Verify the formats
echo "🔍 Verifying icon formats..."
file assets/icons/AppIcon120x120.png
file assets/icons/AppIcon167x167.png

echo "✅ Standard PNG icons ready for EAS build!"
echo "🚀 Run: eas build --platform ios --profile production"
