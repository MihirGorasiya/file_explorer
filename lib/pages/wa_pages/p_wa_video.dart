// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../statecontrol/controller.dart';

class WhatsAppVideosPage extends StatefulWidget {
  const WhatsAppVideosPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppVideosPage> createState() => _WhatsAppVideosPageState();
}

class _WhatsAppVideosPageState extends State<WhatsAppVideosPage> {
  final Controller c = Get.find();
  final String videoDirectoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Video';
  late List<String> videoPaths = [];

  void getImagePaths() async {
    videoPaths = await Directory(videoDirectoryPath)
        .list(recursive: true)
        .map((e) => e.path)
        .where((e) => e.endsWith('.mp4'))
        .toList();
    setState(() {});
  }

  @override
  void initState() {
    getImagePaths();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return videoPaths.isNotEmpty
        ? ListView.builder(
            itemCount: videoPaths.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  c.onOpenFile(videoPaths[index]);
                },
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: c.themeColors[c.themeColorIndex.value],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    Icons.video_file_rounded,
                    size: 40,
                  ),
                ),
                title: Text(videoPaths[index].split('/').last),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }
}
