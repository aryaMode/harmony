import 'package:flutter/material.dart';
import 'package:harmony/const/colors.dart';
import '';
import 'welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: pColor,
        hintColor: aColor,
        scaffoldBackgroundColor: sColor,
        appBarTheme: AppBarTheme(
          backgroundColor: tColor,
          elevation: 0, // No shadow
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: WelcomeScreen(),
    );
  }
}
