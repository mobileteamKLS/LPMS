
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../ui/widgest/expantion_card.dart';

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
  final TextEditingController cargoDescriptionController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  double fieldHeight = 45;
  bool isValid = true;

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
                            const Text(
                              "BASIC DETAILS",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
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

                              SizedBox(
                                height: fieldHeight,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(

                                  controller: billNoController,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      setState(() {
                                        fieldHeight = 65; // Increase height when validation fails
                                      });
                                      return 'Enter Bill No';
                                    } else {
                                      setState(() {
                                        fieldHeight = 45; // Reset to original height when valid
                                      });
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15), // Adjust vertical padding to center the text
                                    errorStyle: const TextStyle(height: 0),
                                    labelText: "Shipping Bill No.",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: billDateController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Shipping Bill Date",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: exporterNameController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Name of Exporter",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: hsnCodeController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "HSN Code",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.015,
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
                                height: MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: cargoDescriptionController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Cargo Description",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
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
                                    MediaQuery.sizeOf(context).width * 0.43,
                                    child: TextFormField(
                                      controller: qualityController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Quantity",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                          
                                  SizedBox(
                                    height: 45,
                                    width:
                                    MediaQuery.sizeOf(context).width * 0.43,
                                    child:TextFormField(
                                      controller: weightController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        labelText: "Cargo Weight",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ) ,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.015,
                              ),
                              SizedBox(
                                height: 45,
                                width: MediaQuery.sizeOf(context).width,
                                child: TextFormField(
                                  controller: valueController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Cargo Value",
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
                                  child: OutlinedButton(onPressed: () {  }, child: const Text("Cancel"),),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  height: 45,
                                  width:
                                  MediaQuery.sizeOf(context).width * 0.42,
                                  child: ElevatedButton(onPressed: () {
                                    if (_formKey.currentState!.validate()) {

                                      final newShipment = ShipmentDetails(
                                        billNo: billNoController.text,
                                        billDate: billDateController.text,
                                        exporterName: exporterNameController.text,
                                        hsnCode: hsnCodeController.text,
                                        cargoType: cargoTypeController.text,
                                        cargoDescription: cargoDescriptionController.text,
                                        quality: qualityController.text,
                                        cargoWeight: weightController.text,
                                        cargoValue: valueController.text,
                                      );
                                      Navigator.pop(context, newShipment); // Pass the object back
                                    }
                                  }, child: const Text("Save",style: TextStyle(color: Colors.white),),),
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

class User {
  final String name;
  final int id;

  User({required this.name, required this.id});

  @override
  String toString() {
    return 'User(name: $name, id: $id)';
  }
}
