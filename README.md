# Blackout Tracker
[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)
Flutter app for checking battery and charge state and WiFI and internet connection state. Tested in android devices


### App window

Buttons down: restart, stop background process, cloud archive, check info
![image](https://user-images.githubusercontent.com/91286611/207553296-b317fb1c-1551-4774-b4e3-ddc4e51a8b95.png)


### In Firestore
![image](https://user-images.githubusercontent.com/91286611/207553435-af910d7d-dc5e-4cef-8ed8-cfc4fae49c2b.png)

### Installing Firestore
For using project you need configure your Firestore - create own Firebase project with name as app name, register app and add in project your credentials - use Firebase CLI or download google-services.json and place in android[app_name]/app, then create in lib/domain/entities/firebase_options.dart and add credenials as here (for Android app):
```dart
import 'package:firebase_core/firebase_core.dart';

const FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: "AAABB11_AABB111HHH22gggHHHJ_AAAbbb111C",
  appId: "5:111222333444:android:111aaaBBBccc22CCCCddDD",
  messagingSenderId: "111222333444",
  projectId: "blackoutchecker-111B",
  storageBucket: "blackoutchecker-111B.appspot.com",
);
```

