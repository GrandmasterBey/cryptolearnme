#!/bin/bash

echo "📱 CryptoLearn Screenshot Capture Tool"
echo "===================================="
echo ""
echo "This will help you capture and resize screenshots for App Store"
echo ""

# Create directories
mkdir -p original_screenshots
mkdir -p final_screenshots

echo "📸 Step 1: Take screenshots of your app"
echo "----------------------------------------"
echo "1. Run your app: npx expo start --ios"
echo "2. Navigate to different screens in the app"
echo "3. Take screenshots using Cmd+Shift+4"
echo "4. Save them to the 'original_screenshots' folder"
echo ""
echo "Press Enter when you're ready to resize..."
read

echo ""
echo "🔧 Step 2: Resizing screenshots..."
echo "-----------------------------------"

# Process all screenshots in original_screenshots folder
if [ "$(ls -A original_screenshots/)" ]; then
    for file in original_screenshots/*.png original_screenshots/*.jpg original_screenshots/*.jpeg; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            filename_no_ext="${filename%.*}"
            
            echo "Processing: $filename"
            
            # Resize to iPhone 16 Pro dimensions
            sips -z 2688 1242 "$file" --out "final_screenshots/${filename_no_ext}_portrait.png"
            sips -z 1242 2688 "$file" --out "final_screenshots/${filename_no_ext}_landscape.png"
            
            echo "✓ Created portrait and landscape versions"
        fi
    done
    
    echo ""
    echo "✅ All screenshots ready for App Store!"
    echo "📁 Location: final_screenshots/"
    echo ""
    echo "📋 Screenshots created:"
    ls -la final_screenshots/
else
    echo "❌ No screenshots found in 'original_screenshots' folder"
    echo "Please add your screenshots to that folder first"
fi
