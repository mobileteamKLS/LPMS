    import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:lpms/theme/app_color.dart';
import 'dart:async';
    import 'package:flutter/painting.dart';
import '../../core/dimensions.dart';
import '../../core/img_assets.dart';
import '../../util/media_query.dart';

class CustomTextFieldOld extends StatefulWidget {
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
  final bool isValidationRequired;

  const CustomTextFieldOld({
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
    this.customWidth,
    this.isValidationRequired = true,
  }) : super(key: key);

  @override
  _CustomTextFieldStateOld createState() => _CustomTextFieldStateOld();
}

class _CustomTextFieldStateOld extends State<CustomTextFieldOld> {
  late double fieldHeight;
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fieldHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.customWidth ?? MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
      child: SizedBox(
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
                      errorMessage = widget.validationMessage;
                    });
                    return errorMessage;
                  }
                  if (widget.validationPattern != null &&
                      !widget.validationPattern!.hasMatch(value)) {
                    setState(() {
                      fieldHeight = widget.errorHeight;
                      errorMessage = widget.patternErrorMessage;
                    });
                    return errorMessage;
                  }
                  setState(() {
                    fieldHeight = widget.initialHeight;
                    errorMessage = null;
                  });
                  return null;
                }
              : null,
          onChanged: (value) {
            if (widget.isValidationRequired) {
              _formKey.currentState?.validate();
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            errorStyle: const TextStyle(height: 0),
            labelText: widget.labelText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            errorText: errorMessage,
          ),
        ),
      ),
    );
  }
}

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
  final bool isValidationRequired;
  final bool isEnabled;
  final Function(VoidCallback)? registerTouchedCallback;
  final Function(String)? onApiCall;
  final FocusNode? focusNode;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.initialHeight = 45,
    this.errorHeight = 65,
    this.validationMessage = 'Field is Required',
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputFormatters,
    this.validationPattern,
    this.patternErrorMessage = 'Invalid input',
    this.customWidth,
    this.isValidationRequired = true,
    this.registerTouchedCallback,
    this.onApiCall,
    this.focusNode, // Optional focusNode
  })  : assert(
          !isValidationRequired || registerTouchedCallback != null,
          'registerTouchedCallback must be provided when isValidationRequired is true',
        ),
        super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late double fieldHeight;
  String? errorMessage;
  bool _isTouched = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    fieldHeight = widget.initialHeight;
    if (widget.isValidationRequired && widget.registerTouchedCallback != null) {
      widget.registerTouchedCallback!(
          _markTouched); // Register the callback if required
    }
  }

  void _markTouched() {
    setState(() {
      _isTouched = true;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _isTouched = true;
    });

    if (widget.isValidationRequired) {
      final isValid = widget.validationPattern?.hasMatch(value) ?? true;
      setState(() {
        if (value.isEmpty) {
          fieldHeight = widget.errorHeight;
          errorMessage = widget.validationMessage;
        } else if (!isValid) {
          fieldHeight = widget.errorHeight;
          errorMessage = widget.patternErrorMessage;
        } else {
          fieldHeight = widget.initialHeight;
          errorMessage = null;
        }
      });
      Form.of(context)?.validate();
    }

    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.onApiCall != null) {
        widget.onApiCall!(value);
      }
    });
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
        focusNode: widget.focusNode,
        enabled: widget.isEnabled,
        validator: widget.isValidationRequired
            ? (value) {
                if (!_isTouched) return null;

                if (value == null || value.isEmpty) {
                  setState(() {
                    fieldHeight = widget.errorHeight;
                    errorMessage = widget.validationMessage;
                  });
                  return errorMessage;
                }
                if (widget.validationPattern != null &&
                    !widget.validationPattern!.hasMatch(value)) {
                  setState(() {
                    fieldHeight = widget.errorHeight;
                    errorMessage = widget.patternErrorMessage;
                  });
                  return errorMessage;
                }
                setState(() {
                  fieldHeight = widget.initialHeight;
                  errorMessage = null;
                });
                return null;
              }
            : null,
        onChanged: _onChanged,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          errorStyle: const TextStyle(height: 0),
          labelText: widget.isValidationRequired
              ? "${widget.labelText}*"
              : widget.labelText,
          labelStyle: TextStyle(color: AppColors.textColorPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          errorText: _isTouched ? errorMessage : null,
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

    if (newText == '') {
      return newValue;
    } else if (double.tryParse(newText) == null) {
      return oldValue;
    }

    if (newText.contains('.') && newText.split('.')[1].length > decimalRange) {
      return oldValue;
    }

    return newValue;
  }
}

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController? otherDateController;
  final String labelText;
  final double initialHeight;
  final double errorHeight;
  final String validationMessage;
  final double? customWidth;
  final bool allowPastDates;
  final bool allowFutureDates;
  final bool isRequiredField;
  final bool isFromDate;
  final VoidCallback? onDatePicked;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    this.otherDateController,
    required this.labelText,
    this.initialHeight = 45,
    this.errorHeight = 65,
    this.validationMessage = 'Field is Required',
    this.customWidth,
    this.allowPastDates = true,
    this.allowFutureDates = true,
    this.isRequiredField = true,
    this.isFromDate = false,
    this.onDatePicked,
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
    FocusScope.of(context).unfocus();
    DateTime currentDate = DateTime.now();
    DateTime initialDate = _getInitialDate(currentDate);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.allowPastDates ? DateTime(2000) : currentDate,
      lastDate: widget.allowFutureDates ? DateTime(2100) : currentDate,
      builder: (BuildContext context, Widget? child) {
        return _datePickerTheme(child);
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('d MMM yyyy').format(pickedDate);
      widget.controller.text = formattedDate;
      _validateDate(pickedDate, context);

      // Call the API via the callback after date is picked and validated
      if (widget.onDatePicked != null) {
        widget.onDatePicked!();
      }
    }
  }

  DateTime _getInitialDate(DateTime currentDate) {
    if (widget.controller.text.isNotEmpty) {
      try {
        return DateFormat('d MMM yyyy').parse(widget.controller.text);
      } catch (e) {
        return currentDate;
      }
    }
    if (_isFirstCall && widget.isFromDate) {
      _isFirstCall = false;
      return currentDate.subtract(const Duration(days: 2));
    }
    return currentDate;
  }

  Widget _datePickerTheme(Widget? child) {
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
  }

  void _validateDate(DateTime selectedDate, BuildContext context) {
    if (widget.otherDateController != null &&
        widget.otherDateController!.text.isNotEmpty) {
      DateTime otherDate =
          DateFormat('d MMM yyyy').parse(widget.otherDateController!.text);

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
      ),
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
                  setState(() {
                    fieldHeight = widget.errorHeight;
                  });
                  return widget.validationMessage;
                }
                setState(() {
                  fieldHeight = widget.initialHeight;
                });
                return null;
              }
            : null,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          errorStyle: const TextStyle(height: 0),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: AppColors.textColorPrimary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
          ),
          suffixIcon: IconButton(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, color: AppColors.primary),
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
    Color backgroundColor = AppColors.warningColor,
    IconData? leftIcon = Icons.info, // Optional left icon
  }) {
    final snackBar = SnackBar(
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  if (leftIcon != null) // Only display icon if provided
                    Icon(leftIcon, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2, // Set max lines for better control
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.height - 225,
      //     left: 10,
      //     right: 10),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class CustomSnackBarTop {
  static void show(
    BuildContext context, {
    required String message,
    Color backgroundColor = AppColors.warningColor,
    IconData? leftIcon = Icons.info, // Optional left icon
  }) {
    final snackBar = SnackBar(
      content: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  if (leftIcon != null) // Only display icon if provided
                    Icon(leftIcon, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 2, // Set max lines for better control
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 225,
          left: 10,
          right: 10),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
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
    required this.value2,
    required this.header1,
    required this.header2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

class CustomText extends StatefulWidget {
  final String text;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int? maxLine;

  const CustomText(
      {super.key,
      required this.text,
      required this.fontColor,
      required this.fontSize,
      required this.fontWeight,
      required this.textAlign,
      this.textDecoration = TextDecoration.none,
      this.maxLine = 3});

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
        maxLines: widget.maxLine,
        widget.text,
        textAlign: widget.textAlign,
        style: TextStyle(
            fontSize: widget.fontSize,
            color: widget.fontColor,
            fontWeight: widget.fontWeight,
            decoration: widget.textDecoration,
            decorationColor: widget.fontColor));
  }
}

class GroupIdCustomTextField extends StatefulWidget {
  final String? labelText;
  final String? prefixicon;
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final FormFieldValidator? validator;
  final TextInputType? textInputType;
  final bool isEnable;
  final bool isPassword;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final bool isIcon;
  final VoidCallback? onSuffixTap;
  final bool isSearch;
  final bool isCountryPicker;
  final TextInputAction inputAction;
  final bool needOutlineBorder;
  final bool readOnly;
  final bool needRequiredSign;
  final int maxLines;
  final bool animatedLabel;
  final Color fillColor;
  final Color fontColor;
  final bool isRequired;
  final bool hasIcon;
  final bool hastextcolor;
  final double fontSize;
  final bool showErrorText;
  final VoidCallback? onPress;
  final Color? prefixIconcolor;
  final Color? hintTextcolor;
  final double verticalPadding;
  final double circularCorner;
  final double boxHeight;
  final int? maxLength;
  final double iconSize;
  final bool? isDigitsOnly;

  const GroupIdCustomTextField(
      {super.key,
        this.labelText,
        this.readOnly = false,
        this.fillColor = Colors.transparent,
        this.fontColor = Colors.black,
        required this.onChanged,
        this.hintText,
        this.prefixicon,
        this.controller,
        this.focusNode,
        this.nextFocus,
        this.validator,
        this.textInputType,
        this.isEnable = true,
        this.isPassword = false,
        this.isShowSuffixIcon = false,
        this.isShowPrefixIcon = false,
        this.isIcon = false,
        this.onSuffixTap,
        this.fontSize = 10,
        this.isSearch = false,
        this.isCountryPicker = false,
        this.inputAction = TextInputAction.next,
        this.needOutlineBorder = false,
        this.needRequiredSign = false,
        this.maxLines = 1,
        this.animatedLabel = false,
        this.isRequired = false,
        this.hasIcon = false,
        this.hastextcolor = false,
        this.showErrorText = true,
        this.prefixIconcolor,
        this.hintTextcolor,
        this.verticalPadding = 0,
        this.circularCorner = 30,
        this.onPress,
        this.iconSize = 30,
        this.maxLength = 13,

        this.boxHeight = 30,
        this.isDigitsOnly = false});

  @override
  State<GroupIdCustomTextField> createState() => _GroupIdCustomTextFieldState();
}

class _GroupIdCustomTextFieldState extends State<GroupIdCustomTextField> {
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_updateTextToUppercase);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_updateTextToUppercase);
    super.dispose();
  }

  void _updateTextToUppercase() {
    if (widget.controller != null && widget.controller!.text != widget.controller!.text.toUpperCase()) {
      widget.controller!.value = widget.controller!.value.copyWith(
        text: widget.controller!.text.toUpperCase(),
        selection: TextSelection.collapsed(offset: widget.controller!.text.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.needOutlineBorder
        ? widget.animatedLabel
        ? TextFormField(

      onTap: () {
        if (widget.onPress != null) {
          widget.onPress!();
        }
      },
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      ],
      style: TextStyle(
          color: widget.hastextcolor == true
              ? Colors.black
              : Colors.black, fontSize: widget.fontSize),
      //textAlign: TextAlign.left,
      cursorColor: AppColors.primary,
      controller: widget.controller,
      autofocus: false,
      textInputAction: widget.inputAction,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? obscureText : false,
      decoration: InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        labelText: widget.labelText ?? '',
        floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps the label always floating above the field
        labelStyle:TextStyle(
            color: widget.hastextcolor
                ? AppColors.black
                : AppColors.black, fontSize: widget.fontSize),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.0),
          borderSide: BorderSide(color: AppColors.textFieldBorderColor, width: 0.5),
        ),

        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(obscureText
                ? Icons.visibility_off
                : Icons.visibility, color: widget.prefixIconcolor, size: 20), onPressed: _toggle)
            : widget.isIcon
            ? IconButton(
            onPressed: () {
              if (widget.onPress != null) {
                widget.onPress!(); // Handles custom suffix icon event
              }
            },
            icon: SvgPicture.asset(widget.prefixicon!, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE3,))
            : null
            : null,
      ),

      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      onChanged: (text) => widget.onChanged!(text),
    )
        : TextFormField(
      onTap: () {
        widget.onPress!();
      },
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      style:TextStyle(
          color: widget.hastextcolor == true
              ? widget.fontColor
              : AppColors.black, fontSize: widget.fontSize),
      //textAlign: TextAlign.left,
      inputFormatters: <TextInputFormatter>[
        widget.isDigitsOnly == true ? FilteringTextInputFormatter.allow(RegExp("[0-9]")) : FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
      ],
      cursorColor: AppColors.black,
      controller: widget.controller,
      autofocus: false,
      textInputAction: widget.inputAction,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.textInputType,

      obscureText: widget.isPassword ? obscureText : false,
      decoration: InputDecoration(
        counterText: "",
        /* prefixIcon: widget.hasIcon ? Icon(widget.prefixicon, color: widget.prefixIconcolor,) : null,*/
        /* constraints: BoxConstraints.loose(Size.fromHeight(widget.boxHeight)),*/
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        hintText: widget.hintText != null ? widget.hintText : '',
        hintStyle:TextStyle(fontSize: widget.fontSize, color: widget.hintTextcolor, fontWeight: FontWeight.w400),
        fillColor: widget.fillColor,
        filled: true,
        border: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 0.1,
                color: AppColors.labelTextColor),
            borderRadius:
            BorderRadius.circular(widget.circularCorner)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 0.1,
                color: AppColors.labelTextColor),
            borderRadius:
            BorderRadius.circular(widget.circularCorner)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                width: 0.1,
                color: AppColors.labelTextColor),
            borderRadius: BorderRadius.circular(widget.circularCorner)),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(
                obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.hintTextColor,
                size: 20),
            onPressed: _toggle)
            : widget.isIcon
            ? IconButton(
          onPressed: widget.onSuffixTap,
          icon: Icon(
            widget.isSearch
                ? Icons.search_outlined
                : widget.isCountryPicker
                ? Icons.arrow_drop_down_outlined
                : Icons.camera_alt_outlined,
            size: 25,
            color: AppColors.primary,
          ),
        )
            : null
            : null,

        prefixIcon: widget.isShowPrefixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(
                obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.hintTextColor,
                size: 20),
            onPressed: _toggle)
            : widget.isIcon
            ? IconButton(
            onPressed: widget.onSuffixTap,
            icon: SvgPicture.asset(search_scan, height: ScreenDimension.onePercentOfScreenHight * AppDimensions.ICONSIZE_2_6 ,)
        )
            : null
            : null,

      ),
      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      onChanged: (text) => widget.onChanged!(text),
    )
        : TextFormField(
      onTap: () {
        widget.onPress!();
      },
      maxLines: widget.maxLines,
      readOnly: widget.readOnly,
      style:  TextStyle(
          color: widget.hastextcolor
              ? widget.fontColor
              : AppColors.grey),
      //textAlign: TextAlign.left,
      cursorColor: AppColors.hintTextColor,
      controller: widget.controller,
      autofocus: false,
      textInputAction: widget.inputAction,
      enabled: widget.isEnable,
      focusNode: widget.focusNode,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      obscureText: widget.isPassword ? obscureText : false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: widget.verticalPadding, horizontal: 20),
        labelText: widget.labelText,
        labelStyle: TextStyle(
            color: widget.hastextcolor
                ? AppColors.textColorPrimary
                : AppColors.labelTextColor),
        fillColor: Colors.transparent,
        filled: true,
        border: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: AppColors.textFieldDisableBorderColor)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: AppColors.primary)),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(
                width: 0.5, color: AppColors.textFieldDisableBorderColor)),
        suffixIcon: widget.isShowSuffixIcon
            ? widget.isPassword
            ? IconButton(
            icon: Icon(
                obscureText
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppColors.hintTextColor,
                size: 20),
            onPressed: _toggle)
            : widget.isIcon
            ? IconButton(
          onPressed: widget.onSuffixTap,
          icon: Icon(
            widget.isSearch
                ? Icons.search_outlined
                : widget.isCountryPicker
                ? Icons.arrow_drop_down_outlined
                : Icons.camera_alt_outlined,
            size: 25,
            color: AppColors.primary,
          ),
        )
            : null
            : null,
      ),
      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
          : null,
      onChanged: (text) => widget.onChanged!(text),
    );
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
