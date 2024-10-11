import 'package:flutter/material.dart';
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

}