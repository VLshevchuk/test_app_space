import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:space_chat/pages/auth/auth.dart';
import 'package:space_chat/pages/space/space_chat.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, routes: {
      '/': (context) => Auth(),
      '/space_chat': (context) => SpaceChat(),
    }),
  );
}
