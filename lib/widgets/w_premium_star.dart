import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../statecontrol/controller.dart';

class PremiumStarWidget extends StatelessWidget {
  const PremiumStarWidget({
    Key? key,
    required this.c,
    required this.size,
  }) : super(key: key);

  final Controller c;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Icon(
        Icons.star_rate_rounded,
        size: size,
        color: c.themeColors[c.themeColorIndex.value],
      ),
    );
  }
}
