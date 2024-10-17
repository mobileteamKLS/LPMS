import 'dart:convert';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lpms/screens/VehicleDetails.dart';
import 'package:lpms/util/Uitlity.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../api/auth.dart';
import '../models/SelectionModel.dart';
import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../ui/widgest/AutoSuggest.dart';
import '../ui/widgest/expantion_card.dart';
import '../util/Global.dart';
import 'Encryption.dart';
import 'ShipmentDetails.dart';

class BookingCreationExport extends StatefulWidget {
  const BookingCreationExport({super.key});

  @override
  State<BookingCreationExport> createState() => _BookingCreationExportState();
}

class _BookingCreationExportState extends State<BookingCreationExport> {
  // final multiSelectController = MultiSelectController<Vehicle>();
  final TextEditingController chaController = TextEditingController();
  final TextEditingController noOfVehiclesController = TextEditingController();
  bool enableVehicleNo = true;
  bool isValid = true;
  final FocusNode _cityFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int modeSelected = 0;
  double _textFieldHeight = 45; // Default initial height
  double _textFieldHeight2 = 45; // Default initial height
  final double initialHeight = 45;
  final double errorHeight = 65;
  final List categoriesData = [
    {
      'name': 'SHIPMENT DETAILS',
      'sub_categories': [],
    },
  ];
  List<ShipmentDetails> shipmentList1 = [
    ShipmentDetails(
      billNo: "SBN001",
      billDate: "2024-10-01",
      exporterName: "Global Exports Ltd",
      hsnCode: "123456",
      cargoType: "Electronics",
      cargoDescription: "Smartphones and accessories",
      quality: "High",
      cargoWeight: "500kg",
      cargoValue: "\$50,000",
    ),
    ShipmentDetails(
      billNo: "SBN002",
      billDate: "2024-10-02",
      exporterName: "Oceanic Cargo Pvt Ltd",
      hsnCode: "654321",
      cargoType: "Textiles",
      cargoDescription: "Cotton Fabrics",
      quality: "Medium",
      cargoWeight: "1200kg",
      cargoValue: "\$30,000",
    ),
    ShipmentDetails(
      billNo: "SBN003",
      billDate: "2024-10-03",
      exporterName: "Sky High Logistics",
      hsnCode: "789012",
      cargoType: "Machinery",
      cargoDescription: "Industrial Machinery",
      quality: "Premium",
      cargoWeight: "2000kg",
      cargoValue: "\$100,000",
    ),
  ];
  List<VehicleDetails> dummyVehicleDetailsList2 = [
    VehicleDetails(
      billDate: "2024-01-25",
      vehicleType: "6 Wheeler Truck",
      vehicleNo: "LMN789",
      driverLicenseNo: "DL-654321987",
      driverMobNo: "9876543230",
      driverDOB: "1988-12-14",
      driverName: "David Brown",
      remark: "Damaged goods",
    ),
    VehicleDetails(
      billDate: "2024-02-01",
      vehicleType: "Truck",
      vehicleNo: "PQR101",
      driverLicenseNo: "DL-789456123",
      driverMobNo: "9876543240",
      driverDOB: "1992-07-08",
      driverName: "Robert Johnson",
      remark: "Smooth operation",
    ),
    VehicleDetails(
      billDate: "2024-02-05",
      vehicleType: "Chassis",
      vehicleNo: "DEF234",
      driverLicenseNo: "DL-321654987",
      driverMobNo: "9876543250",
      driverDOB: "1989-03-18",
      driverName: "James Williams",
      remark: "Late departure",
    ),
  ];

  bool _isLoading = false;
  final AuthService authService = AuthService();
  final EncryptionService encryptionService = EncryptionService();

  List<SelectionModels> vehicleTypes = [];
  bool isLoading = false;

  void _updateTextField() {
    if (modeSelected == 1) {
      noOfVehiclesController.text = '1';
    }
  }

  @override
  void initState() {
    super.initState();
    // multiSelectController.clearAll();
    callAllApis();
    noOfVehiclesController.text = "1";
  }

