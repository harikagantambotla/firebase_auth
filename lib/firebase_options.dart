// File: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCla24SJv3D3v7sm186UwLvvnaRTf2fUcM",
    authDomain: "fir-authapp-6e44f.firebaseapp.com",
    projectId: "fir-authapp-6e44f",
    storageBucket: "fir-authapp-6e44f.firebasestorage.app",
    messagingSenderId: "863672132852",
    appId: "1:863672132852:web:d62716428453633fb0aaa1",
    measurementId: "G-F6SZCPC8W1",
  );
}
