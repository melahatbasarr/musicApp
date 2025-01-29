import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/common/widget/password_textfield.dart';
import 'package:music_app/features/auth/login/screens/login_page.dart';
import 'package:music_app/features/auth/register/controller/register_controller.dart';
import '../../../../config/theme/custom_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterController _controller = Get.find<RegisterController>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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
              title: "First Name",
              controller: _nameController,
              iconData: Icons.person_outline),
          const SizedBox(height: 12),
          DefaultTextField(
              title: "Last Name",
              controller: _surnameController,
              iconData: Icons.person_outline),
          const SizedBox(height: 12),
          DefaultTextField(
              title: "Email",
              controller: _emailController,
              iconData: Icons.email_outlined),
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
            fontFamily: "Poppins Regular",
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Sign In',
              style: const TextStyle(
                color: CustomColors.whiteText,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  _checkFields() {
    if (_nameController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your first name");
    } else if (_surnameController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your last name");
    } else if (_emailController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your email");
    } else if (_passwordController.text.isEmpty) {
      CustomWidgets.showSnackBar(message: "Please enter your password");
    } else {
      _controller.registerUser(
        firstName: _nameController.text,
        lastName: _surnameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        onSuccess: _onSuccess,
        onFailure: _onFailure,
      );
    }
  }

  // Success handler
  void _onSuccess() {
    /*
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage()),
      (route) => false,
    );*/

    Get.offAll(() => const LoginPage());
  }

  // Failure handler
  void _onFailure() {}
}
