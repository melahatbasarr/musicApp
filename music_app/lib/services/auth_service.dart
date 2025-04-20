import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _isGuestUserKey = 'is_guest_user';
  static const String _emailKey = 'user_email';
  static const String _usernameKey = 'username';
  static const String _isAdminModeKey = 'is_admin_mode';

  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Check if user is a guest (continued without login)
  Future<bool> isGuestUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isGuestUserKey) ?? false;
  }

  // Check if user is in admin mode
  Future<bool> isAdminMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isAdminModeKey) ?? false;
  }

  // Set user as logged in
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
    // If user logs in, they are no longer a guest
    if (value) {
      await prefs.setBool(_isGuestUserKey, false);
    }
  }

  // Set user as guest
  Future<void> setGuestUser(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isGuestUserKey, value);
  }

  // Set admin mode
  Future<void> setAdminMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAdminModeKey, value);
  }

  // Save user email
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
  }

  // Get user email
  Future<String> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  // Save username
  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
  }

  // Get username
  Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey) ?? '';
  }

  // Log out user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.setBool(_isGuestUserKey, false);
    await prefs.setBool(_isAdminModeKey, false);
    await prefs.remove(_emailKey);
    await prefs.remove(_usernameKey);
  }
} 