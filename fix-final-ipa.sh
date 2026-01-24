#!/bin/bash

echo "🔧 Converting CgBI icons to standard PNG (preserving signature)..."

# Extract IPA
unzip -q "$1" -d temp_fix_final

# Convert CgBI icons to standard PNG in-place
if [ -f "temp_fix_final/Payload/CryptoLearn.app/AppIcon120x120.png" ]; then
    echo "🔄 Converting AppIcon120x120.png..."
    sips -s format png temp_fix_final/Payload/CryptoLearn.app/AppIcon120x120.png --out temp_fix_final/Payload/CryptoLearn.app/AppIcon120x120.png.tmp
    mv temp_fix_final/Payload/CryptoLearn.app/AppIcon120x120.png.tmp temp_fix_final/Payload/CryptoLearn.app/AppIcon120x120.png
fi

if [ -f "temp_fix_final/Payload/CryptoLearn.app/AppIcon167x167.png" ]; then
    echo "🔄 Converting AppIcon167x167.png..."
    sips -s format png temp_fix_final/Payload/CryptoLearn.app/AppIcon167x167.png --out temp_fix_final/Payload/CryptoLearn.app/AppIcon167x167.png.tmp
    mv temp_fix_final/Payload/CryptoLearn.app/AppIcon167x167.png.tmp temp_fix_final/Payload/CryptoLearn.app/AppIcon167x167.png
fi

# Re-create IPA preserving signature structure
cd temp_fix_final
zip -r ../"$(basename "$1" .ipa)_FINAL.ipa" Payload/ _CodeSignature/ SwiftSupport/ > /dev/null 2>&1
cd ..

# Clean up
rm -rf temp_fix_final

echo "✅ Final IPA created: $(basename "$1" .ipa)_FINAL.ipa"

# Verify icon format
echo "🔍 Verifying icon format..."
unzip -p "$(basename "$1" .ipa)_FINAL.ipa" "Payload/CryptoLearn.app/AppIcon120x120.png" | file -
unzip -p "$(basename "$1" .ipa)_FINAL.ipa" "Payload/CryptoLearn.app/AppIcon167x167.png" | file -

# Verify signature
echo "🔍 Verifying signature..."
unzip -q "$(basename "$1" .ipa)_FINAL.ipa"
codesign -dv Payload/CryptoLearn.app
rm -rf Payload

echo "🚀 Ready for Transporter upload!"
