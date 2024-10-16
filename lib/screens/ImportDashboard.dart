import 'dart:convert';

import 'package:excel/excel.dart' as ex;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:lpms/screens/BookingCreationExport.dart';
import 'package:lpms/theme/app_color.dart';
import 'package:path_provider/path_provider.dart';
import '../api/auth.dart';
import '../models/ShippingList.dart';
import '../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../ui/widgest/AppDrawer.dart';
import '../ui/widgest/CustomTextField.dart';
import '../util/Global.dart';
import '../util/Uitlity.dart';
import 'dart:io';

import 'BookingCreationImport.dart';

class ImportScreen extends StatefulWidget {
  const ImportScreen({super.key});

  @override
  State<ImportScreen> createState() => _ImportScreenState();
}

class _ImportScreenState extends State<ImportScreen> {
  bool isLoading = false;
  bool hasNoRecord = false;
  bool isFilterApplied = false;
  DateTime? selectedDate;
  String slotFilterDate = "Slot Date";
  int? selectedTerminalId = 151;
  final _formKey = GlobalKey<FormState>();

  // List of terminal data with id as int
  final List<Map<String, dynamic>> terminals = [
    {'id': 157, 'name': 'AKOLA'},
    {'id': 155, 'name': 'ATTARI'},
    {'id': 154, 'name': 'RAXAUL'},
    {'id': 153, 'name': 'JOGBANI'},
    {'id': 152, 'name': 'PETRAPOLE'},
    {'id': 151, 'name': 'AGARTALA'},
  ];
  List<SlotBookingShipmentDetailsImport> listShipmentDetails = [];
  List<SlotBookingShipmentDetailsImport> listShipmentDetailsBind = [];
  final AuthService authService = AuthService();
  List<bool> _isExpandedList = [];
  List<String> selectedFilters = [];
  List<SlotBookingShipmentDetailsImport> filteredList = [];

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  late String startOfDayFormatted;
  late String endOfDayFormatted;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    DateTime startOfDay = today
        .subtract(const Duration(days: 1))
        .toLocal()
        .copyWith(hour: 0, minute: 0, second: 0);
    startOfDayFormatted = startOfDay.toUtc().toIso8601String();

