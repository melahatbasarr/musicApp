import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/core/resources/data_state.dart';
import 'package:music_app/features/auth/register/repository/register_repository.dart';
import 'package:music_app/services/auth_service.dart';

final class RegisterController extends GetxController {
  var isLoading = false.obs;

  final RegisterRepository registerRepository;

  RegisterController({required this.registerRepository});

  void registerUser({
    required String username,
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) {
    isLoading.value = true;
    
    // Simüle edilmiş bir API çağrısı
    Future.delayed(const Duration(seconds: 1), () async {
      try {
        // Başarılı kayıt senaryosu
        isLoading.value = false;
        
        // Auth servisine kayıt bilgilerini kaydet
        final authService = AuthService();
        await authService.saveUsername(username);
        await authService.saveEmail(email);
        await authService.setLoggedIn(true);
        await authService.setGuestUser(false);
        
        onSuccess();
      } catch (e) {
        isLoading.value = false;
        onFailure();
        print("Register error: $e");
        
        CustomWidgets.showSnackBar(
          message: "Registration failed. Please try again."
        );
      }
    });
  }
}
