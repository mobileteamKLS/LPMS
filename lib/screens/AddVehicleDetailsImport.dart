import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../ui/widgest/AutoSuggest.dart';
import '../util/Global.dart';
import 'BookingCreationExport.dart';


class AddVehicleDetailsImports extends StatefulWidget {
  final VehicleDetailsImports? vehicleDetails;
  const AddVehicleDetailsImports({super.key, this.vehicleDetails});

  @override
  State<AddVehicleDetailsImports> createState() => _AddVehicleDetailsImportsState();
}

class _AddVehicleDetailsImportsState extends State<AddVehicleDetailsImports> {
  final _formKey = GlobalKey<FormState>();
  late int vehicleTypeId;
  late TextEditingController vehicleTypeController = TextEditingController();
  late TextEditingController vehicleNoController = TextEditingController();
  late TextEditingController driverLicenseNoController = TextEditingController();
  late TextEditingController driverMobNoController =
  TextEditingController();
  late TextEditingController driverDOBController = TextEditingController();
  late TextEditingController driverNameController = TextEditingController();
  late TextEditingController remarkController = TextEditingController();
  double fieldHeight = 45;
  double _textFieldHeight = 45;
  final FocusNode _cityFocusNode = FocusNode();
  bool isValid = true;
  late RegExp hsnPattern = RegExp(r'^\d{6,8}$');
  late RegExp doublePattern = RegExp(r'^\d*\.?\d*$');
  final List<VoidCallback> _markFieldsTouched = [];
  void _addMarkTouchedCallback(VoidCallback callback) {
    _markFieldsTouched.add(callback);
  }
  late VehicleDetailsImports editDetails;
  void _markAllFieldsTouched() {
    for (var callback in _markFieldsTouched) {
      callback();
    }
  }

  clearControllers(){
    vehicleTypeController.clear();
    vehicleNoController.clear();
    driverLicenseNoController.clear();
    driverDOBController.clear();
    driverMobNoController.clear();
    driverNameController.clear();
    remarkController.clear();

  }

  @override
  void initState() {
    super.initState();
    print(widget.vehicleDetails?.vehicleId);
    vehicleTypeId=widget.vehicleDetails?.vehicleTypeId ??0;
    print(vehicleTypeId);
    vehicleTypeController = TextEditingController(text: widget.vehicleDetails?.vehicleTypeName ?? '');
    vehicleNoController = TextEditingController(text: widget.vehicleDetails?.truckNo ?? '');
    driverLicenseNoController = TextEditingController(text: widget.vehicleDetails?.drivingLicenseNo ?? '');
    driverDOBController = TextEditingController(text: widget.vehicleDetails?.driverDob ?? '');
    driverMobNoController = TextEditingController(text: widget.vehicleDetails?.driverContact ?? '');
    driverNameController = TextEditingController(text: widget.vehicleDetails?.driverName ?? '');
    remarkController = TextEditingController(text: widget.vehicleDetails?.remarksChassisNo ?? '');
    if (widget.vehicleDetails != null) editDetails = widget.vehicleDetails!;
    selectedVehicleList = multiSelectController.selectedItems.map((item) {
      return Vehicle(id:item.value.id, name:item.value.name);
    }).toList();

  }

