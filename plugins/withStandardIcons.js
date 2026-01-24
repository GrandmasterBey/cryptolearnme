const { withAppBuildGradle } = require('@expo/config-plugins');
const fs = require('fs');
const path = require('path');

module.exports = function withStandardIcons(config) {
  return withAppBuildGradle(config, (config) => {
    // This plugin will be processed during EAS build
    // We'll add a script to copy standard PNG icons to the app bundle
    return config;
  });
};

// Alternative approach: Use a custom plugin that modifies the iOS build
const withIOSStandardIcons = (config) => {
  return {
    ...config,
    // Add post-build hook to copy standard PNG icons
    hooks: {
      postExport: async (ctx) => {
        console.log('🎨 Adding standard PNG icons to iOS build...');
        
        const iosPath = path.join(ctx.projectPath, 'ios');
        const icon120Path = path.join(ctx.projectPath, 'assets/icons/AppIcon120x120.png');
        const icon167Path = path.join(ctx.projectPath, 'assets/icons/AppIcon167x167.png');
        
        if (fs.existsSync(icon120Path) && fs.existsSync(icon167Path)) {
          // Copy icons to the build directory
          const buildPath = path.join(iosPath, 'build');
          if (fs.existsSync(buildPath)) {
            fs.copyFileSync(icon120Path, path.join(buildPath, 'AppIcon120x120.png'));
            fs.copyFileSync(icon167Path, path.join(buildPath, 'AppIcon167x167.png'));
            console.log('✅ Standard PNG icons added to build');
          }
        }
      },
    },
  };
};

module.exports = withIOSStandardIcons;
