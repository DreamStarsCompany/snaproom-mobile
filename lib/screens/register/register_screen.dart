import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../routes/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int selectedIndex = 0; // 0: Customer, 1: Designer

  final usernameField = const CustomTextField(
    hintText: 'Username',
    icon: Icons.person,
  );
  final emailField = const CustomTextField(
    hintText: 'Gmail',
    icon: Icons.email,
  );
  final portfolioField = const CustomTextField(
    hintText: 'Portfolio Link',
    icon: Icons.work,
  );
  final passwordField = const CustomTextField(
    hintText: 'Password',
    icon: Icons.lock,
    obscureText: true,
  );
  final confirmPasswordField = const CustomTextField(
    hintText: 'Confirm Password',
    icon: Icons.lock,
    obscureText: true,
  );
  

  @override
  Widget build(BuildContext context) {
    final commonFields = <Widget>[
      const SizedBox(height: 20),
      usernameField,
      const SizedBox(height: 16),
      emailField,
      const SizedBox(height: 16),
      passwordField,
      const SizedBox(height: 16),
      confirmPasswordField,
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'SnapRoom',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3B4F39),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Style Your Space, Your Way.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF3B4F39),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'CREATE YOUR NEW ACCOUNT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3F5139),
                ),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 24),

              if (selectedIndex == 0)
                Expanded(child: Column(children: commonFields))
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ...commonFields,
                        const SizedBox(height: 16),
                        portfolioField,
                        const SizedBox(height: 28), 
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 28),

              ElevatedButton(
                onPressed: () {
                  // TODO: Handle register logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3B4F39),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color(0xFF3B4F39)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
