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
import 'package:music_app/features/auth/forgot_password/screens/forgot_password_page.dart';
import 'package:music_app/features/auth/login/controller/login_controller.dart';
import 'package:music_app/features/auth/register/screens/register_page.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';

final class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

final class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: CustomColors.navyBlueColor,
          body: ListView(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 150),
            physics: const BouncingScrollPhysics(),
            children: [
              CustomWidgets.pageTitle("Sign In"),
              const SizedBox(height: 40),
              DefaultTextField(
                title: "Email Adress",
                controller: _emailController,
                iconData: Icons.email_outlined,
              ),
              const SizedBox(height: 15),
              PasswordTextField(
                title: "Password",
                controller: _passwordController,
              ),
              const SizedBox(height: 15),
              _buildForgotPasswordText(),
              const SizedBox(height: 15),
              OrangeButton(
                title: "Sign In",
                onTap: () => _checkFields(),
              ),
              const SizedBox(height: 15),
              _buildRegisterText(),
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
          child: const Text(
            "Forgot password",
            style: TextStyle(
              color: CustomColors.whiteText,
              fontSize: 14,
            ),
          ),
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
                color: CustomColors.purpleText,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage())),
            ),
          ],
        ),
      ),
    );
  }

  _checkFields() {
    if (_emailController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Enter your e-mail address");
    } else if (_passwordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Enter your password");
    } else {
      _controller.loginUser(
          email: _emailController.text, password: _passwordController.text);
    }
  }

  @override
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
