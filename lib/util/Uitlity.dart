import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_color.dart';
 class Utils{

  static Icon getStatusIcon(String status) {
    switch (status) {
      case 'GATED-IN':
        return const Icon(Icons.flag_outlined, color: Colors.black,size: 18,);
      case 'GATE-IN':
        return const Icon(Icons.input_outlined, color: Colors.black,size: 18,);
      case 'REJECT FOR GATE-IN':
        return const Icon(Icons.cancel_outlined, color: Colors.black,size: 18,);
      case 'DRAFT':
        return const Icon(Icons.local_shipping_outlined, color: Colors.black,size: 18,);
      case 'PENDING FOR GATE-IN':
        return const Icon(Icons.pending_actions_outlined, color: Colors.black,size: 18,);
      default:
        return const Icon(Icons.help, color: Colors.black,size: 18,);
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'GATED-IN':
        return AppColors.gatedIn;
      case 'GATE-IN':
        return AppColors.gateInRed;
      case 'DRAFT':
        return AppColors.draft;
      case 'PENDING FOR GATE-IN':
        return AppColors.gateInYellow;
      case 'REJECT FOR GATE-IN':
        return AppColors.gateInRed;
      default:
        return AppColors.gateInYellow;
    }
  }

  static printPrettyJson(String jsonString) {
    if(jsonString.isEmpty){
      return;
    }
    var jsonObject = jsonDecode(jsonString);
    var prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);
    const int chunkSize = 1000;
    for (var i = 0; i < prettyString.length; i += chunkSize) {
      print(prettyString.substring(
          i, i + chunkSize > prettyString.length ? prettyString.length : i + chunkSize));
    }
    // printLongString(prettyString);
  }
  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static keepFirstNElements(List<dynamic> list, int n) {
    if (n < list.length) {
      list.removeRange(n, list.length);
    }
  }

  // static void printLongString(String text) {
  //   const int chunkSize = 1000;
  //   for (var i = 0; i < text.length; i += chunkSize) {
  //     print(text.substring(
  //         i, i + chunkSize > text.length ? text.length : i + chunkSize));
  //   }
  // }

}