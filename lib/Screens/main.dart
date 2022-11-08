import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shipconvenient/Screens/Signup/authentication/phone.dart';
import 'package:shipconvenient/Screens/Welcome/welcome_screen.dart';
import 'constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tiện đường',
        theme: ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: kPrimaryColor,
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              iconColor: kPrimaryColor,
              prefixIconColor: kPrimaryColor,
              // contentPadding: EdgeInsets.symmetric(
              //     horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(color: Colors.black, width: 0.0),
              ),
            )),
        home: WelcomeScreen());
  }
}