  Future<ShipmentDetails?> validateAndNavigate() async {
    if (_formKey.currentState!.validate()) {
      return await Navigator.push<ShipmentDetails>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddShipmentDetails(),
        ),
      );
    } else {
      // Return null if validation fails
      return null;
    }
  }

  Future<VehicleDetails?> validateAndNavigateV2() async {
    if (_formKey.currentState!.validate()) {
      return await Navigator.push<VehicleDetails>(
        context,
        MaterialPageRoute(
          builder: (context) => const AddVehicleDetails(),
        ),
      );
    } else {
      // Return null if validation fails
      return null;
    }
  }

  Future<void> callAllApis() async {
    try {
      setState(() {
        isLoading = true;
      });

      await Future.wait([
        loadCargoTypes(),
        loadCHAExporterNames('Agent'),
        loadCHAExporterNames('Exporter'),
      ]);
    } catch (e) {
      print("Error calling APIs: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Map<String, dynamic> transformJson(Map<String, dynamic> secondJson) {
  //   return {
  //     "jointablename": secondJson["jointablename"] ?? "",
  //     "jointablecondition": secondJson["jointablecondition"] ?? "",
  //     "toprecord": secondJson["toprecord"] ?? 999,
  //     "AllRecord": secondJson["AllRecord"] ?? false,
  //     "Istariff": secondJson["Istariff"] ?? false,
  //     "IsDisabled": secondJson["IsDisabled"] ?? false,
  //     "wherecondition": secondJson["wherecondition"] ?? "",
  //     "ReferenceId": secondJson["ReferenceId"] ?? "VehicleType",
  //     "IsAll": secondJson["IsAll"] ?? true,
  //   };
  // }

  Future<void> loadCargoTypes() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final mdl = SelectionModels();
    mdl.topRecord ??= 10; // Assign 10 if topRecord is null
    mdl.topRecord = mdl.topRecord == 10 ? 999 : mdl.topRecord;

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
        isLoading = false;
      });
    }
  }

  Future<void> loadCHAExporterNames(basedOnPrevious) async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      isLoading = true;
    });

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
          isLoading = false;
        });
      });
    }).catchError((onError) {
      setState(() {
        setState(() {
          isLoading = false;
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
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      color: AppColors.cardTextColor,
                                    ),
                                    Text(
                                      " india",
                                      style: TextStyle(
                                          color: AppColors.cardTextColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.cardTextColor,
                                    ),
                                    Text(
                                      " bangladesh",
                                      style: TextStyle(
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
                                        hintText: 'Types of Vehicles',
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
                                            color: Colors.green),
                                        disabledIcon: Icon(Icons.lock,
                                            color: Colors.grey.shade300),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          setState(() {
                                            isValid = false;
                                          });
                                          return 'Required';
                                        }
                                        return null;
                                      },
                                      onSelectionChange: (selectedItems) {
                                        // Your selection logic here
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
                                          return 'Required';
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
                                child: FormField<String>(
                                  validator: (value) {
                                    if (chaController.text.isEmpty) {
                                      setState(() {
                                        _textFieldHeight = 45;
                                      });
                                      return 'Required';
                                    }
                                    setState(() {
                                      _textFieldHeight =
                                          initialHeight; // Reset to initial height if valid
                                    });
                                    return null; // Valid input
                                  },
                                  builder: (formFieldState) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          height: _textFieldHeight,
                                          // Dynamic height based on validation
                                          child: TypeAheadField<
                                              CargoTypeExporterImporterAgent>(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: chaController,
                                              focusNode: _cityFocusNode,
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          vertical: 12.0,
                                                          horizontal: 10.0),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .errorRed),
                                                  ),
                                                  labelText: 'CHA Name',
                                                  labelStyle: formFieldState
                                                          .hasError
                                                      ? const TextStyle(
                                                          color: AppColors
                                                              .errorRed)
                                                      : const TextStyle(
                                                          color:
                                                              Colors.black87),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .errorRed),
                                                  ),

                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: AppColors
                                                                .errorRed),
                                                  )),
                                            ),
                                            suggestionsCallback: (search) =>
                                                CHAAgentService.find(search),
                                            itemBuilder: (context, city) {
                                              return Container(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    top: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.2),
                                                    left: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.2),
                                                    right: BorderSide(
                                                        color: Colors.black,
                                                        width: 0.2),
                                                    bottom: BorderSide
                                                        .none, // No border on the bottom
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    Text(city.code
                                                        .toUpperCase()),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(city.description
                                                        .toUpperCase()),
                                                  ],
                                                ),
                                              );
                                            },
                                            onSuggestionSelected: (city) {
                                              chaController.text = city
                                                  .description
                                                  .toUpperCase();
                                              formFieldState.didChange(
                                                  chaController.text);
                                            },
                                            noItemsFoundBuilder: (context) =>
                                                const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('No CHA Found'),
                                            ),
                                          ),
                                        ),
                                        if (formFieldState.hasError)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4.0, left: 16),
                                            child: Text(
                                              formFieldState.errorText ?? '',
                                              style: const TextStyle(
                                                  color: AppColors.errorRed,
                                                  fontSize: 12),
                                            ),
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddShipmentDetailsListNew(
                      shipmentDetailsList: shipmentList,
                      validateAndNavigate: validateAndNavigate,
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddVehicleDetailsListNew(
                      vehicleDetailsList: dummyVehicleDetailsList,
                      validateAndNavigate: validateAndNavigateV2,
                      isExport: true,                    ),
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
                                      print(multiSelectController.selectedItems);
                                      if (_formKey.currentState!.validate()) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Form submitted successfully!')),
                                        );
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

class Vehicle {
  final String name;
  final String id;

  Vehicle({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
