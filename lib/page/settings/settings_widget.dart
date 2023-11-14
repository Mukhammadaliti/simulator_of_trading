import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class CustomButtonSettings extends StatelessWidget {
  const CustomButtonSettings({
    super.key,
    required this.settingsImage,
    required this.settingsText,
    this.onPressed,
  });
  final String settingsImage;
  final String settingsText;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16,
        ),
        child: TextButton(
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xff0A1730),
              side: const BorderSide(color: Colors.white)),
          onPressed: onPressed,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 10,
                ),
                child: SvgPicture.asset(
                  settingsImage,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 16,
                  right: 16,
                ),
                child: Text(
                  settingsText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'SFProText',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
