import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_auth.dart';
import 'firestore_test.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp_f(),
    );


  }
}

