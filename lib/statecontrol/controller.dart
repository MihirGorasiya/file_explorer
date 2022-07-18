import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var isTransfering = false.obs;
  var selectedItem = <String>[].obs;
  var createErrorMessage = ''.obs;
  var copyDestPath = ''.obs;
  var cutDestPath = ''.obs;
  var statusString = 'Searching For Files'.obs;

  var sdPath = '';

  void goToPage(BuildContext context, Widget newPage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => newPage,
      ),
    );
  }
}
