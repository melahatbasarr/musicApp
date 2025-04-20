import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/features/auth/forgot_password/repository/forgot_password_repository.dart';

class VerificationCodeController extends GetxController {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();
  final RxBool isLoading = false.obs;
  final RxString verificationId = ''.obs;

  /// Doğrulama kodu gönderir
  Future<void> sendVerificationCode(String contactInfo, String type) async {
    if (contactInfo.isEmpty) {
      CustomWidgets.showSnackBar(message: "Contact information is missing");
      return;
    }

    isLoading.value = true;
    try {
      String? id;
      if (type == 'email') {
        id = await _repository.sendPasswordResetEmailCode(contactInfo);
      } else {
        id = await _repository.sendPasswordResetPhoneCode(contactInfo);
      }
      
      if (id != null) {
        verificationId.value = id;
        CustomWidgets.showSnackBar(
          message: "Verification code sent successfully",
        );
      } else {
        CustomWidgets.showSnackBar(
          message: "Failed to send verification code. Please try again.",
        );
      }
    } catch (e) {
      CustomWidgets.showSnackBar(
        message: "Error: ${e.toString()}",
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Doğrulama kodunu doğrular
  Future<bool> verifyCode(String code) async {
    if (code.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter verification code");
      return false;
    }

    if (verificationId.value.isEmpty) {
      CustomWidgets.showSnackBar(message: "Verification ID is missing. Please request a new code.");
      return false;
    }

    isLoading.value = true;
    try {
      final bool isSuccess = await _repository.verifyPasswordResetCode(verificationId.value, code);
      
      if (isSuccess) {
        CustomWidgets.showSnackBar(
          message: "Verification successful",
        );
        return true;
      } else {
        CustomWidgets.showSnackBar(
          message: "Invalid verification code. Please try again.",
        );
        return false;
      }
    } catch (e) {
      CustomWidgets.showSnackBar(
        message: "Error: ${e.toString()}",
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
} 