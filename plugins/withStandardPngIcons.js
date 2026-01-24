const { withDangerousMod } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

module.exports = function withStandardPngIcons(config) {
  return withDangerousMod(config, [
    'ios',
    (config) => {
      const { projectRoot } = config.modRequest;
      
      // Find and convert CgBI icons to standard PNG before signing
      const iosProjectPath = path.join(projectRoot, 'ios');
      const appIcon120Path = path.join(iosProjectPath, 'CryptoLearn', 'AppIcon120x120.png');
      const appIcon167Path = path.join(iosProjectPath, 'CryptoLearn', 'AppIcon167x167.png');
      
      console.log('🔧 Converting CgBI icons to standard PNG before signing...');
      
      // Convert 120x120 icon if it exists
      if (fs.existsSync(appIcon120Path)) {
        console.log('🔄 Converting AppIcon120x120.png');
        const { execSync } = require('child_process');
        try {
          execSync(`sips -s format png "${appIcon120Path}" --out "${appIcon120Path}.tmp"`, { stdio: 'inherit' });
          fs.renameSync(`${appIcon120Path}.tmp`, appIcon120Path);
          console.log('✅ AppIcon120x120.png converted');
        } catch (error) {
          console.log('⚠️ Could not convert AppIcon120x120.png:', error.message);
        }
      }
      
      // Convert 167x167 icon if it exists  
      if (fs.existsSync(appIcon167Path)) {
        console.log('🔄 Converting AppIcon167x167.png');
        const { execSync } = require('child_process');
        try {
          execSync(`sips -s format png "${appIcon167Path}" --out "${appIcon167Path}.tmp"`, { stdio: 'inherit' });
          fs.renameSync(`${appIcon167Path}.tmp`, appIcon167Path);
          console.log('✅ AppIcon167x167.png converted');
        } catch (error) {
          console.log('⚠️ Could not convert AppIcon167x167.png:', error.message);
        }
      }
      
      console.log('✅ Icon conversion complete!');
      
      return config;
    }
  ]);
};
