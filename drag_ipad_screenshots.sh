#!/bin/bash

echo "📱 Resizing iPad 13 Screenshots for App Store"
echo "=========================================="
echo ""

# Create output directory
mkdir -p ipad_screenshots

# Process each file dragged onto the script
for file in "$@"; do
    if [[ -f "$file" ]]; then
        # Get filename without extension
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        
        echo "Processing: $filename"
        
        # Resize to iPad 13" dimensions
        sips -z 2732 2048 "$file" --out "ipad_screenshots/${filename_no_ext}_portrait.png"
        
        # Also create landscape version
        sips -z 2048 2732 "$file" --out "ipad_screenshots/${filename_no_ext}_landscape.png"
        
        echo "✓ Created resized versions in ipad_screenshots/"
        echo ""
    else
        echo "⚠️  File not found: $file"
    fi
done

echo "✅ All iPad screenshots resized and ready for App Store!"
echo "📁 Location: ipad_screenshots/"
echo ""
echo "📋 Resized iPad screenshots:"
ls -la ipad_screenshots/
