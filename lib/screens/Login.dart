import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lpms/theme/app_color.dart';

import '../models/IPInfo.dart';
import 'Encryption.dart';
class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Replace with your API endpoint
      var response = await http.post(
        Uri.parse('https://example.com/api/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": "Invalid username or password"};
      }
    } catch (error) {
      return {"success": false, "message": "An error occurred. Please try again."};
    }
  }

  Future<IpInfo> fetchIpInfo() async {
    final response = await http.get(Uri.parse("https://ipapi.co/json/"));
    final int statusCode = response.statusCode;
    if (statusCode <= 200 || statusCode > 400) {
      final data = json.decode(response.body);
      debugPrint(IpInfo.fromJson(data).toString());
      return IpInfo.fromJson(data);
    } else {
      throw Exception('Failed to load IP information');
    }
  }
}



class LoginPage extends StatefulWidget {
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
  IpInfo? ipInfo;
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    // Call the AuthService login function
    var result = await _authService.login(username, password);

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
      print("check_Api=======${fetchedIpInfo.ip}");
      debugPrint(encryptionService.encryptUsingRandomKey("Kale@123`223.185.15.90", "userKey"));
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
      appBar: AppBar(title: Text('Login'),
      backgroundColor: AppColors.primary),
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
                decoration: InputDecoration(labelText: 'Username'),
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
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              // Error message display
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
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
                    ? CircularProgressIndicator(
                  color: Colors.white,
                )
                    : Text('Login',style: TextStyle(color: Colors.white),),
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