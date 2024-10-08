import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpms/screens/ExportDashboard.dart';

import 'package:lpms/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/auth.dart';
import '../models/IPInfo.dart';
import '../models/LoginMaster.dart';
import '../util/Global.dart';
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
  bool isPasswordVisible = false;
  bool _rememberMe = false;
  String? _errorMessage;
  late IpInfo ipInfo;
  late int key;
  bool isSwitched = false;
  final AuthService authService = AuthService();

  void loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUsername = prefs.getString('username');
    String? savedPassword = prefs.getString('password');
    bool? rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      setState(() {
        _usernameController.text = savedUsername ?? '';
        _passwordController.text = savedPassword ?? '';
        _rememberMe = rememberMe;
      });
    }
  }

  // Save username and password
  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
    }
    await prefs.setBool('remember_me', _rememberMe);
  }

  Future<void> _handleLogin() async {
    debugPrint(encryptionService.encryptUsingRandomKey(
        "${_passwordController.text}`${ipInfo.ip}", "$key"));
    var password = encryptionService.encryptUsingRandomKey(
        "${_passwordController.text.trim()}`${ipInfo.ip}", "$key");
    debugPrint(encryptionService.decryptUsingRandomKey(password, "$key"));
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    var queryParams = {
      "LoginName": _usernameController.text.trim(),
      "OTPGenerationCode": "",
      "LoginPassword": password,
      "IpAddress": ipInfo.ip,
      "IpCity": ipInfo.city,
      "IpCountry": ipInfo.country,
      "IpOrg": ipInfo.org,
      "UserAgent": "",
      "LogonType": "",
      "BusinesslineId": "",
    };

    var headers = {
      'accept': 'application/json, text/plain, */*',
      'accept-language': 'en-US,en;q=0.9',
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
      'sec-ch-ua':
          '\\Chromium\\;v=\\128\\, \\Not;A=Brand\\;v=\\24\\, \\Microsoft Edge\\;v=\\128\\',
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

    await _authService
        .getUserAuthenticationDetails(
            "api_login/Login/GetUserAuthenticationDetails",
            queryParams,
            headers)
        .then((response) {
      if (response.body.isEmpty) {
        final snackBar = SnackBar(
          content: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    Text('  Invalid Login Details'),
                  ],
                ),
                GestureDetector(
                  child: const Icon(Icons.close, color: Colors.white),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          width: 230,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return;
      }
      final Map<String, dynamic> jsonData = json.decode(response.body);
      _saveCredentials();
      setState(() {
        loginMaster = [LoginDetailsMaster.fromJSON(jsonData)];
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ExportScreen()),
      );
    });

    setState(() {
      _isLoading = false;
    });
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
    // showLoadingDialog(context);
    setState(() {
      _isLoading = true;
    });

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
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    await authService
        .fetchLoginDataPOST(
            "api_login/Login/GetUserKey?loginname=${_usernameController.text.trim()}",
            queryParam,
            headers)
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData["Key"] == null) {
        final snackBar = SnackBar(
          content: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    Text('  Invalid Login Details'),
                  ],
                ),
                GestureDetector(
                  child: const Icon(Icons.close, color: Colors.white),
                  onTap: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          width: 230,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        key = jsonData["Key"];
        print("KEY---$key");
        setState(() {
          _isLoading = false;
        });
      });
      _handleLogin();
    }).catchError((onError) {
      setState(() {
        setState(() {
          _isLoading = false;
        });
      });
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchIpInfo();
    loadSavedCredentials();
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
                height: MediaQuery.sizeOf(context).height*0.39,
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
                        style: TextStyle(fontSize: 22.sp, color: Colors.white),
                      ),
                      Text(
                        "Registered Account",
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height*0.61,
                color: AppColors.background,
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * .25,
                right: 12.0,
                left: 12.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height*0.74,
              width: MediaQuery.sizeOf(context).width,
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
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                         SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.01,
                        ),

                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              labelText: 'Username',
                              suffixIcon: Icon(Icons.person_2_outlined),
                              suffixIconColor: AppColors.primary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                         SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.01,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isPasswordVisible,
                          decoration:  InputDecoration(
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  isPasswordVisible
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              suffixIconColor: AppColors.primary),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),

                         SizedBox(    height: MediaQuery.sizeOf(context).height*0.01,),

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
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value;
                                      });
                                    },
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    activeTrackColor: AppColors.secondary,
                                  ),
                                ),
                                const Text(
                                  'Remember',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                )
                              ],
                            ),
                            const Text(
                              ' Forgot Password',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.primary),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
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
                                      getUserKey();
                                    }
                                  },
                            child: const Text(
                              'SIGN IN',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Row(
                          children: [
                            Text(
                              'Read the',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              ' Privacy Policy ',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.primary),
                            ),
                            Text(
                              'And',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                            Text(
                              ' Terms of Use',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.primary),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        SizedBox(
                          height: 64,

                          child: Image.asset(
                            "assets/images/kls.jpg",
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'App version 1.0',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    // semi-transparent background
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Loading...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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

  void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
