// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../statecontrol/controller.dart';

class WhatsAppAudiosPage extends StatefulWidget {
  const WhatsAppAudiosPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppAudiosPage> createState() => _WhatsAppAudiosPageState();
}

class _WhatsAppAudiosPageState extends State<WhatsAppAudiosPage> {
  final Controller c = Get.find();
  final String audioDirectoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Audio';
  late List<String> audioPaths = [];

  void getImagePaths() async {
    audioPaths = await Directory(audioDirectoryPath)
        .list(recursive: true)
        .map((e) => e.path)
        .where((e) =>
            (e.endsWith('.mp3') || e.endsWith('.ogg') || e.endsWith('.wav')))
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
    return audioPaths.isNotEmpty
        ? ListView.builder(
            itemCount: audioPaths.length,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  c.onOpenFile(audioPaths[index]);
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
                title: Text(audioPaths[index].split('/').last),
              );
            },
          )
        : Center(child: Text('No Audio File Available.'));
  }
}
