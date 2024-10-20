import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lpms/screens/BookingCreationExport.dart';
import 'package:lpms/screens/BookingCreationImport.dart';
import 'package:lpms/ui/widgest/CustomTextField.dart';
import 'package:lpms/util/Uitlity.dart';
import '../api/auth.dart';
import '../models/ShippingList.dart';
import '../theme/app_color.dart';
import '../theme/app_theme.dart';
import '../util/Global.dart';

class AddBookSlot extends StatefulWidget {
  final bool isExport;
  final VehicleDetailsExports vehicleDetails;
  const AddBookSlot({super.key, required this.isExport, required this.vehicleDetails});

  @override
  State<AddBookSlot> createState() => _AddBookSlotState();
}

class _AddBookSlotState extends State<AddBookSlot> {
  final _formKey = GlobalKey<FormState>();
  String slotFilterDate = "Slot Date";
  DateTime? selectedDate;
  final AuthService authService = AuthService();
  bool isLoading = false;
  List<SlotDetails> slotDetailsList = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickDate(BuildContext context, StateSetter setState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            primaryColor: AppColors.primary,

            dialogBackgroundColor: Colors.white,
            // Change dialog background color
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary, // Change header and button color
              onPrimary: Colors.white, // Text color on primary (header text)
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        slotFilterDate = DateFormat('d MMM yyyy').format(pickedDate);
        print("DATE is $slotFilterDate");
      });
      getShipmentDetails();
    }
  }

  getShipmentDetails() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });
    slotDetailsList = [];
    var queryParams = {
      "CommodityTypeId": 1,
      "ShipmentModeId": widget.isExport? 7198:7199,
      "Date": Utils.formatDate(selectedDate!),
      "OrgProdId": loginMaster[0].adminOrgProdId,
      "TerminalId": loginMaster[0].terminalId,
      "VehicleTypeId": widget.vehicleDetails.vehicleTypeId.toString(),
      "TimeZone": loginMaster[0].timeZone
    };
    await authService
        .postData(
      "api_master/SlotConfiguration/GetAllBookingSlot",
      queryParams,
    )
        .then((response) {
      print("data received ");
      List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isEmpty) {
        setState(() {
          // hasNoRecord = true;
        });
      }

      setState(() {
        slotDetailsList =
            jsonData.map((json) => SlotDetails.fromJSON(json)).toList();
        isLoading = false;
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
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
              colors: [Color(0xFF0057D8), Color(0xFF1c86ff)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.userGear, size: 26),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: Stack(
              children: [
                const Icon(FontAwesomeIcons.bell, size: 26),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [Text('Drawer Item')],
        ),
      ),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            color: AppColors.background,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          child: const Icon(Icons.arrow_back_ios,
                              color: AppColors.primary),
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) =>const BookingCreationExport()));
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Slot Booking',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildSlotBookingContainer(context),
                    const SizedBox(height: 10),
                    _buildSlotAvailabilityContainer(context),
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
                size: Size(MediaQuery.of(context).size.width, 100),
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
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomNavigationItem(
              icon: CupertinoIcons.chart_pie,
              label: "Dashboard",
              onTap: () {},
            ),
            _buildBottomNavigationItem(
              icon: Icons.help_outline,
              label: "User Help",
              color: AppColors.primary,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotBookingContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Discover available slots by selecting date",
                      style: TextStyle(
                        color: AppColors.textColorSecondary,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.008),
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            slotFilterDate,
                            style: const TextStyle(
                                fontSize: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                      onTap: () {
                        pickDate(context, setState);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotAvailabilityContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline_rounded),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Slot Availability is subject to market change based on slot availability",
                    style: TextStyle(
                      color: AppColors.textColorSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10,),
            isLoading
                ? const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  )
                : _buildSlotList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotList(BuildContext context) {
    return slotDetailsList.isEmpty
        ? Container(
            height: 400,
            alignment: Alignment.center,
            child: const Text("NO RECORD FOUND"),
          )
        : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: slotDetailsList.length,
            itemBuilder: (context, index) {
              final slot = slotDetailsList[index];
              return Container(
                padding: EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.textColorPrimary, width: 0.3),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline_rounded),
                        const SizedBox(width: 8),
                        Text(slot.bookedTimeSlot),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.containerBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("${slot.availableSlots}"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.vehicleDetails.slotDateTime=slot.bookedTimeSlot;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => widget.isExport?const BookingCreationExport():const BookingCreationImport(),
                            ),
                          );
                        },
                        child: const Text(
                          "Book Now",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget _buildBottomNavigationItem({
    required IconData icon,
    required String label,
    Color color = Colors.black,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
