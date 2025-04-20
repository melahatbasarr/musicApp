import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';

class VerificationController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  
  var isLoading = false.obs;
  var isVerified = false.obs;
  var verificationMethod = "email".obs; // "email" veya "phone"
  var verificationStep = 0.obs; // 0: Method seçimi, 1: Kod doğrulama

  // Kullanıcının seçtiği doğrulama yöntemini belirle
  void setVerificationMethod(String method) {
    verificationMethod.value = method;
  }

  // Doğrulama kodu gönder
  Future<void> sendVerificationCode() async {
    try {
      isLoading.value = true;
      
      if (verificationMethod.value == "email") {
        if (emailController.text.isEmpty) {
          CustomWidgets.showSnackBar(message: "Please enter your email address");
          isLoading.value = false;
          return;
        }
      } else {
        if (phoneController.text.isEmpty) {
          CustomWidgets.showSnackBar(message: "Please enter your phone number");
          isLoading.value = false;
          return;
        }
      }
      
      // API çağrısı simülasyonu
      await Future.delayed(const Duration(seconds: 2));
      
      // Başarılı olduğunu varsayalım
      CustomWidgets.showSnackBar(
        message: "Verification code sent to your ${verificationMethod.value}"
      );
      
      // Bir sonraki adıma geç
      verificationStep.value = 1;
    } catch (e) {
      CustomWidgets.showSnackBar(
        message: "Failed to send verification code: $e"
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Doğrulama kodunu kontrol et
  Future<bool> verifyCode() async {
    try {
      isLoading.value = true;
      
      if (codeController.text.isEmpty) {
        CustomWidgets.showSnackBar(message: "Please enter verification code");
        isLoading.value = false;
        return false;
      }
      
      // API çağrısı simülasyonu
      await Future.delayed(const Duration(seconds: 2));
      
      // Geçerli bir kod olarak kabul edelim (6 haneli)
      if (codeController.text.length == 6 && int.tryParse(codeController.text) != null) {
        isVerified.value = true;
        CustomWidgets.showSnackBar(message: "Verification successful");
        return true;
      } else {
        CustomWidgets.showSnackBar(message: "Invalid verification code");
        return false;
      }
    } catch (e) {
      CustomWidgets.showSnackBar(
        message: "Verification failed: $e"
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // İlk adıma geri dön
  void resetVerification() {
    verificationStep.value = 0;
    codeController.clear();
  }
  
  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }
} 