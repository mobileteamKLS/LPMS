import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lpms/screens/login/Login.dart';

import '../../api/auth.dart';
import '../../core/img_assets.dart';
import '../../theme/app_color.dart';
import '../../ui/widgest/CustomTextField.dart';
import '../../ui/widgest/app_button.dart';
import '../../core/dimensions.dart';
import '../../util/Global.dart';
import '../../util/media_query.dart';
import 'login_new.dart';

class ForgotUserIdScreen extends StatefulWidget {
  const ForgotUserIdScreen({super.key});

  @override
  State<ForgotUserIdScreen> createState() => _ForgotUserIdScreenState();
}

class _ForgotUserIdScreenState extends State<ForgotUserIdScreen> {
  final TextEditingController emailIdController = TextEditingController();
  final formKey=GlobalKey<FormState>();
  bool _isLoading=false;
  final AuthService authService = AuthService();
  getUserIdMail() async {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isLoading = true;
    });

    var queryParam = {"LoginName": emailIdController.text.trim()};
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    await authService
        .fetchLoginDataPOST(
        "api_login/Login/ResetRegisteredEmailId",
        queryParam,headers
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      if(jsonData.isNotEmpty){
        setState(() {
          _isLoading = false;
        });
        CustomSnackBar.show(context, message: "${jsonData["OtherMessage"]}",backgroundColor: AppColors.successColor,leftIcon: Icons.check_circle);
        Future.delayed(const Duration(milliseconds: 1800), ()
        {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginPageNew()));
        });
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
                            fontSize: ScreenDimension.textSize *AppDimensions. headingText,
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
                                      "Forgot User ID",
                                      style:  TextStyle(
                                          color: AppColors.textColorPrimary,
                                          letterSpacing: 0.8,
                                          fontSize: ScreenDimension.textSize * AppDimensions.headingText,
                                          fontWeight: FontWeight.w900)),

                                ],),
                              SizedBox(
                                height: ScreenDimension.onePercentOfScreenHight*2,
                              ),
                              TextFormField(
                                controller: emailIdController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Registered Email ID',
                                    contentPadding: EdgeInsets.only(left:8 ),
                                    suffixIcon: Icon(Icons.mail_outline_outlined),
                                    suffixIconColor: AppColors.primary),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email Id Required.';
                                  }
                                  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                                  RegExp regex = RegExp(pattern);
                                  if (!regex.hasMatch(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              SizedBox(
                                height: ScreenDimension.onePercentOfScreenHight*2.5,
                              ),
                              RoundedGradientButton(text: "SEND MAIL",
                                  press: _isLoading?null: (){
                                    print("Sign In");
                                    if (formKey.currentState!.validate()) {
                                      getUserIdMail();
                                    }
                                  }
                                  ),
                              SizedBox(height: ScreenDimension.onePercentOfScreenHight * 2,),
                              GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        "Back to Login",
                                        style: TextStyle(
                                            color: AppColors.primary,
                                            letterSpacing: 0.8,
                                            fontSize: ScreenDimension.textSize * AppDimensions.titleText,
                                            fontWeight: FontWeight.w500)),

                                  ],
                                ),
                                onTap: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginPageNew()));
                                },
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
                              SizedBox(height: ScreenDimension.onePercentOfScreenHight * 1,),
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
