import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpms/core/img_assets.dart';
import 'package:lpms/screens/slot_booking/ExportDashboard.dart';

import 'package:lpms/theme/app_color.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/auth.dart';
import '../../models/IPInfo.dart';
import '../../models/LoginMaster.dart';
import '../../ui/widgest/app_button.dart';
import '../../util/Global.dart';
import '../../core/dimensions.dart';
import '../../util/media_query.dart';
import '../../core/Encryption.dart';
import 'forgot_password.dart';
import 'forgot_username.dart';
import 'otp_screen.dart';

class LoginPageNew extends StatefulWidget {
  const   LoginPageNew({super.key});

  @override
  _LoginPageNewState createState() => _LoginPageNewState();
}

class _LoginPageNewState extends State<LoginPageNew> {
  final formKeyForMail = GlobalKey<FormState>();
  final formKeyForPhone = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final EncryptionService encryptionService = EncryptionService();
  bool _isLoading = false;
  bool isPasswordVisible = true;
  bool _rememberMe = false;
  String? _errorMessage;

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

  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', _usernameController.text.trim());
      await prefs.setString('password', _passwordController.text.trim());
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
      "IsPrimaryStakeholder": true,
      "LoginName": _usernameController.text.trim(),
      "OTPGenerationCode": "",
      "LoginPassword": password,
      "IpAddress": ipInfo.ip,
      "IpCity": ipInfo.city,
      "IpCountry": ipInfo.country,
      "IpOrg": ipInfo.org,
      "UserAgent": "",
      "LogonType": "",
      "BusinesslineId": 0,
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
        CustomSnackBar.show(context, message: "Invalid Login Details",backgroundColor: Colors.red);
        return;
      }
      final Map<String, dynamic> jsonData = json.decode(response.body);
      _saveCredentials();
      setState(() {
        loginMaster = [LoginDetailsMaster.fromJSON(jsonData)];
      });
      // _usernameController.clear();
      // _passwordController.clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ExportScreen()),(route) => false,
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
        CustomSnackBar.show(context, message: "Invalid Login Details",backgroundColor: Colors.red);
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

  generateOtp() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });

    var queryParam = {
      "SendMobileOTP": true,
      "MobileNo": _phoneNoController.text.trim(),
      "EmailIdOTPCode": 0,
      "MobileOTPCode": 0,
      "IsSameOTPasMail": true,
      "IsSendOtpToClient": true,
      "Mode": "Mobile"
    };
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjQwMDciLCJyb2xlIjoiV2ViQXBwVXNlciIsIm5iZiI6MTczNzM0NjcxMSwiZXhwIjoxNzM3MzgyNzExLCJpYXQiOjE3MzczNDY3MTF9.PuktgWE3ootb7Oi8eYXogJUnR6QYz6R519GDKLz7ARI',
    };
    await authService
        .fetchLoginDataPOST(
        "api_user/RegistrationRequest/GenerateOTP",
        queryParam,headers
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData=jsonDecode(response.body);
      print(jsonData["ResponseStatus"]);
      if(jsonData.isNotEmpty){
        setState(() {
          _isLoading = false;
        });
        if(jsonData["ResponseStatus"]=="failure"){
          CustomSnackBar.show(context, message: "Kindly contact system administrator.",backgroundColor: AppColors.warningColor,leftIcon: Icons.info_outlined);
        }else{
          print("${jsonData["ResponseObject"]["MobileOTPCode"]}");
          Navigator.push(
              context, MaterialPageRoute(builder: (_) =>  EnterOtpScreen(phoneNo: _phoneNoController.text.trim(), otp:(jsonData["ResponseObject"]["MobileOTPCode"]).toString(),)));
        }




        // Future.delayed(const Duration(milliseconds: 1800), ()
        // {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (_) => const EnterOtpScreen()));
        // });
      }
      else{
        setState(() {
          _isLoading = false;
        });
      }


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
    ScreenDimension().init(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Colors.white,
          child: Container(
            width: double.infinity,

            decoration:  BoxDecoration(
                gradient: const LinearGradient(colors: [
                  AppColors.primary,
                  AppColors.secondary,
                ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,),
                borderRadius:BorderRadius.only(
                    bottomLeft: Radius.circular(ScreenDimension.onePercentOfScreenWidth * 6)
                )
              // image: DecorationImage(
              //     image: AssetImage(loginBgImage), fit: BoxFit.cover),
            ),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 70,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenDimension.onePercentOfScreenWidth*headingTextHorizontalPadding,
                    ),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "LPMS \n",
                            style:TextStyle(
                              fontSize: ScreenDimension.textSize * headingText,
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),

                          ),
                          TextSpan(
                            text: "Land Port Management System",
                            style:  TextStyle(
                              fontSize: ScreenDimension.textSize * headingText,
                              color: AppColors.white,
                              fontWeight: FontWeight.w300,

                            ),
                          ),

                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Container(
                          height:ScreenDimension.onePercentOfScreenHight*75,
                          padding: EdgeInsets.all(
                              ScreenDimension.onePercentOfScreenHight * cardPadding),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:BorderRadius.only(
                                topRight: Radius.circular(ScreenDimension.onePercentOfScreenWidth * cardBorderRadiusCurve),
                                topLeft: Radius.circular(ScreenDimension.onePercentOfScreenWidth * cardBorderRadiusCurve),
                              )

                          ),
                          child:Column(
                            children: [
                              // SizedBox(
                              //   height: ScreenDimension.onePercentOfScreenHight*3,
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Sign In",
                                      style:  TextStyle(
                                          color: AppColors.textColorPrimary,
                                          letterSpacing: 0.8,
                                          fontSize: ScreenDimension.textSize * headingText,
                                          fontWeight: FontWeight.w900)),

                                ],),
                              SizedBox(
                                height: ScreenDimension.onePercentOfScreenHight*1.5,
                              ),
                              const TabBar(
                                labelColor:AppColors.primary,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor:AppColors.primary,
                                tabs: [
                                  Tab(text: "Sign In with User ID"),
                                  Tab(text: "Sign In with OTP"),
                                ],
                              ),
                              SizedBox(
                                height: ScreenDimension.onePercentOfScreenHight*2,
                              ),
                              Container(
                                height: ScreenDimension.onePercentOfScreenHight*39,

                                child: TabBarView(
                                  children: [
                                    Form(
                                      key: formKeyForMail,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _usernameController,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                labelText: 'User ID',
                                                contentPadding: EdgeInsets.only(left:8 ),
                                                suffixIcon: Icon(Icons.person_2_outlined),
                                                suffixIconColor: AppColors.primary),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'User ID Required.';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: ScreenDimension.onePercentOfScreenHight*1.5,
                                          ),
                                          TextFormField(
                                            controller: _passwordController,
                                            obscureText: isPasswordVisible,
                                            decoration:  InputDecoration(
                                                labelText: 'Password',
                                                contentPadding: EdgeInsets.only(left:8 ),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    // Based on passwordVisible state choose the icon
                                                    isPasswordVisible
                                                        ? Icons.visibility_off_outlined
                                                        :Icons.visibility_outlined ,
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
                                                return 'Password Required.';
                                              }
                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: ScreenDimension.onePercentOfScreenHight*2.5,
                                          ),
                                          RoundedGradientButton(text: "SIGN IN", press:_isLoading?null: (){
                                            print("Sign In");
                                            if (formKeyForMail.currentState!.validate()) {
                                              getUserKey();
                                            }
                                          }
                                          ),
                                          SizedBox(height: ScreenDimension.onePercentOfScreenHight * 2,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Theme(
                                                    data: ThemeData(useMaterial3: false),
                                                    child: Switch(
                                                      onChanged: (value) async{
                                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                                        await prefs.setBool('remember_me', value);
                                                        setState(()  {
                                                          _rememberMe = value;
                                                        });
                                                      },
                                                      value: _rememberMe,
                                                      activeColor: AppColors.primary,
                                                      activeTrackColor: AppColors.secondary,
                                                    ),
                                                  ),
                                                   Text(
                                                    'Remember',
                                                    style: TextStyle(
                                                        fontSize: ScreenDimension.textSize * bodyTextSmall, color: Colors.black),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:MainAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    child:   Text(
                                                      ' Forgot User ID',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w400,
                                                          fontSize:ScreenDimension.textSize * bodyTextSmall, color: AppColors.primary),
                                                    ),
                                                    onTap: (){
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ForgotUserIdScreen()));
                                                    },
                                                  ),
                                                  const Text("  | "),
                                                  GestureDetector(
                                                    child: Text(
                                                      ' Forgot Password',
                                                      style: TextStyle(fontWeight: FontWeight.w400,

                                                          fontSize: ScreenDimension.textSize * bodyTextSmall, color: AppColors.primary),
                                                    ),
                                                    onTap: (){
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const ForgotPasswordScreen()));
                                                    },
                                                  )
                                                ],),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Form(
                                      key: formKeyForPhone,
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _phoneNoController,
                                            keyboardType: TextInputType.phone,
                                            maxLength: 25,
                                            decoration: const InputDecoration(
                                                labelText: 'Mobile Number',
                                                contentPadding: EdgeInsets.only(left:8 ),
                                                suffixIcon: Icon(Icons.person_2_outlined),
                                                suffixIconColor: AppColors.primary),
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Mobile Number Required.';
                                              }

                                              return null;
                                            },
                                          ),
                                          SizedBox(
                                            height: ScreenDimension.onePercentOfScreenHight*2.5,
                                          ),
                                          RoundedGradientButton(text: "SEND OTP", press:_isLoading?null: (){
                                            print("Sign In");
                                            if (formKeyForPhone.currentState!.validate()) {
                                              generateOtp();
                                            }
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                                            // );
                                          }
                                          ),
                                          SizedBox(height: ScreenDimension.onePercentOfScreenHight * 2,),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Image.asset(lpaiImage2, height: ScreenDimension.onePercentOfScreenHight * 7,),
                                SizedBox(width: ScreenDimension.onePercentOfScreenWidth*1,),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Land Ports \n",
                                        style:TextStyle(
                                          fontSize: ScreenDimension.textSize * bodyTextLarge,
                                          color: const Color(0xff266d96),
                                          fontWeight: FontWeight.w800,
                                          height: 1.0,
                                        ),

                                      ),
                                      TextSpan(
                                        text: "Authority of India\n",
                                        style:  TextStyle(
                                          fontSize: ScreenDimension.textSize * bodyTextLarge,
                                          color: const Color(0xff266d96),
                                          fontWeight: FontWeight.w800,
                                          height: 1.0,

                                        ),
                                      ),
                                      TextSpan(
                                        text: "Systematic Seamless Secure",
                                        style:  TextStyle(
                                          fontSize: ScreenDimension.textSize * 1.0,
                                          color: AppColors.textColorPrimary,
                                          fontWeight: FontWeight.w600,

                                        ),
                                      ),

                                    ],
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ], ),
                              SizedBox(height: ScreenDimension.onePercentOfScreenHight * 1,),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Read ",
                                      style:  TextStyle(
                                        fontSize: ScreenDimension.textSize * bodyTextMedium,
                                        color: AppColors.textColorPrimary,
                                        fontWeight: FontWeight.w500,

                                      ),

                                    ),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *bodyTextMedium,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *bodyTextMedium,
                                        color: AppColors.textColorPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *  bodyTextMedium,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),

                                  ],
                                ),
                                textAlign: TextAlign.start,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: ScreenDimension.onePercentOfScreenHight * 2),
                                child: Text("Kale Logistics Solution", style: TextStyle(
                                  color: AppColors.textColorSecondary, fontSize: ScreenDimension.textSize * bodyTextMedium, fontWeight: FontWeight.w400,
                                ),),
                              ),

                            ],
                          ) ,
                        ),

                      ],
                    )),
                _isLoading
                    ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
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
