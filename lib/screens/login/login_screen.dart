import 'package:flutter/material.dart';
import '../../services/user_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0; // 0: customer, 1: designer

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please fill in all fields");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print("== LOGIN START ==");
      print("Email: $email");
      print("Password: $password");
      print("Selected index (0=Customer, 1=Designer): $selectedIndex");

      dynamic response;
      if (selectedIndex == 0) {
        response = await UserService.loginCustomer(email, password);
      } else {
        response = await UserService.loginDesigner(email, password);
      }

      print("Response from server: $response");

      if (response != null && response['statusCode'] == 200) {
        _showMessage("Login successful");

        if (selectedIndex == 0) {
          print("Navigating to Customer Homepage");
          Navigator.pushReplacementNamed(context, AppRoutes.customerHomepage);
        } else {
          print("Navigating to Designer Dashboard");
          Navigator.pushReplacementNamed(context, AppRoutes.designerDashboard);
        }
      } else {
        print(
          "Login failed with message: ${response?['message'] ?? 'No message'}",
        );
        _showMessage(response?['message'] ?? "Login failed");
      }
    } catch (e) {
      print("Exception during login: $e");
      _showMessage("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
      print("== LOGIN END ==");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Column(
                children: [
                  Image.asset(
                    'assets/images/full_logo_green.png',
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'LOGIN TO YOUR ACCOUNT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF3F5139),
                ),
              ),
              const SizedBox(height: 8),
              ToggleButtons(
                isSelected: [selectedIndex == 0, selectedIndex == 1],
                onPressed: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                borderRadius: BorderRadius.circular(30),
                selectedColor: Colors.white,
                fillColor: const Color(0xFF3B4F39),
                color: const Color(0xFF3B4F39),
                splashColor: const Color(0x553B4F39),
                hoverColor: const Color(0x223B4F39),
                borderColor: const Color(0xFF3B4F39),
                borderWidth: 1.5,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                constraints: const BoxConstraints(minHeight: 42, minWidth: 120),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Customer'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Designer'),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // TODO: Forgot password logic
                    },
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                    ),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B4F39),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Color(0xFF3B4F39)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
