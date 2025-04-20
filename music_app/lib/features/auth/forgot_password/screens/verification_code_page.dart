import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/login_animation.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/auth/forgot_password/controller/verification_code_controller.dart';
import 'package:music_app/features/auth/forgot_password/screens/reset_password_page.dart';

class VerificationCodePage extends StatefulWidget {
  final String? email;
  final String? phone;
  
  const VerificationCodePage({
    super.key,
    this.email,
    this.phone,
  });

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final VerificationCodeController _controller = Get.put(VerificationCodeController());
  final TextEditingController _verificationCodeController = TextEditingController();
  
  String get contactInfo => widget.email ?? widget.phone ?? "";
  String get verificationType => widget.email != null ? "email" : "phone";

  @override
  void initState() {
    super.initState();
    // Doğrulama kodu gönder
    _controller.sendVerificationCode(contactInfo, verificationType);
  }
  
  @override
  void dispose() {
    _verificationCodeController.dispose();
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
            title: Text(
              "${verificationType == 'email' ? 'Email' : 'Phone'} Verification",
              style: const TextStyle(
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
                child: CustomWidgets.pageTitle("Verify Your Account"),
              ),
              const SizedBox(height: 20),
              _buildInfoText(),
              const SizedBox(height: 30),
              
              // Doğrulama kodu giriş alanı
              DefaultTextField(
                title: "Verification Code",
                controller: _verificationCodeController,
                iconData: Icons.security,
                keyboardType: TextInputType.number,
                maxLength: 6,
              ),
              
              const SizedBox(height: 20),
              
              // Doğrulama butonu
              OrangeButton(
                title: "Verify Code",
                onTap: _verifyCode,
              ),
              
              const SizedBox(height: 15),
              
              // Yeniden kod gönderme butonu
              Center(
                child: TextButton(
                  onPressed: () => _controller.sendVerificationCode(contactInfo, verificationType),
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Poppins Regular",
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(() => LoadingAnimation(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  Widget _buildInfoText() {
    String message = verificationType == 'email'
        ? "We've sent a verification code to your email address: $contactInfo"
        : "We've sent a verification code via SMS to your phone number: $contactInfo";
    
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontFamily: "Poppins Regular",
      ),
    );
  }

  // Doğrulama kodunu doğrulama işlemi
  void _verifyCode() async {
    if (_verificationCodeController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter verification code");
      return;
    }
    
    final isSuccess = await _controller.verifyCode(_verificationCodeController.text);
    
    if (isSuccess && mounted) {
      // Şifre sıfırlama sayfasına yönlendir
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(
            email: widget.email,
            phone: widget.phone,
          ),
        ),
      );
    }
  }
} 