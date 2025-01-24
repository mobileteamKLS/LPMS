import 'package:flutter/material.dart';

import '../../theme/app_color.dart';

class RoundedGradientButton extends StatelessWidget {
  final bool isborderButton;
  final String text;
  final VoidCallback? press;
  final Color color;
  final Color? textColor;
  final double horizontalPadding;
  final double verticalPadding;
  final double cornerRadius;
  final double textSize;

  const RoundedGradientButton({
    Key? key,
    required this.text,
    required this.press,
    this.color=AppColors.primary,
    this.textColor=AppColors.white,
    this.horizontalPadding = 20,
    this.verticalPadding = 12,
    this.cornerRadius = 10,
    this.textSize = 16,
    this.isborderButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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