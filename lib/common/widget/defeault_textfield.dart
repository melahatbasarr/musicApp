import 'package:flutter/material.dart';
import 'package:music_app/config/theme/custom_colors.dart';

final class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final IconData? iconData;

  const DefaultTextField({super.key, required this.title, required this.controller, this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: CustomColors.whiteText,
            fontFamily: "Poppins Regular",
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: CustomColors.purpleText, 
          ),
          decoration: InputDecoration(
            isDense: true,
            fillColor: CustomColors.navyBlueColor,
            filled: true,
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2), 
            ),
            prefixIcon: iconData == null ? null : Icon(iconData, color: CustomColors.whiteText),
          ),
        ),
      ],
    );
  }
}
