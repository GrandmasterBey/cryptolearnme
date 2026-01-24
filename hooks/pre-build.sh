#!/bin/bash

# This script runs during EAS build before signing
# It converts CgBI icons to standard PNG format

echo "🔧 Pre-build icon fix running..."

# Find and convert CgBI icons to standard PNG
find . -name "AppIcon*.png" -type f | while read icon; do
    if file "$icon" | grep -q "CgBI"; then
        echo "🔄 Converting $icon from CgBI to standard PNG"
        sips -s format png "$icon" --out "$icon.tmp"
        mv "$icon.tmp" "$icon"
    fi
done

echo "✅ Pre-build icon fix complete"
