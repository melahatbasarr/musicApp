import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:music_app/config/theme/custom_colors.dart';

final class CustomWidgets {

  static Text pageTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: CustomColors.orangeText,
        fontSize: 35,
        fontFamily: "Poppins Medium",
      ),
    );
  }

  static AppBar appBar(String title, {bool? backButtonVisibility}) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontFamily: "Poppins Medium",
        ),
      ),
      centerTitle: true,
      leading: Visibility(
        visible: backButtonVisibility ?? true,
        child: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 20),
          ),
        ),
      ),
    );
  }

  static showSnackBar({String? title, required String message}){
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(message,style: const TextStyle(color: Colors.white),),
        duration: const Duration(seconds: 3),
        backgroundColor: CustomColors.orangeText,
        icon: const Icon(Icons.error_outline,color: Colors.white,),
      ),
    );
  }
}