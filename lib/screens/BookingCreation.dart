import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lpms/util/Uitlity.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../api/auth.dart';
import '../models/SelectionModel.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../ui/widgest/expantion_card.dart';
import '../util/Global.dart';
import 'Encryption.dart';

class BookingCreation extends StatefulWidget {
  const BookingCreation({super.key});

  @override
  State<BookingCreation> createState() => _BookingCreationState();
}

class _BookingCreationState extends State<BookingCreation> {
  final controller = MultiSelectController<User>();
  final List categoriesData = [
    {
      'name': 'SHIPMENT DETAILS',
      'sub_categories': [],
    },
  ];
  bool _isLoading = false;
  final AuthService authService = AuthService();
  final EncryptionService encryptionService = EncryptionService();
  var items = [
    DropdownItem(label: 'Truck', value: User(name: 'Truck', id: 1)),
    DropdownItem(label: 'Chassis', value: User(name: 'Chassis', id: 6)),
    DropdownItem(
        label: '6 Wheeler Truck', value: User(name: '6 Wheeler Truck', id: 2)),
  ];

  List<SelectionModels> vehicleTypes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadVehicleTypes();
  }
  Map<String, dynamic> transformJson(Map<String, dynamic> secondJson) {
    return {
      "jointablename": secondJson["jointablename"] ?? "",
      "jointablecondition": secondJson["jointablecondition"] ?? "",
      "toprecord": secondJson["toprecord"] ?? 999,
      "AllRecord": secondJson["AllRecord"] ?? false,
      "Istariff": secondJson["Istariff"] ?? false,
      "IsDisabled": secondJson["IsDisabled"] ?? false,
      "wherecondition": secondJson["wherecondition"] ?? "",
      "ReferenceId": secondJson["ReferenceId"] ?? "VehicleType",
      "IsAll": secondJson["IsAll"] ?? true,
    };
  }


  Future<void> loadVehicleTypes() async {
    setState(() {
      isLoading = true;
    });

    final mdl = SelectionModels(
      whereCondition: "Coalesce(A.IsActive,0) = 1 AND A.OrgProdId=1",
      referenceId: "VehicleType",
      isAll: true,
    );
    if (mdl.topRecord == null || mdl.topRecord == 10) {
      mdl.topRecord = 999;
    }

    SelectionQuery body = SelectionQuery();

    body.query =
        await encryptionService.encryptUsingRandomKeyPrivateKey(mdl.toJson());
    print("-----Normal-----");
    print(mdl.toJson());
    print("-----Decipher==0-----");
    var q="LZCLfQHPgHAlajwnEtThKB+IvntjvuYcE0N58IIMmCovXeuyiDQb/pynXkuBI764cAkuH+KCIt7oG0AeN3KFjRPmk7Sp9KSfg6LFwP4L1CWS8q8G2siRbz18g+KCveuZj3weqlB9EfvmQWu9Y9F6nP/wlZo0P/dcWawkix2uQ9Di3JyxBW0Vp6EWWd+INUdRs0wbvfelxgXUt4ZIoE1K8dXwEyHLb+KILFp98lkX99XU7F0ht6/ebjov5ULu+fHYZNzacHLkwRY3FBiqpPggJUMZmQd8z8VtnBDBEdGoR/g71LcLxjC5Mqxqy8M379jK";
    print(encryptionService.decryptUsingRandomKeyPrivateKey(q));
    print("-----Decipher==1-----");
    print(encryptionService.decryptUsingRandomKeyPrivateKey(body.query));
    mdl.query = body.query;
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    await authService
        .fetchLoginDataPOST(
            "/api/GenericDropDown/GetAllVehicleType", mdl, headers)
        .then((response) {
      print("data received ");
      if (response.body.isNotEmpty) {
        json.decode(response.body);
        print(json.decode(response.body));
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
      print(onError);
    });
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
                            offset: const Offset(0, 3), // changes position of shadow
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
                                      " AGA",
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
                                      " ALL",
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "BASIC DETAILS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.01,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.88,
                                  child: MultiDropdown<User>(
                                    items: items,
                                    controller: controller,
                                    enabled: true,
                                    searchEnabled: true,
                                    chipDecoration: const ChipDecoration(
                                      backgroundColor: AppColors.secondary,
                                      wrap: true,
                                      runSpacing: 2,
                                      spacing: 10,
                                    ),
                                    fieldDecoration: FieldDecoration(
                                      hintText: 'Types of Vehicles',
                                      hintStyle: const TextStyle(
                                          color: Colors.black54),
                                      // prefixIcon: const Icon(CupertinoIcons.flag),
                                      showClearIcon: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                            color:
                                                AppColors.textFieldBorderColor),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: const BorderSide(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    dropdownDecoration:
                                        const DropdownDecoration(
                                      marginTop: 2,
                                      maxHeight: 500,
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
                                      selectedIcon: const Icon(Icons.check_box,
                                          color: Colors.green),
                                      disabledIcon: Icon(Icons.lock,
                                          color: Colors.grey.shade300),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select a vehicle';
                                      }
                                      return null;
                                    },
                                    onSelectionChange: (selectedItems) {
                                      debugPrint(
                                          "OnSelectionChange: $selectedItems");
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 45,
                                  width:
                                      MediaQuery.sizeOf(context).width * 0.42,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelText: "No of Vehicles",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
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
                                        MediaQuery.sizeOf(context).width * 0.5,
                                    minHeight: 45.0,
                                    fontSize: 14.0,
                                    initialLabelIndex: 0,
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
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.015,
                            ),
                            SizedBox(
                              height: 45,
                              width: MediaQuery.sizeOf(context).width,
                              child: TextField(
                                decoration: InputDecoration(
                                  isDense: true,
                                  labelText: "CHA Name*",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddShipmentDetailsList(
                    categories: categoriesData,shipmentDetailsList: shipmentList,
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.015,
                    ),
                    AddVehicleDetailsList(
                      categories: categoriesData,
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

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
