import React, { useState, useRef } from 'react';
import { WebView, View, Text, TouchableOpacity, StyleSheet, Alert, ActivityIndicator, SafeAreaView } from 'react-native';
import { StatusBar } from 'expo-status-bar';

export default function App() {
  const [loading, setLoading] = useState(true);
  const webViewRef = useRef(null);

  const handleRefresh = () => {
    if (webViewRef.current) {
      webViewRef.current.reload();
    }
  };

  const showHelp = () => {
    Alert.alert(
      'CryptoLearn Help',
      'Welcome to CryptoLearn!\n\nThis app provides comprehensive cryptocurrency education.\n\nTap the refresh button to reload content.',
      [{ text: 'Got it!' }]
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar style="light" />
      <View style={styles.header}>
        <Text style={styles.title}>CryptoLearn</Text>
        <View style={styles.buttonContainer}>
          <TouchableOpacity style={styles.refreshButton} onPress={handleRefresh}>
            <Text style={styles.buttonText}>↻</Text>
          </TouchableOpacity>
          <TouchableOpacity style={styles.helpButton} onPress={showHelp}>
            <Text style={styles.buttonText}>?</Text>
          </TouchableOpacity>
        </View>
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
        onError={(error) => {
          console.log('WebView Error:', error);
          setLoading(false);
        }}
      />
      
      {loading && (
        <View style={styles.loadingOverlay}>
          <ActivityIndicator size="large" color="#4A90E2" />
          <Text style={styles.loadingText}>Loading CryptoLearn...</Text>
        </View>
      )}
    </SafeAreaView>
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
    paddingHorizontal: 15,
    paddingTop: 10,
    paddingBottom: 10,
    backgroundColor: '#1a1a1a',
    borderBottomWidth: 1,
    borderBottomColor: '#333',
  },
  title: {
    color: '#fff',
    fontSize: 20,
    fontWeight: 'bold',
  },
  buttonContainer: {
    flexDirection: 'row',
    gap: 10,
  },
  refreshButton: {
    padding: 8,
    backgroundColor: '#4A90E2',
    borderRadius: 5,
    minWidth: 40,
    alignItems: 'center',
  },
  helpButton: {
    padding: 8,
    backgroundColor: '#FFD700',
    borderRadius: 5,
    minWidth: 40,
    alignItems: 'center',
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
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