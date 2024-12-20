import 'package:flutter/material.dart';

class MyFeatureBox extends StatelessWidget {
  final double height, width;
  final String boxName;
  final Color boxColor;
  final Icon boxIcon;
  final void Function()? onTap;

  const MyFeatureBox({
    super.key,
    required this.height,
    required this.width,
    required this.boxName,
    required this.boxIcon,
    required this.boxColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1, // Adjust the flex value to control space distribution
      child: Container(
        margin: const EdgeInsets.all(20),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: boxColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: onTap,
              icon: boxIcon,
              iconSize: 50, // Control the size of the icon
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              boxName,
              style: const TextStyle(
                fontSize: 16, // Adjust text size for responsiveness
              ),
            ),
          ],
        ),
      ),
    );
  }
}
