//ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'dart:io';

import 'package:file_manager/statecontrol/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/explorer/w_file_list_view.dart';
import '../widgets/explorer/w_file_not_found_icon.dart';
import '../widgets/explorer/w_pop_up_menu.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({
    Key? key,
    required this.dirPath,
    required this.isSelecting,
  }) : super(key: key);
  final String dirPath;
  final bool isSelecting;
  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  final Controller c = Get.find();
  List<String> childDirList = [];
  List<String> childfileList = [];
  String currentDir = "Folder Name";
  final TextEditingController textController = TextEditingController();
  String createFolderError = '';

  void requestPermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    }
  }

  void getChildDirList() async {
    childDirList.clear();
    c.statusString.value = 'Searching For Files';
    List<String> tempList;

    tempList =
        await Directory(widget.dirPath).list().map((e) => e.path).toList();

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].split('/').last.startsWith('.')) {
        tempList.removeAt(i);
      }
    }

    tempList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].split('/').last.startsWith('.')) {
        tempList.removeAt(i);
      } else {
        if (c.isFile(tempList[i])) {
          childfileList.add(tempList[i]);
        } else {
          childDirList.add(tempList[i]);
        }
      }
    }
    // childDirList = tempList;
    for (var i = 0; i < childfileList.length; i++) {
      childDirList.add(childfileList[i]);
    }
    setState(() {});
    c.statusString.value = 'No File Found !';
  }

  void setCurrentDirName() {
    currentDir =
        widget.dirPath.split('/')[widget.dirPath.split('/').length - 1];

    if (currentDir == "0") {
      currentDir = "Internal Storage";
    } else if (currentDir == "453E-10F7") {
      currentDir = "SD Card";
    }
    setState(() {});
  }

  void onFolderCreate() async {
    var folderName = textController.text;
    if (folderName.isEmpty) {
      c.createErrorMessage.value = 'Enter Folder Name!';
    } else if (Directory('${widget.dirPath}/$folderName').existsSync()) {
      c.createErrorMessage.value = 'Folder Already exists!';
    } else {
      await Directory('${widget.dirPath}/$folderName').create();
      getChildDirList();
      Navigator.pop(context);
    }
  }

  void onDeletePressed() async {
    int selectedItemCount = c.selectedItem.length;

    if (selectedItemCount == 0) {
      return;
    }

    for (int i = 0; i < selectedItemCount; i++) {
      if (c.isFile(c.selectedItem[i])) {
        File(c.selectedItem[i]).deleteSync();
      } else {
        Directory(c.selectedItem[i]).deleteSync(recursive: true);
      }
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    c.goToPage(
      context,
      ExplorerPage(dirPath: widget.dirPath, isSelecting: false),
    );
    // getChildDirList();
  }

  void onRenamePressed() async {
    var newName = textController.text;

    if (c.isFile(c.selectedItem[0])) {
      var parentPath = File(c.selectedItem[0]).parent.path;
      var fileExtention = c.selectedItem[0].split('.').last;
      File(c.selectedItem[0]).rename('$parentPath/$newName.$fileExtention');
    } else {
      var parentPath = Directory(c.selectedItem[0]).parent.path;
      Directory(c.selectedItem[0]).rename('$parentPath/$newName');
    }
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    c.goToPage(
      context,
      ExplorerPage(dirPath: widget.dirPath, isSelecting: false),
    );
  }

  @override
  void initState() {
    requestPermission();
    getChildDirList();
    setCurrentDirName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentDir),
        actions: [
          SizedBox(
            child: widget.isSelecting
                ? CircleAvatar(
                    backgroundColor: Colors.black38,
                    foregroundColor: Colors.amber,
                    child: Obx(
                      () => Text(
                        c.selectedItem.length.toString(),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : null,
          ),
          PopUpMenu(
            isSelecting: widget.isSelecting,
            textController: textController,
            errorMsg: createFolderError,
            onCreatePressed: onFolderCreate,
            onRenamePressed: onRenamePressed,
            onDeletePressed: onDeletePressed,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 23,
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.dirPath,
                ),
              ),
            ),
            Expanded(
              child: childDirList.isNotEmpty
                  ? FileListView(
                      curDirPath: widget.dirPath,
                      childDirList: childDirList,
                      isSelecting: widget.isSelecting,
                    )
                  : const FileNotFoundIcon(),
            )
          ],
        ),
      ),
    );
  }
}
