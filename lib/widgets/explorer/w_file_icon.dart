import 'dart:io';

import 'package:flutter/material.dart';

class FileIconWidget extends StatelessWidget {
  const FileIconWidget({
    Key? key,
    required this.fileName,
  }) : super(key: key);

  final String fileName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (fileName.endsWith('.mp4') ||
              fileName.endsWith('.avi') ||
              fileName.endsWith('.mkv') ||
              fileName.endsWith('.mov')) {
            return const MyIcon(
              icon: Icons.video_file_rounded,
            );
          } else if (fileName.endsWith('.mp3') ||
              fileName.endsWith('.aac') ||
              fileName.endsWith('.ogg') ||
              fileName.endsWith('.aiff') ||
              fileName.endsWith('.wav')) {
            return const MyIcon(
              icon: Icons.audio_file_rounded,
            );
          } else if (fileName.endsWith('.apk')) {
            return const MyIcon(
              icon: Icons.archive_rounded,
            );
          } else if (fileName.endsWith('.jpg') ||
              fileName.endsWith('.jpeg') ||
              fileName.endsWith('.tiff') ||
              fileName.endsWith('.raw') ||
              fileName.endsWith('.gif') ||
              fileName.endsWith('.png')) {
            return const MyIcon(
              icon: Icons.image_rounded,
            );
          } else if (fileName.contains('.')) {
            if (!Directory(fileName).existsSync()) {
              return const MyIcon(
                icon: Icons.file_present_rounded,
              );
            } else {
              return const MyIcon(
                icon: Icons.folder,
              );
            }
          } else {
            return const MyIcon(
              icon: Icons.folder,
            );
          }
        },
      ),
    );
  }
}

class MyIcon extends StatelessWidget {
  const MyIcon({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 35,
      // color: Colors.grey[900],
    );
  }
}
