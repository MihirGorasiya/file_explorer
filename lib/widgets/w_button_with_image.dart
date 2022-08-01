// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ButtonWithImage extends StatelessWidget {
  const ButtonWithImage({
    Key? key,
    required this.buttonDesc,
    required this.buttonIcon,
    required this.onPressed,
  }) : super(key: key);
  final String buttonDesc;
  final IconData buttonIcon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              buttonIcon,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            buttonDesc,
            style: TextStyle(
                color: Colors.grey[900],
                fontSize: 15,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
