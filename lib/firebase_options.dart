// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnlHlEsBHGokAzgmY3Pg-RJWpceSBflj4',
    appId: '1:1013934756717:web:fe1f6ae14b839813f30064',
    messagingSenderId: '1013934756717',
    projectId: 'presence-3e0ff',
    authDomain: 'presence-3e0ff.firebaseapp.com',
    storageBucket: 'presence-3e0ff.appspot.com',
    measurementId: 'G-QLPETPP39P',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBGYHdMK82gBqSAvGi0B0pLFeifJUfaqLw',
    appId: '1:1013934756717:android:76b7203690ef289ff30064',
    messagingSenderId: '1013934756717',
    projectId: 'presence-3e0ff',
    storageBucket: 'presence-3e0ff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAf9yr2WseQtnMJY0lsz9rQv69OlJpnCso',
    appId: '1:1013934756717:ios:e66c4532424ed8f5f30064',
    messagingSenderId: '1013934756717',
    projectId: 'presence-3e0ff',
    storageBucket: 'presence-3e0ff.appspot.com',
    iosClientId:
        '1013934756717-9gdmvojpb496bkre5jrgu7ifjm5kc9c4.apps.googleusercontent.com',
    iosBundleId: 'com.presence',
  );
}
