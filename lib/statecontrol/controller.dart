import 'dart:io';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var isTransfering = false.obs;
  var selectedItem = <String>[].obs;
  var createErrorMessage = ''.obs;
  var copyDestPath = ''.obs;
  var cutDestPath = ''.obs;
  var statusString = 'Searching For Files'.obs;
  var darkMode = true.obs;
  var sizeDetails = '0'.obs;
  var colorCodes = <Map<String, dynamic>>[
    {
      'light': {
        'mainColor': Colors.amber,
      },
      'dark': [],
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
    int fileNum = 0;
    int totalSize = 0;
    for (var i = 0; i < selectedItem.length; i++) {
      if (isFile(selectedItem[i])) {
        totalSize += File(selectedItem[i]).lengthSync();
      } else {
        Directory(selectedItem[i])
            .listSync(recursive: true, followLinks: false)
            .forEach((element) {
          if (element is File) {
            fileNum++;
            totalSize += element.lengthSync().ceil();
          }
        });
      }
    }
    sizeDetails.value = filesize(totalSize);
  }
}
