import 'package:flutter/material.dart';

class PlainTextButton extends StatelessWidget {
  const PlainTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.bgColor,
    required this.textColor,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color? bgColor;
  final Color? textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7.5),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
