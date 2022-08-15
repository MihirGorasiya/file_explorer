import 'package:flutter/material.dart';

class FileNameWidget extends StatelessWidget {
  const FileNameWidget({
    Key? key,
    required this.isSelecting,
    required this.fileName,
  }) : super(key: key);

  final bool isSelecting;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.purple,
      height: 45,
      width: isSelecting
          ? MediaQuery.of(context).size.width * 0.69
          : MediaQuery.of(context).size.width * 0.77,
      child: Text(
        fileName,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15),
      ),
    );
  }
}
