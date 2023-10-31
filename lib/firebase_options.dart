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
    apiKey: 'AIzaSyDkcfJGniZroKe_ur8_ooXDKfTtumIsBX4',
    appId: '1:807533675316:web:46be1e658d7464e2609b61',
    messagingSenderId: '807533675316',
    projectId: 'location-tracking-79023',
    authDomain: 'location-tracking-79023.firebaseapp.com',
    storageBucket: 'location-tracking-79023.appspot.com',
    measurementId: 'G-RC63SDQG7R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDjxlJzyT6pam-V-Dl8YnUYhjplTz1qEok',
    appId: '1:807533675316:android:64434d80ab40642c609b61',
    messagingSenderId: '807533675316',
    projectId: 'location-tracking-79023',
    storageBucket: 'location-tracking-79023.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCNFd4nPCg4x-uW1Xw_zm_wJTvPM3pDVd4',
    appId: '1:807533675316:ios:47566c4a5c5e076d609b61',
    messagingSenderId: '807533675316',
    projectId: 'location-tracking-79023',
    storageBucket: 'location-tracking-79023.appspot.com',
    iosBundleId: 'com.example.locationTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCNFd4nPCg4x-uW1Xw_zm_wJTvPM3pDVd4',
    appId: '1:807533675316:ios:be5d6f9ee81e60c2609b61',
    messagingSenderId: '807533675316',
    projectId: 'location-tracking-79023',
    storageBucket: 'location-tracking-79023.appspot.com',
    iosBundleId: 'com.example.locationTracker.RunnerTests',
  );
}