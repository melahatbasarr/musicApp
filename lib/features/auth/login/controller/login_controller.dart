// login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/features/auth/login/model/login_model.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import 'package:music_app/common/widget/custom_widget.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;

  void checkFields() {
    if (emailController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "E-posta adresinizi giriniz");
    } else if (passwordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Şifrenizi giriniz");
    } else {
      loginUser(
        email: emailController.text,
        password: passwordController.text,
      );
    }
  }

  Future<void> loginUser({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final loginModel = LoginModel(email: email, password: password);

      bool isSuccess = await loginModel.loginUser();

      if (isSuccess) {
        Get.offAll(() => const NavigatorPage());
      } else {
        CustomWidgets.showSnackBar(message: "E-posta veya şifre hatalı");
      }
    } finally {
      isLoading.value = false;
    }
  }
}