    DateTime endOfDay =
        today.toLocal().copyWith(hour: 23, minute: 59, second: 59);
    endOfDayFormatted = endOfDay.toUtc().toIso8601String();
    print('Start of Day: $startOfDayFormatted');
    print('End of Day: $endOfDayFormatted');
    getShipmentDetails(endOfDayFormatted, startOfDayFormatted, "", "",
        airportId: loginMaster[0].terminalId);
    fromDateController = TextEditingController(
        text: _formatDate(DateTime.now().subtract(const Duration(days: 2))));
    toDateController = TextEditingController(text: _formatDate(DateTime.now()));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
                              fromDateController.text = _formatDate(
                                  DateTime.now()
                                      .subtract(const Duration(days: 2)));
                              toDateController.text =
                                  _formatDate(DateTime.now());
                              getShipmentDetails(endOfDayFormatted,
                                  startOfDayFormatted, "", "",
                                  airportId: selectedTerminalId!);
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
          ]),
      drawer: AppDrawer(selectedScreen: "Import"),
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
                  padding: const EdgeInsets.only(
                      top: 2, left: 10, right: 10, bottom: 4),
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
                            onTap: () {
                              if (filteredList.isEmpty &&
                                  listShipmentDetails.isEmpty) {
                                final snackBar = SnackBar(
                                  content: SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.info,
                                                color: Colors.white),
                                            Text('  No Data Found'),
                                          ],
                                        ),
                                        GestureDetector(
                                          child: const Icon(Icons.close,
                                              color: Colors.white),
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentSnackBar();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  backgroundColor: AppColors.warningColor,
                                  behavior: SnackBarBehavior.floating,
                                  width: 200,
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                                return;
                              }
                              if (filteredList.isNotEmpty) {
                                exportToExcel(filteredList);
                              } else {
                                exportToExcel(listShipmentDetails);
                              }
                            },
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
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 0.0, bottom: 60),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.01,
                              child: (hasNoRecord)
                                  ? Container(
                                      height: 400,
                                      child: const Center(
                                        child: Text("NO RECORD FOUND"),
                                      ),
                                    )
                                  : selectedFilters.isNotEmpty ||
                                          selectedDate != null
                                      ? ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext, index) {
                                            SlotBookingShipmentDetailsImport
                                                shipmentDetails =
                                                filteredList.elementAt(index);
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
                                            SlotBookingShipmentDetailsImport
                                                shipmentDetails =
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
      floatingActionButton: Theme(
        data: ThemeData(useMaterial3: false),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BookingCreationImport()),
            );
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
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

      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: AppColors.white,
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(CupertinoIcons.chart_pie),
      //       label: 'Dashboard',
      //     ),
      //
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.help_outline),
      //       label: 'User Help',
      //     ),
      //   ],
      //   onTap: (index) {
      //     if (index == 2) {}
      //   },
      // ),
    );
  }

  Future<void> showNotification(String filePath) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    // var iosDetails = IOSNotificationDetails();

    var platformDetails = NotificationDetails(
      android: androidDetails,
      // iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Download Complete',
      'The file has been saved to $filePath',
      platformDetails,
    );
  }

  void exportToExcel(List<SlotBookingShipmentDetailsImport> shipments) async {
    var excel = ex.Excel.createExcel();
    ex.Sheet sheetObject = excel['Sheet1'];
    sheetObject.appendRow([
      ex.TextCellValue("Status"),
      ex.TextCellValue("Booking No."),
      ex.TextCellValue("Booking Date"),
      ex.TextCellValue("BOE No."),
      ex.TextCellValue("BOE Date"),
    ]);
    for (var shipment in shipments) {
      sheetObject.appendRow([
        ex.TextCellValue(shipment.statusDescription),
        ex.TextCellValue(shipment.bookingNo),
        ex.TextCellValue(shipment.bookingDt),
        ex.TextCellValue(shipment.boeNo),
        ex.TextCellValue(shipment.boeDt),
      ]);
    }

    final directory = await getDownloadsDirectory();
    String filePath = '/storage/emulated/0/Download/shipments.xlsx';

    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    print('Excel file saved at $filePath');
    showNotification("/storage/emulated/0/Download");
  }

  getShipmentDetails(String endOfDayFormatted, String startOfDayFormatted,
      String bookingNo, String boeNo,
      {int airportId = 151}) async {
    if (isLoading) return;
    listShipmentDetails = [];
    listShipmentDetailsBind = [];
    setState(() {
      isLoading = true;
    });

    var queryParams = {
      "AirportId": airportId,
      "OrgProdId": loginMaster[0].adminOrgProdId,
      "BookingNo": bookingNo,
      "CompanyCode": loginMaster[0].companyCode,
      "BranchCode": loginMaster[0].branchCode,
      "BOENo": boeNo,
      "TimeZone": loginMaster[0].timeZone,
      "Todate": endOfDayFormatted,
      "Fromdate": startOfDayFormatted
    };
    await authService
        .postData(
      "api_pcs/ImpShipment/GetAll",
      queryParams,
    )
        .then((response) {
      print("data received ");
      List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isEmpty) {
        setState(() {
          hasNoRecord = true;
        });
      }
      listShipmentDetailsBind = jsonData
          .map((json) => SlotBookingShipmentDetailsImport.fromJSON(json))
          .toList();
      print("length dockInOutVTListExport = ${listShipmentDetailsBind.length}");
      setState(() {
        listShipmentDetails = listShipmentDetailsBind;
        // filteredList = listShipmentDetails;
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

  Widget buildShipmentDetailsCard(
      SlotBookingShipmentDetailsExport shipmentDetails, int index) {
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
      SlotBookingShipmentDetailsImport shipmentDetails, int index) {
    bool isExpanded = _isExpandedList[index];
    return Card(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: SizedBox(
        height: isExpanded ? 230 : 130,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Utils.getStatusColor(
                              shipmentDetails.statusDescription),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            Utils.getStatusIcon(
                                shipmentDetails.statusDescription),
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
              Row(
                children: [
                  Text(
                    shipmentDetails.bookingNo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Text(
                  //   '${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.bookingDt))}  ',
                  //   style: const TextStyle(
                  //       fontSize: 16, fontWeight: FontWeight.w800),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.grey.shade200,
                  //     borderRadius: BorderRadius.circular(4),
                  //     border: Border.all(color: Colors.black26),
                  //   ),
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 4, vertical: 2),
                  //   child: Text(
                  //     shipmentDetails.cargoTypeName.substring(0, 3),
                  //     style: const TextStyle(
                  //       fontSize: 12,
                  //       color: Colors.black54,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              // const SizedBox(height: 2),

              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'BOE No.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${shipmentDetails.boeNo}  ',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHA Name',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'ABC',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 64),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'BOE Date',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    '${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.boeDt))}  ',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Exporter Name',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    shipmentDetails.exporterImporter,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showShipmentSearchDialog(BuildContext outerContext) async {
    TextEditingController bookingNoController = TextEditingController();
    TextEditingController boeNoController = TextEditingController();

    Future<void> _selectDate(
        BuildContext context, TextEditingController controller,
        {bool isFromDate = false}) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        //initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: isFromDate
            ? DateTime.now().subtract(const Duration(days: 2))
            : DateTime.now(),
        firstDate: DateTime(2020),
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

      if (picked != null) {
        controller.text = DateFormat('d MMM yyyy').format(picked);
      }
    }

    void search() async {
      String bookingNo = bookingNoController.text.trim();
      String boeNo = boeNoController.text.trim();
      String fromDate = fromDateController.text.trim();
      String toDate = toDateController.text.trim();

      if (fromDate.isEmpty || toDate.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 100));
        await Future.delayed(const Duration(milliseconds: 100));
        CustomSnackBar.show(context,
            message: "Please fill in all fields",
            backgroundColor: AppColors.warningColor);
        return;
      }
      DateTime fromDateTime = DateFormat('d MMM yyyy').parse(fromDate);
      DateTime toDateTime = DateFormat('d MMM yyyy').parse(toDate);

      if (fromDateTime.isAfter(toDateTime)) {
        fromDateController.text='';
        CustomSnackBar.show(
          context,
          message: "From Date should be less than To Date",
          backgroundColor: AppColors.warningColor,
        );
        return;
      }
      if (toDateTime.isBefore(fromDateTime)) {
        toDateController.text ='';

        CustomSnackBar.show(
          context,
          message: "To Date should be greater than From Date",
          backgroundColor: AppColors.warningColor,
        );
        return;
      }

      String fromDateISO = fromDateTime.toIso8601String();
      String toDateISO = toDateTime.toIso8601String();

      print(
          "Booking No: $bookingNo, Shipping Bill No: $boeNo, From Date: $fromDateISO, To Date: $toDateISO");
      if (selectedTerminalId != null) {
        getShipmentDetails(toDateISO, fromDateISO, bookingNo, boeNo,
            airportId: selectedTerminalId!);
      } else {
        getShipmentDetails(toDateISO, fromDateISO, bookingNo, boeNo);
      }

      Navigator.pop(context);
    }

    return showDialog(
      context: context,
      barrierColor: const Color(0x01000000),
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              insetPadding: const EdgeInsets.all(0),
              child: Container(

                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.textFieldBorderColor),
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Shipment Search",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          width: double.infinity,
                          child: Divider(color: Colors.grey),
                        ), // Gray horizontal line
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: bookingNoController,
                          labelText: "Booking No.",
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: boeNoController,
                          labelText: "BOE No.",
                          isValidationRequired: false,
                        ),

                        const SizedBox(height: 16),
                        CustomDatePicker(
                          controller: fromDateController,
                          labelText: 'From Date',
                          isFromDate: true,
                          otherDateController: toDateController,
                        ),
                        // TextField(
                        //   controller: fromDateController,
                        //   decoration: InputDecoration(
                        //     labelText: "From Date",
                        //     suffixIcon: IconButton(
                        //       icon: const Icon(Icons.calendar_today),
                        //       onPressed: () => _selectDate(
                        //           context, fromDateController,
                        //           isFromDate: true),
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(6),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 16),
                        CustomDatePicker(
                          controller: toDateController,
                          labelText: 'To Date',
                          otherDateController: fromDateController,
                        ),
                        SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.09),
                        const SizedBox(
                          width: double.infinity,
                          child: Divider(color: Colors.grey),
                        ),
                        const SizedBox(height: 16),

                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()){
                              search();
                            }
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

                        OutlinedButton(
                          onPressed: () {
                            bookingNoController.clear();
                            boeNoController.clear();
                            fromDateController.text = _formatDate(DateTime.now()
                                .subtract(const Duration(days: 2)));
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
                            style: TextStyle(
                                color: AppColors.primary), // Blue text
                          ),
                        ),
                        const SizedBox(height: 16), // Space between buttons
                        // Cancel button
                        TextButton(
                          onPressed: () {
                            bookingNoController.clear();
                            boeNoController.clear();
                            fromDateController.text = _formatDate(DateTime.now()
                                .subtract(const Duration(days: 2)));
                            toDateController.text = _formatDate(DateTime.now());
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
              ),
            ),
          ),
        );
      },
    );
  }

  void filterShipments() {
    setState(() {
      filteredList = getFilteredShipmentDetails(
          listShipmentDetails, selectedFilters, selectedDate);
    });
  }

  List<SlotBookingShipmentDetailsImport> getFilteredShipmentDetails(
      List<SlotBookingShipmentDetailsImport> listShipmentDetails,
      List<String> selectedFilters,
      DateTime? selectedDate) {
    return listShipmentDetails.where((shipment) {
      bool statusMatchFound = true;
      bool dateMatchFound = true;

      if (selectedFilters.isNotEmpty) {
        statusMatchFound = selectedFilters.any((filter) {
          return shipment.statusDescription.trim().toUpperCase() ==
              filter.trim().toUpperCase();
        });
      }

      if (selectedDate != null) {
        try {
          DateFormat format = DateFormat("yyyy-MM-dd");
          DateTime shipmentDate = format.parse(shipment.bookingDt);

          dateMatchFound = shipmentDate.year == selectedDate.year &&
              shipmentDate.month == selectedDate.month &&
              shipmentDate.day == selectedDate.day;
        } catch (e) {
          print("Error parsing date: ${shipment.bookingDt}");
          dateMatchFound = false;
        }
      }
      return statusMatchFound && dateMatchFound;
    }).toList();
  }

