import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/common/widget/password_textfield.dart';
import 'package:music_app/features/auth/register/controller/register_controller.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import '../../../../config/theme/custom_colors.dart';
import '../../../../features/auth/login/screens/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controller = Get.find<RegisterController>();
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkGreyColor,
      body: ListView(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 150),
        physics: const BouncingScrollPhysics(),
        children: [
          Center(child: CustomWidgets.pageTitle("Sign Up")),
          const SizedBox(height: 30),
          
          DefaultTextField(
              title: "Username",
              controller: _usernameController,
              iconData: Icons.person_outline),
          const SizedBox(height: 12),
          PasswordTextField(title: "Password", controller: _passwordController),
          const SizedBox(height: 40),
          OrangeButton(title: "Sign Up", onTap: () => _checkFields()),
          const SizedBox(height: 10),
          _buildLoginText(),
        ],
      ),
    );
  }

  _buildLoginText() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Already have an account ? ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontFamily: "Poppins Regular",
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: CustomColors.orangeText,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins Medium",
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }

  _checkFields() {
    if (_usernameController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your username");
    } else if (_passwordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your password");
    } else {
      _controller.registerUser(
        username: _usernameController.text,
        email: _usernameController.text,
        password: _passwordController.text,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  // Success handler
  void _onSuccess() {
    // Doğrudan ana sayfaya yönlendir
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const NavigatorPage()),
      (route) => false,
    );
  }

  // Failure handler
  void _onFailure() {}
}
