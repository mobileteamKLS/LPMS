import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_color.dart';
import 'Global.dart';

class Utils {
  static bool _isDialogShowing = false;

  static Icon getStatusIcon(String status) {
    switch (status) {
      case 'GATED-IN':
        return const Icon(
          Icons.flag_outlined,
          color: Colors.black,
          size: 18,
        );
      case 'GATE-IN':
        return const Icon(
          Icons.input_outlined,
          color: Colors.black,
          size: 18,
        );
      case 'REJECT FOR GATE-IN':
        return const Icon(
          Icons.cancel_outlined,
          color: Colors.black,
          size: 18,
        );
      case 'DRAFT':
        return const Icon(
          Icons.local_shipping_outlined,
          color: Colors.black,
          size: 18,
        );
      case 'PENDING FOR GATE-IN':
        return const Icon(
          Icons.pending_actions_outlined,
          color: Colors.black,
          size: 18,
        );
      default:
        return const Icon(
          Icons.help,
          color: Colors.black,
          size: 18,
        );
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'GATED-IN':
        return AppColors.gatedIn;
      case 'GATE-IN':
        return AppColors.gateInRed;
      case 'DRAFT':
        return AppColors.draft;
      case 'PENDING FOR GATE-IN':
        return AppColors.gateInYellow;
      case 'REJECT FOR GATE-IN':
        return AppColors.gateInRed;
      default:
        return AppColors.gateInYellow;
    }
  }

  static printPayload(Map<String, dynamic> payload) {
    for (var entry in payload.entries) {
      print('${entry.key}: ${entry.value}');
    }
  }

  static printPrettyJson(String jsonString) {
    if (jsonString.isEmpty) {
      return;
    }
    var jsonObject = jsonDecode(jsonString);
    var prettyString = const JsonEncoder.withIndent('  ').convert(jsonObject);
    const int chunkSize = 1000;
    for (var i = 0; i < prettyString.length; i += chunkSize) {
      print(prettyString.substring(
          i,
          i + chunkSize > prettyString.length
              ? prettyString.length
              : i + chunkSize));
    }
    // printLongString(prettyString);
  }

  static String formatDate(DateTime date) {
    return DateFormat('d MMM yyyy').format(date);
  }

  static keepFirstNElements(List<dynamic> list, int n) {
    if (n < list.length) {
      list.removeRange(n, list.length);
    }
  }

  static String normalizeString(String input) {
    return input.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static clearMasterData() {
    vehicleListImports = [];
    vehicleListExports = [];
    shipmentListExports = [];
    shipmentListImports = [];
    multiSelectController.clearAll();
  }

  static clearMasterDataForToggle() {
    vehicleListImports = [];
    vehicleListExports = [];
    shipmentListExports = [];
    shipmentListImports = [];
    // multiSelectController.clearAll();
  }

  static void showLoadingDialog(BuildContext context, {String? message}) {
    if (!_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                if (message != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      );
    }
  }

  static void hideLoadingDialog(BuildContext context) {
    if (_isDialogShowing) {
      _isDialogShowing = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  static Future<bool?> confirmationDialog(
    BuildContext context,
  ) {
    return showDialog<bool>(
      barrierColor: AppColors.textColorPrimary.withOpacity(0.5),
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: const Row(
            children: [
            Icon(
            Icons.info_outline_rounded,
            color: AppColors.textColorPrimary,

          ),
              Text(
                "  Confirmation",
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textColorPrimary,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this record ?",
            style: TextStyle(
                fontSize: 16,
                color: AppColors.textColorPrimary,
                fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.primary
                ),
                child: const Text(
                  "DELETE",
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width / 100 * 1.8,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "CANCEL",
                style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        );
      },
    );
  }

// static void printLongString(String text) {
//   const int chunkSize = 1000;
//   for (var i = 0; i < text.length; i += chunkSize) {
//     print(text.substring(
//         i, i + chunkSize > text.length ? text.length : i + chunkSize));
//   }
// }
}
