import 'dart:io';

import 'package:file_manager/widgets/explorer/w_file_icon.dart';
import 'package:file_manager/widgets/explorer/w_file_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/p_explorer.dart';
import '../../pages/w_select_icon.dart';
import '../../statecontrol/controller.dart';

class FileListView extends StatelessWidget {
  FileListView({
    Key? key,
    required this.childDirList,
    required this.isSelecting,
    required this.curDirPath,
  }) : super(key: key);

  final List<String> childDirList;
  final String curDirPath;
  final bool isSelecting;
  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    void onDirSelect(int index) {
      if (isSelecting) {
        if (c.selectedItem.contains(childDirList[index])) {
          c.selectedItem.remove(childDirList[index]);
        } else {
          c.selectedItem.add(childDirList[index]);
        }
      } else {
        if (Directory(childDirList[index]).existsSync()) {
          c.goToPage(
            context,
            ExplorerPage(
              dirPath: childDirList[index],
              isSelecting: false,
            ),
          );
        } else {
          c.onOpenFile(childDirList[index]);
        }
      }
    }

    void onSelectionStart(int index) {
      if (!isSelecting) {
        c.selectedItem.clear();
        c.selectedItem.add(childDirList[index]);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExplorerPage(
              dirPath: curDirPath,
              isSelecting: true,
            ),
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: childDirList.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(vertical: 5),
          // color: Colors.grey[800],
          child: InkWell(
            onTap: () => onDirSelect(index),
            onLongPress: () => onSelectionStart(index),
            child: Row(
              children: [
                FileIconWidget(fileName: childDirList[index]),
                const SizedBox(width: 10),
                FileNameWidget(
                  isSelecting: isSelecting,
                  fileName: childDirList[index].split('/').last,
                ),
                const SizedBox(width: 10),
                SelectIconWidget(
                  isSelecting: isSelecting,
                  fileName: childDirList[index],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
