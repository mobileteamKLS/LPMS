import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lpms/models/TerminalMaster.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import 'package:lpms/util/Global.dart';
import 'package:lpms/util/Uitlity.dart';
import '../../api/auth.dart';
import '../../models/ShippingList.dart';
import '../../theme/app_color.dart';
import '../../theme/app_theme.dart';
import '../../ui/widgest/AutoSuggest.dart';


class AddShipmentDetails extends StatefulWidget {
  final ShipmentDetailsExports? shipment;
  final bool isExport;

  const AddShipmentDetails({super.key, this.shipment, required this.isExport});

  @override
  State<AddShipmentDetails> createState() => _AddShipmentDetailsState();
}

class _AddShipmentDetailsState extends State<AddShipmentDetails> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode exporterFocusNode = FocusNode();
  final FocusNode cargoTypeFocusNode = FocusNode();
  late TextEditingController billNoController = TextEditingController();
  late TextEditingController billDateController = TextEditingController();
  late TextEditingController exporterNameController = TextEditingController();
  late TextEditingController hsnCodeController = TextEditingController();
  late TextEditingController cargoTypeController = TextEditingController();
  late TextEditingController cargoCategoryController = TextEditingController();
  late TextEditingController cargoDescriptionController =
  TextEditingController();
  late TextEditingController qualityController = TextEditingController();
  late TextEditingController weightController = TextEditingController();
  late TextEditingController valueController = TextEditingController();
  double fieldHeight = 45;
  double _textFieldHeight = 45;
  bool isValid = true;
  final RegExp hsnPattern = RegExp(r'^\d{6,8}$');
  final RegExp doublePattern = RegExp(r'^\d*\.?\d*$');
  int exporterId=0;
  int cargoTypeId=0;
  int cargoCategoryId=0;
  final AuthService authService = AuthService();
  final List<VoidCallback> _markFieldsTouched = [];
  void _addMarkTouchedCallback(VoidCallback callback) {
    _markFieldsTouched.add(callback);
  }

  void _markAllFieldsTouched() {
    for (var callback in _markFieldsTouched) {
      callback();
    }
  }
  clearControllers(){
    billNoController.clear();
    billDateController.clear();
    exporterNameController.clear();
    hsnCodeController.clear();
    cargoTypeController.clear();
    cargoCategoryController.clear();
    cargoDescriptionController.clear();
    valueController.text="0.0";
    qualityController.text="0";
    weightController.text="0.0";
  }


  @override
  void dispose() {
    billNoController.dispose();
    billDateController.dispose();
    exporterNameController.dispose();
    hsnCodeController.dispose();
    cargoTypeController.dispose();
    cargoCategoryController.dispose();
    cargoDescriptionController.dispose();
    valueController.dispose();
    qualityController.dispose();
    weightController.dispose();
    super.dispose();
  }

  late ShipmentDetailsExports editDetails;
  @override
  void initState() {
    super.initState();
    billNoController = TextEditingController(
        text: widget.shipment?.shippingBillNoIgmNno ?? '');
    billDateController =
        TextEditingController(text: widget.shipment?.shippingBillDateIgm ?? '');
    exporterNameController = TextEditingController(
        text: widget.shipment?.nameOfExporterImporter ?? '');
    hsnCodeController =
        TextEditingController(text: widget.shipment?.hsnCode ?? '');
    cargoTypeController =
        TextEditingController(text: widget.shipment?.cargoType ?? '');
    cargoCategoryController =
        TextEditingController(text: widget.shipment?.cargoCategory ?? '');
    cargoDescriptionController =
        TextEditingController(text: widget.shipment?.cargoDescription ?? '');
    qualityController =
        TextEditingController(text: widget.shipment?.quantity.toString() ?? '0');
    weightController = TextEditingController(
        text: widget.shipment?.cargoWeight.toString() ?? '0.0');
    valueController = TextEditingController(
        text: widget.shipment?.cargoValue.toString() ?? '0.0');
    exporterId=widget.shipment?.exporterId??0;
    cargoTypeId=widget.shipment?.cargoTypeId??0;
    cargoCategoryId=widget.shipment?.cargoTypeId??0;
    print("isExport shp: ${widget.isExport}");
    if (widget.shipment != null) editDetails = widget.shipment!;
    exporterFocusNode.addListener(() async {
      if (!exporterFocusNode.hasFocus) {
        final input = exporterNameController.text;
        final suggestions = await ExporterService.isValidAgent(input);
        if (!suggestions) {
          exporterNameController.clear();
          exporterId = 0;
          // formFieldState.didChange(null);
        }
      }
    });
    //
    // cargoTypeFocusNode.addListener(() async {
    //   if (!cargoTypeFocusNode.hasFocus) {
    //     final input = cargoTypeController.text;
    //     print("cargo type$input");
    //     final suggestions = await CargoTypeService.isValidAgent(input);
    //     print("cargo is $suggestions");
    //     if (!suggestions) {
    //       cargoTypeController.clear();
    //       cargoTypeId=0;
    //
    //     }
    //   }
    // });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.isExport ? 'Exports' : 'Imports',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 32),
          toolbarHeight: 60,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0057D8),
                  Color(0xFF1c86ff),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(
                  FontAwesomeIcons.userGear,
                  size: 26,
                ),
                color: Colors.white,
                onPressed: () {}),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(
                    FontAwesomeIcons.bell,
                    size: 26,
                  ),
                  // Bell icon
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.orange, // Notification dot color
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.white,
              onPressed: () {},
            ),
          ]),
      drawer: Drawer(
        child: ListView(
          children: const [Text('Drawer Item')],
        ),
      ),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Shipment Details',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        GestureDetector(
                          child: const Row(
                            children: [Icon(Icons.restart_alt_outlined, color: Colors.grey,),
                              Text(
                                'Clear',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal, fontSize: 18),
                              ),],
                          ),
                          onTap: (){
                            clearControllers();
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(12.0),
                    //     color: AppColors.white,
                    //   ),
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         vertical: 14, horizontal: 10),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             SizedBox(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "Type of Vehicle",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.sizeOf(context).height *
                    //                             0.003,
                    //                   ),
                    //                   const Text(
                    //                     "Truck",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorPrimary,
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.w700),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             SizedBox(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "No. of Vehicle",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.sizeOf(context).height *
                    //                             0.003,
                    //                   ),
                    //                   const Text(
                    //                     "2",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorPrimary,
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.w700),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             SizedBox(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "FTL/LTL",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.sizeOf(context).height *
                    //                             0.003,
                    //                   ),
                    //                   const Text(
                    //                     "FTL",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorPrimary,
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.w700),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(
                    //           height: MediaQuery.sizeOf(context).height * 0.015,
                    //         ),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: [
                    //             SizedBox(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "CHA Name",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                         MediaQuery.sizeOf(context).height *
                    //                             0.003,
                    //                   ),
                    //                   const Text(
                    //                     "ABC CHA",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorPrimary,
                    //                         fontSize: 16,
                    //                         fontWeight: FontWeight.w700),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: MediaQuery.sizeOf(context).height * 0.015,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                controller: billNoController,
                                labelText: widget.isExport
                                    ? "Shipping Bill No."
                                    : "BOE No.",
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15)
                                ],
                                registerTouchedCallback: _addMarkTouchedCallback,
                                // onApiCall: (v){
                                //   checkDuplicateShipBillNoAndDate();
                                // },
                              ),

                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              CustomDatePicker(
                                controller: billDateController,
                                labelText: widget.isExport
                                    ? 'Shipping Bill Date*'
                                    : "BOE Date",
                                allowFutureDates: false,
                                initialHeight: 45,
                                errorHeight: 65,
                                // onDatePicked: onDatePicked(),
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              // CustomTextField(
                              //   controller: exporterNameController,
                              //   labelText: "Name of Exporter",
                              //   inputType: TextInputType.text,
                              // ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: TypeAheadField<
                                    CargoTypeExporterImporterAgent>(
                                  controller: exporterNameController,
                                  debounceDuration:
                                  const Duration(milliseconds: 300),
                                  suggestionsCallback: (search) =>
                                      ExporterService.find(search),
                                  itemBuilder: (context, item) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          left: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          right: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          bottom: BorderSide
                                              .none, // No border on the bottom
                                        ),
                                        color: AppColors.white,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(item.code.toUpperCase()),
                                          const SizedBox(width: 10),
                                          Text(item.description.toUpperCase()),
                                        ],
                                      ),
                                    );
                                  },
                                  builder: (context, controller, focusNode) =>
                                      CustomTextField(
                                        controller: controller,
                                        labelText: "Name of Exporter",
                                        registerTouchedCallback:
                                        _addMarkTouchedCallback,
                                        focusNode: focusNode,
                                      ),
                                  decorationBuilder: (context, child) =>
                                      Material(
                                        type: MaterialType.card,
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: child,
                                      ),
                                  // itemSeparatorBuilder: (context, index) =>
                                  //     Divider(),
                                  emptyBuilder: (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No Exporter Found',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  listBuilder: (context, children) =>ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      reverse: SuggestionsController.of<CargoTypeExporterImporterAgent>(context).effectiveDirection ==
                                          VerticalDirection.up,
                                      children: children,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    exporterNameController.text =
                                        value.description
                                            .toUpperCase();
                                    exporterId=int.parse(value.value);
                                    _formKey.currentState!.validate();
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   width: MediaQuery
                              //       .sizeOf(context)
                              //       .width,
                              //   child: FormField<String>(
                              //     validator: (value) {
                              //       if (exporterNameController.text.isEmpty) {
                              //         setState(() {
                              //           _textFieldHeight = 45;
                              //         });
                              //         return '  Field is Required';
                              //       }
                              //       setState(() {
                              //         _textFieldHeight =
                              //         45;
                              //       });
                              //       return null;
                              //     },
                              //     builder: (formFieldState) {
                              //       return Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           widget.isExport ? AnimatedContainer(
                              //             duration: const Duration(
                              //                 milliseconds: 200),
                              //             height: _textFieldHeight,
                              //             // Dynamic height based on validation
                              //             child: TypeAheadField<
                              //                 CargoTypeExporterImporterAgent>(
                              //               hideSuggestionsOnKeyboardHide:true,
                              //               ignoreAccessibleNavigation: true,
                              //               textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //                 controller: exporterNameController,
                              //                 focusNode: exporterFocusNode,
                              //                 decoration:  InputDecoration(
                              //                   contentPadding:
                              //                   const EdgeInsets.symmetric(
                              //                       vertical: 12.0,
                              //                       horizontal: 10.0),
                              //                   border: const OutlineInputBorder(),
                              //                   labelText: 'Name of Exporter*',
                              //                   labelStyle: TextStyle(
                              //                     color: formFieldState.hasError
                              //                         ? AppColors.errorRed
                              //                         : Colors.black87,
                              //                   ),
                              //                 ),
                              //               ),
                              //               suggestionsCallback: (search) =>
                              //                   ExporterService.find(search),
                              //               itemBuilder: (context, city) {
                              //                 return Container(
                              //                   decoration: const BoxDecoration(
                              //                     border: Border(
                              //                       top: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       left: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       right: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       bottom: BorderSide
                              //                           .none, // No border on the bottom
                              //                     ),
                              //                   ),
                              //                   padding:
                              //                   const EdgeInsets.all(8.0),
                              //                   child: Row(
                              //                     children: [
                              //                       Text(city.code
                              //                           .toUpperCase()),
                              //                       const SizedBox(
                              //                         width: 10,
                              //                       ),
                              //                       Text(city.description
                              //                           .toUpperCase()),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               onSuggestionSelected: (city) {
                              //                 exporterNameController.text =
                              //                     city.description
                              //                         .toUpperCase();
                              //                 exporterId=int.parse(city.value);
                              //                 formFieldState
                              //                     .didChange(
                              //                     exporterNameController.text);
                              //                 _formKey.currentState!.validate();
                              //               },
                              //               noItemsFoundBuilder: (context) =>
                              //                   const Padding(
                              //                     padding: EdgeInsets.all(8.0),
                              //                     child: Text(
                              //                         'No Exporter Found'),
                              //                   ),
                              //             ),
                              //           ) :
                              //           AnimatedContainer(
                              //             duration: const Duration(
                              //                 milliseconds: 200),
                              //             height: _textFieldHeight,
                              //             // Dynamic height based on validation
                              //             child: TypeAheadField<
                              //                 CargoTypeExporterImporterAgent>(
                              //               hideSuggestionsOnKeyboardHide:true,
                              //               ignoreAccessibleNavigation: true,
                              //               textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //                 controller: exporterNameController,
                              //                 focusNode: exporterFocusNode,
                              //                 decoration: const InputDecoration(
                              //                   contentPadding:
                              //                   EdgeInsets.symmetric(
                              //                       vertical: 12.0,
                              //                       horizontal: 10.0),
                              //                   border: OutlineInputBorder(),
                              //                   labelText: 'Name of Importer',
                              //                 ),
                              //               ),
                              //               suggestionsCallback: (search) =>
                              //                   ImporterService.find(search),
                              //               itemBuilder: (context, city) {
                              //                 return Container(
                              //                   decoration: const BoxDecoration(
                              //                     border: Border(
                              //                       top: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       left: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       right: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       bottom: BorderSide
                              //                           .none, // No border on the bottom
                              //                     ),
                              //                   ),
                              //                   padding:
                              //                   const EdgeInsets.all(8.0),
                              //                   child: Row(
                              //                     children: [
                              //                       Text(city.code
                              //                           .toUpperCase()),
                              //                       const SizedBox(
                              //                         width: 10,
                              //                       ),
                              //                       Text(city.description
                              //                           .toUpperCase()),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               onSuggestionSelected: (city) {
                              //                 exporterNameController.text =
                              //                     city.description
                              //                         .toUpperCase();
                              //                 formFieldState
                              //                     .didChange(
                              //                     exporterNameController.text);
                              //               },
                              //               noItemsFoundBuilder: (context) =>
                              //               const Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Text('No Importer Found'),
                              //               ),
                              //             ),
                              //           ),
                              //           if (formFieldState.hasError)
                              //             Padding(
                              //               padding:
                              //               const EdgeInsets.only(
                              //                   top: 8.0, left: 16),
                              //               child: Text(
                              //                 formFieldState.errorText ?? '',
                              //                 style: const TextStyle(
                              //                     color:AppColors.errorRed,
                              //                     fontSize: 12),
                              //               ),
                              //             ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              CustomTextField(
                                controller: hsnCodeController,
                                labelText: 'HSN Code',
                                inputType: TextInputType.number,
                                isValidationRequired: true,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                registerTouchedCallback: _addMarkTouchedCallback,
                                validationPattern: hsnPattern,
                                patternErrorMessage:
                                'Enter a valid HSN code',
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: TypeAheadField<
                                    CargoCategory>(
                                  controller: cargoCategoryController,
                                  debounceDuration:
                                  const Duration(milliseconds: 300),
                                  suggestionsCallback: (search) =>
                                      CargoCategoryService.find(search),
                                  itemBuilder: (context, item) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          left: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          right: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          bottom: BorderSide
                                              .none, // No border on the bottom
                                        ),
                                        color: AppColors.white,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          // Text(item.code.toUpperCase()),
                                          // const SizedBox(width: 10),
                                          Text(item.description.toUpperCase()),
                                        ],
                                      ),
                                    );
                                  },
                                  builder: (context, controller, focusNode) =>
                                      CustomTextField(
                                        controller: controller,
                                        labelText: "Cargo Category",
                                        registerTouchedCallback:
                                        _addMarkTouchedCallback,
                                        focusNode: focusNode,
                                      ),
                                  decorationBuilder: (context, child) =>
                                      Material(
                                        type: MaterialType.card,
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: child,
                                      ),
                                  // itemSeparatorBuilder: (context, index) =>
                                  //     Divider(),
                                  emptyBuilder: (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No Cargo Category Found',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  listBuilder: (context, children) =>ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      reverse: SuggestionsController.of<CargoCategory>(context).effectiveDirection ==
                                          VerticalDirection.up,
                                      children: children,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    cargoCategoryController.text =
                                        value.description
                                            .toUpperCase();
                                    setState(() {
                                      cargoCategoryId=int.parse(value.value);
                                    });
                                    print("$cargoCategoryId");
                                    _formKey.currentState!.validate();
                                  },
                                ),
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: TypeAheadField<
                                    CargoTypeExporterImporterAgent>(
                                  controller: cargoTypeController,
                                  debounceDuration:
                                  const Duration(milliseconds: 300),
                                  suggestionsCallback: (search) =>
                                      CargoTypeService.find(search),
                                  itemBuilder: (context, item) {
                                    return Container(
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          left: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          right: BorderSide(
                                              color: Colors.black, width: 0.2),
                                          bottom: BorderSide
                                              .none, // No border on the bottom
                                        ),
                                        color: AppColors.white,
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          // Text(item.code.toUpperCase()),
                                          // const SizedBox(width: 10),
                                          Text(item.description.toUpperCase()),
                                        ],
                                      ),
                                    );
                                  },
                                  builder: (context, controller, focusNode) =>
                                      CustomTextField(
                                        controller: controller,
                                        labelText: "Cargo Type",
                                        registerTouchedCallback:
                                        _addMarkTouchedCallback,
                                        focusNode: focusNode,
                                      ),
                                  decorationBuilder: (context, child) =>
                                      Material(
                                        type: MaterialType.card,
                                        elevation: 4,
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: child,
                                      ),
                                  // itemSeparatorBuilder: (context, index) =>
                                  //     Divider(),
                                  emptyBuilder: (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No Cargo Type Found',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  listBuilder: (context, children) =>ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      reverse: SuggestionsController.of<CargoTypeExporterImporterAgent>(context).effectiveDirection ==
                                          VerticalDirection.up,
                                      children: children,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    cargoTypeController.text =
                                        value.description
                                            .toUpperCase();
                                    cargoTypeId=int.parse(value.value);
                                    _formKey.currentState!.validate();
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   width: MediaQuery
                              //       .sizeOf(context)
                              //       .width,
                              //   child: FormField<String>(
                              //     validator: (value) {
                              //       if (cargoTypeController.text.isEmpty) {
                              //         setState(() {
                              //           _textFieldHeight = 45;
                              //         });
                              //         return '  Field is Required';
                              //       }
                              //       setState(() {
                              //         _textFieldHeight =
                              //         45; // Reset to initial height if valid
                              //       });
                              //       return null; // Valid input
                              //     },
                              //     builder: (formFieldState) {
                              //       return Column(
                              //         crossAxisAlignment:
                              //         CrossAxisAlignment.start,
                              //         children: [
                              //           AnimatedContainer(
                              //             duration: const Duration(milliseconds: 200),
                              //             height: _textFieldHeight,
                              //             // Dynamic height based on validation
                              //             child: TypeAheadField<
                              //                 CargoTypeExporterImporterAgent>(
                              //               hideSuggestionsOnKeyboardHide:true,
                              //               ignoreAccessibleNavigation: true,
                              //               textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //                 controller: cargoTypeController,
                              //                 focusNode: cargoTypeFocusNode,
                              //                 decoration:  InputDecoration(
                              //                   contentPadding:
                              //                   const EdgeInsets.symmetric(
                              //                       vertical: 12.0,
                              //                       horizontal: 10.0),
                              //                   border: OutlineInputBorder(),
                              //                   labelText: 'Cargo Type*',
                              //                   labelStyle: TextStyle(
                              //                     color: formFieldState.hasError
                              //                         ? AppColors.errorRed
                              //                         : Colors.black87,
                              //                   ),
                              //                 ),
                              //               ),
                              //               suggestionsCallback: (search) =>
                              //                   CargoTypeService.find(search),
                              //               itemBuilder: (context, city) {
                              //                 return Container(
                              //                   decoration: const BoxDecoration(
                              //                     border: Border(
                              //                       top: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       left: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       right: BorderSide(
                              //                           color: Colors.black,
                              //                           width: 0.2),
                              //                       bottom: BorderSide
                              //                           .none, // No border on the bottom
                              //                     ),
                              //                   ),
                              //                   padding:
                              //                   const EdgeInsets.all(8.0),
                              //                   child: Row(
                              //                     children: [
                              //                       Text(city.description
                              //                           .toUpperCase()),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               onSuggestionSelected: (city) {
                              //                 print("onSuggestionSelected");
                              //                 cargoTypeController.text =
                              //                     city.description
                              //                         .toUpperCase();
                              //                 cargoTypeId=int.parse(city.value);
                              //                 formFieldState
                              //                     .didChange(
                              //                     cargoTypeController.text);
                              //                 _formKey.currentState!.validate();
                              //               },
                              //               noItemsFoundBuilder: (context) =>
                              //               const Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Text(
                              //                     'No Cargo Type Found'),
                              //               ),
                              //             ),
                              //           ),
                              //           if (formFieldState.hasError)
                              //             Padding(
                              //               padding:
                              //               const EdgeInsets.only(
                              //                   top: 8.0, left: 16.0),
                              //               child: Text(
                              //                 formFieldState.errorText ?? '',
                              //                 style: const TextStyle(
                              //                     color: AppColors.errorRed,
                              //                     fontSize: 12),
                              //               ),
                              //             ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              CustomTextField(
                                controller: cargoDescriptionController,
                                labelText: "Cargo Description",
                                inputType: TextInputType.text,
                                registerTouchedCallback: _addMarkTouchedCallback,
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextField(
                                    controller: qualityController,
                                    labelText: 'Quantity',
                                    customWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.43,
                                    inputType: TextInputType.number,
                                    isValidationRequired: true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10)
                                    ],
                                    registerTouchedCallback: _addMarkTouchedCallback,
                                  ),
                                  CustomTextField(
                                    controller: weightController,
                                    labelText: 'Cargo Weight',
                                    isValidationRequired: true,
                                    customWidth:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.43,

                                    inputType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                      DecimalTextInputFormatter(
                                          decimalRange: 2),
                                    ],
                                    validationPattern: doublePattern,
                                    registerTouchedCallback: _addMarkTouchedCallback,
                                    patternErrorMessage: 'Enter a valid number',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                MediaQuery
                                    .sizeOf(context)
                                    .height * 0.015,
                              ),
                              CustomTextField(
                                controller: valueController,
                                labelText: "Cargo Value",
                                isValidationRequired: false,
                                inputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .sizeOf(context)
                          .height * 0.015,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: AppColors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 45,
                                  width:
                                  MediaQuery
                                      .sizeOf(context)
                                      .width * 0.42,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      );
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 45,
                                  width:
                                  MediaQuery
                                      .sizeOf(context)
                                      .width * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _markAllFieldsTouched();
                                      if (_formKey.currentState!.validate()) {
                                        if(!isEdit || widget.shipment==null) {
                                          final newShipment = ShipmentDetailsExports(
                                            shippingBillNoIgmNno: billNoController
                                                .text,
                                            shippingBillDateIgm: billDateController
                                                .text,
                                            nameOfExporterImporter:
                                            exporterNameController.text,
                                            hsnCode: hsnCodeController.text,
                                            cargoType: cargoTypeController.text,
                                            cargoCategory:cargoCategoryController.text ,
                                            cargoDescription:
                                            cargoDescriptionController.text,
                                            quantity: int.parse(
                                                qualityController
                                                    .text),
                                            cargoWeight: double.parse(
                                                weightController.text),
                                            cargoValue: valueController.text,
                                            cargoTypeId: cargoTypeId,
                                            cargoCategoryId: cargoCategoryId,
                                            chaName: chaNameMaster,
                                            typeOfGoods: null,
                                            exporterId: exporterId,
                                            unitOfQt: null,
                                            portOfDest: null,
                                            grossQt: null,
                                            isUliPverified: false,  isULIPHSNCodePverified: false, hsnCodeList: [],

                                          );
                                          Navigator.pop(context,
                                              newShipment);
                                        }
                                        else{
                                          editDetails = widget.shipment!.copyWith(
                                            shippingBillNoIgmNno: billNoController
                                                .text,
                                            shippingBillDateIgm: billDateController
                                                .text,
                                            nameOfExporterImporter:
                                            exporterNameController.text,
                                            hsnCode: hsnCodeController.text,
                                            cargoType: cargoTypeController.text,
                                            cargoCategory:cargoCategoryController.text,
                                            cargoDescription:
                                            cargoDescriptionController.text,
                                            quantity: int.parse(
                                                qualityController
                                                    .text),
                                            cargoWeight: double.parse(
                                                weightController.text),
                                            cargoValue: valueController.text,
                                            cargoTypeId: cargoTypeId,
                                            cargoCategoryId: cargoCategoryId,
                                            chaName: chaNameMaster,
                                            typeOfGoods: null,
                                            exporterId: exporterId,
                                            unitOfQt: "",
                                            portOfDest: "",
                                            grossQt: null,
                                            isUliPverified: false,
                                            isULIPHSNCodePverified: false,
                                            hsnCodeList: [],
                                          );
                                          Navigator.pop(context,
                                              editDetails);
                                        }
                                      }
                                    },
                                    child: const Text(
                                      "Save",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .sizeOf(context)
                          .height * 0.015,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: CustomPaint(
                size: Size(MediaQuery
                    .of(context)
                    .size
                    .width,
                    100), // Adjust the height as needed
                painter: AppBarPainterGradient(),
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: BottomAppBar(
      //   padding: const EdgeInsets.symmetric(horizontal: 10),
      //   height: 60,
      //   color: Colors.white,
      //   surfaceTintColor: Colors.white,
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 5,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       GestureDetector(
      //         onTap: () {},
      //         child: const Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(CupertinoIcons.chart_pie),
      //             Text("Dashboard"),
      //           ],
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {},
      //         child: const Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: [
      //             Icon(
      //               Icons.help_outline,
      //               color: AppColors.primary,
      //             ),
      //             Text(
      //               "User Help",
      //               style: TextStyle(color: AppColors.primary),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
   onDatePicked() {
    checkDuplicateShipBillNoAndDate();
  }

  checkDuplicateShipBillNoAndDate() async {
    if(billNoController.text.isEmpty){

      return;
    }
    if(billDateController.text.isEmpty){
      return;
    }
    Utils.showLoadingDialog(context);
    var queryParams ={
      "SBillNo":billNoController.text,
      "SBillDt": DateFormat('d MMM yyyy').parse(billDateController.text).toIso8601String(),
      "DetailId": "0"
    };
    await authService
        .postData(
      "api_pcs/ShipmentMaster/CheckDuplicateShipBillNoAndDate",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData["ResponseMessage"]);
      if (jsonData["ResponseMessage"] =="msg15") {

        Utils.hideLoadingDialog(context);
        CustomSnackBar.show(context, message: "Shipping bill no already exists.");
      }
      Utils.hideLoadingDialog(context);
    }).catchError((onError) {
      Utils.hideLoadingDialog(context);
      print(onError);
    });
  }
}

