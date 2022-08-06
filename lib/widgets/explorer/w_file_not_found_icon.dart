// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../statecontrol/controller.dart';

class FileNotFoundIcon extends StatefulWidget {
  const FileNotFoundIcon({
    Key? key,
  }) : super(key: key);

  @override
  State<FileNotFoundIcon> createState() => _FileNotFoundIconState();
}

class _FileNotFoundIconState extends State<FileNotFoundIcon> {
  final Controller c = Get.find();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => c.statusString.value == 'No File Found !'
                ? Icon(
                    Icons.warning_rounded,
                    size: 70,
                    color: c.themeColors[c.themeColorIndex.value],
                  )
                : const CircularProgressIndicator(),
          ),
          Obx(
            () => Text(
              c.statusString.value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
