import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbamdWOxNTcivpdpzBWtoTiynsFt-VFGM',
    appId: '1:797374885277:android:5ab5aa316a915f917a9374',
    messagingSenderId: '797374885277',
    projectId: 'crud-app-80221',
    storageBucket: 'crud-app-80221.firebasestorage.app',
  );
}
