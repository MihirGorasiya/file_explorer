//ignore_for_file: prefer_const_literals_to_create_immutables, use_build_context_synchronously, unused_local_variable
import 'dart:io';

import 'package:file_manager/pages/w_select_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../statecontrol/controller.dart';
import '../widgets/explorer/w_file_icon.dart';
import '../widgets/explorer/w_file_not_found_icon.dart';
import '../widgets/explorer/w_pop_up_menu.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({
    Key? key,
    // required this.dirPath,
    required this.isSelecting,
  }) : super(key: key);
  // final String dirPath;
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
    setState(() {
      childDirList.clear();
      childfileList.clear();
    });

    c.statusString.value = 'Searching For Files';
    List<String> tempList;

    // Get all Dir List
    tempList = await Directory(c.currentDirectoryPath.value)
        .list()
        .map((e) => e.path)
        .toList();

    // if showHiddenFile is enabled
    if (!c.showHiddenFiles.value) {
      // Remove dir start with .
      for (int i = 0; i < tempList.length; i++) {
        if (tempList[i].split('/').last.startsWith('.')) {
          tempList.removeAt(i);
        }
      }
    }

    // sort by name
    tempList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });

    // filter files and folder
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].split('/').last.startsWith('.') &&
          !c.showHiddenFiles.value) {
        tempList.removeAt(i);
      } else if (tempList[i].endsWith('.sfmpv')) {
        /*
        // remove all files from private vault
        List<String> a = tempList[i].split('.');
        a.removeLast();
        String newPath = a.join('.');
        File(tempList[i]).rename(newPath);
        */
        continue;
      } else {
        if (c.isFile(tempList[i])) {
          childfileList.add(tempList[i]);
        } else {
          childDirList.add(tempList[i]);
        }
      }
    }
    // childDirList = tempList;

    // Add files in the end of list
    for (var i = 0; i < childfileList.length; i++) {
      childDirList.add(childfileList[i]);
    }

    setState(() {});
    c.statusString.value = 'No File Found !';
  }

  void setCurrentDirName() {
    currentDir = c.currentDirectoryPath.value
        .split('/')[c.currentDirectoryPath.value.split('/').length - 1];

    if (currentDir == "0") {
      currentDir = "Internal Storage";
    }
    // if (currentDir == "453E-10F7")
    else {
      currentDir = "SD Card";
    }
    setState(() {});
  }

  void onFolderCreate() async {
    var folderName = textController.text;
    if (folderName.isEmpty) {
      c.createErrorMessage.value = 'Enter Folder Name!';
    } else if (Directory('${c.currentDirectoryPath.value}/$folderName')
        .existsSync()) {
      c.createErrorMessage.value = 'Folder Already exists!';
    } else {
      await Directory('${c.currentDirectoryPath.value}/$folderName').create();
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
        await File(c.selectedItem[i]).delete();
      } else {
        if (c.safeDelete.value) {
          await Directory(c.selectedItem[i]).delete();
        } else {
          await Directory(c.selectedItem[i]).delete(recursive: true);
        }
      }
    }
    c.isSelecting.value = !c.isSelecting.value;
    getChildDirList();
    Navigator.pop(context);
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

    c.isSelecting.value = false;
    getChildDirList();
    Navigator.pop(context);
  }

  void resetCurDirPath(String newPath) {
    c.currentDirectoryPath.value = newPath;
    getChildDirList();
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
    return WillPopScope(
      onWillPop: () {
        if (c.isSelecting.value) {
          c.isSelecting.value = !c.isSelecting.value;
          return Future.value(false);
        } else {
          if (c.currentDirectoryPath.value != '/storage/emulated/0' &&
              c.currentDirectoryPath.value != c.sdPath) {
            resetCurDirPath(
                Directory(c.currentDirectoryPath.value).parent.path);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(currentDir),
          actions: [
            SizedBox(
              child: widget.isSelecting
                  ? CircleAvatar(
                      backgroundColor: Colors.black38,
                      foregroundColor: c.themeColors[c.themeColorIndex.value],
                      child: Obx(
                        () => Text(
                          c.selectedItem.length.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  : null,
            ),
            Obx(
              () => PopUpMenu(
                isSelecting: c.isSelecting.value,
                textController: textController,
                errorMsg: createFolderError,
                onCreatePressed: onFolderCreate,
                onRenamePressed: onRenamePressed,
                onDeletePressed: onDeletePressed,
                updateFileList: getChildDirList,
              ),
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
                    c.currentDirectoryPath.value,
                  ),
                ),
              ),
              // Expanded(
              //   child: childDirList.isNotEmpty
              //       ? FileListView(
              //           curDirPath: widget.dirPath,
              //           childDirList: childDirList,
              //           isSelecting: widget.isSelecting,
              //         )
              //       : const FileNotFoundIcon(),
              // ),
              Expanded(
                child: childDirList.isNotEmpty
                    ? ListView.builder(
                        itemCount: childDirList.length,
                        itemBuilder: (context, index) {
                          return Obx(
                            () => ListTile(
                              onTap: () async {
                                // selection is on
                                if (c.isSelecting.value) {
                                  if (c.selectedItem
                                      .contains(childDirList[index])) {
                                    c.selectedItem.remove(childDirList[index]);
                                  } else {
                                    c.selectedItem.add(childDirList[index]);
                                  }
                                }
                                // selection is off
                                else {
                                  if (!c.isFile(childDirList[index])) {
                                    resetCurDirPath(childDirList[index]);
                                  } else {
                                    c.onOpenFile(childDirList[index]);
                                  }
                                }
                              },
                              onLongPress: () {
                                if (!c.isSelecting.value) {
                                  c.selectedItem.clear();
                                  c.selectedItem.add(childDirList[index]);

                                  c.isSelecting.value = true;
                                }
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 3,
                              ),
                              leading:
                                  FileIconWidget(fileName: childDirList[index]),
                              title: Text(
                                childDirList[index].split('/').last,
                                maxLines: 1,
                              ),
                              trailing: SizedBox(
                                child: c.isSelecting.value
                                    ? SelectIconWidget(
                                        fileName: childDirList[index])
                                    : null,
                              ),
                            ),
                          );
                        },
                      )
                    : const FileNotFoundIcon(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
