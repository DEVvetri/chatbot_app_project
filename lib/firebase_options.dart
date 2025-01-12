// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQIR6nTw-7rl56iOlE1qvh11esNvNlYJc',
    appId: '1:147179434328:web:baaec33cceaf6643ce352d',
    messagingSenderId: '147179434328',
    projectId: 'chatbot-project-96d8a',
    authDomain: 'chatbot-project-96d8a.firebaseapp.com',
    storageBucket: 'chatbot-project-96d8a.firebasestorage.app',
    measurementId: 'G-HMRYS5WW8L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBTWZNPoU6i3e-m9p2EIbSK0IecH_LMChQ',
    appId: '1:147179434328:android:a27b320a9031e9e0ce352d',
    messagingSenderId: '147179434328',
    projectId: 'chatbot-project-96d8a',
    storageBucket: 'chatbot-project-96d8a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDT5ouXxiBJkYfssr7d4hvQgP_nv5ud5jk',
    appId: '1:147179434328:ios:2704fe66e9335e8fce352d',
    messagingSenderId: '147179434328',
    projectId: 'chatbot-project-96d8a',
    storageBucket: 'chatbot-project-96d8a.firebasestorage.app',
    iosBundleId: 'com.example.chatbotAppProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDT5ouXxiBJkYfssr7d4hvQgP_nv5ud5jk',
    appId: '1:147179434328:ios:2704fe66e9335e8fce352d',
    messagingSenderId: '147179434328',
    projectId: 'chatbot-project-96d8a',
    storageBucket: 'chatbot-project-96d8a.firebasestorage.app',
    iosBundleId: 'com.example.chatbotAppProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAQIR6nTw-7rl56iOlE1qvh11esNvNlYJc',
    appId: '1:147179434328:web:b9121903b4d6f3b5ce352d',
    messagingSenderId: '147179434328',
    projectId: 'chatbot-project-96d8a',
    authDomain: 'chatbot-project-96d8a.firebaseapp.com',
    storageBucket: 'chatbot-project-96d8a.firebasestorage.app',
    measurementId: 'G-LKCR79KD3S',
  );
}