// Function to handle filtering by status and date
//   List<ShipmentDetails> getFilteredShipmentDetails(
//       List<ShipmentDetails> listShipmentDetails,
//       List<String> selectedFilters,
//       DateTime? selectedDate) {
//
//     return listShipmentDetails.where((shipment) {
//       // Status filtering
//       bool statusMatchFound = selectedFilters.any((filter) {
//         return shipment.statusDescription.trim().toUpperCase() == filter.trim().toUpperCase();
//       });
//
//       // Date filtering
//       bool dateMatchFound = true; // Default to true if no date is provided
//
//       if (selectedDate != null) {
//         try {
//           // Parse the string date into DateTime
//           DateTime shipmentDate = DateTime.parse(shipment.bookingDt);
//
//           // Compare the parsed date with the selected date
//           dateMatchFound = shipmentDate.year == selectedDate.year &&
//               shipmentDate.month == selectedDate.month &&
//               shipmentDate.day == selectedDate.day;
//         } catch (e) {
//           print("Error parsing date: ${shipment.bookingDt}");
//           dateMatchFound = false; // If date parsing fails, exclude this shipment
//         }
//       }
//
//       // Return true only if both status and date match
//       return statusMatchFound && dateMatchFound;
//     }).toList();
//   }

// Helper function to check if two dates are the same
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> pickDate(BuildContext context, StateSetter setState) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            useMaterial3: false,
            primaryColor: AppColors.primary,
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
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
    }
  }

  //
  // void filterShipments() {
  //   setState(() {
  //     filteredList =
  //         getFilteredShipmentDetails(listShipmentDetails, selectedFilters);
  //   });
  // }
  //
  // List<ShipmentDetails> getFilteredShipmentDetails(
  //     List<ShipmentDetails> listShipmentDetails, List<String> selectedFilters) {
  //   return listShipmentDetails.where((shipment) {
  //     bool matchFound = selectedFilters.any((filter) {
  //       // Print both values for debugging
  //       print(
  //           "Checking Shipment Status: ${shipment.statusDescription}, Filter: $filter");
  //       return shipment.statusDescription.toUpperCase() == filter;
  //     });
  //     return matchFound;
  //   }).toList();
  // }

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
  //                         selectedColor: AppColors.primary.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: AppColors.primary.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in Pending'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: AppColors.primary.withOpacity(0.2),
  //                       ),
  //                       FilterChip(
  //                         label: Text('Gate-in Rejected'),
  //                         selected: false,
  //                         onSelected: (bool selected) {},
  //                         selectedColor: AppColors.primary.withOpacity(0.2),
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
                            label: const Text(
                              'Draft',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            selected: selectedFilters.contains('DRAFT'),
                            showCheckmark: false,
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('DRAFT')
                                    : selectedFilters.remove('DRAFT');
                              });
                            },
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters.contains('DRAFT')
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                            ),
                            checkmarkColor: AppColors.primary,
                          ),
                          FilterChip(
                            label: const Text(
                              'Gated-in',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            selected: selectedFilters.contains('GATED-IN'),
                            showCheckmark: false,
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('GATED-IN')
                                    : selectedFilters.remove('GATED-IN');
                              });
                            },
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters.contains('GATED-IN')
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          FilterChip(
                            label: const Text(
                              'Gate-in Pending',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            selected:
                                selectedFilters.contains('PENDING FOR GATE-IN'),
                            showCheckmark: false,
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('PENDING FOR GATE-IN')
                                    : selectedFilters
                                        .remove('PENDING FOR GATE-IN');
                              });
                            },
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters
                                        .contains('PENDING FOR GATE-IN')
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                          FilterChip(
                            label: const Text(
                              'Gate-in Rejected',
                              style: TextStyle(color: AppColors.primary),
                            ),
                            selected:
                                selectedFilters.contains('REJECT FOR GATE-IN'),
                            showCheckmark: false,
                            onSelected: (bool selected) {
                              setState(() {
                                selected
                                    ? selectedFilters.add('REJECT FOR GATE-IN')
                                    : selectedFilters
                                        .remove('REJECT FOR GATE-IN');
                              });
                            },
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                color: selectedFilters
                                        .contains('REJECT FOR GATE-IN')
                                    ? AppColors.primary
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FILTER BY DATE',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
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
                        setState(() {
                          isFilterApplied = true;
                        });
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
                          isFilterApplied = false;
                          selectedDate = null;
                          slotFilterDate = "Slot Date";
                        });
                        Navigator.pop(context);
                        filterShipments();
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
}
