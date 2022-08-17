// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';
import '../utils/fuction_storage.dart';
import '../widgets/explorer/w_file_icon.dart';

class PrivateVaultPage extends StatefulWidget {
  const PrivateVaultPage({Key? key}) : super(key: key);

  @override
  State<PrivateVaultPage> createState() => _PrivateVaultPageState();
}

class _PrivateVaultPageState extends State<PrivateVaultPage> {
  final Controller c = Get.find();
  late List<String> fileList = [];
  late List<String> fileNameList = [];
  bool searchingFile = true;
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    fileList.clear();
    fileList = await FuctionStorage().getPrivateFiles();

    for (var i = 0; i < fileList.length; i++) {
      List<String> splitted = fileList[i].split('.');
      splitted.removeLast();
      String newFileName = splitted.join('.');
      fileNameList.add(newFileName);
    }

    searchingFile = false;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          'Tap and hold file to remove from private Vault.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var i = 0; i < fileList.length; i++) {
      if (File(fileNameList[i]).existsSync()) {
        File(fileNameList[i]).renameSync(fileList[i]);
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Private Vault'),
      ),
      body: fileList.isNotEmpty
          ? ListView.builder(
              itemCount: fileList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: ListTile(
                    onTap: () async {
                      File(fileList[index]).rename(fileNameList[index]);
                      c.onOpenFile(fileNameList[index]);
                    },
                    onLongPress: () {
                      if (File(fileList[index]).existsSync()) {
                        File(fileList[index]).rename(fileNameList[index]);
                      }
                      fileList.removeAt(index);
                      fileNameList.removeAt(index);
                      setState(() {});
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 3,
                    ),
                    leading: FileIconWidget(fileName: fileList[index]),
                    title: Text(
                      fileNameList[index].split('/').last,
                      maxLines: 1,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: searchingFile
                  ? CircularProgressIndicator()
                  : Text(
                      'No Files added yet to private Vault.',
                      style: TextStyle(fontSize: 17),
                    ),
            ),
    );
  }
}
