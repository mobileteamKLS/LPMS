import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lpms/theme/app_color.dart';

import '../api/auth.dart';
import '../models/IPInfo.dart';
import 'Encryption.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final EncryptionService encryptionService = EncryptionService();
  bool _isLoading = false;
  String? _errorMessage;
  late IpInfo ipInfo;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    var result = await _authService.getUserAuthenticationDetails(
        username,
        "",
        password,
        ipInfo.ip,
        ipInfo.city,
        ipInfo.country,
        ipInfo.org,
        "",
        "",
        "");

    setState(() {
      _isLoading = false;
    });

    if (result['success']) {
      // Navigate to another screen on success
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message
      setState(() {
        _errorMessage = result['message'];
      });
    }
  }

  Future<void> fetchIpInfo() async {
    try {
      final fetchedIpInfo = await _authService.fetchIpInfo();

      debugPrint(encryptionService.encryptUsingRandomKey(
          "Kale@123`223.185.15.90", "61"));
      setState(() {
        ipInfo = fetchedIpInfo;
      });
    } catch (e) {
      setState(() {
        // Update the state to reflect the error if needed
      });
      print('Failed to load IP information: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchIpInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login'), backgroundColor: AppColors.primary),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Username field
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),

              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Error message display
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Login button
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _handleLogin();
                        }
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
