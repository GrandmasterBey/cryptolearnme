#!/bin/bash

echo "📱 Resizing Desktop Screenshots for App Store"
echo "=========================================="
echo ""

# Create output directory
mkdir -p final_screenshots

# Process each file dragged onto the script
for file in "$@"; do
    if [[ -f "$file" ]]; then
        # Get filename without extension
        filename=$(basename "$file")
        filename_no_ext="${filename%.*}"
        
        echo "Processing: $filename"
        
        # Resize to iPhone 16 Pro dimensions
        sips -z 2688 1242 "$file" --out "final_screenshots/${filename_no_ext}_portrait.png"
        
        # Also create landscape version
        sips -z 1242 2688 "$file" --out "final_screenshots/${filename_no_ext}_landscape.png"
        
        echo "✓ Created resized versions in final_screenshots/"
        echo ""
    else
        echo "⚠️  File not found: $file"
    fi
done

echo "✅ All screenshots resized and ready for App Store!"
echo "📁 Location: final_screenshots/"
echo ""
echo "📋 Resized screenshots:"
ls -la final_screenshots/
