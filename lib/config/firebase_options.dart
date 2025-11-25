// FILE: lib/config/firebase_options.dart
// Flutter Firebase configuration for all platforms

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ✅ WEB CONFIGURATION
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAZqcGWDr27Gbp7pKlBYJdyu9G1SMW5RtI',
    appId: '1:198196824870:web:a3b8dec294b53a3f40cfe7',
    messagingSenderId: '198196824870',
    projectId: 'esneaker-75905',
    authDomain: 'esneaker-75905.firebaseapp.com',
    storageBucket: 'esneaker-75905.firebasestorage.app',
    measurementId: 'G-TQ6VRT3W3Z',
  );

  // ✅ ANDROID CONFIGURATION (From your google-services.json)
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDWChtAHckZdVUU0CWft9yyE7rk5DsR9jE',
    appId: '1:198196824870:android:fe2149df9a945d4140cfe7',
    messagingSenderId: '198196824870',
    projectId: 'esneaker-75905',
    storageBucket: 'esneaker-75905.firebasestorage.app',
  );

  // iOS Configuration (if you add iOS later)
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZqcGWDr27Gbp7pKlBYJdyu9G1SMW5RtI',
    appId: '1:198196824870:ios:placeholder',
    messagingSenderId: '198196824870',
    projectId: 'esneaker-75905',
    storageBucket: 'esneaker-75905.firebasestorage.app',
    iosBundleId: 'com.example.e_sneakers',
  );
}
