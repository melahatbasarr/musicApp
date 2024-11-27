// login_model.dart

class LoginModel {
  final String email;
  final String password;

  LoginModel({required this.email, required this.password});

  // Perform the login action (simplified)
  Future<bool> loginUser() async {
    // Simulate network delay for login (you can replace this with real API call)
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation: check if email and password match predefined values
    return email == "test@example.com" && password == "password123";
  }
}
