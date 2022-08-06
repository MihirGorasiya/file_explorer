import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class StorageInfoBanner extends StatefulWidget {
  const StorageInfoBanner({
    Key? key,
    required this.usedSpace,
    required this.usedSpacePer,
    required this.totalSpace,
  }) : super(key: key);

  final double? usedSpace;
  final double? usedSpacePer;
  final double? totalSpace;

  @override
  State<StorageInfoBanner> createState() => _StorageInfoBannerState();
}

class _StorageInfoBannerState extends State<StorageInfoBanner> {
  final Controller c = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: c.themeColors[c.themeColorIndex.value],
        borderRadius: BorderRadius.circular(25),
      ),
      height: 150,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * .35,
            decoration: BoxDecoration(
              // color: Colors.pinkAccent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .20,
                height: MediaQuery.of(context).size.width * .20,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Center(
                        child: Text(
                      widget.usedSpace == 0
                          ? '85%'
                          : '${(widget.usedSpacePer! * 100).ceil()}%',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    )),
                    CircularProgressIndicator(
                      value:
                          widget.usedSpace == 0 ? 0.75 : widget.usedSpacePer!,
                      color: Colors.grey[700],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.green,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Internal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    'Storage',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.usedSpace == 0
                        ? '00.0 GB/00.0 GB'
                        : '${widget.usedSpace}GB/${widget.totalSpace}GB used',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
