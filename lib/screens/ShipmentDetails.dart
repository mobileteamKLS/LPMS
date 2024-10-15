import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';


class AddShipmentDetails extends StatefulWidget {
  const AddShipmentDetails({super.key});

  @override
  State<AddShipmentDetails> createState() => _AddShipmentDetailsState();
}

class _AddShipmentDetailsState extends State<AddShipmentDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController billNoController = TextEditingController();
  final TextEditingController billDateController = TextEditingController();
  final TextEditingController exporterNameController = TextEditingController();
  final TextEditingController hsnCodeController = TextEditingController();
  final TextEditingController cargoTypeController = TextEditingController();
  final TextEditingController cargoDescriptionController =
      TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  double fieldHeight = 45;
  bool isValid = true;
  final RegExp hsnPattern = RegExp(r'^\d{6,8}$');
  final RegExp doublePattern = RegExp(r'^\d*\.?\d*$');

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
                          'Shipment Details',
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Type of Vehicle",
                                        style: TextStyle(
                                            color: AppColors.textColorSecondary,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.003,
                                      ),
                                      const Text(
                                        "Truck",
                                        style: TextStyle(
                                            color: AppColors.textColorPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "No. of Vehicle",
                                        style: TextStyle(
                                            color: AppColors.textColorSecondary,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.003,
                                      ),
                                      const Text(
                                        "2",
                                        style: TextStyle(
                                            color: AppColors.textColorPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "FTL/LTL",
                                        style: TextStyle(
                                            color: AppColors.textColorSecondary,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.003,
                                      ),
                                      const Text(
                                        "FTL",
                                        style: TextStyle(
                                            color: AppColors.textColorPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "CHA Name",
                                        style: TextStyle(
                                            color: AppColors.textColorSecondary,
                                            fontSize: 14),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.003,
                                      ),
                                      const Text(
                                        "ABC CHA",
                                        style: TextStyle(
                                            color: AppColors.textColorPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
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
                                  labelText: "Shipping Bill No."),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomDatePicker(
                                controller: billDateController,
                                labelText: 'Shipping Bill Date',
                                allowFutureDates: false,

                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: exporterNameController,
                                labelText: "Name of Exporter",
                                inputType: TextInputType.text,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: hsnCodeController,
                                labelText: 'HSN Code',
                                inputType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validationPattern: hsnPattern,
                                patternErrorMessage:
                                    'Enter a valid HSN code (6 to 8 digits)',
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: cargoTypeController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Cargo Type",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: cargoDescriptionController,
                                labelText: "Cargo Description",
                                inputType: TextInputType.text,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomTextField(
                                    controller: qualityController,
                                    labelText: 'Quantity',
                                    customWidth:
                                        MediaQuery.of(context).size.width *
                                            0.43,
                                    inputType: TextInputType.number,
                                  ),
                                  CustomTextField(
                                    controller: weightController,
                                    labelText: 'Cargo Weight',
                                    customWidth:
                                        MediaQuery.of(context).size.width *
                                            0.43,
                                    inputType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d*')),
                                      DecimalTextInputFormatter(
                                          decimalRange: 2),
                                    ],
                                    validationPattern: doublePattern,
                                    patternErrorMessage: 'Enter a valid number',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              CustomTextField(
                                controller: valueController,
                                labelText: "Cargo Value",
                                inputType: TextInputType.text,
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
                                    onPressed: () {},
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
                                      if (_formKey.currentState!.validate()) {
                                        final newShipment = ShipmentDetails(
                                          billNo: billNoController.text,
                                          billDate: billDateController.text,
                                          exporterName:
                                              exporterNameController.text,
                                          hsnCode: hsnCodeController.text,
                                          cargoType: cargoTypeController.text,
                                          cargoDescription:
                                              cargoDescriptionController.text,
                                          quality: qualityController.text,
                                          cargoWeight: weightController.text,
                                          cargoValue: valueController.text,
                                        );
                                        Navigator.pop(context,
                                            newShipment);
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

