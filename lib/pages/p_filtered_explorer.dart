import 'dart:io';

import 'package:file_manager/pages/w_select_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';

import '../statecontrol/controller.dart';
import '../widgets/explorer/w_file_icon.dart';
import '../widgets/explorer/w_file_name_widget.dart';
import '../widgets/explorer/w_file_not_found_icon.dart';

class FilteredExplorerPage extends StatefulWidget {
  const FilteredExplorerPage({
    Key? key,
    required this.fileType,
  }) : super(key: key);
  final String fileType;

  @override
  State<FilteredExplorerPage> createState() => _FilteredExplorerPageState();
}

class _FilteredExplorerPageState extends State<FilteredExplorerPage> {
  // TODO: Add Functionality go to file dir

  final Controller c = Get.find();
  List<String> allRootDirPathList = [];
  List<String> childDirList = [];

  bool isFileTypeMatches(String event) {
    if (widget.fileType == 'Images') {
      if (event.endsWith('.jpg') ||
          event.endsWith('.jpeg') ||
          event.endsWith('.tiff') ||
          event.endsWith('.raw') ||
          event.endsWith('.gif') ||
          event.endsWith('.png')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Videos') {
      if (event.endsWith('.mp4') ||
          event.endsWith('.avi') ||
          event.endsWith('.mkv') ||
          event.endsWith('.mov')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Audios') {
      if (event.endsWith('.mp3') ||
          event.endsWith('.aac') ||
          event.endsWith('.ogg') ||
          event.endsWith('.aiff') ||
          event.endsWith('.wav')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Documents') {
      if (event.endsWith('.pdf') ||
          event.endsWith('.doc') ||
          event.endsWith('.docx') ||
          event.endsWith('.txt') ||
          event.endsWith('.ppt') ||
          event.endsWith('.pptx')) {
        return true;
      } else {
        return false;
      }
    } else {
      if (event.endsWith('.apk')) {
        return true;
      } else {
        return false;
      }
    }
  }

  void getAllFiles() async {
    c.statusString.value = 'Searching For Files';
    allRootDirPathList = await Directory('/storage/emulated/0')
        .list()
        .map((e) => e.path)
        .toList();

    List<String> sdDirs =
        await Directory(c.sdPath).list().map((e) => e.path).toList();

    allRootDirPathList.addAll(sdDirs);

    int i = 0;
    while (i < allRootDirPathList.length) {
      if (!(allRootDirPathList[i].contains('.') ||
          allRootDirPathList[i].contains('Android'))) {
        childDirList.addAll(await Directory(allRootDirPathList[i])
            .list(recursive: true)
            .map((event) => event.path)
            .where((event) => isFileTypeMatches(event))
            .toList());
      }

      i++;
    }

    // childDirList = await Directory('/storage/emulated/0/download')
    //     .list()
    //     .map((event) => event.path)
    //     .where((event) => isFileTypeMatches(event))
    //     .toList();

    setState(() {});
    c.statusString.value = 'No File Found !';
  }

  void onDirSelect(int index) {
    OpenFile.open(childDirList[index]);
  }

  @override
  void initState() {
    getAllFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.fileType)),
      body: childDirList.isNotEmpty
          ? ListView.builder(
              itemCount: childDirList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  // color: Colors.grey[800],
                  child: InkWell(
                    onTap: () => onDirSelect(index),
                    child: Row(
                      children: [
                        FileIconWidget(fileName: childDirList[index]),
                        const SizedBox(width: 10),
                        FileNameWidget(
                          isSelecting: false,
                          fileName: childDirList[index].split('/').last,
                        ),
                        const SizedBox(width: 10),
                        SelectIconWidget(
                          isSelecting: false,
                          fileName: childDirList[index],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const FileNotFoundIcon(),
    );
  }
}
