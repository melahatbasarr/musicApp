import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/features/auth/forgot_password/repository/forgot_password_repository.dart';

class ResetPasswordController extends GetxController {
  final ForgotPasswordRepository _repository = ForgotPasswordRepository();
  final RxBool isLoading = false.obs;

  /// Şifre sıfırlama işlemini gerçekleştirir
  Future<bool> resetPassword(String newPassword, {String? email, String? phone}) async {
    if (newPassword.isEmpty) {
      CustomWidgets.showSnackBar(message: "Password cannot be empty");
      return false;
    }

    if (email == null && phone == null) {
      CustomWidgets.showSnackBar(message: "Email or phone is required for password reset");
      return false;
    }

    isLoading.value = true;
    try {
      final bool isSuccess = await _repository.resetPassword(
        newPassword,
        email: email,
        phone: phone,
      );
      
      if (isSuccess) {
        return true;
      } else {
        CustomWidgets.showSnackBar(
          message: "Failed to reset password. Please try again.",
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