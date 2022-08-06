import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class StorageListTile extends StatelessWidget {
  const StorageListTile({
    Key? key,
    required this.usedSpace,
    this.totalSpace,
    required this.onPressed,
    required this.storageTitle,
    required this.storageInfo,
  }) : super(key: key);

  final double? usedSpace;
  final double? totalSpace;
  final VoidCallback onPressed;
  final String storageTitle;
  final String storageInfo;

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.find();
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: c.darkMode.value
              ? const Color.fromARGB(255, 46, 46, 46)
              : const Color.fromARGB(255, 230, 230, 230),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: c.darkMode.value
                  ? const Color.fromARGB(255, 54, 54, 54)
                  : const Color.fromARGB(255, 230, 230, 230),
              spreadRadius: 5,
              blurRadius: 1.5,
            ),
          ],
        ),
        child: InkWell(
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storageTitle,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: c.darkMode.value
                          ? c.themeColors[c.themeColorIndex.value]
                          : Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    storageInfo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: c.darkMode.value
                          ? c.themeColors[c.themeColorIndex.value]
                          : Colors.grey[900],
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: c.darkMode.value
                    ? c.themeColors[c.themeColorIndex.value]
                    : Colors.grey[900],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
