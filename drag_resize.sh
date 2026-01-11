#!/bin/bash

# Create output directory
mkdir -p resized_screenshots

echo "📱 Resizing screenshots for App Store (iPhone 16 Pro: 1242x2688)"
echo "Drag image files onto this script to resize them automatically"
echo ""

# Process each file dragged onto the script
for file in "$@"; do
    if [[ -f "$file" ]]; then
        # Get filename without extension
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        
        echo "Processing: $filename"
        
        # Resize to iPhone 16 Pro dimensions (portrait)
        sips -z 2688 1242 "$file" --out "resized_screenshots/${filename_no_ext}_iphone_portrait.png"
        
        # Also create landscape version
        sips -z 1242 2688 "$file" --out "resized_screenshots/${filename_no_ext}_iphone_landscape.png"
        
        echo "✓ Created resized versions in resized_screenshots/"
        echo ""
    else
        echo "⚠️  File not found: $file"
    fi
done

echo "✅ All screenshots resized and ready for App Store!"
echo "📁 Location: resized_screenshots/"
