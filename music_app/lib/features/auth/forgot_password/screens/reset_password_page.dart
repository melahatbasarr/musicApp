import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/login_animation.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/auth/forgot_password/controller/reset_password_controller.dart';
import 'package:music_app/features/auth/login/screens/login_page.dart';
// import 'package:music_app/navigation/routes.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;
  final String? phone;
  
  const ResetPasswordPage({
    super.key,
    this.email,
    this.phone,
  });

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final ResetPasswordController _controller = Get.put(ResetPasswordController());
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: CustomColors.darkGreyColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Reset Password",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins Medium",
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(
                child: CustomWidgets.pageTitle("Create New Password"),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Your new password must be different from previously used passwords.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontFamily: "Poppins Regular",
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Yeni şifre alanı
              DefaultTextField(
                title: "New Password",
                controller: _passwordController,
                iconData: Icons.lock,
              ),
              
              const SizedBox(height: 20),
              
              // Şifre tekrar alanı
              DefaultTextField(
                title: "Confirm Password",
                controller: _confirmPasswordController,
                iconData: Icons.lock,
              ),
              
              const SizedBox(height: 30),
              
              // Şifre sıfırlama butonu
              OrangeButton(
                title: "Reset Password",
                onTap: _resetPassword,
              ),
            ],
          ),
        ),
        Obx(() => LoadingAnimation(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  // Şifre sıfırlama işlemi
  void _resetPassword() async {
    if (_passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please fill in all fields");
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      CustomWidgets.showSnackBar(message: "Passwords do not match");
      return;
    }
    
    if (_passwordController.text.length < 6) {
      CustomWidgets.showSnackBar(message: "Password must be at least 6 characters");
      return;
    }
    
    final isSuccess = await _controller.resetPassword(
      _passwordController.text,
      email: widget.email,
      phone: widget.phone,
    );
    
    if (isSuccess) {
      CustomWidgets.showSnackBar(
        message: "Password has been reset successfully",
      );
      
      // Başarılı şifre sıfırlamadan sonra giriş sayfasına yönlendir
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }
} 