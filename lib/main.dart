// ignore_for_file: prefer_const_constructors

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:file_manager/utils/purchase_api.dart';
import 'package:file_manager/utils/file_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/p_home.dart';
import 'statecontrol/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PurchaseApi.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Controller c = Get.put(Controller());

  @override
  void initState() {
    PurchaseApi().getPurchasesStatus();
    FileHandler().retriveData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Obx(
      () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Slavia - File Manager',
        themeMode: c.darkMode.value ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          fontFamily: GoogleFonts.baloo2().fontFamily,
          // primarySwatch: c.themeColors[c.themeColorIndex.value],
          primarySwatch: c.themeColors[c.themeColorIndex.value],
          colorScheme: ColorScheme.light(
            primary: c.themeColors[c.themeColorIndex.value],
            secondary: c.themeColors[c.themeColorIndex.value],
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
          primarySwatch: c.themeColors[c.themeColorIndex.value],
          colorScheme: ColorScheme.dark(
            primary: c.themeColors[c.themeColorIndex.value],
            secondary: c.themeColors[c.themeColorIndex.value],
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
              color: c.themeColors[c.themeColorIndex.value],
            ),
          ),
          showLoader: false,
          loadingText: Text(
            'Beta Version',
            style: TextStyle(
              fontSize: 15,
              color: c.themeColors[c.themeColorIndex.value],
              fontWeight: FontWeight.w100,
            ),
          ),
          durationInSeconds: 2,
          backgroundColor:
              c.darkMode.value ? Colors.grey.shade800 : Colors.white,
          navigator: const HomePage(),
          // navigator: const IapPurchaseTestPage(),
        ),
      ),
    );
  }
}
