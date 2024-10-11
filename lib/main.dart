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

    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme:AppTheme.lightTheme,
          home:  const BookingCreation(),
        );
      },

    );
  }
}


