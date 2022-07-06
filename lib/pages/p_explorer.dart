//ignore_for_file: prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class ExplorerPage extends StatefulWidget {
  const ExplorerPage({
    Key? key,
    required this.dirPath,
  }) : super(key: key);
  final String dirPath;
  @override
  State<ExplorerPage> createState() => _ExplorerPageState();
}

class _ExplorerPageState extends State<ExplorerPage> {
  List<String> childDirList = [];
  List<String> childfileList = [];
  String currentDir = "Folder Name";

  void requestPermission() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
    }
  }

  void getChildDirList() async {
    List<String> tempList;

    tempList = await Directory(widget.dirPath)
        .list()
        .map((e) => e.path)
        .where((element) => !element.startsWith('.'))
        .toList();

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
        if (File(tempList[i]).existsSync()) {
          childfileList.add(tempList[i]);
          tempList.removeAt(i);
        } else if (Directory(tempList[i]).existsSync()) {
          childDirList.add(tempList[i]);
        }
      }
    }
    // childDirList = tempList;
    for (var i = 0; i < childfileList.length; i++) {
      childDirList.add(childfileList[i]);
    }
    setState(() {});
  }

  void setCurrentDirName() {
    currentDir =
        widget.dirPath.split('/')[widget.dirPath.split('/').length - 1];
    print(currentDir);
    if (currentDir == "0") {
      currentDir = "Internal Storage";
    } else if (currentDir == "453E-10F7") {
      currentDir = "SD Card";
    }
    setState(() {});
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.dirPath),
            Expanded(
              child: childDirList.isNotEmpty
                  ? ListView.builder(
                      itemCount: childDirList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          // color: Colors.grey[800],
                          child: InkWell(
                            onTap: () {
                              // String newPath = childDirList[index];
                              if (Directory(childDirList[index]).existsSync()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExplorerPage(
                                      dirPath: childDirList[index],
                                    ),
                                  ),
                                );
                              } else {
                                OpenFile.open(childDirList[index]);
                              }
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    if (childDirList[index].endsWith('.mp4')) {
                                      return Icon(
                                        Icons.video_file,
                                        size: 35,
                                        color: Colors.grey[900],
                                      );
                                    } else if (childDirList[index]
                                        .endsWith('.mp3')) {
                                      return Icon(
                                        Icons.audio_file,
                                        size: 35,
                                        color: Colors.grey[900],
                                      );
                                    } else if (childDirList[index]
                                            .endsWith('.jpg') ||
                                        childDirList[index].endsWith('.jpeg') ||
                                        childDirList[index].endsWith('.png')) {
                                      return Icon(
                                        Icons.image,
                                        size: 35,
                                        color: Colors.grey[900],
                                      );
                                    } else if (childDirList[index]
                                        .contains('.')) {
                                      if (!Directory(childDirList[index])
                                          .existsSync()) {
                                        return Icon(
                                          Icons.file_present,
                                          size: 35,
                                          color: Colors.grey[900],
                                        );
                                      } else {
                                        return Icon(
                                          Icons.folder,
                                          size: 35,
                                          color: Colors.grey[900],
                                        );
                                      }
                                    } else {
                                      return Icon(
                                        Icons.folder,
                                        size: 35,
                                        color: Colors.grey[900],
                                      );
                                    }
                                  }),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  child: Text(
                                    childDirList[index].split('/').last,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_rounded,
                            size: 70,
                            color: Colors.amber,
                          ),
                          const Text(
                            "No File Found !",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                        ],
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
