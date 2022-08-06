import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class SelectIconWidget extends StatelessWidget {
  SelectIconWidget({
    Key? key,
    required this.isSelecting,
    required this.fileName,
  }) : super(key: key);

  final bool isSelecting;
  final String fileName;
  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: isSelecting
          ? Obx(() => Icon(
                c.selectedItem.contains(fileName)
                    ? Icons.check_box
                    : Icons.check_box_outline_blank_rounded,
                color: c.themeColors[c.themeColorIndex.value],
              ))
          : null,
    );
  }
}
