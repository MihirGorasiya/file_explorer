import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../statecontrol/controller.dart';

class FileHandler {
  final Controller c = Get.find();
  String filePath = '';
  String readData = 'dummy Data';

  void saveData() async {
    String newData =
        '${c.darkMode.value}|${c.showHiddenFiles.value}|${c.themeColorIndex.value}';

    Directory? dir = await getExternalStorageDirectory();
    filePath = '${dir!.path}/settings.txt';

    if (!File(filePath).existsSync()) {
      await File(filePath).create();
    }
    await File(filePath).writeAsString(newData);
  }

  void retriveData() async {
    Directory? dir = await getExternalStorageDirectory();
    filePath = '${dir!.path}/settings.txt';

    if (!File(filePath).existsSync()) {
      saveData();
    }

    readData = await File(filePath).readAsString();

    List<String> splittedReadData = readData.split('|');

    c.darkMode.value = splittedReadData[0] == 'true';
    c.showHiddenFiles.value = splittedReadData[1] == 'true';
    c.themeColorIndex.value = int.parse(splittedReadData[2]);
    // return readData.split('|');
  }
}
