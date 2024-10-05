import 'dart:convert';

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
  late int key;
  bool isSwitched = false;
  final AuthService authService = AuthService();

  Future<void> _handleLogin() async {
    debugPrint(encryptionService.encryptUsingRandomKey(
        "Kale@123`${ipInfo.ip}", "$key"));
    var pwd = encryptionService.encryptUsingRandomKey(
        "Kale@123`${ipInfo.ip}", "$key");
    debugPrint(encryptionService.decryptUsingRandomKey(pwd, "$key"));
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    var queryParams = {
      "LoginName": "lpaiadmin@dockerbike.com",
      "OTPGenerationCode": "",
      "LoginPassword": pwd
      ,
      "IpAddress": ipInfo.ip,
      "IpCity": ipInfo.city,
      "IpCountry": ipInfo.country,
      "IpOrg": ipInfo.org,
      "UserAgent": "",
      "LogonType": "",
      "BusinesslineId": "",
    };

    var headers={
      'accept': 'application/json, text/plain, */*',
      'accept-language': 'en-US,en;q=0.9',
      'authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjQwMDciLCJyb2xlIjoiV2ViQXBwVXNlciIsIm5iZiI6MTcyNzkzNTc1MywiZXhwIjoxNzI3OTcxNzUzLCJpYXQiOjE3Mjc5MzU3NTN9.VIB5aDv7icxRJR2Ohi7uhGrRFyPuJghsfpKOoOW6I1M',
      'browser': 'Brave',
      'communityadminorgid': '11157',
      'content-type': 'application/json',
      'ipaddress': '115.247.234.14',
      'ipcity': 'Mumbai',
      'ipcountry': 'India',
      'iporg': 'Reliance Jio Infocomm Limited',
      'offset': '1726062551',
      'priority': 'u=1, i,',
      'roleid': '4044',
      'screenid': 'null',
      'screenname': 'null',
      'sec-ch-ua': '\\Chromium\\;v=\\128\\, \\Not;A=Brand\\;v=\\24\\, \\Microsoft Edge\\;v=\\128\\',
      'sec-ch-ua-mobile': '?0',
      'sec-ch-ua-platform': '\\Windows\\',
      'sec-fetch-dest': 'empty',
      'sec-fetch-mode': 'cors',
      'sec-fetch-site': 'cross-site',
      'tz': 'India Standard Time',
      'userid': '4007',
      'Referer': 'http://localhost:4219/',
      'Referrer-Policy': 'strict-origin-when-cross-origin'
    };

    var result = await _authService.getUserAuthenticationDetails(
        "api_login/Login/GetUserAuthenticationDetails", queryParams, headers);

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
      setState(() {
        ipInfo = fetchedIpInfo;
      });
    } catch (e) {
      setState(() {});
      print('Failed to load IP information: $e');
    }
  }

  getUserKey() async {
    var queryParam = {
      "headers": {
        "normalizedNames": {},
        "lazyUpdate": [
          {"name": "Offset", "op": "d"},
          {"name": "Offset", "value": "1728013689", "op": "a"}
        ],
        "headers": {},
        "lazyInit": {
          "normalizedNames": {},
          "lazyUpdate": null,
          "headers": {},
          "lazyInit": null
        }
      }
    };
    var headers={
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    await authService
        .fetchLoginDataPOST("api_login/Login/GetUserKey?loginname=lpaiadmin@dockerbike.com", queryParam, headers)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);

      setState(() {
        key = jsonData["Key"];
        print("KEY---$key");
        // isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        // isLoading = false;
      });
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchIpInfo();
    getUserKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 268.h,
                width: double.infinity,
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sign In to LPMS",
                        style: TextStyle(fontSize: 24.sp, color: Colors.white),
                      ),
                      Text(
                        "Registered Account",
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: (640 - 268).h,
                color: AppColors.background,
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .27,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {},
                                  child: const Icon(Icons.arrow_back_ios)),
                              const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'User Id',
                              suffixIcon: Icon(Icons.person_2_outlined),
                              suffixIconColor: AppColors.primary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              suffixIcon: Icon(Icons.remove_red_eye_outlined),
                              suffixIconColor: AppColors.primary),
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

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Theme(
                                  data: ThemeData(useMaterial3: false),
                                  child: Switch(
                                    onChanged: toggleSwitch,
                                    value: isSwitched,
                                    activeColor: AppColors.primary,
                                    activeTrackColor: AppColors.secondary,
                                  ),
                                ),
                                const Text(
                                  'Remember',
                                  style: TextStyle(fontSize: 14,color: Colors.black),
                                )
                              ],
                            ),
                            const Text(
                              'Recover Forgot Password',
                              style: TextStyle(fontSize: 14,color: AppColors.primary),
                            )
                          ],
                        ),
                        const SizedBox(height: 16,),
                        Container(
                          decoration: BoxDecoration(
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
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent),
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
                                    'SIGN IN',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16,),
                        const Row(
                          children: [
                            Text(
                              'Read the',
                              style: TextStyle(fontSize: 14,color: Colors.black),
                            ),
                            Text(
                              ' Privacy Policy ',
                              style: TextStyle(fontSize: 14,color: AppColors.primary),
                            ),
                            Text(
                              'And',
                              style: TextStyle(fontSize: 14,color: Colors.black),
                            ),
                            Text(
                              ' Terms of Use',
                              style: TextStyle(fontSize: 14,color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18,),
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.asset(
                              "assets/images/kls.jpg",

                              ),
                        ),
                        const SizedBox(height: 18,),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'App version 1.0',
                              style: TextStyle(fontSize: 14,color: Colors.black),
                            ),
                          ],
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

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('Switch Button is OFF');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