  @override
  void dispose() {
    // vehicleTypeController.dispose();
    // driverLicenseNoController.dispose();
    // driverMobNoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Imports',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 32),
          toolbarHeight: 80,
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
                          'Vehicle Details',
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
                    //                 CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "Type of Vehicle",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                     MediaQuery.sizeOf(context).height *
                    //                         0.003,
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
                    //                 CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "No. of Vehicle",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                     MediaQuery.sizeOf(context).height *
                    //                         0.003,
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
                    //                 CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "FTL/LTL",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                     MediaQuery.sizeOf(context).height *
                    //                         0.003,
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
                    //                 CrossAxisAlignment.start,
                    //                 children: [
                    //                   const Text(
                    //                     "CHA Name",
                    //                     style: TextStyle(
                    //                         color: AppColors.textColorSecondary,
                    //                         fontSize: 14),
                    //                   ),
                    //                   SizedBox(
                    //                     height:
                    //                     MediaQuery.sizeOf(context).height *
                    //                         0.003,
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
                              // CustomDatePicker(
                              //   controller: billDateController,
                              //   labelText: 'Shipping Bill Date',
                              //   allowPastDates: false,
                              // ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),

                              // CustomTextField(
                              //   controller: vehicleTypeController,
                              //   labelText: "Type of Vehicle",
                              //   inputType: TextInputType.text,
                              // ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: TypeAheadField<
                                    Vehicle>(
                                  controller: vehicleTypeController,
                                  debounceDuration:
                                  const Duration(milliseconds: 300),
                                  suggestionsCallback: (search) =>
                                      SelectedVehicleService.find(search),
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
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(item.name),

                                        ],
                                      ),
                                    );
                                  },
                                  builder: (context, controller, focusNode) =>
                                      CustomTextField(
                                        controller: controller,
                                        labelText: "Types of Vehicle",
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
                                  itemSeparatorBuilder: (context, index) =>
                                      Divider(),
                                  emptyBuilder: (context) => const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('No Vehicle Found',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  onSelected: (value) {
                                    vehicleTypeController.text =
                                        value.name;
                                    vehicleTypeId=int.parse(value.id);
                                    _formKey.currentState!.validate();
                                  },
                                ),
                              ),

                              // SizedBox(
                              //   width: MediaQuery.sizeOf(context).width,
                              //   child: FormField<String>(
                              //     validator: (value) {
                              //       if (vehicleTypeController.text.isEmpty) {
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
                              //                 Vehicle>(
                              //               hideSuggestionsOnKeyboardHide:true,
                              //               ignoreAccessibleNavigation: true,
                              //               textFieldConfiguration:
                              //               TextFieldConfiguration(
                              //                 controller: vehicleTypeController,
                              //                 focusNode: _cityFocusNode,
                              //                 decoration: const InputDecoration(
                              //                   contentPadding:
                              //                   EdgeInsets.symmetric(
                              //                       vertical: 12.0,
                              //                       horizontal: 10.0),
                              //                   border: OutlineInputBorder(),
                              //                   labelText: 'Types of Vehicle',
                              //                 ),
                              //               ),
                              //               suggestionsCallback: (search) =>
                              //                   SelectedVehicleService.find(search),
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
                              //
                              //                       Text(city.name
                              //                           ),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               onSuggestionSelected: (city) {
                              //                 vehicleTypeController.text =
                              //                     city.name;
                              //                 vehicleTypeId=int.parse(city.id);
                              //                 formFieldState
                              //                     .didChange(vehicleTypeController.text);
                              //               },
                              //               noItemsFoundBuilder: (context) =>
                              //               const Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Text('No Vehicle Found'),
                              //               ),
                              //             ),
                              //           ),
                              //           if (formFieldState.hasError)
                              //             Padding(
                              //               padding:
                              //               const EdgeInsets.only(top: 8.0,left: 16),
                              //               child: Text(
                              //                 formFieldState.errorText ?? '',
                              //                 style: const TextStyle(
                              //                     color: AppColors.errorRed,fontSize: 12),
                              //               ),
                              //             ),
                              //         ],
                              //       );
                              //     },
                              //   ),
                              // ),

                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: vehicleNoController,
                                labelText: "Vehicle No.",
                                inputType: TextInputType.text,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                registerTouchedCallback: _addMarkTouchedCallback,
                              ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: driverLicenseNoController,
                                labelText: "Driving License No.",
                                inputType: TextInputType.text,
                                inputFormatters: [

                                  LengthLimitingTextInputFormatter(16)
                                ],
                                registerTouchedCallback: _addMarkTouchedCallback,
                              ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomDatePicker(
                                controller: driverDOBController,
                                labelText: "Driver DOB",
                                allowPastDates: true,
                                allowFutureDates: false,
                                isRequiredField: false,
                              ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: driverNameController,
                                labelText: "Driver Name",
                                inputType: TextInputType.text,
                                inputFormatters: [

                                  LengthLimitingTextInputFormatter(50)
                                ],
                                registerTouchedCallback: _addMarkTouchedCallback,
                              ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: driverMobNoController,
                                labelText: "Driver Mobile No.",
                                inputType: TextInputType.phone,
                                isValidationRequired: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                              ),
                              SizedBox(
                                height:
                                MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: remarkController,
                                labelText: "Remark/Chassis No.",
                                inputType: TextInputType.text,
                                isValidationRequired: false,
                                inputFormatters: [

                                  LengthLimitingTextInputFormatter(16)
                                ],

                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
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
                                  MediaQuery.sizeOf(context).width * 0.42,
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
                                  MediaQuery.sizeOf(context).width * 0.42,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _markAllFieldsTouched();
                                      if (_formKey.currentState?.validate() ?? false) {
                                        print("$vehicleTypeId");
                                       if(!isEdit){
                                         final newVehicle = VehicleDetailsImports(
                                           vehicleTypeId:  vehicleTypeId,
                                           vehicleTypeName: vehicleTypeController.text,
                                           truckNo: vehicleNoController.text,
                                           drivingLicenseNo: driverLicenseNoController.text,
                                           driverContact: driverMobNoController.text,
                                           driverDob: driverDOBController.text,
                                           driverName:driverNameController.text,
                                           remarksChassisNo:remarkController.text,
                                         );
                                         Navigator.pop(context,
                                             newVehicle);
                                       }
                                       else{
                                         editDetails =
                                             widget.vehicleDetails!.copyWith(
                                           vehicleTypeId:  vehicleTypeId,
                                           vehicleTypeName: vehicleTypeController.text,
                                           truckNo: vehicleNoController.text,
                                           drivingLicenseNo: driverLicenseNoController.text,
                                           driverContact: driverMobNoController.text,
                                           driverDob: driverDOBController.text,
                                           driverName:driverNameController.text,
                                           remarksChassisNo:remarkController.text,
                                           slotConfigId: 0,
                                           slotDurationId: 0,
                                               isModifySlot: false,
                                               isNewSlot: false
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
                      height: MediaQuery.sizeOf(context).height * 0.015,
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
                size: Size(MediaQuery.of(context).size.width,
                    100), // Adjust the height as needed
                painter: AppBarPainterGradient(),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.chart_pie),
                  Text("Dashboard"),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.help_outline,
                    color: AppColors.primary,
                  ),
                  Text(
                    "User Help",
                    style: TextStyle(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


