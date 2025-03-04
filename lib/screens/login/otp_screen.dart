import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lpms/screens/login/Login.dart';

import '../../api/auth.dart';
import '../../core/img_assets.dart';
import '../../models/login_model.dart';
import '../../theme/app_color.dart';
import '../../ui/widgest/CustomTextField.dart';
import '../../ui/widgest/app_button.dart';
import '../../core/dimensions.dart';
import '../../util/Global.dart';
import '../../util/media_query.dart';
import '../slot_booking/ExportDashboard.dart';
import 'login_new.dart';

class EnterOtpScreen extends StatefulWidget {
  final String phoneNo;
  final String otp;
  const EnterOtpScreen({super.key, required this.phoneNo, required this.otp});

  @override
  State<EnterOtpScreen> createState() => _EnterOtpScreenState();
}

class _EnterOtpScreenState extends State<EnterOtpScreen> {
  final TextEditingController otpController = TextEditingController();
  final formKey=GlobalKey<FormState>();
  bool _isLoading=false;
  final AuthService authService = AuthService();
  int secondsRemaining = 180;
  int attempt = 3;
  Timer? timer;
  bool isButtonDisabled = false;
  String? otp;

  void startTimer() {
    isButtonDisabled = true;
    secondsRemaining = 180;
    setState(() {
      attempt = 3;
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (secondsRemaining == 0) {
        timer?.cancel();
        FocusScope.of(context).requestFocus(FocusNode());
        otpController.clear();
        CustomSnackBar.show(context, message: "OTP expired.",backgroundColor: AppColors.errorRed,leftIcon: Icons.info_outlined);
        setState(() {
          isButtonDisabled = false;
          otp=null;
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }


  @override
  void initState() {
    super.initState();
    otp=widget.otp;
    startTimer();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void resendOTP() {
    print("OTP Sent!");
    generateOtp(widget.phoneNo);

  }

  generateOtp(String phoneNo) async {
    otpController.clear();
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });

    var queryParam = {
      "SendMobileOTP": true,
      "MobileNo": phoneNo,
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
          setState(() {
            otp=(jsonData["ResponseObject"]["MobileOTPCode"]).toString();
          });
          startTimer();

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



  Future<void> loginUsingPhoneNo() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(otp==null){
      otpController.clear();
      CustomSnackBar.show(context, message: "OTP expired, resend it now.",backgroundColor: AppColors.errorRed,leftIcon: Icons.info_outlined);
      return;
    }
    setState(() {
      _isLoading = true;
    });

    var queryParams = {
    "MobileNo": widget.phoneNo,
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

    await authService
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
      // _saveCredentials();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    horizontal: ScreenDimension.onePercentOfScreenWidth*AppDimensions.headingTextHorizontalPadding,
                  ),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "LPMS \n",
                          style:TextStyle(
                            fontSize: ScreenDimension.textSize * AppDimensions.headingText,
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),

                        ),
                        TextSpan(
                          text: "Land Port Management System",
                          style:  TextStyle(
                            fontSize: ScreenDimension.textSize *AppDimensions.headingText,
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Container(
                          height:ScreenDimension.onePercentOfScreenHight*75,
                          padding: EdgeInsets.all(
                              ScreenDimension.onePercentOfScreenHight * AppDimensions.cardPadding),
                          decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius:BorderRadius.only(
                                topRight: Radius.circular(ScreenDimension.onePercentOfScreenWidth * AppDimensions.cardBorderRadiusCurve),
                                topLeft: Radius.circular(ScreenDimension.onePercentOfScreenWidth * AppDimensions.cardBorderRadiusCurve),
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
                                          fontSize: ScreenDimension.textSize * AppDimensions.headingText,
                                          fontWeight: FontWeight.w900)),

                                ],),

                              Padding(
                                padding: EdgeInsets.symmetric(vertical: ScreenDimension.onePercentOfScreenHight * 2),

                                child: Text("We have sent you a 6 digit OTP on registered mobile number", style: TextStyle(
                                  color: AppColors.textColorSecondary, fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge, fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,),
                              ),

                              TextFormField(
                                controller: otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: const InputDecoration(
                                    labelText: 'Enter OTP',
                                    contentPadding: EdgeInsets.only(left:8 ),
                                    suffixIcon: Icon(Icons.lock_outline_rounded),
                                    suffixIconColor: AppColors.primary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'OTP Required.';
                                  }
                                  if(otp!=null){
                                    if(otp!=value){
                                      return 'Incorrect OTP';
                                    }
                                  }

                                  return null;
                                },
                              ),

                              SizedBox(
                                height: ScreenDimension.onePercentOfScreenHight*2.5,
                              ),
                              RoundedGradientButton(text: "SIGN IN",
                                  press: (_isLoading)?null: (){
                                    print("Sign In");
                                    if (formKey.currentState!.validate()) {
                                      loginUsingPhoneNo();
                                    }else{
                                      FocusScope.of(context).requestFocus(FocusNode());
                                      if(attempt>1){
                                        setState(() {
                                          attempt--;
                                        });
                                        otpController.clear();
                                        CustomSnackBar.show(context, message: "Invalid OTP. You have $attempt attempt(s) remaining.",backgroundColor: AppColors.warningColor,leftIcon: Icons.info_outlined);
                                      }
                                      else{
                                        setState(() {
                                          otpController.clear();
                                           secondsRemaining=0;
                                          isButtonDisabled = false;
                                          print("----$isButtonDisabled");
                                           formKey.currentState!.reset();
                                          otp=null;
                                        });
                                        CustomSnackBar.show(context, message: "Maximum attempts exceeded. Please try again later.",backgroundColor: AppColors.warningColor,leftIcon: Icons.info_outlined);

                                      }

                                   }
                                  }
                              ),
                              SizedBox(height: ScreenDimension.onePercentOfScreenHight * 2,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.arrow_back_ios_rounded,color: AppColors.textColorPrimary,),
                                        Text(
                                            "Back",
                                            style:  TextStyle(
                                                color: AppColors.primary,
                                                letterSpacing: 0.8,
                                                fontSize: ScreenDimension.textSize * AppDimensions.titleText,
                                                fontWeight: FontWeight.w700)),

                                      ],
                                    ),
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                  isButtonDisabled?
                                  Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: "Resend OTP in ",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenDimension.textSize *
                                                          AppDimensions.titleText,
                                                  color: AppColors
                                                      .textColorPrimary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "$secondsRemaining",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenDimension.textSize *
                                                          AppDimensions.titleText,
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " seconds.",
                                                style: TextStyle(
                                                  fontSize:
                                                      ScreenDimension.textSize *
                                                          AppDimensions.titleText,
                                                  color: AppColors
                                                      .textColorPrimary,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.start,
                                        )
                                      : GestureDetector(
                                          child:
                                              Text("Resend OTP",
                                                  style: TextStyle(
                                                      color: AppColors.primary,
                                                      letterSpacing: 0.8,
                                                      fontSize: ScreenDimension
                                                              .textSize *
                                                          AppDimensions.titleText,
                                                      fontWeight:
                                                          FontWeight.w700)),

                                          onTap: () {

                                            resendOTP();
                                          },
                                        ),
                                ],
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
                                            fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge,
                                            color: const Color(0xff266d96),
                                            fontWeight: FontWeight.w800,
                                            height: 1.0,
                                          ),

                                        ),
                                        TextSpan(
                                          text: "Authority of India\n",
                                          style:  TextStyle(
                                            fontSize: ScreenDimension.textSize * AppDimensions.bodyTextLarge,
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
                              SizedBox(height: ScreenDimension.onePercentOfScreenHight * 1.5,),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Read ",
                                      style:  TextStyle(
                                        fontSize: ScreenDimension.textSize * AppDimensions.bodyTextMedium,
                                        color: AppColors.textColorPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),
                                    TextSpan(
                                      text: "Privacy Policy",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *AppDimensions.bodyTextMedium,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *AppDimensions.bodyTextMedium,
                                        color: AppColors.textColorPrimary,
                                        fontWeight: FontWeight.w500,
                                      ),

                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      style: TextStyle(
                                        fontSize: ScreenDimension.textSize *  AppDimensions.bodyTextMedium,
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
                                  color: AppColors.textColorSecondary, fontSize: ScreenDimension.textSize * AppDimensions.bodyTextMedium, fontWeight: FontWeight.w400,
                                ),),
                              ),

                            ],
                          ) ,
                        ),

                      ],
                    ),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
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
    );
  }
}
