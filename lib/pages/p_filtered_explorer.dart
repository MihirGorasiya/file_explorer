import 'dart:io';

import 'package:file_manager/pages/w_select_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';
import '../widgets/explorer/w_file_icon.dart';
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
  final Controller c = Get.find();
  List<String> allRootDirPathList = [];
  List<String> childDirList = [];

  bool isFileTypeMatches(String fileName) {
    if (widget.fileType == 'Images') {
      if (fileName.endsWith('.jpg') ||
          fileName.endsWith('.jpeg') ||
          fileName.endsWith('.tiff') ||
          fileName.endsWith('.raw') ||
          fileName.endsWith('.gif') ||
          fileName.endsWith('.png')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Videos') {
      if (fileName.endsWith('.mp4') ||
          fileName.endsWith('.avi') ||
          fileName.endsWith('.mkv') ||
          fileName.endsWith('.mov')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Audios') {
      if (fileName.endsWith('.mp3') ||
          fileName.endsWith('.aac') ||
          fileName.endsWith('.ogg') ||
          fileName.endsWith('.aiff') ||
          fileName.endsWith('.wav')) {
        return true;
      } else {
        return false;
      }
    } else if (widget.fileType == 'Documents') {
      if (fileName.endsWith('.pdf') ||
          fileName.endsWith('.doc') ||
          fileName.endsWith('.docx') ||
          fileName.endsWith('.txt') ||
          fileName.endsWith('.ppt') ||
          fileName.endsWith('.pptx')) {
        return true;
      } else {
        return false;
      }
    } else {
      if (fileName.endsWith('.apk')) {
        return true;
      } else {
        return false;
      }
    }
  }

  void getAllFiles() async {
    c.statusString.value = 'Searching For Files';

    // get all internal dir List
    allRootDirPathList = await Directory('/storage/emulated/0')
        .list()
        .map((e) => e.path)
        .toList();

    // get all SD Card dir List
    List<String> sdDirs =
        await Directory(c.sdPath).list().map((e) => e.path).toList();

    allRootDirPathList.addAll(sdDirs);

    // get specific type of Files
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

    setState(() {});
    c.statusString.value = 'No File Found !';
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
                return Obx(
                  () => ListTile(
                    onTap: () => c.onOpenFile(childDirList[index]),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 3,
                    ),
                    leading: FileIconWidget(fileName: childDirList[index]),
                    title: Text(
                      childDirList[index].split('/').last,
                      maxLines: 1,
                    ),
                    trailing: SizedBox(
                      child: c.isSelecting.value
                          ? SelectIconWidget(fileName: childDirList[index])
                          : null,
                    ),
                  ),
                );
              },
            )
          : const FileNotFoundIcon(),
    );
  }
}
