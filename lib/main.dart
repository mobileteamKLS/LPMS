import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lpms/screens/BookingCreation.dart';
import 'package:lpms/screens/ExportDashboard.dart';
import 'package:lpms/screens/Login.dart';
import 'package:lpms/theme/app_theme.dart';
import 'package:lpms/ui/widgest/multiselect.dart';

void main() {
 // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme:AppTheme.lightTheme,
    //   home:  const LoginPage(),
    // );


    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,

      builder: (_ , child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme:AppTheme.lightTheme,
          home:  const LoginPage(),
        );
      },

    );
  }
}


