// ignore_for_file: prefer_const_constructors

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:file_manager/pages/p_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: GoogleFonts.baloo2().fontFamily,
        primarySwatch: Colors.amber,
        colorScheme: ColorScheme.dark(
          primary: Colors.amber,
          secondary: Colors.amber,
        ),
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
      ),
      home: EasySplashScreen(
        logo: Image(image: AssetImage('assets/file_explorer_logo.png')),
        title: Text(
          'File Manager',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
        showLoader: false,
        loadingText: Text(
          'Beta Version',
          style: TextStyle(
            fontSize: 15,
            color: Colors.amber,
            fontWeight: FontWeight.w100,
          ),
        ),
        backgroundColor: Colors.grey.shade800,
        navigator: const HomePage(),
      ),
    );
  }
}
