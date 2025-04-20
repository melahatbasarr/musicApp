import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_app/common/widget/custom_widget.dart';
import 'package:music_app/common/widget/defeault_textfield.dart';
import 'package:music_app/common/widget/login_animation.dart';
import 'package:music_app/common/widget/orange_button.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/auth/forgot_password/controller/forgot_password_controller.dart';
import 'package:music_app/features/auth/login/screens/login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  final ForgotPasswordController _controller = Get.put(ForgotPasswordController());
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
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
              "Forgot Password",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins Medium",
              ),
            ),
          ),
          body: Column(
            children: [
              // Başlık
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: CustomWidgets.pageTitle("Reset Password"),
              ),
              
              // Tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomColors.orangeText,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white60,
                  labelStyle: const TextStyle(
                    fontFamily: "Poppins Medium",
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.email_outlined),
                      text: "Email",
                    ),
                    Tab(
                      icon: Icon(Icons.phone_android),
                      text: "Phone",
                    ),
                  ],
                ),
              ),
              
              // Tab içerikleri
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Email tab içeriği
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildEmailForm(),
                    ),
                    
                    // Phone tab içeriği
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: _buildPhoneForm(),
                    ),
                  ],
                ),
              ),
              
              // Giriş sayfasına dön butonu
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  child: CustomWidgets.title(
                    "Back to Login",
                    color: CustomColors.whiteText,
                    underline: true,
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

  // Email ile sıfırlama formu
  Widget _buildEmailForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DefaultTextField(
            title: "Email",
            controller: _controller.emailController,
            iconData: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          OrangeButton(
            title: "Send Reset Link",
            onTap: () => _controller.resetPasswordWithEmail(context),
          ),
        ],
      ),
    );
  }

  // Telefon ile sıfırlama formu
  Widget _buildPhoneForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DefaultTextField(
            title: "Phone Number",
            controller: _controller.phoneController,
            iconData: Icons.phone_android,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          OrangeButton(
            title: "Send Verification Code",
            onTap: () => _controller.resetPasswordWithPhone(context),
          ),
        ],
      ),
    );
  }
}