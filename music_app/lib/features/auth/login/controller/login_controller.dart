import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/core/resources/data_state.dart';
import 'package:music_app/features/auth/login/repository/login_repository.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/services/auth_service.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;

  final LoginRepository loginRepository;

  // Constructor ile Repository'yi enjekte ediyoruz.
  LoginController({required this.loginRepository});

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
      // Admin girişi kontrolü
      if (email.toLowerCase() == "admin" && password == "1") {
        await _loginAsAdmin();
        return;
      }

      isLoading.value = true;

      // Simüle edilmiş bir API çağrısı
      await Future.delayed(const Duration(seconds: 1));
      
      // Set user as logged in
      final authService = AuthService();
      await authService.saveEmail(email);
      await authService.saveUsername(email); // Email'i username olarak da kullan
      await authService.setLoggedIn(true);
      await authService.setGuestUser(false);
      
      // Clear controllers
      emailController.clear();
      passwordController.clear();
      
      isLoading.value = false;
      
      // Navigate to home page
      Get.offAll(() => const NavigatorPage());
    } catch (e) {
      isLoading.value = false;
      CustomWidgets.showSnackBar(message: "Login failed: $e");
    }
  }

  /// Admin girişi işlemi
  Future<void> _loginAsAdmin() async {
    isLoading.value = true;
    
    try {
      // Admin yetkisiyle giriş yap
      final authService = AuthService();
      await authService.saveEmail("admin@test.com");
      await authService.saveUsername("Admin");
      await authService.setLoggedIn(true);
      await authService.setGuestUser(false);
      await authService.setAdminMode(true); // Admin modunu aktifleştir
      
      // Clear controllers
      emailController.clear();
      passwordController.clear();
      
      CustomWidgets.showSnackBar(message: "Admin olarak giriş yapıldı");
      
      // Ana sayfaya yönlendir
      Get.offAll(() => const NavigatorPage());
    } catch (e) {
      CustomWidgets.showSnackBar(message: "Admin girişi başarısız: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void loginAsGuest(BuildContext context) async {
    isLoading.value = true;

    try {
      final authService = AuthService();
      await authService.setGuestUser(true);
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavigatorPage()),
        (route) => false,
      );
    } catch (e) {
      CustomWidgets.showSnackBar(message: "Guest login failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
