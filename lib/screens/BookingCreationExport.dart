import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lpms/screens/AddVehicleDetailsImport.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import 'package:lpms/util/Uitlity.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../api/auth.dart';
import '../models/LoginMaster.dart';
import '../models/SelectionModel.dart';
import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../ui/widgest/AutoSuggest.dart';
import '../ui/widgest/expantion_card.dart';
import '../util/Global.dart';
import 'AddVehicleDetailsExport.dart';
import 'Encryption.dart';
import 'AddShipmentDetailsExport.dart';
import 'ExportDashboard.dart';

class BookingCreationExport extends StatefulWidget {
  final String operationType;
  final int? bookingId;
  const BookingCreationExport({super.key, required this.operationType, this.bookingId});

  @override
  State<BookingCreationExport> createState() => _BookingCreationExportState();
}

class _BookingCreationExportState extends State<BookingCreationExport> {
  // final multiSelectController = MultiSelectController<Vehicle>();
  final TextEditingController chaController = TextEditingController();

  // final TextEditingController noOfVehiclesController = TextEditingController();
  bool enableVehicleNo = true;
  bool isValid = true;
  final FocusNode chaFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int modeSelected = 0;
  int chaIdMaster = 0;
  double _textFieldHeight = 45;
  double _textFieldHeight2 = 45;
  final double initialHeight = 45;
  final double errorHeight = 65;
  final AuthService authService = AuthService();
  final EncryptionService encryptionService = EncryptionService();

  List<SelectionModels> vehicleTypes = [];
  bool _isLoading = false;
  final List<VoidCallback> _markFieldsTouched = [];

  void _addMarkTouchedCallback(VoidCallback callback) {
    _markFieldsTouched.add(callback);
  }

  void _markAllFieldsTouched() {
    for (var callback in _markFieldsTouched) {
      callback();
    }
  }

  void _updateTextField() {
    if (modeSelected == 1) {
      noOfVehiclesController.text = '1';
      isFTlAndOneShipment = false;
    } else {
      isFTlAndOneShipment = true;
    }
    if (isFTlAndOneShipment && shipmentListExports.length > 1) {
      shipmentListExports = [shipmentListExports.first];
    }
    if (!isFTlAndOneShipment && noOfVehiclesController.text.isNotEmpty) {
      int maxItems = int.tryParse(noOfVehiclesController.text) ?? 1;
      if (vehicleListExports.length > maxItems) {
        vehicleListExports = vehicleListExports.sublist(0, maxItems);
      }
    }
    Utils.clearMasterDataForToggle();
  }

  @override
  void initState() {
    super.initState();
    originMaster = "";
    destinationMaster = "";
    noOfVehiclesController.clear();
    multiSelectController.clearAll();
    Utils.clearMasterData();
    isFTlAndOneShipment = true;
    getOriginDestination();
    noOfVehiclesController.text = "1";


    chaFocusNode.addListener(() async {
      if (!chaFocusNode.hasFocus) {
        final input = chaController.text;
        final suggestions = await CHAAgentService.isValidAgent(input);
        if (!suggestions) {
          chaController.clear();
          chaNameMaster = '';
          chaIdMaster = 0;
          // formFieldState.didChange(null);
        }
      }
    });
  }

