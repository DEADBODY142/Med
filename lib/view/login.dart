import 'package:flutter/material.dart';
import 'package:medicine_reminder/controller/controller.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'homepage.dart'; // Import the HealthDashboard page
import 'dart:convert';
import 'package:http/http.dart' as http;

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
      if (isLoggedIn) {
        // If the user is already logged in, navigate directly to the HealthDashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HealthDashboard()),
        );
      }
    } catch (e) {
      debugPrint('Error checking login status: $e');
    }
  }

  // Simulated login function with SharedPreferences
  // void _login() async {
  //   if (_formKey.currentState!.validate()) {
  //     final success = await _authController.loginUser(
  //       _emailController.text,
  //       _passwordController.text,
  //     );

  //     if (success) {
  //       // Save login status using SharedPreferences
  //       await _authController.setLoginStatus(true);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Login successful!')),
  //       );

  //       // Navigate to the HealthDashboard page (home page)
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => HealthDashboard()),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Invalid credentials')),
  //       );
  //     }
  //   }
  // }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final String baseUrl = 'http://127.0.0.1:5000'; // Use '10.0.2.2' for Android Emulator or your server IP for physical devices

      try {
        final response = await http.post(
          Uri.parse('$baseUrl/login'), // Flask API route for login
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);

          if (responseData['success']) {
            // Save login status using SharedPreferences
            await _authController.setLoginStatus(true);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login successful!')),
            );

            // Navigate to the HealthDashboard page (home page)
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HealthDashboard()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(responseData['message'] ?? 'Invalid credentials')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to connect to the server: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign In'),
        backgroundColor: Colors.blue, // Blue color for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Icon(Icons.medical_services, size: 50, color: Colors.blue), // Medicine-related icon at the top
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                validator: (value) {
                  if (value!.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.blue),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter your password' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Sign In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue color for the button
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: Text('New here? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
