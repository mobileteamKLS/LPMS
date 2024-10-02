import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    var queryParams = {
      "LoginName": "lpaiadmin@dockerbike.com",
      "OTPGenerationCode": "",
      "LoginPassword": "Kale@123",
      "IpAddress": ipInfo.ip,
      "IpCity": ipInfo.city,
      "IpCountry": ipInfo.country,
      "IpOrg": ipInfo.org,
      "UserAgent": "",
      "LogonType": "",
      "BusinesslineId": "",
    };

    var result = await _authService.getUserAuthenticationDetails("api_login/Login/GetUserAuthenticationDetails",queryParams);

    setState(() {
      _isLoading = false;
    });
    print(result);
    // if (result['success']) {
    //   // Navigate to another screen on success
    //   Navigator.pushReplacementNamed(context, '/home');
    // } else {
    //   // Show error message
    //   setState(() {
    //     _errorMessage = result['message'];
    //   });
    // }
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
    resizeToAvoidBottomInset: false,
      body:Stack(
        children: [
          Column(
            children: [
              Container(
                height:268.h,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0057D8),
                      Color(0xFF1c86ff),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Container(
                height: (640-268).h,
                color: AppColors.background,
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .25,
                right: 12.0,
                left: 12.0),
            child: Container(
              height: 500.h,
              width: 350.w,

              child: Card(
                color: Colors.white,
                surfaceTintColor: Colors.white,
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child:  Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 8,top: 16),
                           child: Row(
                             children: [
                               GestureDetector(onTap: (){}, child: const Icon(Icons.arrow_back_ios)),
                               const Text("Sign In",style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                             ],
                           ),
                         ),
                        SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(labelText: 'User Id'),
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
                        Container(

                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF0057D8),
                                Color(0xFF1c86ff),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
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
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
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
