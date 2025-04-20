import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/login_animation.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/auth/forgot_password/controller/verification_controller.dart';
import 'package:music_app/features/auth/forgot_password/screens/reset_password_page.dart';

class VerificationPage extends StatefulWidget {
  final String? initialEmail;
  final String? initialPhone;
  
  const VerificationPage({
    super.key,
    this.initialEmail,
    this.initialPhone,
  });

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final VerificationController _controller = Get.put(VerificationController());

  @override
  void initState() {
    super.initState();
    
    // Hangi doğrulama yöntemi kullanılacak?
    if (widget.initialEmail != null && widget.initialEmail!.isNotEmpty) {
      _controller.verificationMethod.value = "email";
      _controller.emailController.text = widget.initialEmail!;
      // Eğer email bilgisi verildiyse, bir sonraki adıma geç
      _controller.verificationStep.value = 1;
      // Kod gönderme işlemini başlat
      _controller.sendVerificationCode();
    } else if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _controller.verificationMethod.value = "phone";
      _controller.phoneController.text = widget.initialPhone!;
      // Eğer telefon bilgisi verildiyse, bir sonraki adıma geç
      _controller.verificationStep.value = 1;
      // Kod gönderme işlemini başlat
      _controller.sendVerificationCode();
    }
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
              "Account Verification",
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
                child: CustomWidgets.pageTitle("Verify Account"),
              ),
              const SizedBox(height: 20),
              
              // Doğrulama adımı: adım 0 ise yöntem seçme, adım 1 ise kod doğrulama
              Obx(() => _controller.verificationStep.value == 0
                ? _buildMethodSelection()
                : _buildCodeVerification()
              ),
            ],
          ),
        ),
        Obx(() => LoadingAnimation(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  // Doğrulama yöntemi seçim ekranı
  Widget _buildMethodSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select a verification method to reset your password:",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: "Poppins Regular",
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 30),
        
        // Email doğrulama seçeneği
        Obx(() => _buildVerificationOption(
          title: "Email Verification",
          description: "Receive a verification code via email",
          icon: Icons.email_outlined,
          isSelected: _controller.verificationMethod.value == "email",
          onTap: () => _controller.setVerificationMethod("email"),
        )),
        
        const SizedBox(height: 15),
        
        // Telefon doğrulama seçeneği
        Obx(() => _buildVerificationOption(
          title: "Phone Verification",
          description: "Receive SMS with verification code",
          icon: Icons.phone_android,
          isSelected: _controller.verificationMethod.value == "phone",
          onTap: () => _controller.setVerificationMethod("phone"),
        )),
        
        const SizedBox(height: 30),
        
        // Email doğrulama için input
        Obx(() => _controller.verificationMethod.value == "email"
          ? Column(
              children: [
                DefaultTextField(
                  title: "Email Address",
                  controller: _controller.emailController,
                  iconData: Icons.email_outlined,
                ),
                const SizedBox(height: 15),
              ],
            )
          : const SizedBox.shrink()
        ),
        
        // Telefon doğrulama için input
        Obx(() => _controller.verificationMethod.value == "phone"
          ? Column(
              children: [
                DefaultTextField(
                  title: "Phone Number",
                  controller: _controller.phoneController,
                  iconData: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
              ],
            )
          : const SizedBox.shrink()
        ),
        
        OrangeButton(
          title: "Send Verification Code",
          onTap: () => _controller.sendVerificationCode(),
        ),
      ],
    );
  }

  // Kod doğrulama ekranı
  Widget _buildCodeVerification() {
    return Column(
      children: [
        const Text(
          "Enter the verification code we sent to verify your account.",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontFamily: "Poppins Regular",
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        
        // Seçilen doğrulama yöntemine göre bilgi metni
        Obx(() => Text(
          _controller.verificationMethod.value == "email"
            ? "We've sent a code to: ${_controller.emailController.text}"
            : "We've sent an SMS to: ${_controller.phoneController.text}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins Medium",
          ),
          textAlign: TextAlign.center,
        )),
        
        const SizedBox(height: 30),
        
        // Doğrulama kodu giriş alanı
        DefaultTextField(
          title: "Verification Code",
          controller: _controller.codeController,
          iconData: Icons.security,
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        
        const SizedBox(height: 20),
        
        OrangeButton(
          title: "Verify",
          onTap: _verifyCode,
        ),
        
        const SizedBox(height: 20),
        
        // Yeniden kod gönderme ve farklı yöntem seçme butonları
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => _controller.sendVerificationCode(),
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
            TextButton(
              onPressed: () => _controller.resetVerification(),
              child: const Text(
                "Try Different Method",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Poppins Regular",
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Doğrulama yöntemi seçim kartı
  Widget _buildVerificationOption({
    required String title,
    required String description,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade800 : Colors.grey.shade900,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? CustomColors.orangeText : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? CustomColors.orangeText : Colors.white,
              size: 32,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? CustomColors.orangeText : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins Medium",
                    ),
                  ),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "Poppins Regular",
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: CustomColors.orangeText,
            ),
          ],
        ),
      ),
    );
  }

  // Doğrulama kodu ile doğrulama yapma işlemi
  void _verifyCode() async {
    final isVerified = await _controller.verifyCode();
    
    if (isVerified && mounted) {
      // Doğrulama başarılıysa şifre sıfırlama sayfasına yönlendir
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(
            email: _controller.verificationMethod.value == "email" 
              ? _controller.emailController.text 
              : null,
            phone: _controller.verificationMethod.value == "phone" 
              ? _controller.phoneController.text 
              : null,
          ),
        ),
      );
    }
  }
} 