import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double height, width;
  final Color buttonColor;
  const MyButton({
    super.key,
    required this.height,
    required this.width,
    required this.buttonColor,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color.fromARGB(255, 0, 0, 0)
          .withOpacity(1), // Adds splash effect
      borderRadius:
          BorderRadius.circular(25), // Matches the button's border radius
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(28),
          // border: Border.all(
          //   color: Colors.black,
          // ),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
