#!/bin/bash

# Create screenshots directory
mkdir -p screenshots

echo "Taking screenshots for CryptoLearn app..."
echo "Make sure the app is running in the simulator"
echo ""

# Function to take and resize screenshot
take_screenshot() {
    local name=$1
    local width=$2
    local height=$3
    
    echo "Taking screenshot: $name (${width}x${height})"
    # Take screenshot (you'll need to manually select the simulator)
    screencapture -i "screenshots/${name}_original.png"
    
    # Resize to correct dimensions
    if [ -f "screenshots/${name}_original.png" ]; then
        sips -z $height $width "screenshots/${name}_original.png" --out "screenshots/${name}.png"
        echo "✓ Created: screenshots/${name}.png"
    else
        echo "✗ Screenshot not taken"
    fi
}

# iPhone 16 Pro screenshots
echo "iPhone 16 Pro screenshots (1242x2688):"
take_screenshot "iphone_01_home" 1242 2688
take_screenshot "iphone_02_login" 1242 2688
take_screenshot "iphone_03_dashboard" 1242 2688
take_screenshot "iphone_04_lessons" 1242 2688
take_screenshot "iphone_05_profile" 1242 2688
take_screenshot "iphone_06_settings" 1242 2688

echo ""
echo "Done! Check the screenshots folder."
