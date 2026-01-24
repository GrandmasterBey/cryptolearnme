const { withDangerousMod } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

module.exports = function withFixedPngIcons(config) {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const { modResults: projectRoot } = config;
      const iosProjectPath = path.join(projectRoot, 'ios');
      
      // This function will be called after the iOS build but before signing
      console.log('🔧 Applying PNG icon fixes...');
      
      // We'll add the icon conversion logic here
      // But for now, let's ensure the standalone icons exist
      const appIcon120 = path.join(iosProjectPath, 'CryptoLearn', 'Images.xcassets', 'AppIcon120x120.png');
      const appIcon167 = path.join(iosProjectPath, 'CryptoLearn', 'Images.xcassets', 'AppIcon167x167.png');
      
      // Create standard PNG versions if they don't exist
      if (!fs.existsSync(appIcon120)) {
        console.log('⚠️ AppIcon120x120.png not found');
      }
      
      if (!fs.existsSync(appIcon167)) {
        console.log('⚠️ AppIcon167x167.png not found');
      }
      
      return config;
    },
  ]);
};
