const { withDangerousMod } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

module.exports = function fixIcons(config) {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const iosProjectPath = path.join(config.modRequest.projectRoot, 'ios');
      const appDelegatePath = path.join(iosProjectPath, 'CryptoLearn', 'AppDelegate.mm');
      
      // Add a build phase script to copy standard PNG icons
      const buildScript = `
# Copy standard PNG icons to app bundle
echo "🎨 Copying standard PNG icons..."
if [ -f "$PROJECT_DIR/../assets/icons/AppIcon120x120.png" ]; then
    cp "$PROJECT_DIR/../assets/icons/AppIcon120x120.png" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/AppIcon120x120.png"
fi
if [ -f "$PROJECT_DIR/../assets/icons/AppIcon167x167.png" ]; then
    cp "$PROJECT_DIR/../assets/icons/AppIcon167x167.png" "$BUILT_PRODUCTS_DIR/$CONTENTS_FOLDER_PATH/AppIcon167x167.png"
fi
echo "✅ Standard PNG icons copied"
`;

      // Write the build script to a file
      fs.writeFileSync(path.join(iosProjectPath, 'copy-icons.sh'), buildScript);
      
      return config;
    },
  ]);
};
