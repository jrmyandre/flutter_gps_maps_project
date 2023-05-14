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
    apiKey: 'AIzaSyAf_nQuNekx7sgnhH0G3IykrBnElEgNMaM',
    appId: '1:59225144141:web:667e554787965744c61504',
    messagingSenderId: '59225144141',
    projectId: 'flutter-test-81f25',
    authDomain: 'flutter-test-81f25.firebaseapp.com',
    databaseURL: 'https://flutter-test-81f25-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-81f25.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoK9NCBj-AFpvbz6OCTsmiIje9Y5dDRWE',
    appId: '1:59225144141:android:4cfc222fb0f30580c61504',
    messagingSenderId: '59225144141',
    projectId: 'flutter-test-81f25',
    databaseURL: 'https://flutter-test-81f25-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-81f25.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5XsQr9YnjqjHDDx3lMIasrL-mx-tnHXw',
    appId: '1:59225144141:ios:d1973d91170bbafec61504',
    messagingSenderId: '59225144141',
    projectId: 'flutter-test-81f25',
    databaseURL: 'https://flutter-test-81f25-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-81f25.appspot.com',
    iosClientId: '59225144141-0o8g1chi41g06hdkkvgdqo8rt8qkm6lh.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterGoogleMapTesting',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5XsQr9YnjqjHDDx3lMIasrL-mx-tnHXw',
    appId: '1:59225144141:ios:d1973d91170bbafec61504',
    messagingSenderId: '59225144141',
    projectId: 'flutter-test-81f25',
    databaseURL: 'https://flutter-test-81f25-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-test-81f25.appspot.com',
    iosClientId: '59225144141-0o8g1chi41g06hdkkvgdqo8rt8qkm6lh.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterGoogleMapTesting',
  );
}
