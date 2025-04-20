import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/login_animation.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/common/widget/password_textfield.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/auth/login/controller/login_controller.dart';
import 'package:music_app/features/auth/register/screens/register_page.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/features/auth/forgot_password/screens/forgot_password_page.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> {
  late final LoginController _controller;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    try {
      _controller = Get.find<LoginController>();
      _controller.emailController = _emailController;
      _controller.passwordController = _passwordController;
    } catch (e) {
      print("Login controller error: $e");
      // Eğer controller bulunamazsa, main.dart'ta genellikle zaten init edilmiştir
      // Ama yine de hata durumunda uygulamanın çökmemesi için önlem alıyoruz
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: CustomColors.darkGreyColor,
          body: ListView(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 150),
            physics: const BouncingScrollPhysics(),
            children: [
              Center(child: CustomWidgets.pageTitle("Sign In")),
              const SizedBox(height: 40),
              DefaultTextField(
                title: "Username",
                controller: _emailController,
                iconData: Icons.person_outline,
              ),
              const SizedBox(height: 15),
              PasswordTextField(
                title: "Password",
                controller: _passwordController,
              ),
              const SizedBox(height: 15),
              _buildForgotPasswordText(),
              const SizedBox(height: 20),
              OrangeButton(
                title: "Sign In",
                onTap: () => _checkFields(),
              ),
              const SizedBox(height: 15),
              _buildRegisterText(),
              const SizedBox(height: 15),
              _buildSocialLoginButton(),
              const SizedBox(height: 15),
              _buildContinueWithoutLoginButton(),
            ],
          ),
        ),
        Obx(() => LoadingAnimation(isLoading: _controller.isLoading.value)),
      ],
    );
  }

  _buildForgotPasswordText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
          ),
          child: CustomWidgets.title("Forgot Password",color:CustomColors.whiteText,underline: true),
        ),
      ],
    );
  }

  _buildRegisterText() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(
            color: Colors.grey,
            fontFamily: "Poppins Regular",
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Sign Up',
              style: const TextStyle(
                color: CustomColors.whiteText,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  try {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterPage()),
                      (route) => false
                    );
                  } catch (e) {
                    print("Navigation error: $e");
                    Get.offAll(() => const RegisterPage());
                  }
                },
            ),
          ],
        ),
      ),
    );
  }

  _checkFields() {
    if (_emailController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Enter your username");
    } else if (_passwordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Enter your password");
    } else {
      _controller.loginUser(
        email: _emailController.text, 
        password: _passwordController.text
      );
    }
  }

  Widget _buildSocialLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/icons/google_icon.png',
              height: 24,
            ),
            const SizedBox(width: 10),
            const Text(
              "Google",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWithoutLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: CustomColors.whiteText,
        ),
        onPressed: () async {
          try {
            // Önce AuthService'i oluştur
            final authService = AuthService();
            
            // Kullanıcıyı misafir olarak ayarla
            await authService.setGuestUser(true);
            await authService.setLoggedIn(false);
            
            if (!mounted) return;
            
            // Direkt olarak Bluetooth sayfasına git
            Get.offAll(() => const NavigatorPage(initialIndex: 1));
          } catch (e) {
            print("Guest login error: $e");
            
            if (!mounted) return;
            
            // Hata mesajı göster
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("An error occurred. Please try again."))
            );
          }
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            "Continue without login",
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Poppins Regular",
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }

  void notify(isSuccess) {
    if (isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const NavigatorPage()),
        (route) => false,
      );
    }
  }
}
