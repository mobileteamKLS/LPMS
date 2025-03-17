import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lpms/screens/login/login_new.dart';
import 'package:lpms/theme/app_color.dart';
import 'package:lpms/theme/app_theme.dart';

void main() {
 // debugPaintSizeEnabled = true;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: AppColors.secondary,
      systemNavigationBarColor: Colors.black,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.primary, // Set your status bar color
        systemNavigationBarColor: Colors.black, // Set your nav bar color
      ),
    );
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:AppTheme.lightTheme,
      home:  const LoginPageNew(),
    );


    // return ScreenUtilInit(
    //   designSize: const Size(360, 690),
    //   minTextAdapt: true,
    //   splitScreenMode: true,
    //
    //   builder: (_ , child) {
    //     return MaterialApp(
    //       title: 'Flutter Demo',
    //       debugShowCheckedModeBanner: false,
    //       theme:AppTheme.lightTheme,
    //       home:  const LoginPageNew(),
    //     );
    //   },
    //
    // );
  }
}


