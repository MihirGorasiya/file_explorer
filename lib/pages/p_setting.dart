// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle tStyle = const TextStyle(color: Colors.amber, fontSize: 17);
    return Scaffold(
      appBar: AppBar(title: Text('Setting')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Features',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 25,
              ),
            ),
            Text(
              '- Settings fuctionality \n- Light Mode \n- Custom Color Theme \n- Move File \n- Copy Folder \n- File size in MB, KB and other unit\n - And Much More',
              style: tStyle,
            ),
          ],
        ),
      ),
    );
  }
}
