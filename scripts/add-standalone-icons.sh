#!/bin/bash

echo "🔧 Adding standalone icons for App Store submission..."

# Create standard PNG icons if they don't exist
if [ ! -f "AppIcon120x120.png" ]; then
    echo "📱 Creating AppIcon120x120.png..."
    sips -z 120 120 assets/icon.png --out AppIcon120x120.png
fi

if [ ! -f "AppIcon167x167.png" ]; then
    echo "📱 Creating AppIcon167x167.png..."  
    sips -z 167 167 assets/icon.png --out AppIcon167x167.png
fi

# Copy to iOS project root so they're included in the bundle
cp AppIcon120x120.png ios/CryptoLearn/
cp AppIcon167x167.png ios/CryptoLearn/

echo "✅ Standalone icons added successfully!"
