import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

class Controller extends GetxController {
  // -------------------- String --------------------
  var createErrorMessage = ''.obs;
  var copyDestPath = ''.obs;
  var cutDestPath = ''.obs;
  var statusString = 'Searching For Files'.obs;
  var sizeDetails = '0'.obs;

  // -------------------- Bool --------------------
  // TODO: Add bool for premium check
  var isTransfering = 0.obs;
  var darkMode = true.obs;
  var showHiddenFiles = true.obs;
  var safeDelete = false.obs;

  // -------------------- Int --------------------
  var themeColorIndex = 0.obs;

  // -------------------- Others --------------------
  var selectedItem = <String>[].obs;
  var themeColors = <MaterialColor>[
    Colors.amber,
    Colors.blue,
    Colors.red,
    Colors.teal,
    Colors.purple,
    Colors.orange,
    Colors.lime,
    Colors.indigo,
    Colors.cyan,
    Colors.green,
  ];
  var colorCodes = <Map<String, dynamic>>[
    {
      'light': {
        'mainColor': Colors.white,
        'contrastColor': Colors.grey[900],
      },
      'dark': {
        'mainColor': Colors.grey[900],
        'contrastColor': Colors.white,
      },
    }
  ].obs;

  var sdPath = '';

  void goToPage(BuildContext context, Widget newPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newPage,
      ),
    );
  }

  bool isFile(String path) {
    if (File(path).existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  void getSizeDetails() {
    // int fileNum = 0;
    int totalSize = 0;
    for (var i = 0; i < selectedItem.length; i++) {
      if (isFile(selectedItem[i])) {
        totalSize += File(selectedItem[i]).lengthSync();
      } else {
        Directory(selectedItem[i])
            .listSync(recursive: true, followLinks: false)
            .forEach((element) {
          if (element is File) {
            // fileNum++;
            totalSize += element.lengthSync().ceil();
          }
        });
      }
    }
    sizeDetails.value = filesize(totalSize);
  }

  void onOpenFile(String filePath) {
    OpenFile.open(filePath);
  }
}
