import 'package:flutter/material.dart';
import 'package:lpms/screens/slot_booking/ExportDashboard.dart';
import 'package:lpms/screens/slot_booking/ImportDashboard.dart';
import 'package:lpms/theme/app_color.dart';

class AppDrawer extends StatefulWidget {
  final String selectedScreen;

  AppDrawer({required this.selectedScreen});

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showSlotBookingItems = false;

  @override
  void initState() {
    super.initState();

    if (widget.selectedScreen == 'Import' || widget.selectedScreen == 'Export') {
      showSlotBookingItems = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0057D8),
                  Color(0xFF1c86ff),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Text(
              'LPMS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ExpansionTile(
            title: const Text("Slot Booking"),
            leading: const Icon(Icons.local_shipping_outlined),
            initiallyExpanded: showSlotBookingItems,
            backgroundColor: (widget.selectedScreen == 'Import' || widget.selectedScreen == 'Export')
                ? Colors.grey[300]
                : null,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.import_export_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Export'),
                selected: widget.selectedScreen == 'Export',
                selectedTileColor: Colors.grey[300],
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExportScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.import_export_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Import'),
                selected: widget.selectedScreen == 'Import',
                selectedTileColor: Colors.grey[300],
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImportScreen()),
                  );
                },
              ),
            ],
          )
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () {
          //     Navigator.pushReplacement(
          //       context,
          //       MaterialPageRoute(builder: (context) => SettingsScreen()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
