import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_app/features/auth/username/controller/username_controller.dart';
import 'package:music_app/features/auth/username/repository/username_repository.dart';
import 'package:provider/provider.dart';
import 'package:music_app/features/auth/login/controller/login_controller.dart';
import 'package:music_app/features/auth/login/repository/login_repository.dart';
import 'package:music_app/features/auth/register/controller/register_controller.dart';
import 'package:music_app/features/auth/register/repository/register_repository.dart';
import 'package:music_app/features/player/controller/player_controller.dart';
import 'package:music_app/features/settings/update_profile/controller/update_profile_controller.dart';
import 'package:music_app/features/splash/screens/splash_page.dart';
import 'package:music_app/features/auth/login/screens/login_page.dart';
import 'package:music_app/features/navigator/screens/navigator_page.dart';
import 'package:music_app/features/auth/register/screens/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // GetX bağımlılıkları başlatılıyor
    final loginRepository = LoginRepositoryImpl();
    final registerRepository = RegisterRepositoryImpl();
    final usernameRepository = UserNameRepositoryImpl();

    // Controller'ları kalıcı olarak ekliyoruz
    Get.put<LoginController>(
        LoginController(loginRepository: loginRepository), permanent: true);
    Get.put<RegisterController>(
        RegisterController(registerRepository: registerRepository), permanent: true);
    Get.put<UsernameController>(
        UsernameController(usernameRepository: usernameRepository), permanent: true);
    Get.put(PlayerController(), permanent: true);
    
    // Uygulamayı başlatma
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UpdateProfileController()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print("Application initialization error: $e");
    // Basit bir hata ekranı göster
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: Text(
              "An error occurred while starting the app. Please restart.",
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: "Poppins Medium",
      ),
      home: const SplashPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/bluetooth': (context) => const NavigatorPage(initialIndex: 1),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
