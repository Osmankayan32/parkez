import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:login_screen/services/locator.dart';
import 'package:login_screen/themes/light_theme.dart';
import 'package:login_screen/views/login_screen/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'views/login_screen/yeni_giriş_ekranı.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Firebase Auth',
        debugShowCheckedModeBanner: false,
        theme: Themes.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
