import 'package:flutter/material.dart';
import 'package:medicine_reminder/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medicine_reminder/view/homepage.dart'; // Import HealthDashboard instead of homepage

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check login status on app startup
  void _checkLoginStatus() async {
    try {
      bool isLoggedIn = await _authController.checkLoginStatus();
      if (isLoggedIn && mounted) {  // Added mounted check for safety
        // Navigate to HealthDashboard instead of HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HealthDashboard()),
        );
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
    }
  }

  // Login function
  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final success = await _authController.loginUser(
          _emailController.text,
          _passwordController.text,
        );

        if (success && mounted) {  // Added mounted check
          // Save login status
          await _authController.setLoginStatus(true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );

          // Navigate to HealthDashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HealthDashboard()),
          );
        } else if (mounted) {  // Added mounted check
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid credentials')),
          );
        }
      } catch (e) {
        if (mounted) {  // Added mounted check
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Center(
                child: Icon(Icons.medical_services, size: 50, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                obscureText: true,
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your password' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text('New here? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}