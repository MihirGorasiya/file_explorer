// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class WhatsAppImagesPage extends StatefulWidget {
  const WhatsAppImagesPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppImagesPage> createState() => _WhatsAppImagesPageState();
}

class _WhatsAppImagesPageState extends State<WhatsAppImagesPage> {
  final String imageDirectoryPath =
      '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Images';
  late List<String> imagePaths = [];

  void getImagePaths() async {
    imagePaths = await Directory(imageDirectoryPath)
        .list(recursive: true)
        .map((e) => e.path)
        .where((e) => e.endsWith('.jpg'))
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
    return imagePaths.isNotEmpty
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
            ),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  OpenFile.open(imagePaths[index]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.file(
                    File(imagePaths[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          )
        : CircularProgressIndicator();
  }
}
