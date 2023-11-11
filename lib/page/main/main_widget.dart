import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.decoration,
    required this.text,
    required this.clip,
    this.onPressed,
  });
  final Decoration? decoration;
  final String text;
  final Clip clip;
  final Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: 56,
        width: double.infinity,
        clipBehavior: clip,
        decoration: decoration,
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w600,
              height: 0,
              letterSpacing: 0.40,
            ),
          ),
        ),
      ),
    );
  }
}
