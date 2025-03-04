import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpms/screens/slot_booking/BookingCreationExport.dart';
import 'package:lpms/screens/slot_booking/ExportDashboard.dart';
import 'package:lpms/screens/login/Login.dart';
import 'package:lpms/screens/login/login_new.dart';
import 'package:lpms/theme/app_color.dart';
import 'package:lpms/theme/app_theme.dart';
import 'package:lpms/ui/widgest/AutoSuggest.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import 'package:lpms/ui/widgest/multiselect.dart';

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
        statusBarColor: Colors.blue, // Set your status bar color
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


