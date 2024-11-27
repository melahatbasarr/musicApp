import 'package:flutter/material.dart';
import 'package:music_app/config/theme/custom_colors.dart';

final class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String title;

  const PasswordTextField(
      {super.key, required this.title, required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

final class _PasswordTextFieldState extends State<PasswordTextField> {
  bool visibility = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            color: CustomColors.whiteText,
            fontFamily: "Poppins Regular",
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: widget.controller,
          obscureText: !visibility,
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
              borderSide: BorderSide(
                  color: Colors.white, width: 2), // Alt kısımdan beyaz çizgi
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 2),
            ),
            prefixIcon:
                const Icon(Icons.lock_outline, color: CustomColors.whiteText),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  visibility = !visibility;
                });
              },
              icon: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
                color: CustomColors.whiteText,
              ),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
