import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/services/auth_service.dart';
import 'package:music_app/config/theme/custom_colors.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import 'package:get/get.dart';
import 'package:music_app/features/auth/login/screens/login_page.dart';

class AuthWrapper extends StatelessWidget {
  final Widget child;
  final bool isBluetoothScreen;

  const AuthWrapper({
    Key? key,
    required this.child,
    this.isBluetoothScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _shouldShowLoginPrompt(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return child; // While loading, just show the child
        }

        final shouldShowPrompt = snapshot.data!;
        
        if (shouldShowPrompt) {
          return Stack(
            children: [
              child,
              // Full page overlay with semi-transparent background
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {}, // Intercept taps to prevent interactions with background
                  child: Container(
                    color: Colors.black54,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Center(
                        child: _buildLoginModal(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return child;
      },
    );
  }

  Widget _buildLoginModal(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: CustomColors.darkGreyColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Login Required',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins Medium',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Please login to view this page.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontFamily: 'Poppins Regular',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Login button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  try {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false
                    );
                  } catch (e) {
                    print("Navigation error: $e");
                    // GetX yöntemini deneyelim
                    Get.offAll(() => const LoginPage());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.orangeText,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins Medium',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Sign Up link
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/register',
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white38),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins Medium',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _shouldShowLoginPrompt() async {
    try {
      final authService = AuthService();
      final isLoggedIn = await authService.isLoggedIn();
      final isGuest = await authService.isGuestUser();
      
      // Sadece misafir kullanıcı ise ve Bluetooth ekranı değilse 
      return isGuest && !isLoggedIn && !isBluetoothScreen;
    } catch (e) {
      print("AuthWrapper error: $e");
      return false; // Hata durumunda içeriği göster
    }
  }
} 