import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class SelectIconWidget extends StatelessWidget {
  SelectIconWidget({
    Key? key,
    required this.fileName,
  }) : super(key: key);

  final String fileName;
  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Icon(
          c.selectedItem.contains(fileName)
              ? Icons.check_box
              : Icons.check_box_outline_blank_rounded,
          color: c.themeColors[c.themeColorIndex.value],
        ));
  }
}
