import React, { useState, useEffect, useRef } from 'react';
import { WebView, View, Text, TouchableOpacity, StyleSheet, Alert, ActivityIndicator } from 'react-native';
import { StatusBar } from 'expo-status-bar';

export default function App() {
  const [canGoBack, setCanGoBack] = useState(false);
  const [canGoForward, setCanGoForward] = useState(false);
  const [loading, setLoading] = useState(true);
  const webViewRef = useRef(null);

  const handleBack = () => {
    if (webViewRef.current && canGoBack) {
      webViewRef.current.goBack();
    }
  };

  const handleForward = () => {
    if (webViewRef.current && canGoForward) {
      webViewRef.current.goForward();
    }
  };

  const handleRefresh = () => {
    if (webViewRef.current) {
      webViewRef.current.reload();
    }
  };

  const showNavigationAlert = () => {
    Alert.alert(
      'Navigation Help',
      'Use the navigation buttons above to browse the CryptoLearn website. You can also swipe left/right to go back/forward.',
      [{ text: 'Got it!' }]
    );
  };

  return (
    <View style={styles.container}>
      <StatusBar style="light" />
      <View style={styles.header}>
        <TouchableOpacity 
          style={[styles.navButton, !canGoBack && styles.disabledButton]} 
          onPress={handleBack}
          disabled={!canGoBack}
        >
          <Text style={styles.navButtonText}>←</Text>
        </TouchableOpacity>
        
        <TouchableOpacity style={styles.refreshButton} onPress={handleRefresh}>
          <Text style={styles.navButtonText}>↻</Text>
        </TouchableOpacity>
        
        <TouchableOpacity 
          style={[styles.navButton, !canGoForward && styles.disabledButton]} 
          onPress={handleForward}
          disabled={!canGoForward}
        >
          <Text style={styles.navButtonText}>→</Text>
        </TouchableOpacity>
        
        <TouchableOpacity style={styles.helpButton} onPress={showNavigationAlert}>
          <Text style={styles.helpButtonText}>?</Text>
        </TouchableOpacity>
      </View>
      
      <WebView
        ref={webViewRef}
        source={{ uri: 'https://cryptolearn.me' }}
        style={styles.webView}
        allowsInlineMediaPlayback={true}
        mediaPlaybackRequiresUserAction={false}
        allowsFullscreenVideo={true}
        javaScriptEnabled={true}
        domStorageEnabled={true}
        startInLoadingState={true}
        scalesPageToFit={true}
        showsHorizontalScrollIndicator={false}
        showsVerticalScrollIndicator={false}
        onLoadStart={() => setLoading(true)}
        onLoadEnd={() => setLoading(false)}
        onNavigationStateChange={(navState) => {
          setCanGoBack(navState.canGoBack);
          setCanGoForward(navState.canGoForward);
        }}
      />
      
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#4A90E2" />
          <Text style={styles.loadingText}>Loading CryptoLearn...</Text>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#000',
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 10,
    paddingTop: 50,
    paddingBottom: 10,
    backgroundColor: '#1a1a1a',
    borderBottomWidth: 1,
    borderBottomColor: '#333',
  },
  navButton: {
    padding: 10,
    minWidth: 50,
    alignItems: 'center',
    backgroundColor: '#4A90E2',
    borderRadius: 5,
  },
  disabledButton: {
    backgroundColor: '#333',
  },
  refreshButton: {
    padding: 10,
    minWidth: 50,
    alignItems: 'center',
    backgroundColor: '#4A90E2',
    borderRadius: 5,
  },
  helpButton: {
    padding: 10,
    minWidth: 50,
    alignItems: 'center',
    backgroundColor: '#FFD700',
    borderRadius: 5,
  },
  navButtonText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  helpButtonText: {
    color: '#000',
    fontSize: 18,
    fontWeight: 'bold',
  },
  webView: {
    flex: 1,
  },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.8)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    color: '#4A90E2',
    marginTop: 10,
    fontSize: 16,
  },
});