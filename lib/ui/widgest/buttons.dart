import 'package:flutter/material.dart';

import '../../theme/app_color.dart';
class ButtonWidgets {
  static Widget buildRoundedGradientButton({
    required String text,
    required VoidCallback press,
    Color color = AppColors.primary,
    Color? textColor = AppColors.white,
    double horizontalPadding = 20,
    double verticalPadding = 12,
    double cornerRadius = 10,
    double textSize = 16,
    bool isborderButton = false,
    BuildContext? context,
  }) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isborderButton ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(cornerRadius),
          border: isborderButton ? Border.all(color: color, width: 2) : null,
          gradient: !isborderButton
              ? const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: textSize,
            ),
          ),
        ),
      ),
    );
  }
}