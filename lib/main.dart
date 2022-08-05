// ignore_for_file: prefer_const_constructors

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:file_manager/pages/p_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'statecontrol/controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  final Controller c = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Obx(() => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: c.darkMode.value ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            fontFamily: GoogleFonts.baloo2().fontFamily,
            primarySwatch: Colors.amber,
            colorScheme: ColorScheme.light(
              primary: Colors.amber,
              secondary: Colors.amber,
            ),
            brightness: Brightness.light,
            appBarTheme: AppBarTheme(
              color: Colors.transparent,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          darkTheme: ThemeData(
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
            iconTheme: IconThemeData(color: Colors.grey[900]),
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
            backgroundColor:
                c.darkMode.value ? Colors.grey.shade800 : Colors.white,
            navigator: const HomePage(),
          ),
        ));
  }
}
