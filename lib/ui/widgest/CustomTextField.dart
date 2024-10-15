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
  final bool isValidationRequired; // New flag for validation

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
    this.customWidth, // Optional custom width
    this.isValidationRequired = true, // Default: validation is required
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
        validator: widget.isValidationRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  setState(() {
                    fieldHeight = widget.errorHeight;
                  });
                  return widget.validationMessage;
                }
                if (widget.validationPattern != null &&
                    !widget.validationPattern!.hasMatch(value)) {
                  setState(() {
                    fieldHeight = widget.errorHeight;
                  });
                  return widget.patternErrorMessage;
                }
                setState(() {
                  fieldHeight = widget.initialHeight;
                });
                return null;
              }
            : null,
        // Skip validation if not required
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
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
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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
  final TextEditingController? otherDateController; // For comparison
  final String labelText;
  final double initialHeight;
  final double errorHeight;
  final String validationMessage;
  final double? customWidth;
  final bool allowPastDates;
  final bool isRequiredField;
  final bool isFromDate;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    this.otherDateController, // New: optional controller for validation
    required this.labelText,
    this.initialHeight = 45,
    this.errorHeight = 65,
    this.validationMessage = 'Required',
    this.customWidth,
    this.allowPastDates = true,
    this.isRequiredField = true,
    this.isFromDate = false,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late double fieldHeight;
  bool _isFirstCall = true;
  String? validationMessage;

  @override
  void initState() {
    super.initState();
    fieldHeight = widget.initialHeight;
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime initialDate;

    if (widget.controller.text.isNotEmpty) {
      try {
        initialDate = DateFormat('d MMM yyyy').parse(widget.controller.text);
      } catch (e) {
        initialDate = currentDate;
      }
    } else {
      if (_isFirstCall && widget.isFromDate) {
        initialDate = currentDate.subtract(const Duration(days: 2));
        _isFirstCall = false;
      } else {
        initialDate = currentDate;
      }
    }

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
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
      widget.controller.text = formattedDate;
      _validateDate(pickedDate, context);
    }
  }

  void _validateDate(DateTime selectedDate, BuildContext context) {
    if (widget.otherDateController != null &&
        widget.otherDateController!.text.isNotEmpty) {
      DateTime otherDate = DateFormat('d MMM yyyy').parse(widget.otherDateController!.text);

      if (widget.isFromDate && selectedDate.isAfter(otherDate)) {
        _showSnackBar(context, 'From Date should be less than To Date');
        _clearController();
      } else if (!widget.isFromDate && selectedDate.isBefore(otherDate)) {
        _showSnackBar(context, 'To Date should be greater than From Date');
        _clearController();
      } else {
        setState(() {
          fieldHeight = widget.initialHeight;
          validationMessage = null;
        });
      }
    }
  }

  void _clearController() {
    setState(() {
      widget.controller.clear();
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    // Display the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.info, color: Colors.white),
                  Text('  $message'),
                ],
              ),
              GestureDetector(
                child: const Icon(Icons.close, color: Colors.white),
                onTap: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.warningColor,
        behavior: SnackBarBehavior.floating,

      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.customWidth ?? MediaQuery.of(context).size.width;

    return SizedBox(
      height: fieldHeight,
      width: width,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.isRequiredField
            ? (value) {
          if (value == null || value.isEmpty) {
            return widget.validationMessage;
          }
          return null;
        }
            : null,
        decoration: InputDecoration(
          contentPadding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          errorStyle: const TextStyle(height: 0),
          labelText: widget.labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          suffixIcon: IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today,
                color: AppColors.primary),
          ),
        ),
        readOnly: true, // Prevent manual text input
      ),
    );
  }
}

class CustomSnackBar {
  static void show(
      BuildContext context, {
        required String message,
        Color backgroundColor = Colors.amber,
      }) {
    final snackBar = SnackBar(
      content: SizedBox(
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.white),
                Text('  $message'),
              ],
            ),
            GestureDetector(
              child: const Icon(Icons.close, color: Colors.white),
              onTap: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,

    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}


class ShipmentInfoRow extends StatelessWidget {
  final String header1;
  final String header2;
  final String value1;
  final String value2;

  const ShipmentInfoRow({
    super.key,
    required this.value1,
    required this.value2, required this.header1, required this.header2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                header1,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Text(
                value1,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorPrimary,
                    fontSize: 15),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                 header2,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Text(
                value2,
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColorPrimary,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