  @override
  void dispose() {
    chaController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Exports',
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Landport'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: 'Landport Terminal',
                                border: OutlineInputBorder(),
                              ),
                              value: selectedTerminalId,
                              items: terminals.map((terminal) {
                                return DropdownMenuItem<int>(
                                  value: terminal['id'],
                                  child: Text(terminal['name'] ?? ''),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedTerminalId = value;
                                });
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }),
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
                    const Row(
                      children: [
                        Text(
                          'Booking Creation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradient1,
                            AppColors.gradient2,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 12, left: 10, bottom: 12, right: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "BOOKING INFO.",
                                  style: TextStyle(
                                      color: AppColors.cardTextColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.cardTextColor,
                                    ),
                                    Text(
                                      " $originMaster",
                                      style: const TextStyle(
                                          color: AppColors.cardTextColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.cardTextColor,
                                    ),
                                    Text(
                                      " $destinationMaster",
                                      style: const TextStyle(
                                          color: AppColors.cardTextColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        child: Text("NEW BOOKING"),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                              const Text(
                                "BASIC DETAILS",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.01,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.88,
                                    child: MultiDropdown<Vehicle>(
                                      items: items,
                                      controller: multiSelectController,
                                      enabled: true,
                                      searchEnabled: false,
                                      chipDecoration: const ChipDecoration(
                                        backgroundColor: AppColors.secondary,
                                        wrap: false,
                                        runSpacing: 4,
                                        spacing: 4,
                                      ),
                                      fieldDecoration: FieldDecoration(
                                        hintText: 'Types of Vehicles*',
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: AppColors.errorRed),
                                        ),
                                        hintStyle: !isValid
                                            ? const TextStyle(
                                                color: AppColors.errorRed)
                                            : const TextStyle(
                                                color: Colors.black54),
                                        showClearIcon: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          borderSide: const BorderSide(
                                              color: AppColors
                                                  .textFieldBorderColor),
                                        ),
                                        // focusedBorder: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(4),
                                        //   borderSide: const BorderSide(
                                        //     color: Colors.black87,
                                        //   ),
                                        // ),
                                      ),
                                      dropdownDecoration:
                                          const DropdownDecoration(
                                        marginTop: 2,
                                        maxHeight: 400,
                                        header: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Text(
                                            'Select vehicles from the list',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      dropdownItemDecoration:
                                          DropdownItemDecoration(
                                        selectedIcon: const Icon(
                                            Icons.check_box,
                                            color: AppColors.successColor),
                                        disabledIcon: Icon(Icons.lock,
                                            color: Colors.grey.shade300),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            isValid = false;
                                          });
                                          return 'Field is Required';
                                        }
                                        return null;
                                      },
                                      onSelectionChange: (selectedItems) {
                                        print("Selection changed");
                                        if (selectedItems.isNotEmpty) {
                                          setState(() {
                                            isValid = true;
                                          });
                                        }
                                        if (_formKey.currentState != null) {
                                          _formKey.currentState!.validate();
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: _textFieldHeight2,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.42,
                                    child: TextFormField(
                                      controller: noOfVehiclesController,
                                      enabled: modeSelected == 1 ? false : true,
                                      onChanged: (value) {
                                        if (int.parse(
                                                noOfVehiclesController.text) ==
                                            0) {
                                          noOfVehiclesController.text = "1";
                                        }
                                        setState(() {
                                          int maxItems =
                                              int.tryParse(value) ?? 1;
                                          if (vehicleListExports.length >
                                              maxItems) {
                                            vehicleListExports =
                                                vehicleListExports.sublist(
                                                    0, maxItems);
                                          }
                                        });
                                      },
                                      // Disable based on switch state
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "No of Vehicles",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(2),
                                      ],
                                      validator: (value) {
                                        if (modeSelected != 1 &&
                                            (value == null || value.isEmpty)) {
                                          setState(() {
                                            _textFieldHeight2 = 65;
                                          });
                                          return 'Field is Required';
                                        }
                                        setState(() {
                                          _textFieldHeight2 = 45;
                                        });
                                        return null; // No error
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    height: 45,
                                    width:
                                        MediaQuery.sizeOf(context).width * 0.42,
                                    child: ToggleSwitch(
                                      minWidth:
                                          MediaQuery.sizeOf(context).width *
                                              0.5,
                                      minHeight: 45.0,
                                      fontSize: 14.0,
                                      initialLabelIndex: modeSelected,
                                      activeBgColor: const [AppColors.primary],
                                      activeFgColor: Colors.white,
                                      inactiveBgColor: Colors.white,
                                      inactiveFgColor: Colors.grey[900],
                                      totalSwitches: 2,
                                      labels: const ['FTL', 'LTL'],
                                      cornerRadius: 0.0,
                                      borderWidth: 0.5,
                                      borderColor: [Colors.grey],
                                      onToggle: (index) {
                                        print('switched to: $index');

                                        setState(() {
                                          modeSelected = index!;
                                        });
                                        _updateTextField();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                child: TypeAheadField<
                                    CargoTypeExporterImporterAgent>(
                                  controller: chaController,
                                  debounceDuration:
                                      const Duration(milliseconds: 300),
                                  suggestionsCallback: (search) =>
                                      CHAAgentService.find(search),
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
                                    labelText: "CHA Name",
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
                                    child: Text('No CHA Found',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  onSelected: (value) {
                                    chaController.text =
                                        value.description.toUpperCase();
                                    chaNameMaster = value.description;
                                    chaIdMaster = int.parse(value.value);
                                    _formKey.currentState!.validate();
                                  },
                                ),
                              ),
                              // SizedBox(
                              //   width: MediaQuery.sizeOf(context).width,
                              //   child: FormField<String>(
                              //     validator: (value) {
                              //       if (chaController.text.isEmpty) {
                              //         setState(() {
                              //           _textFieldHeight = 45;
                              //         });
                              //         return 'Field is Required';
                              //       }
                              //       setState(() {
                              //         _textFieldHeight = initialHeight; // Reset to initial height if valid
                              //       });
                              //       return null; // Valid input
                              //     },
                              //     builder: (formFieldState) {
                              //
                              //       chaController.addListener(() {
                              //         if (formFieldState.hasError && chaController.text.isNotEmpty) {
                              //           formFieldState.didChange(chaController.text); // Clear error
                              //         }
                              //       });
                              //
                              //       return Column(
                              //         crossAxisAlignment: CrossAxisAlignment.start,
                              //         children: [
                              //           AnimatedContainer(
                              //             duration: Duration(milliseconds: 200),
                              //             height: _textFieldHeight, // Dynamic height based on validation
                              //             child: TypeAheadField<CargoTypeExporterImporterAgent>(
                              //               hideSuggestionsOnKeyboardHide: true,
                              //               ignoreAccessibleNavigation: true,
                              //               textFieldConfiguration: TextFieldConfiguration(
                              //                 controller: chaController,
                              //                 focusNode: chaFocusNode,
                              //                 decoration: InputDecoration(
                              //                   contentPadding: const EdgeInsets.symmetric(
                              //                       vertical: 12.0, horizontal: 10.0),
                              //                   labelText: 'CHA Name*',
                              //                   labelStyle: TextStyle(
                              //                     color: formFieldState.hasError
                              //                         ? AppColors.errorRed
                              //                         : Colors.black87,
                              //                   ),
                              //                   // Set border depending on the error state
                              //                   border: OutlineInputBorder(
                              //                     borderRadius: BorderRadius.circular(4),
                              //                     borderSide: const BorderSide(
                              //                       color:  AppColors.errorRed
                              //                           ,
                              //                     ),
                              //                   ),
                              //
                              //                   errorBorder:
                              //                       OutlineInputBorder(
                              //                     borderRadius: BorderRadius.circular(4),
                              //                     borderSide: const BorderSide(color: AppColors.errorRed),
                              //                   )
                              //                       ,
                              //                   focusedErrorBorder:  OutlineInputBorder(
                              //                     borderRadius: BorderRadius.circular(4),
                              //                     borderSide: BorderSide(color: AppColors.errorRed),
                              //                   )
                              //                      ,
                              //                 ),
                              //               ),
                              //               suggestionsCallback: (search) => CHAAgentService.find(search),
                              //               itemBuilder: (context, city) {
                              //                 return Container(
                              //                   decoration: const BoxDecoration(
                              //                     border: Border(
                              //                       top: BorderSide(color: Colors.black, width: 0.2),
                              //                       left: BorderSide(color: Colors.black, width: 0.2),
                              //                       right: BorderSide(color: Colors.black, width: 0.2),
                              //                       bottom: BorderSide.none, // No border on the bottom
                              //                     ),
                              //                   ),
                              //                   padding: const EdgeInsets.all(8.0),
                              //                   child: Row(
                              //                     children: [
                              //                       Text(city.code.toUpperCase()),
                              //                       const SizedBox(width: 10),
                              //                       Text(city.description.toUpperCase()),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //               onSuggestionSelected: (city) {
                              //                 chaController.text = city.description.toUpperCase();
                              //                 chaNameMaster = city.description;
                              //                 chaIdMaster = int.parse(city.value);
                              //                 formFieldState.didChange(chaController.text);
                              //                 _formKey.currentState!.validate();
                              //               },
                              //               noItemsFoundBuilder: (context) => const Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Text('No CHA Found'),
                              //               ),
                              //             ),
                              //           ),
                              //           if (formFieldState.hasError)
                              //             Padding(
                              //               padding: const EdgeInsets.only(top: 4.0, left: 16),
                              //               child: Text(
                              //                 formFieldState.errorText ?? '',
                              //                 style: const TextStyle(
                              //                     color: AppColors.errorRed, fontSize: 12),
                              //               ),
                              //             ),
                              //         ],
                              //       );
                              //     },
                              //   )
                              //   ,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddShipmentDetailsListNew(
                      shipmentDetailsList: shipmentListExports,
                      validateAndNavigate: validateAndNavigate,
                      isExport: true,
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddVehicleDetailsListExportsNew(
                      vehicleDetailsList: vehicleListExports,
                      validateAndNavigate: validateAndNavigateV2,
                      isExport: true,
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
                                      multiSelectController.clearAll();
                                      Navigator.pop(context);
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
                                      if (_formKey.currentState!.validate()) {
                                        saveBookingDetailsExport();
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
          _isLoading
              ? Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
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

  Future<ShipmentDetailsExports?> validateAndNavigate() async {
    _markAllFieldsTouched();
    if (_formKey.currentState!.validate()) {
      return await Navigator.push<ShipmentDetailsExports>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddShipmentDetails(
            isExport: true,
          ),
        ),
      );
    } else {
      // Return null if validation fails
      return null;
    }
  }

  Future<VehicleDetailsExports?> validateAndNavigateV2() async {
    _markAllFieldsTouched();
    if (_formKey.currentState!.validate()) {
      return await Navigator.push<VehicleDetailsExports>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddVehicleDetailsExports(),
        ),
      );
    } else {

      return null;
    }
  }

  Future<void> callAllApis() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await Future.wait([
        loadCargoTypes(),
        loadCHAExporterNames('Agent'),
        loadCHAExporterNames('Exporter'),

      ]);
      if(widget.operationType!="C"){
        getViewEditShipment(widget.bookingId);
      }
    } catch (e) {
      print("Error calling APIs: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadCargoTypes() async {
    cargoTypeList = [];
    await Future.delayed(const Duration(seconds: 2));

    final mdl = SelectionModels();
    mdl.topRecord ??= 10; // Assign 10 if topRecord is null
    mdl.topRecord = mdl.topRecord == 10 ? 999 : mdl.topRecord;
    mdl.allRecord = false;
    mdl.isTariff = false;
    mdl.isDisabled = false;
    mdl.whereCondition =
        "CLOV.Identifier = ''CargoType'' AND Coalesce(CLOV.IsDeleted,0) = 0 AND Coalesce(CLOV.IsActive,0) = 1 AND ISNULL(CLOV.Community_Admin_OrgId,0)=${loginMaster[0].adminOrgId}";
    mdl.description = "Concat(CLOV.Code,'' - '',CLOV.Description)";

    SelectionQuery body = SelectionQuery();
    body.query =
        await encryptionService.encryptUsingRandomKeyPrivateKey(mdl.toJson());
    mdl.query = body.query;

    var headers = {
      'Accept': 'text/plain',
      'Content-Type': 'multipart/form-data',
    };
    var fields = {
      'Query': '${body.query}',
    };

    try {
      final response = await authService.sendMultipartRequest(
        headers: headers,
        fields: fields,
        endPoint: "api/GenericDropDown/GetAllClientListOfValues",
      );

      if (response.body.isNotEmpty) {
        print("-----Cargo Types-----");
        List<dynamic> jsonData = json.decode(response.body);
        print("-----Cargo Types----- $jsonData");
        print("-----Cargo Types Length= ${jsonData.length}-----");

        setState(() {
          cargoTypeList = jsonData
              .map((json) => CargoTypeExporterImporterAgent.fromJSON(json))
              .toList();
        });
        print("-----Cargo Types Length= ${cargoTypeList.length}-----");
      } else {
        print("Response is empty");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadCHAExporterNames(basedOnPrevious) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = true;
    });
    exporterList = [];
    cargoTypeList = [];
    final mdl = SelectionModels();
    mdl.jointableName = 'Organization_Businessline OB ';
    mdl.allRecord = true;
    mdl.jointableCondition =
        '''OB.OrgId = O.OrgId inner join OrganizationDetails OD with(nolock) on OD.OrgId = O.OrgId and OD.RegistrationPaymentStatus=''PAID'' and OD.RequestStatus=''Activated'' and OD.SubscriptionStatus=''Active'' AND COALESCE(OD.IsExpire, 0) = 0 ''';
    if (basedOnPrevious != null) {
      mdl.whereCondition =
          '''O.Community_Admin_OrgId=${loginMaster[0].adminOrgId} AND OB.BusinesslineId = (select top 1 BusinessTypeID from Master_BusinessType where Community_Admin_OrgId=${loginMaster[0].adminOrgId} and LOWER(BusinessType) = LOWER(''${basedOnPrevious}''))''';
    } else {
      mdl.whereCondition =
          'O.Community_Admin_OrgId=${loginMaster[0].adminOrgId}';
    }
    SelectionQuery body = SelectionQuery();
    body.query =
        await encryptionService.encryptUsingRandomKeyPrivateKey(mdl.toJson());

    mdl.query = body.query;
    Utils.printPrettyJson(
        encryptionService.decryptUsingRandomKeyPrivateKey(body.query));

    var headers = {
      'Accept': 'text/plain',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${loginMaster[0].token}',
    };
    var fields = {
      'Query': '${body.query}',
    };

    await authService
        .sendMultipartRequest(
            headers: headers,
            fields: fields,
            endPoint: "api/GenericDropDown/GetAllOrganizations")
        .then((response) {
      if (response.body.isNotEmpty) {
        json.decode(response.body);
        print("-----$basedOnPrevious-----");
        print(json.decode(response.body));
        List<dynamic> jsonData = json.decode(response.body);
        if (basedOnPrevious == "Exporter") {
          setState(() {
            exporterList = jsonData
                .map((json) => CargoTypeExporterImporterAgent.fromJSON(json))
                .toList();
          });
          print("-----$basedOnPrevious Length= ${exporterList.length}-----");
        } else if (basedOnPrevious == "Agent") {
          setState(() {
            chaAgentList = jsonData
                .map((json) => CargoTypeExporterImporterAgent.fromJSON(json))
                .toList();
          });
          print("-----$basedOnPrevious Length= ${chaAgentList.length}-----");
        }
      } else {
        print("response is empty");
      }
      setState(() {
        setState(() {
          _isLoading = false;
        });
      });
    }).catchError((onError) {
      setState(() {
        setState(() {
          _isLoading = false;
        });
      });
    });
    // await authService
    //     .fetchLoginDataPOST(
    //         "api/GenericDropDown/GetAllVehicleType", fields, headers)
    //     .then((response) {
    //   print("data received ");
    //   if (response.body.isNotEmpty) {
    //     json.decode(response.body);
    //     print(json.decode(response.body));
    //   } else {
    //     print("response is empty");
    //   }
    //   setState(() {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    // }).catchError((onError) {
    //   setState(() {
    //     setState(() {
    //       _isLoading = false;
    //     });
    //   });
    //   print(onError);
    // });
  }

  bool validateVehicleDetailsList() {
    for (var obj in vehicleListExports) {
      if (obj.drivingLicense == null ||
          obj.rcScanned == null ||
          obj.slotViewDateTime.isEmpty) {
        return false;
      }
    }
    return true;
  }

  saveBookingDetailsExport() async {
    // if (shipmentListExports.isEmpty && vehicleListExports.isEmpty) {
    //   CustomSnackBar.show(context,
    //       message: "Shipment and Vehicle Details are required");
    //   return;
    // }
    if (shipmentListExports.isEmpty) {
      CustomSnackBar.show(context, message: "Please fill up Shipment Details.");
      return;
    }
    // if (vehicleListExports.isEmpty) {
    //   CustomSnackBar.show(context, message: "Vehicle Details are required");
    //   return;
    // }
    for (var vehicleDetails in vehicleListExports) {
      String? drivingLicenseError = vehicleDetails.validateDrivingLicense();
      if (drivingLicenseError != null) {
        CustomSnackBar.show(context,
            message: "$drivingLicenseError ${vehicleDetails.truckNo}");
        print("Dl");
        return;
      }

      String? rcScannedError = vehicleDetails.validateRcScanned();
      if (rcScannedError != null) {
        CustomSnackBar.show(context,
            message: "$rcScannedError ${vehicleDetails.truckNo}");
        print("rc");
        return;
      }
      if (vehicleListExports.isNotEmpty) {
        if (int.parse(noOfVehiclesController.text) !=
            vehicleListExports.length) {
          CustomSnackBar.show(context,
              message: "Please add details for remaining vehicles.");
          return;
        }
      }

      // String slotViewDateTimeError = vehicleDetails.validateSlotViewDateTime();
      // if (slotViewDateTimeError != "") {
      //   CustomSnackBar.show(context, message: "$slotViewDateTimeError ${vehicleDetails.truckNo}");
      //   print("slotdt");
      //   return;
      // }
    }

    // setState(() {
    //   _isLoading = true;
    // });

    Utils.showLoadingDialog(context);
    List<String> vehicleIdList =
        selectedVehicleList.map((vehicle) => vehicle.id).toList();

    SlotBookingCreationExport bookingCreationExport = SlotBookingCreationExport(
      bookingId: 0,
      vehicleType: vehicleIdList,
      bookingDt: null,
      noofVehicle: int.parse(noOfVehiclesController.text),
      isFtl: modeSelected == 0,
      isLtl: modeSelected == 1,
      origin: originMaster,
      destination: destinationMaster,
      hsnCode: null,
      cargoValue: null,
      shipmentDetailsList: shipmentListExports,
      vehicalDetailsList: vehicleListExports,
      chaName: chaNameMaster,
      chaId: chaIdMaster,
      unitOfQt: null,
      portOfDest: null,
      grossQt: null,
      orgProdId: loginMaster[0].adminOrgProdId,
      userId: loginMaster[0].userId,
      branchCode: loginMaster[0].branchCode,
      companyCode: loginMaster[0].companyCode,
      airportId: selectedTerminalId!,
      paCompanyCode: loginMaster[0].companyCode,
      screenId: 9065,
      adminOrgProdId: loginMaster[0].adminOrgProdId,
      orgId: loginMaster[0].adminOrgId,
    );
    Map<String, dynamic> payload = bookingCreationExport.toJson();
    Utils.printPayload(payload);

    await authService
        .postData(
      "api_pcs/ShipmentMaster/UpSertShipment",
      payload,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      if (jsonData["ResponseMessage"] == "msg15") {
        Utils.hideLoadingDialog(context);
        CustomSnackBar.show(context,
            message: "Shipping bill no already exists.");
        return;
      }
      Utils.hideLoadingDialog(context);
      CustomSnackBar.show(context,
          message: "Export Shipment Booking Created Successfully",
          backgroundColor: AppColors.successColor,
          leftIcon: Icons.check_circle);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ExportScreen()));
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      print(onError);
    });
  }

  getOriginDestination() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    var queryParams = {
      "TerminalId": selectedTerminalId,
      "IsImportShipment": false,
    };
    await authService
        .postData(
      "api_master/Airport/GetAirportOriginDestination",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (jsonData["Origin"] != null && jsonData["Origin"] != null) {
        setState(() {
          originMaster = jsonData["Origin"];
          destinationMaster = jsonData["Destination"];
        });
        callAllApis();
      } else {
        setState(() {
          _isLoading = false;
        });
        CustomSnackBar.show(context, message: "No Data Found");
        Navigator.pop(context);
      }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      print(onError);
    });
  }

  getViewEditShipment(bookingId) async {
    setState(() {
      _isLoading = true;
    });

    var queryParams = {
      "BookingId": bookingId.toString(),
      "TimeZone": loginMaster[0].timeZone,
    };
    await authService
        .getData(
      "api_pcs/ShipmentMaster/GetShipmentById",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      setState(() {
        shipmentListExports=(jsonData['ShipmentDetailsList'] as List).map((item) => ShipmentDetailsExports.fromJson(item))
            .toList();
      });
      setState(() {
        vehicleListExports=(jsonData['VehicalDetailsList'] as List).map((item) => VehicleDetailsExports.fromJson(item))
            .toList();
      });

      print("Driver Name: ${vehicleListExports[0].driverName}");
      print("Driving License Document Name: ${vehicleListExports[0].drivingLicense.toString()}");
      print("RC Document File Path: ${vehicleListExports[0].rcScanned?.filePath}");
      setState(() {
        _isLoading = false;
      });
      // if (jsonData["Origin"] != null && jsonData["Origin"] != null) {
      //   setState(() {
      //     originMaster = jsonData["Origin"];
      //     destinationMaster = jsonData["Destination"];
      //   });
      //   callAllApis();
      // } else {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   CustomSnackBar.show(context, message: "No Data Found");
      //   Navigator.pop(context);
      // }
    }).catchError((onError) {
      setState(() {
        _isLoading = false;
      });
      print(onError);
    });
  }

}

class Vehicle {
  final String name;
  final String id;

  Vehicle({required this.name, required this.id});
}
