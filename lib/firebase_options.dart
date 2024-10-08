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
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCbB0bgJ5NRywREtQThSfHhWlZjAYHFHmc',
    appId: '1:1066127325416:web:95e6d1d4bb7aa4602df15d',
    messagingSenderId: '1066127325416',
    projectId: 'car-pooling-d243a',
    authDomain: 'car-pooling-d243a.firebaseapp.com',
    storageBucket: 'car-pooling-d243a.appspot.com',
    measurementId: 'G-TW5MQ0M5ZV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAosjwejcbUCaNUO83YPmGfRIMrWgZSP0k',
    appId: '1:1066127325416:android:7d113d825b0ba3492df15d',
    messagingSenderId: '1066127325416',
    projectId: 'car-pooling-d243a',
    storageBucket: 'car-pooling-d243a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBEXy9JrZvxvjMtjS-77nKTD_QATEiovHs',
    appId: '1:1066127325416:ios:986e704cc74452a72df15d',
    messagingSenderId: '1066127325416',
    projectId: 'car-pooling-d243a',
    storageBucket: 'car-pooling-d243a.appspot.com',
    iosBundleId: 'com.example.driverDemo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBEXy9JrZvxvjMtjS-77nKTD_QATEiovHs',
    appId: '1:1066127325416:ios:2b4d4b68048a3b4c2df15d',
    messagingSenderId: '1066127325416',
    projectId: 'car-pooling-d243a',
    storageBucket: 'car-pooling-d243a.appspot.com',
    iosBundleId: 'com.example.driverDemo.RunnerTests',
  );
}
