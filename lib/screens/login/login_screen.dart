import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';

// Thêm import này
import '../customerHomepage/customer_homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0; // 0: customer, 1: designer

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
                children: const [
                  Text(
                    'SnapRoom',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B4F39),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Style Your Space, Your Way.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF3B4F39),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'LOGIN TO YOUR ACCOUTN',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
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
                borderRadius: BorderRadius.circular(20),
                selectedColor: Colors.white,
                fillColor: const Color(0xFF3B4F39),
                color: const Color(0xFF3B4F39),
                textStyle: const TextStyle(fontSize: 12),
                constraints: const BoxConstraints(minHeight: 36, minWidth: 120),
                children: const [Text('Customer'), Text('Designer')],
              ),
              const SizedBox(height: 30),
              const CustomTextField(
                hintText: 'Username', icon: Icons.person),
              const SizedBox(height: 20),
              const CustomTextField(
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
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
                onPressed: () {
                  if (selectedIndex == 0) {
                    // Điều hướng đến CustomerHomePage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerHomePage(),
                      ),
                    );
                  } else {
                    // Tạm thời chưa xử lý designer
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Designer login not implemented yet')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B4F39),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Login', style: TextStyle(fontSize: 16)),
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
                      style: TextStyle(color: Color(0xFF3B4F39)),),
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
