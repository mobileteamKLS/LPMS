import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lpms/theme/app_color.dart';

import '../api/auth.dart';
import '../models/ShippingList.dart';
import '../theme/app_theme.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../util/Uitlity.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  bool isLoading = false;
  bool isExapnded = false;
  List<ShipmentDetails> listShipmentDetails = [];
  List<ShipmentDetails> listShipmentDetailsBind = [];
  final AuthService authService = AuthService();
  List<bool> _isExpandedList = [];



  @override
  void initState() {
    super.initState();
    getShipmentDetails();


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
              icon: const Icon(FontAwesomeIcons.userGear),
              color: Colors.white,
              onPressed: () {},
            ),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(FontAwesomeIcons.bell),
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
            // Expands to maximum width and height
            color: AppColors.background,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(CupertinoIcons.cube),
                          Text(
                            '  SHIPMENT LIST',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: AppColors.primary,
                            ),
                            onPressed: () {
                              // Search action
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.more_vert_outlined,
                              color: AppColors.primary,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Showing (0/0)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.upload_file,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {},
                              ),
                              const Text(
                                'Export',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.filter_alt_outlined,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {},
                              ),
                              const Text(
                                'Filter',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                isLoading
                    ? const Center(
                        child: SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator()))
                    : Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0, left: 0.0),
                            child: SizedBox(
                                width: MediaQuery.of(context).size.width / 1.01,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext, index) {
                                    ShipmentDetails shipmentDetails =
                                        listShipmentDetails.elementAt(index);
                                    return buildShipmentDetailsCard(
                                        shipmentDetails, index);
                                  },
                                  itemCount: listShipmentDetails.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.all(2),
                                )),
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  100), // Adjust the height as needed
              painter: AppBarPainterGradient(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_pie),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_box_rounded,
              size: 42,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'User Help',
          ),
        ],
        onTap: (index) {
          if (index == 2) {}
        },
      ),
    );
  }

  getShipmentDetails() async {
    if (isLoading) return;
    listShipmentDetails = [];
    listShipmentDetailsBind = [];
    setState(() {
      isLoading = true;
    });
    DateTime now = DateTime.now();
    DateTime startOfTodayIST = DateTime(now.year, now.month, now.day, 0, 0); // Start of today in local time
    DateTime startOfTodayUTC = startOfTodayIST.toUtc().add(const Duration(hours: 5, minutes: 30)); // Convert to UTC
    DateTime currentIST = now.toUtc().add(const Duration(hours: 5, minutes: 30)); // Current time in IST

    var queryParams = {
      "AirportId": 151,
      "OrgProdId": 3284,
      "BookingNo": "",
      "CompanyCode": "LPAI",
      "BranchCode": "LPAI",
      "SBillNo": "",
      "TimeZone": "India Standard Time",
      "Todate": currentIST.toIso8601String(), // Current date and time in IST
      "Fromdate": startOfTodayUTC.toIso8601String() // Start of today in IST, converted to UTC
      // "Todate": now.toUtc().toIso8601String(),
      // "Fromdate": startOfToday.toUtc().toIso8601String()

    };
    await authService
        .postData(
      "api_pcs/ShipmentMaster/GetAll",
      queryParams,
    )
        .then((response) {
      print("data received ");
      List<dynamic> jsonData = json.decode(response.body);
      listShipmentDetailsBind =jsonData.map((json) => ShipmentDetails.fromJSON(json)).toList();
      print("length dockInOutVTListExport = ${listShipmentDetailsBind.length}");
      setState(() {
        listShipmentDetails = listShipmentDetailsBind;
        isLoading = false;
        _isExpandedList = List<bool>.filled(listShipmentDetails.length, false);
      });
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
      print(onError);
    });
  }

  Widget buildShipmentDetailsCard(ShipmentDetails shipmentDetails, int index) {
    bool isExpanded = _isExpandedList[index];
    return Card(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: SizedBox(
        height: isExpanded ? 180 : 120,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon with DRAFT label
                  Container(
                    decoration: BoxDecoration(
                      color: Utils.getStatusColor(shipmentDetails.statusDescription),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child:  Row(
                      children: [
                        Utils.getStatusIcon(shipmentDetails.statusDescription),
                        SizedBox(width: 4),
                        Text(
                          shipmentDetails.statusDescription,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Three dots icon
                  const Icon(
                    Icons.more_vert,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                   Text(
                    shipmentDetails.bookingNo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black26),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child:  Text(
                      shipmentDetails.cargoTypeName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              isExpanded
                  ?  Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${shipmentDetails.sBillNo}  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              SizedBox(width: 24),
                              Row(
                                children: [
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format( DateTime.parse(shipmentDetails.sBillDt))}  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${DateFormat('dd MMM yyyy HH:mm').format( DateTime.parse(shipmentDetails.bookingDt))}  ',
                                style: TextStyle(fontSize: 14),
                              ),
                              const Icon(
                                Icons.calendar_month_outlined,
                                size: 18,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 8),
              // Show More with expandable content
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpandedList[index] = !_isExpandedList[index];
                      });
                    },
                    child: Text(
                      isExpanded ? 'SHOW LESS' : 'SHOW MORE',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                ],
              ),
              // Expanded content
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandableCard extends StatefulWidget {
  const ExpandableCard({super.key});

  @override
  _ExpandableCardState createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpanded3 = false;
  bool _isExpanded4 = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: SizedBox(
            height: _isExpanded1 ? 180 : 120,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon with DRAFT label
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.draft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'DRAFT',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Three dots icon
                      const Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        'EXP/AGA/20240822/00001',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: const Text(
                          'GEN',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isExpanded1
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'WERE44213  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 24),
                                  Row(
                                    children: [
                                      Text(
                                        '22 AUG 2024  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '22 AUG 2024 10:56  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  // Show More with expandable content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded1 = !_isExpanded1;
                          });
                        },
                        child: Text(
                          _isExpanded1 ? 'SHOW LESS' : 'SHOW MORE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  // Expanded content
                ],
              ),
            ),
          ),
        ),
        Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: SizedBox(
            height: _isExpanded2 ? 180 : 120,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon with DRAFT label
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gateInYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.access_time_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'GATE-IN',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Three dots icon
                      const Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // EXP/AGA/20240822/00001 and GEN labels below DRAFT
                  Row(
                    children: [
                      const Text(
                        'EXP/AGA/20240822/00001',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: const Text(
                          'GEN',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isExpanded2
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'WERE44213  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 24),
                                  Row(
                                    children: [
                                      Text(
                                        '22 AUG 2024  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '22 AUG 2024 10:56  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  // Show More with expandable content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded2 = !_isExpanded2;
                          });
                        },
                        child: Text(
                          _isExpanded2 ? 'SHOW LESS' : 'SHOW MORE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  // Expanded content
                ],
              ),
            ),
          ),
        ),
        Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: SizedBox(
            height: _isExpanded3 ? 180 : 120,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon with DRAFT label
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gatedIn,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'GATED-IN',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Three dots icon
                      const Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // EXP/AGA/20240822/00001 and GEN labels below DRAFT
                  Row(
                    children: [
                      const Text(
                        'EXP/AGA/20240822/00001',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: const Text(
                          'GEN',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isExpanded3
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'WERE44213  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 24),
                                  Row(
                                    children: [
                                      Text(
                                        '22 AUG 2024  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '22 AUG 2024 10:56  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  // Show More with expandable content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded3 = !_isExpanded3;
                          });
                        },
                        child: Text(
                          _isExpanded3 ? 'SHOW LESS' : 'SHOW MORE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  // Expanded content
                ],
              ),
            ),
          ),
        ),
        Card(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: 3,
          child: SizedBox(
            height: _isExpanded4 ? 180 : 120,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon with DRAFT label
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.gateInRed,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              size: 18,
                              color: Colors.black,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'GATE-IN',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Three dots icon
                      const Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // EXP/AGA/20240822/00001 and GEN labels below DRAFT
                  Row(
                    children: [
                      const Text(
                        'EXP/AGA/20240822/00001',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: const Text(
                          'GEN',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isExpanded4
                      ? const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'WERE44213  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 24),
                                  Row(
                                    children: [
                                      Text(
                                        '22 AUG 2024  ',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Icon(
                                        Icons.calendar_month_outlined,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Text(
                                    '22 AUG 2024 10:56  ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Icon(
                                    Icons.calendar_month_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 8),
                  // Show More with expandable content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded4 = !_isExpanded4;
                          });
                        },
                        child: Text(
                          _isExpanded4 ? 'SHOW LESS' : 'SHOW MORE',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                  // Expanded content
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon with DRAFT label
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_shipping,
                            // You can change to a truck icon
                            size: 16,
                            color: Colors.black54,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'DRAFT',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8),
                    // Text: EXP/AGA/20240822/00001
                    Text(
                      'EXP/AGA/20240822/00001',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Label with GEN
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Text(
                        'GEN',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Three dots icon
                Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ],
            ),
            SizedBox(height: 0),
            // "SHOW MORE" link with the location icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'SHOW MORE',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
