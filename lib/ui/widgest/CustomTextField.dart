import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lpms/theme/app_color.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double initialHeight;
  final double errorHeight;
  final String validationMessage;
  final TextInputType inputType;
  final List<TextInputFormatter>? inputFormatters;
  final RegExp? validationPattern;
  final String patternErrorMessage;
  final double? customWidth;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.initialHeight = 45,
    this.errorHeight = 65,
    this.validationMessage = 'Field is Required',
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.validationPattern,
    this.patternErrorMessage = 'Invalid input',
    this.customWidth, // Width passed optionally
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late double fieldHeight;

  @override
  void initState() {
    super.initState();
    fieldHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.customWidth ?? MediaQuery.of(context).size.width;

    return SizedBox(
      height: fieldHeight,
      width: width,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.inputType,
        inputFormatters: widget.inputFormatters,
        validator: (value) {
          if (value == null || value.isEmpty) {
            setState(() {
              fieldHeight = widget.errorHeight;
            });
            return widget.validationMessage;
          }
          if (widget.validationPattern != null && !widget.validationPattern!.hasMatch(value)) {
            setState(() {
              fieldHeight = widget.errorHeight;
            });
            return widget.patternErrorMessage;
          }
          setState(() {
            fieldHeight = widget.initialHeight;
          });
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          errorStyle: const TextStyle(height: 0),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    // Allow only digits and a single decimal point
    if (newText == '') {
      return newValue;
    } else if (double.tryParse(newText) == null) {
      return oldValue; // Revert to old value if the new value is invalid
    }

    // Restrict to only one decimal point and ensure correct decimal range
    if (newText.contains('.') && newText.split('.')[1].length > decimalRange) {
      return oldValue;
    }

    return newValue;
  }
}


class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final double initialHeight;
  final double errorHeight;
  final String validationMessage;
  final double? customWidth;
  final bool allowPastDates; // New parameter to allow/disallow past dates

  const CustomDatePicker({
    Key? key,
    required this.controller,
    required this.labelText,
    this.initialHeight = 45,
    this.errorHeight = 65,
    this.validationMessage = 'Please select a date',
    this.customWidth,
    this.allowPastDates = true, // Default: allow past dates
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late double fieldHeight;

  @override
  void initState() {
    super.initState();
    fieldHeight = widget.initialHeight;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: widget.allowPastDates ? DateTime(2000) : currentDate,
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            primaryColor: AppColors.primary,

            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('d MMM yyyy').format(pickedDate);
      setState(() {
        widget.controller.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.customWidth ?? MediaQuery.of(context).size.width;

    return SizedBox(
      height: fieldHeight,
      width: width,
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            setState(() {
              fieldHeight = widget.errorHeight;
            });
            return widget.validationMessage;
          }
          setState(() {
            fieldHeight = widget.initialHeight;
          });
          return null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          errorStyle: const TextStyle(height: 0),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          suffixIcon: GestureDetector(
            onTap: () => _selectDate(context),
            child: const Icon(Icons.calendar_today,color: AppColors.primary,),
          ),
        ),
        onTap: () => _selectDate(context),
        readOnly: true,
      ),
    );
  }
}


