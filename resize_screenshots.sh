#!/bin/bash

echo "Resizing all screenshots to iPhone 16 Pro dimensions (1242x2688)..."

# Resize all PNG files in screenshots folder
for file in screenshots/*.png; do
    if [ -f "$file" ]; then
        echo "Processing: $file"
        # Get filename without extension
        filename=$(basename "$file" .png)
        
        # Skip if already resized
        if [[ "$filename" == *"_resized" ]]; then
            echo "Skipping already resized file: $file"
            continue
        fi
        
        # Resize to 1242x2688 (portrait for iPhone 16 Pro)
        sips -z 2688 1242 "$file" --out "screenshots/${filename}_resized.png"
        echo "✓ Created: screenshots/${filename}_resized.png"
    fi
done

echo ""
echo "Done! Resized screenshots are ready for App Store."
