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
  bool hasNoRecord = false;
  List<ShipmentDetails> listShipmentDetails = [];
  List<ShipmentDetails> listShipmentDetailsBind = [];
  final AuthService authService = AuthService();
  List<bool> _isExpandedList = [];
  List<String> selectedFilters = [];
  List<ShipmentDetails> filteredList = [];

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  late TextEditingController fromDateController;
  late TextEditingController toDateController;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    DateTime startOfDay = today
        .subtract(const Duration(days: 1))
        .toLocal()
        .copyWith(hour: 0, minute: 0, second: 0);
    String startOfDayFormatted = startOfDay.toUtc().toIso8601String();

    DateTime endOfDay =
        today.toLocal().copyWith(hour: 23, minute: 59, second: 59);
    String endOfDayFormatted = endOfDay.toUtc().toIso8601String();
    print('Start of Day: $startOfDayFormatted');
    print('End of Day: $endOfDayFormatted');
    getShipmentDetails(endOfDayFormatted, startOfDayFormatted, "", "");
    fromDateController = TextEditingController(
        text: _formatDate(DateTime.now().subtract(const Duration(days: 2))));
    toDateController = TextEditingController(text: _formatDate(DateTime.now()));
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
              onPressed: () {},
            ),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 2, left: 10, right: 10),
                  child: Material(
                    color: Colors.transparent,
                    // Ensures background transparency
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
                                print("Search button pressed");
                                showShipmentSearchDialog(context);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.more_vert_outlined,
                                color: AppColors.primary,
                              ),
                              onPressed: () {
                                print("More button pressed");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
                          GestureDetector(
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  ' Export',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          GestureDetector(
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.filter_alt_outlined,
                                  color: AppColors.primary,
                                ),
                                Text(
                                  ' Filter',
                                  style: TextStyle(fontSize: 16),
                                )
                              ],
                            ),
                            onTap: () {
                              showShipmentSearchBottomSheet(context);
                            },
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
                              child: filteredList.isNotEmpty
                                  ? ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext, index) {
                                        // List<ShipmentDetails> filteredList =
                                        //     getFilteredShipmentDetails(
                                        //         listShipmentDetails,
                                        //         selectedFilters);
                                        ShipmentDetails shipmentDetails =
                                        filteredList
                                                .elementAt(index);
                                        return buildShipmentDetailsCardV2(
                                            shipmentDetails, index);
                                      },
                                      itemCount: filteredList.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(2),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (BuildContext, index) {
                                        // List<ShipmentDetails> filteredList =
                                        //     getFilteredShipmentDetails(
                                        //         listShipmentDetails,
                                        //         selectedFilters);
                                        ShipmentDetails shipmentDetails =
                                            listShipmentDetails
                                                .elementAt(index);
                                        return buildShipmentDetailsCardV2(
                                            shipmentDetails, index);
                                      },
                                      itemCount: listShipmentDetails.length,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(2),
                                    ),
                            ),
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

  getShipmentDetails(String endOfDayFormatted, String startOfDayFormatted,
      String bookingNo, String sbNo) async {
    if (isLoading) return;
    listShipmentDetails = [];
    listShipmentDetailsBind = [];
    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "AirportId": 151,
      "OrgProdId": 3284,
      "BookingNo": bookingNo,
      "CompanyCode": "LPAI",
      "BranchCode": "LPAI",
      "SBillNo": sbNo,
      "TimeZone": "India Standard Time",
      "Todate": endOfDayFormatted,
      "Fromdate": startOfDayFormatted
    };
    await authService
        .postData(
      "api_pcs/ShipmentMaster/GetAll",
      queryParams,
    )
        .then((response) {
      print("data received ");
      List<dynamic> jsonData = json.decode(response.body);
      listShipmentDetailsBind =
          jsonData.map((json) => ShipmentDetails.fromJSON(json)).toList();
      print("length dockInOutVTListExport = ${listShipmentDetailsBind.length}");
      setState(() {
        listShipmentDetails = listShipmentDetailsBind;
        filteredList = listShipmentDetails;
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
                      color: Utils.getStatusColor(
                          shipmentDetails.statusDescription),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Utils.getStatusIcon(shipmentDetails.statusDescription),
                        const SizedBox(width: 4),
                        Text(
                          shipmentDetails.statusDescription,
                          style: const TextStyle(
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
                    child: Text(
                      shipmentDetails.cargoTypeName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${shipmentDetails.sBillNo}  ',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Row(
                                children: [
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.sBillDt))}  ',
                                    style: const TextStyle(fontSize: 14),
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
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                '${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(shipmentDetails.bookingDt))}  ',
                                style: const TextStyle(fontSize: 14),
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

  Widget buildShipmentDetailsCardV2(
      ShipmentDetails shipmentDetails, int index) {
    bool isExpanded = _isExpandedList[index];
    return Card(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: SizedBox(
        height: isExpanded ? 240 : 140,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          shipmentDetails.cargoTypeName.substring(0, 3),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<int>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: AppColors.primary,
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 1:
                          // Handle Edit action
                          break;
                        case 2:
                          // Handle Delete action
                          break;
                        case 3:
                          // Handle Audit Log action
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            Icon(Icons.list_alt, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text('Audit Log'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(height: 2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Utils.getStatusColor(
                          shipmentDetails.statusDescription),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      children: [
                        Utils.getStatusIcon(shipmentDetails.statusDescription),
                        const SizedBox(width: 4),
                        Text(
                          shipmentDetails.statusDescription,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shipping Billing No.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${shipmentDetails.sBillNo}  ',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 24),
                              Column(
                                children: [
                                  const Text(
                                    'Shipping Date',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.sBillDt))}  ',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Booking Date & Time',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '${DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(shipmentDetails.bookingDt))}  ',
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showShipmentSearchDialog(BuildContext context) async {
    TextEditingController bookingNoController = TextEditingController();
    TextEditingController shippingBillNoController = TextEditingController();

    Future<void> _selectDate(
        BuildContext context, TextEditingController controller,
        {bool isFromDate = false}) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: isFromDate
            ? DateTime.now().subtract(const Duration(days: 2))
            : DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );

      if (picked != null) {
        controller.text = DateFormat('d MMM yyyy').format(picked);
      }
    }

    void search() async {
      String bookingNo = bookingNoController.text.trim();
      String shippingBillNo = shippingBillNoController.text.trim();
      String fromDate = fromDateController.text.trim();
      String toDate = toDateController.text.trim();

      if (fromDate.isEmpty || toDate.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all fields")),
        );
        return;
      }
      DateTime fromDateTime = DateFormat('d MMM yyyy').parse(fromDate);
      DateTime toDateTime = DateFormat('d MMM yyyy').parse(toDate);

      if (fromDateTime.isAfter(toDateTime)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("From Date should not exceed To Date")),
        );
        return;
      }

      String fromDateISO = fromDateTime.toIso8601String();
      String toDateISO = toDateTime.toIso8601String();

      print(
          "Booking No: $bookingNo, Shipping Bill No: $shippingBillNo, From Date: $fromDateISO, To Date: $toDateISO");
      getShipmentDetails(toDateISO, fromDateISO, bookingNo, shippingBillNo);
      Navigator.pop(context);
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          insetPadding: const EdgeInsets.all(0),
          child: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Shipment Search",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(color: Colors.grey),
                  ), // Gray horizontal line
                  const SizedBox(height: 16),
                  TextField(
                    controller: bookingNoController,
                    decoration: InputDecoration(
                      labelText: "Booking No.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: shippingBillNoController,
                    decoration: InputDecoration(
                      labelText: "Shipping Bill No.",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: fromDateController,
                    decoration: InputDecoration(
                      labelText: "From Date",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(
                            context, fromDateController,
                            isFromDate: true),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: toDateController,
                    decoration: InputDecoration(
                      labelText: "To Date",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, toDateController),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 150),
                  const SizedBox(
                    width: double.infinity,
                    child: Divider(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: () {
                      search();
                      // Navigator.pop(context); // Close dialog after search
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text("SEARCH",
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 16), // Space between buttons
                  // Reset button
                  OutlinedButton(
                    onPressed: () {
                      bookingNoController.clear();
                      shippingBillNoController.clear();
                      fromDateController.text = _formatDate(
                          DateTime.now().subtract(const Duration(days: 2)));
                      toDateController.text = _formatDate(DateTime.now());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "RESET",
                      style: TextStyle(color: AppColors.primary), // Blue text
                    ),
                  ),
                  const SizedBox(height: 16), // Space between buttons
                  // Cancel button
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void filterShipments() {
    setState(() {
      filteredList =
          getFilteredShipmentDetails(listShipmentDetails, selectedFilters);
    });
  }

  List<ShipmentDetails> getFilteredShipmentDetails(
      List<ShipmentDetails> listShipmentDetails, List<String> selectedFilters) {
    // return listShipmentDetails.where((shipment) {
    //   print("${shipment.statusDescription.toUpperCase()}  ${selectedFilters.any((filter)}");
    //   return selectedFilters.any((filter) => shipment.statusDescription.toUpperCase() == filter);
    // }).toList();

    return listShipmentDetails.where((shipment) {
      bool matchFound = selectedFilters.any((filter) {
        // Print both values for debugging
        print(
            "Checking Shipment Status: ${shipment.statusDescription}, Filter: $filter");
        return shipment.statusDescription.toUpperCase() == filter;
      });

      // Print if a match is found or not
      if (matchFound) {
        print("Match found for Shipment Status: ${shipment.statusDescription}");
      } else {
        print("No match for Shipment Status: ${shipment.statusDescription}");
      }
      return matchFound;
    }).toList();
  }

  // void showShipmentSearchBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true, // Allows for dynamic height of the modal sheet
  //     builder: (BuildContext context) {
  //       return FractionallySizedBox(
  //         heightFactor: 0.9, // Adjust height as necessary, use 0.9 for 90% screen coverage
  //         child: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Text(
  //                   "Filter",
  //                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //                 ),
  //                 const Divider(color: Colors.grey),
  //                 SizedBox(height: 20),
  //                 Text('Sort by Status'),
  //                 SizedBox(
  //                   width: double.infinity, // Use full width for the container
  //                   child: Wrap(
  //                     spacing: 8.0,
  //                     children: [
  //                       FilterChip(
  //                         label: Text('Draft'),
  //                         selected: true,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: Colors.blue.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: Colors.blue.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in Pending'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: Colors.blue.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in Rejected'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: Colors.blue.withOpacity(0.2),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 16),
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showShipmentSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // List<String> selectedFilters = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Filter",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('SORT BY STATUS',
                        style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        spacing: 8.0,
                        children: [
                          FilterChip(
                            label: const Text('Draft'),
                            selected: selectedFilters.contains('DRAFT'),
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('DRAFT')
                                    : selectedFilters.remove('DRAFT');
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters.contains('DRAFT')
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                            checkmarkColor: Colors.blue,
                          ),
                          FilterChip(
                            label: const Text('Gate-in'),
                            selected: selectedFilters.contains('GATE-IN'),
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('GATE-IN')
                                    : selectedFilters.remove('GATE-IN');
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters.contains('GATE-IN')
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          FilterChip(
                            label: const Text('Gate-in Pending'),
                            selected:
                                selectedFilters.contains('Gate-in Pending'),
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('Gate-in Pending')
                                    : selectedFilters.remove('Gate-in Pending');
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color:
                                    selectedFilters.contains('Gate-in Pending')
                                        ? Colors.blue
                                        : Colors.transparent,
                              ),
                            ),
                          ),
                          FilterChip(
                            label: const Text('Gate-in Rejected'),
                            selected:
                                selectedFilters.contains('REJECT FOR GATE-IN'),
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('REJECT FOR GATE-IN')
                                    : selectedFilters
                                        .remove('REJECT FOR GATE-IN');
                              });
                            },
                            selectedColor: Colors.blue.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters
                                        .contains('REJECT FOR GATE-IN')
                                    ? Colors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      child: const Divider(color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FILTER BY DATE',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: AppColors.primary),
                            SizedBox(width: 8),
                            Text(
                              'Slot Date',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      child: const Divider(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        filterShipments();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      child: const Text("SEARCH",
                          style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedFilters.clear();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "RESET",
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// void showCustomBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     // shape: RoundedRectangleBorder(
//     //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     // ),
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       // return DraggableScrollableSheet(
//       //   expand: false,
//       //   builder: (context, scrollController) {
//       return SingleChildScrollView(
//         // controller: scrollController,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Filter/Sort',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       // Add your reset logic here
//                     },
//                     child: const Text(
//                       'RESET',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text('Sort by Status'),
//               SizedBox(
//                 width: MediaQuery.of(context).size.width,
//                 child: Wrap(
//                   spacing: 8.0,
//                   children: [
//                     FilterChip(
//                       label: const Text('Draft'),
//                       selected: true,
//                       onSelected: (bool selected) {},
//                       selectedColor: Colors.blue.withOpacity(0.2),
//                     ),
//                     FilterChip(
//                       label: const Text('Gate-in'),
//                       selected: false,
//                       onSelected: (bool selected) {},
//                       selectedColor: Colors.blue.withOpacity(0.2),
//                     ),
//                     FilterChip(
//                       label: const Text('Gate-in Pending'),
//                       selected: false,
//                       onSelected: (bool selected) {},
//                       selectedColor: Colors.blue.withOpacity(0.2),
//                     ),
//                     FilterChip(
//                       label: const Text('Gate-in Rejected'),
//                       selected: false,
//                       onSelected: (bool selected) {},
//                       selectedColor: Colors.blue.withOpacity(0.2),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Row(
//                 children: [
//                   Icon(Icons.calendar_today, color: Colors.blue),
//                   SizedBox(width: 8),
//                   Text(
//                     'Slot Date',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     style: TextButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 32,
//                       ),
//                       backgroundColor: Colors.white,
//                       shape: RoundedRectangleBorder(
//                         side: const BorderSide(color: Colors.blue),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(color: Colors.blue),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       // Add apply logic here
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 32,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text(
//                       'Apply',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       );
//       //   },
//       // );
//     },
//   );
// }
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
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

  // void showShipmentSearchBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               const Text("Filter",
  //                   style:
  //                       TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
  //               const Divider(color: Colors.grey),
  //               const SizedBox(height: 16),
  //               const Text('SORT BY STATUS',style:
  //               TextStyle(fontSize: 16, )),
  //               const SizedBox(height: 16),
  //             SizedBox(
  //               width: MediaQuery.of(context).size.width,
  //               child: Wrap(
  //                 spacing: 8.0,
  //                 children: [
  //                   FilterChip(
  //                     label: Text('Draft'),
  //                     selected: selectedFilters.contains('Draft'),
  //                     onSelected: (bool selected) {
  //                       setState(() {
  //                         selected
  //                             ? selectedFilters.add('Draft')
  //                             : selectedFilters.remove('Draft');
  //                       });
  //                     },
  //                     selectedColor: Colors.blue.withOpacity(0.1),
  //                     backgroundColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       side: BorderSide(
  //                         color: selectedFilters.contains('Draft')
  //                             ? Colors.blue
  //                             : Colors.transparent,
  //                       ),
  //                     ),
  //                     checkmarkColor: Colors.blue,
  //                   ),
  //                   FilterChip(
  //                     label: Text('Gate-in'),
  //                     selected: selectedFilters.contains('Gate-in'),
  //                     onSelected: (bool selected) {
  //                       setState(() {
  //                         selected
  //                             ? selectedFilters.add('Gate-in')
  //                             : selectedFilters.remove('Gate-in');
  //                       });
  //                     },
  //                     selectedColor: Colors.blue.withOpacity(0.1),
  //                     backgroundColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       side: BorderSide(
  //                         color: selectedFilters.contains('Gate-in')
  //                             ? Colors.blue
  //                             : Colors.transparent,
  //                       ),
  //                     ),
  //                   ),
  //                   FilterChip(
  //                     label: Text('Gate-in Pending'),
  //                     selected: selectedFilters.contains('Gate-in Pending'),
  //                     onSelected: (bool selected) {
  //                       setState(() {
  //                         selected
  //                             ? selectedFilters.add('Gate-in Pending')
  //                             : selectedFilters.remove('Gate-in Pending');
  //                       });
  //                     },
  //                     selectedColor: Colors.blue.withOpacity(0.1),
  //                     backgroundColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       side: BorderSide(
  //                         color: selectedFilters.contains('Gate-in Pending')
  //                             ? Colors.blue
  //                             : Colors.transparent,
  //                       ),
  //                     ),
  //                   ),
  //                   FilterChip(
  //                     label: const Text('Gate-in Rejected'),
  //                     selected: selectedFilters.contains('Gate-in Rejected'),
  //                     onSelected: (bool selected) {
  //                       setState(() {
  //                         selected
  //                             ? selectedFilters.add('Gate-in Rejected')
  //                             : selectedFilters.remove('Gate-in Rejected');
  //                       });
  //                     },
  //                     selectedColor: Colors.blue.withOpacity(0.1),
  //                     backgroundColor: Colors.transparent,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                       side: BorderSide(
  //                         color: selectedFilters.contains('Gate-in Rejected')
  //                             ? Colors.blue
  //                             : Colors.transparent,
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //
  //               const SizedBox(height: 8),
  //               Container(
  //                 width: double.infinity,
  //                 child: Divider(color: Colors.grey),
  //               ),
  //               const SizedBox(height: 4),
  //               const Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'FILTER BY DATE',
  //                     style: TextStyle(fontSize: 16),),
  //                   const SizedBox(height: 16),
  //                   Row(
  //                     children: [
  //                       Icon(Icons.calendar_today, color: AppColors.primary),
  //                       SizedBox(width: 8),
  //                       Text(
  //                         'Slot Date',
  //                         style: TextStyle(fontSize: 16),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 16),
  //               Container(
  //                 width: double.infinity,
  //                 child: Divider(color: Colors.grey),
  //               ),
  //               SizedBox(height: 8),
  //
  //               ElevatedButton(
  //                 onPressed: () {
  //
  //                   // Navigator.pop(context); // Close dialog after search
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: AppColors.primary,
  //                   minimumSize: Size.fromHeight(50),
  //                 ),
  //                 child:
  //                 Text("SEARCH", style: TextStyle(color: Colors.white)),
  //               ),
  //               SizedBox(height: 16), // Space between buttons
  //               // Reset button
  //               OutlinedButton(
  //                 onPressed: () {
  //
  //                 },
  //                 style: OutlinedButton.styleFrom(
  //                   side: BorderSide(color: AppColors.primary),
  //                   minimumSize: Size.fromHeight(50),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 child: const Text(
  //                   "RESET",
  //                   style: TextStyle(color: AppColors.primary), // Blue text
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: const Row(
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
                    const SizedBox(width: 8),
                    // Text: EXP/AGA/20240822/00001
                    const Text(
                      'EXP/AGA/20240822/00001',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Label with GEN
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: const Text(
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
                const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 0),
            // "SHOW MORE" link with the location icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'SHOW MORE',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Icon(
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
