import 'dart:convert';

import 'package:excel/excel.dart' as ex;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lpms/screens/slot_booking/BookingCreationExport.dart';
import 'package:lpms/theme/app_color.dart';
import 'package:path_provider/path_provider.dart';
import '../../api/auth.dart';
import '../../core/dimensions.dart';
import '../../core/img_assets.dart';
import '../../models/ShippingList.dart';
import '../../theme/app_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../ui/widgest/AppDrawer.dart';
import '../../ui/widgest/CustomTextField.dart';
import '../../ui/widgest/buttons.dart';
import '../../util/Global.dart';
import '../../util/Uitlity.dart';
import 'dart:io';

import '../../util/media_query.dart';
import 'BookingCreationImport.dart';
import 'ExportDashboard.dart';

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

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<SlotBookingShipmentListingImport> listShipmentDetails = [];
  List<SlotBookingShipmentListingImport> listShipmentDetailsBind = [];
  final AuthService authService = AuthService();
  List<bool> _isExpandedList = [];
  List<String> selectedFilters = [];
  List<SlotBookingShipmentListingImport> filteredList = [];

  String _formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  late TextEditingController fromDateController;
  late TextEditingController toDateController;
  TextEditingController bookingNoController = TextEditingController();
  TextEditingController boeNoController = TextEditingController();

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
    final List<MenuData> menuItems = [
      MenuData(
        title: "Slot Booking",
        icon: slot,
        hasSubmenu: true,
        submenuItems: [
          SubmenuItem(
            title: "Export Booking",
            icon: exportSvg,
            route: '',
            onTap: () {
              // Navigate to create import screen
              Navigator.push(context, CupertinoPageRoute(builder: (context) => const ExportScreen ()));
            },
          ),
          SubmenuItem(
            title: "Import Booking",
            icon: importSvg,
            route: '',
            onTap: () {
              // Navigate to export reports screen
              Navigator.push(context, CupertinoPageRoute(builder: (context) => const ImportScreen()));
            },
          ),

        ],
      ),

    ];
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: const Text(
            'Import',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white, size: 32),
          toolbarHeight: 60,
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
                              items: terminalsList.map((terminal) {
                                return DropdownMenuItem<int>(
                                  value: int.parse(terminal.value),
                                  child: Text(terminal.nameDisplay),
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
        drawer: AppDrawerOld(selectedScreen: "Import",),
      // drawer: AppDrawer(onDrawerCloseIcon: (){
      //   _scaffoldKey.currentState?.closeDrawer();
      // }, menuItems: menuItems,),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(
                horizontal: ScreenDimension.onePercentOfScreenWidth *
                    AppDimensions.defaultPageHorizontalPadding),
            color: AppColors.background,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenDimension.onePercentOfScreenWidth,
                      vertical: ScreenDimension.onePercentOfScreenHight*1.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: SvgPicture.asset(
                              menu,
                              height: ScreenDimension.onePercentOfScreenHight *
                                  AppDimensions.defaultIconSize,
                            ),
                          ),
                          Text(
                            'Shipment Listing',
                            style: AppStyle.defaultHeading,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                more,
                                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                                height: ScreenDimension.onePercentOfScreenHight *
                                    AppDimensions.defaultIconSize,
                              ),
                            ),
                            onTap: () {

                            },
                          ),
                          SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  1.5),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ScreenDimension.onePercentOfScreenWidth,
                      vertical: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Text(
                        'Showing (0/0)',
                        style: AppStyle.defaultTitle,
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                search_scan,
                                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                                height: ScreenDimension.onePercentOfScreenHight *
                                    AppDimensions.defaultIconSize,
                              ),
                            ),
                            onTap: () {
                              print("Search button pressed");
                              showFlightSearchBottomSheet(context);
                            },
                          ),
                          SizedBox(
                              width: ScreenDimension.onePercentOfScreenWidth *
                                  4),
                          InkWell(
                            onTap: () {
                              showFlightFilterBottomSheet(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: SvgPicture.asset(
                                filter,
                                height:
                                ScreenDimension.onePercentOfScreenHight *
                                    AppDimensions.defaultIconSize1,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                                top: 8.0, left: 0.0, bottom: 80),
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
                                            SlotBookingShipmentListingImport
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
                                            SlotBookingShipmentListingImport
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
              MaterialPageRoute(builder: (context) => const BookingCreationImport(operationType: "C", isQRVisisble: false,)),
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

  void showFlightSearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        void search() async {
          String bookingNo = bookingNoController.text.trim();
          String boeNo = boeNoController.text.trim();
          print("BOE $boeNo");
          String fromDate = fromDateController.text.trim();
          String toDate = toDateController.text.trim();

          if (fromDate.isEmpty || toDate.isEmpty) {
            await Future.delayed(const Duration(milliseconds: 100));
            CustomSnackBar.show(
              context,
              message: "Please fill in all fields",
              backgroundColor: Colors.red,
            );
            return;
          }
          DateTime fromDateTime = DateFormat('d MMM yyyy').parse(fromDate);
          DateTime toDateTime = DateFormat('d MMM yyyy').parse(toDate);

          if (fromDateTime.isAfter(toDateTime)) {
            // fromDateController.text = _formatDate(
            //     DateTime.now().subtract(const Duration(days: 2)));
            fromDateController.text = '';
            toDateController.text = _formatDate(DateTime.now());
            CustomSnackBar.show(
              context,
              message: "From Date should be less than To Date",
              backgroundColor: AppColors.warningColor,
            );
            return;
          }
          if (toDateTime.isBefore(fromDateTime)) {
            // fromDateController.text = _formatDate(
            //     DateTime.now().subtract(const Duration(days: 2)));
            toDateController.text = '';
            CustomSnackBar.show(
              context,
              message: "To Date should be greater than From Date",
              backgroundColor: AppColors.warningColor,
            );
            return;
          }

          String fromDateISO = fromDateTime.toIso8601String();
          String toDateISO = toDateTime.toIso8601String();

          if (selectedTerminalId != null) {
            getShipmentDetails(toDateISO, fromDateISO, bookingNo, boeNo,
                airportId: selectedTerminalId!);
          } else {
            getShipmentDetails(toDateISO, fromDateISO, bookingNo, boeNo);
          }

          Navigator.pop(context);
        }
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: ScreenDimension.onePercentOfScreenHight * 96,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: SvgPicture.asset(
                                    searchBlack,
                                    height: ScreenDimension
                                        .onePercentOfScreenHight *
                                        AppDimensions.defaultIconSize,
                                  ),
                                ),
                                Text(
                                  'Shipment Search',
                                  style: AppStyle.defaultHeading,
                                ),
                              ],
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SvgPicture.asset(
                                      cancel,
                                      height: ScreenDimension
                                          .onePercentOfScreenHight *
                                          AppDimensions.defaultIconSize,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Utils.customDivider(
                        space: 0,
                        color: Colors.black,
                        hasColor: true,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Enter details to search",
                              style: TextStyle(
                                fontSize: ScreenDimension.textSize *
                                    AppDimensions.titleText3,
                                color: AppColors.textColorPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: SvgPicture.asset(
                                    clear,
                                    height: ScreenDimension
                                        .onePercentOfScreenHight *
                                        AppDimensions.cardIconsSize2,
                                  ),
                                ),
                                Text("Clear",
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: ScreenDimension.textSize *
                                          AppDimensions.bodyTextMedium,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: bookingNoController,
                              labelText: "Booking No.",
                              isValidationRequired: false,
                            ),
                            SizedBox( height: ScreenDimension.onePercentOfScreenHight*1.5),
                            CustomTextField(
                              controller: boeNoController,
                              labelText: "BOE No.",
                              isValidationRequired: false,
                            ),
                            SizedBox( height: ScreenDimension.onePercentOfScreenHight*1.5),
                            CustomDatePicker(
                              controller: fromDateController,
                              labelText: 'From Date',
                              isFromDate: true,
                              otherDateController: toDateController,
                            ),
                            SizedBox( height: ScreenDimension.onePercentOfScreenHight*1.5),
                            CustomDatePicker(
                              controller: toDateController,
                              labelText: 'To Date',
                              otherDateController: fromDateController,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: ScreenDimension.onePercentOfScreenHight * 50,
                      ),
                      Utils.customDivider(
                        space: 0,
                        color: Colors.black,
                        hasColor: true,
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonWidgets.buildRoundedGradientButton(
                                text: 'Cancel',
                                isborderButton: true,
                                textColor: AppColors.primary,
                                verticalPadding: 10,
                                press: () {
                                  bookingNoController.clear();
                                  boeNoController.clear();
                                  fromDateController.text = _formatDate(DateTime.now()
                                      .subtract(const Duration(days: 2)));
                                  toDateController.text = _formatDate(DateTime.now());
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: ButtonWidgets.buildRoundedGradientButton(
                                text: 'Search',
                                press: () {
                                  print("${boeNoController.text}");
                                 search();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showFlightFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        TextEditingController originController = TextEditingController();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FractionallySizedBox(
              widthFactor: 1,
              child: Container(
                height: ScreenDimension.onePercentOfScreenHight * 42,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter/Sort',
                              style: AppStyle.defaultHeading,
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: SvgPicture.asset(
                                      clear,
                                      height: ScreenDimension
                                          .onePercentOfScreenHight *
                                          AppDimensions.cardIconsSize,
                                    ),
                                  ),
                                  Text("Clear",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: ScreenDimension.textSize *
                                            AppDimensions.bodyTextLarge,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ],
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Utils.customDivider(
                        space: 0,
                        color: Colors.black,
                        hasColor: true,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 0),
                        child: Text(
                          "SORT BY STATUS",
                          style: TextStyle(
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.bodyTextSmall,
                            color: AppColors.textColorSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
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
                      Utils.customDivider(
                        space: 0,
                        color: Colors.black,
                        hasColor: true,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16.0, top: 16.0, bottom: 0),
                        child: Text(
                          "FILTER BY DATE",
                          style: TextStyle(
                            fontSize: ScreenDimension.textSize *
                                AppDimensions.bodyTextSmall,
                            color: AppColors.textColorSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all( 16),
                        child: GestureDetector(
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
                      ),
                      Utils.customDivider(
                        space: 0,
                        color: Colors.black,
                        hasColor: true,
                        thickness: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonWidgets.buildRoundedGradientButton(
                                text: 'Cancel',
                                isborderButton: true,
                                textColor: AppColors.primary,
                                verticalPadding: 10,
                                press: () {
                                  setState(() {
                                    selectedFilters.clear();
                                    isFilterApplied = false;
                                    selectedDate = null;
                                    slotFilterDate = "Slot Date";
                                  });
                                  Navigator.pop(context);
                                  filterShipments();
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: ButtonWidgets.buildRoundedGradientButton(
                                text: 'Apply',
                                press: () {
                                  Navigator.pop(context);
                                  filterShipments();
                                  setState(() {
                                    isFilterApplied = true;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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

  void exportToExcel(List<SlotBookingShipmentListingImport> shipments) async {
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
      else{
        hasNoRecord=false;
      }
      listShipmentDetailsBind = jsonData
          .map((json) => SlotBookingShipmentListingImport.fromJSON(json))
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
      SlotBookingShipmentListingExport shipmentDetails, int index) {
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
                      isExpanded ? 'Show Less' : 'Show More',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
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
      SlotBookingShipmentListingImport shipmentDetails, int index) {
    bool isExpanded = _isExpandedList[index];
    return Card(
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      margin: EdgeInsets.symmetric(horizontal: 0,vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: SizedBox(
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
                              style: AppStyle.statusText,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    child: Container(
                      // margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.gradient1,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SvgPicture.asset(
                          rightArrow,
                          height: ScreenDimension.onePercentOfScreenHight *
                              AppDimensions.cardIconsSize2,
                        ),
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingCreationImport(
                              operationType: "V",
                              bookingId: shipmentDetails.bookingId,
                              isQRVisisble:(shipmentDetails.statusDescription=="PENDING FOR GATE-IN" || shipmentDetails.statusDescription=="REJECT FOR GATE-IN" )?true:false,
                            )),
                      );
                    },
                  ),

                ],
              ),
              SizedBox(height: ScreenDimension.onePercentOfScreenHight*0.4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shipmentDetails.bookingNo,
                    style:AppStyle.subHeading,
                  ),
                  SizedBox(height: ScreenDimension.onePercentOfScreenHight*0.4,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children:  [
                      Text(
                        'Slot Booking Date:',
                        style: AppStyle.defaultTitle,
                      ),
                      SizedBox(width: ScreenDimension.onePercentOfScreenWidth),
                      Text(
                        "${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.bookingDt))}",
                        style:  AppStyle.sideDescText,
                      ),
                    ],
                  ),
                ],
              ),

              isExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        children: [
                          Utils.customDivider(
                            space: 0,
                            color: Colors.black,
                            hasColor: true,
                            thickness: 1,
                          ),
                          SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: ScreenDimension.onePercentOfScreenWidth*44,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          'BOE No.',
                                          style:  AppStyle.sideDescText,
                                        ),
                                        Text(
                                          '${shipmentDetails.boeNo}  ',
                                          style: AppStyle.defaultTitle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                     Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'CHA Name',
                                          style: AppStyle.sideDescText,
                                        ),
                                        Text(
                                          'ABC',
                                          style: AppStyle.defaultTitle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                width: ScreenDimension.onePercentOfScreenWidth*44,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          'BOE Date',
                                          style: AppStyle.sideDescText,
                                        ),
                                        Text(
                                          '${DateFormat('dd MMM yyyy').format(DateTime.parse(shipmentDetails.boeDt))}  ',
                                          style: AppStyle.defaultTitle,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                         Text(
                                          'Importer Name',
                                          style: AppStyle.sideDescText,
                                        ),
                                        Text(
                                          shipmentDetails.exporterImporter,
                                          style: AppStyle.defaultTitle,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
                          Utils.customDivider(
                            space: 0,
                            color: Colors.black,
                            hasColor: true,
                            thickness: 1,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: ScreenDimension.onePercentOfScreenHight,),
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
                      isExpanded ? 'Show Less' : 'Show More',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PopupMenuButton<int>(
                    onSelected: (value) async {
                      switch (value) {
                        case 1:
                          if (shipmentDetails.statusDescription == "GATED-IN") {
                            CustomSnackBar.show(context,
                                message:
                                "Slot booking is already Gate In. Booking cannot be edited");
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BookingCreationImport(
                                  operationType: "E",
                                  bookingId: shipmentDetails.bookingId, isQRVisisble: false,
                                )),
                          );
                          break;
                        case 2:
                          if (shipmentDetails.statusDescription == "GATED-IN") {
                            CustomSnackBar.show(context,
                                message:
                                "Slot booking is already Gate In. Booking cannot be deleted");
                            return;
                          }
                          bool? isTrue =
                          await Utils.confirmationDialog(context);
                          if (isTrue!) {
                            deleteShipment(shipmentDetails.bookingId);
                          }
                          break;
                      // case 3:
                      //   // Handle Audit Log action
                      //   break;
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
                            Icon(Icons.delete, color: AppColors.errorRed),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                      // const PopupMenuItem(
                      //   value: 3,
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.list_alt, color: AppColors.primary),
                      //       SizedBox(width: 8),
                      //       Text('Audit Log'),
                      //     ],
                      //   ),
                      // ),
                    ],
                    color: AppColors.white,
                    child: const Icon(
                      Icons.more_vert,
                      color: AppColors.primary,
                    ),
                  ),
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
                          isValidationRequired: false,
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

  List<SlotBookingShipmentListingImport> getFilteredShipmentDetails(
      List<SlotBookingShipmentListingImport> listShipmentDetails,
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

  deleteShipment(bookingId) async {
    Utils.showLoadingDialog(context);

    var queryParams = {
      "BookingId": bookingId.toString(),
      "TimeZone": loginMaster[0].userId,
    };
    await authService
        .postData(
      "api_pcs/ImpShipment/Delete",
      queryParams,
    )
        .then((response) {
      print("data received ");
      Map<String, dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      if (jsonData["ResponseMessage"] == "msg3") {
        Utils.hideLoadingDialog(context);
        CustomSnackBar.show(context,
            message: "Export shipment booking deleted successfully.",
            backgroundColor: AppColors.successColor,
            leftIcon: Icons.check_circle);

      }
      Utils.hideLoadingDialog(context);
      getShipmentDetails(endOfDayFormatted,
          startOfDayFormatted, "", "",
          airportId: selectedTerminalId!);
    }).catchError((onError) {
      Utils.hideLoadingDialog(context);
      print(onError);
    });
  }
}
