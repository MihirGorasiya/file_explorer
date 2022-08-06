// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:file_manager/pages/wa_pages/p_wa_images.dart';
import 'package:file_manager/pages/wa_pages/p_wa_video.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';
import 'wa_pages/p_wa_audio.dart';

class WhatsAppMediaPage extends StatefulWidget {
  const WhatsAppMediaPage({Key? key}) : super(key: key);

  @override
  State<WhatsAppMediaPage> createState() => _WhatsAppMediaPageState();
}

class _WhatsAppMediaPageState extends State<WhatsAppMediaPage> {
  final Controller c = Get.find();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('WhatsApp'),
          bottom: TabBar(
            indicatorColor: c.themeColors[c.themeColorIndex.value],
            tabs: [
              Tab(
                icon: Icon(Icons.image_rounded),
              ),
              Tab(
                icon: Icon(Icons.video_file),
              ),
              Tab(
                icon: Icon(Icons.audio_file_rounded),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            WhatsAppImagesPage(),
            WhatsAppVideosPage(),
            WhatsAppAudiosPage(),
          ],
        ),
      ),
    );
  }
}
