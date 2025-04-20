import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/features/auth/forgot_password/repository/forgot_password_repository.dart';
import 'package:music_app/features/auth/forgot_password/screens/verification_code_page.dart';

class ForgotPasswordController extends GetxController {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();

  final RxBool isLoading = false.obs;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Email ile şifre sıfırlama isteği gönderir
  Future<void> resetPasswordWithEmail(BuildContext context) async {
    String email = emailController.text.trim();
    if (email.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your email address");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      CustomWidgets.showSnackBar(message: "Please enter a valid email address");
      return;
    }

    isLoading.value = true;
    try {
      bool success = await _repository.sendPasswordResetEmail(email);
      if (success) {
        // Doğrulama ekranına yönlendir
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodePage(email: email),
          ),
        );
      }
    } catch (e) {
      CustomWidgets.showSnackBar(message: "Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Telefon ile şifre sıfırlama isteği gönderir
  Future<void> resetPasswordWithPhone(BuildContext context) async {
    String phone = phoneController.text.trim();
    if (phone.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your phone number");
      return;
    }

    if (phone.length < 10) {
      CustomWidgets.showSnackBar(message: "Please enter a valid phone number");
      return;
    }

    isLoading.value = true;
    try {
      bool success = await _repository.sendPasswordResetPhone(phone);
      if (success) {
        // Doğrulama ekranına yönlendir
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodePage(phone: phone),
          ),
        );
      }
    } catch (e) {
      CustomWidgets.showSnackBar(message: "Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
