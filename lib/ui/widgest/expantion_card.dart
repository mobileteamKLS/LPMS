import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:lpms/theme/app_color.dart';

import '../../api/auth.dart';
import '../../models/ShippingList.dart';
import '../../screens/AddShipmentDetailsExport.dart';
import '../../screens/AddShipmentDetailsImport.dart';
import '../../screens/AddVehicleDetailsExport.dart';
import '../../screens/SlotBooking.dart';
import '../../screens/AddVehicleDetailsImport.dart';
import '../../util/Global.dart';
import 'CustomTextField.dart';
import 'package:http_parser/http_parser.dart';

class ShipmentItemNew extends StatefulWidget {
  final List<ShipmentDetailsExports> shipmentDetailsList;
  final bool isExport;

  const ShipmentItemNew(
      {super.key, required this.shipmentDetailsList, required this.isExport});

  @override
  _ShipmentItemNewState createState() => _ShipmentItemNewState();
}

class _ShipmentItemNewState extends State<ShipmentItemNew> {
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    print("shipmentDetailsList length: ${widget.shipmentDetailsList.length}");
    print("expanded length: ${expanded.length}");
    if (expanded.length != widget.shipmentDetailsList.length) {
      expanded =
          List.generate(widget.shipmentDetailsList.length, (index) => false);
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.shipmentDetailsList.length,
      itemBuilder: (BuildContext context, int index) {
        var shipmentDetails = widget.shipmentDetailsList[index];
        return Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shipping Bill No/ Date",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Text(
                        "${shipmentDetails.shippingBillNoIgmNno}/${shipmentDetails.shippingBillDateIgm}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColorPrimary,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddShipmentDetails(
                                    shipment: shipmentDetails,
                                    isExport: widget.isExport,
                                  ),
                                ),
                              ).then((updatedShipment) {
                                if (updatedShipment != null) {
                                  setState(() {
                                    widget.shipmentDetailsList[index] =
                                        updatedShipment;
                                    // expanded = List.generate(widget.shipmentDetailsList.length, (index) => false);
                                  });
                                }
                              });
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(Icons.edit,
                                    size: 28, color: AppColors.primary)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded[index] = !expanded[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                expanded[index]
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded[index])
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShipmentInfoRow(
                      header1: "Exporter Name",
                      value1: shipmentDetails.nameOfExporterImporter,
                      header2: "HSN Code",
                      value2: shipmentDetails.hsnCode,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Cargo Type",
                      value1: shipmentDetails.cargoType,
                      header2: "Cargo Description",
                      value2: shipmentDetails.cargoDescription,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Quantity",
                      value1: shipmentDetails.quantity.toString(),
                      header2: "Cargo Weight",
                      value2: shipmentDetails.cargoWeight.toString(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Cargo Value",
                      value1: shipmentDetails.cargoValue.toString(),
                      header2: "",
                      value2: "",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}



class AddShipmentDetailsListNew extends StatefulWidget {
  final List<ShipmentDetailsExports> shipmentDetailsList;
  final Future<ShipmentDetailsExports?> Function() validateAndNavigate;
  final bool isExport;

  const AddShipmentDetailsListNew({
    super.key,
    required this.shipmentDetailsList,
    required this.validateAndNavigate,
    required this.isExport,
  });

  @override
  _AddShipmentDetailsListNew createState() => _AddShipmentDetailsListNew();
}

class _AddShipmentDetailsListNew extends State<AddShipmentDetailsListNew> {
  List<bool> expanded = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
    print("-----${widget.shipmentDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shipmentDetailsList.isEmpty) {
      return _buildEmptyShipmentDetails();
    } else {
      return _buildShipmentDetailsList();
    }
  }

  Widget _buildEmptyShipmentDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.background,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SHIPMENT DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  // isFTlAndOneShipment
                  //     ? GestureDetector(
                  //         onTap: ()  {
                  //           },
                  //         child: Container(
                  //           margin: const EdgeInsets.symmetric(horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //           child: const Icon(
                  //             size: 28,
                  //             Icons.add,
                  //             color: AppColors.gateInYellow,
                  //           ),
                  //         ),
                  //       )
                  //     :
                  GestureDetector(
                    onTap: () async {
                      final result = await widget.validateAndNavigate();
                      if (result != null) {
                        setState(() {
                          widget.shipmentDetailsList.add(result);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        size: 28,
                        Icons.add,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Total Count  ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("0"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Method to build the widget when shipmentDetailsList is not empty
  Widget _buildShipmentDetailsList() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background,
                    width: 4.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SHIPMENT DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          // (isFTlAndOneShipment && widget.shipmentDetailsList.length==0)?
                          // GestureDetector(
                          //   onTap: () async {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => AddShipmentDetails(
                          //           shipment: null,
                          //           isExport: widget.isExport,
                          //         ),
                          //       ),
                          //     ).then((newShipment) {
                          //       if (newShipment != null) {
                          //         setState(() {
                          //           // Add new shipment to the list
                          //           shipmentList.add(newShipment);
                          //           expanded.add(false);
                          //         });
                          //       }
                          //     });
                          //   },
                          //   child: Container(
                          //     margin: const EdgeInsets.symmetric(horizontal: 8),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     child: const Icon(
                          //       size: 28,
                          //       Icons.add,
                          //       color: AppColors.errorRed,
                          //     ),
                          //   ),
                          // ):
                          GestureDetector(
                            onTap: () async {
                              if (isFTlAndOneShipment &&
                                  shipmentListExports.isNotEmpty) {
                                CustomSnackBar.show(context, message: "Only 1 Shipment is Allowed");
                                return;
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddShipmentDetails(
                                      shipment: null,
                                      isExport: widget.isExport,
                                    ),
                                  ),
                                ).then((newShipment) {
                                  if (newShipment != null) {
                                    setState(() {
                                      // Add new shipment to the list
                                      shipmentListExports.add(newShipment);
                                      expanded.add(false);
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                size: 28,
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                              widget.shipmentDetailsList.length.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (isExpanded)
              SizedBox(
                child: ShipmentItemNew(
                  shipmentDetailsList: shipmentListExports,
                  isExport: widget.isExport,
                ),
              ),
          ],
        )
      ],
    );
  }
}

class AddVehicleDetailsListExportsNew extends StatefulWidget {
  final List<VehicleDetailsExports> vehicleDetailsList;
  final Future<VehicleDetailsExports?> Function() validateAndNavigate;
  final bool isExport;

  AddVehicleDetailsListExportsNew({
    super.key,
    required this.vehicleDetailsList,
    required this.validateAndNavigate,
    required this.isExport,
  });

  @override
  _AddVehicleDetailsListExportsNew createState() => _AddVehicleDetailsListExportsNew();
}

class _AddVehicleDetailsListExportsNew extends State<AddVehicleDetailsListExportsNew> {
  List<bool> expanded = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.vehicleDetailsList.length, (index) => false);
    print("-----${widget.vehicleDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicleDetailsList.isEmpty) {
      return _buildEmptyVehicleDetails();
    } else {
      return _buildVehicleDetailsList();
    }
  }

  Widget _buildEmptyVehicleDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.background,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "VEHICLE DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await widget.validateAndNavigate();
                      if (result != null) {
                        setState(() {
                          widget.vehicleDetailsList.add(result);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        size: 28,
                        Icons.add,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Total Count  ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("0"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildVehicleDetailsList() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Container(
              padding:
              const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background,
                    width: 4.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "VEHICLE DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              int maxItems =
                                  int.tryParse(noOfVehiclesController.text) ??
                                      1;
                              if (isFTlAndOneShipment &&
                                  vehicleListExports.length >= maxItems) {
                                CustomSnackBar.show(context, message: "Only $maxItems Vehicle is Allowed");
                                return;
                              } else if (!isFTlAndOneShipment &&
                                  vehicleListExports.isNotEmpty) {
                                CustomSnackBar.show(context, message: "Only 1 Vehicle is Allowed");
                                return;
                              } else {
                                final result =
                                await widget.validateAndNavigate();
                                if (result != null) {
                                  setState(() {
                                    widget.vehicleDetailsList.add(result);
                                  });
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                size: 28,
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:
                          Text(widget.vehicleDetailsList.length.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (isExpanded)
              SizedBox(
                child: VehicleItemExportsNew(
                  vehicleDetailsList: vehicleListExports,
                  IsExport: widget.isExport,
                ),
              ),
          ],
        )
      ],
    );
  }
}

class VehicleItemExportsNew extends StatefulWidget {
  final List<VehicleDetailsExports> vehicleDetailsList;
  final IsExport;

  const VehicleItemExportsNew(
      {super.key, required this.vehicleDetailsList, this.IsExport});

  @override
  _VehicleItemExportsNewState createState() => _VehicleItemExportsNewState();
}

class _VehicleItemExportsNewState extends State<VehicleItemExportsNew> {
  List<bool> expanded = [];
  String? fileName;
  String? fileSize;
  final AuthService authService = AuthService();
  final TextEditingController docNameController = TextEditingController();
  final TextEditingController docRemarkController = TextEditingController();

  File? pickedFile;
  Uint8List? fileBytes;

  Future<void> _pickFile(
      setState, VehicleDetailsExports vehicleDetails, String docType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = result.files.single.path!;
      File file2 = File(filePath);
      print("________$file2");
      if (file.extension == 'png' && file.size <= 2 * 1024 * 1024) {
        setState(() {
          fileName = file.name;
          print(fileName);
          fileBytes = result.files.single.bytes;
          pickedFile = File(result.files.single.path!);
          fileSize = '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB';
        });
      } else {
        setState(() {
          fileName = 'Invalid file. Please upload a PNG less than 2 MB.';
          fileSize = null;
        });
      }
      Upload(file2, vehicleDetails, fileName!, docType);
    } else {
      // User canceled the picker
    }
  }

  Future<void> Upload(File file, VehicleDetailsExports vehicleDetails, String fileName,
      String docType) async {
    await Future.delayed(const Duration(seconds: 2));
    var headers = {
      'Accept': 'text/plain',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${loginMaster[0].token}',
    };
    try {
      final response = await authService.uploadFile(
        headers: headers,
        endPoint: "api/ReturnRootPath/Upload",
        file: file,
      );

      if (response.body.isNotEmpty) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        // docDetails ??= DrivingLicense();
        // setState(() {
        //   docDetails?.filePath = jsonData["message"];
        //   docDetails?.documentPhysicalFileName = fileName;
        //   docDetails?.remark = docRemarkController.text;
        //   docDetails?.documentName = docNameController.text;
        //   docDetails?.documentType = docType;
        //   if (docType == "RC UPLOAD") {
        //     docDetails?.documentTyepId = 145;
        //   } else {
        //     docDetails?.documentTyepId = 144;
        //   }
        //   print("DocType");

        DrivingLicense document = DrivingLicense()
          ..filePath = jsonData["message"]
          ..documentPhysicalFileName = fileName
          ..remark = docRemarkController.text
          ..documentName =fileName
          ..documentType = docType
          ..documentTyepId = (docType == "RC UPLOAD") ? 145 : 144;

        setState(() {
          if (docType == "RC UPLOAD") {
            vehicleDetails.rcScanned = document;
          } else {
            vehicleDetails.drivingLicense = document;
          }

          print("Document uploaded for: $docType");
        });
      } else {
        print("Response is empty");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {});
    }
  }

  void showUploadRCSheet(
      BuildContext context, VehicleDetailsExports vehicleDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // List<String> selectedFilters = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Registration Certificate',
                              style: TextStyle(
                                  color: AppColors.textColorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: docNameController,
                                  labelText: 'Document Name',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: docRemarkController,
                                  labelText: 'Remark',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height: 45,
                                      child: fileSize != null
                                          ? const Text(
                                        "File Format & Size :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors
                                                .textColorSecondary),
                                      )
                                          : const Text(""),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 45,
                                      child: fileSize != null
                                          ? Text(
                                        "PNG & $fileSize",
                                        style: const TextStyle(
                                            color: AppColors
                                                .textColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                          : const Text(""),
                                    ),
                                  ],
                                ),
                                fileName != null
                                    ? Text(
                                  " $fileName",
                                  style: const TextStyle(
                                      color: AppColors.textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                                    : const Text(""),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickFile(setState, vehicleDetails,
                                    "RC UPLOAD");
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.upload_outlined,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    ' Upload File',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        fileName = null;
        fileSize = null;
      });
    });
  }

  void showUploadDLSheet(
      BuildContext context, VehicleDetailsExports vehicleDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // List<String> selectedFilters = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Driving License',
                              style: TextStyle(
                                  color: AppColors.textColorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: docNameController,
                                  labelText: 'Document Name',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: docRemarkController,
                                  labelText: 'Remark',
                                  isValidationRequired: false,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height: 45,
                                      child: fileSize != null
                                          ? const Text(
                                        "File Format & Size :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors
                                                .textColorSecondary),
                                      )
                                          : const Text(""),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 45,
                                      child: fileSize != null
                                          ? Text(
                                        "PNG & $fileSize",
                                        style: const TextStyle(
                                            color: AppColors
                                                .textColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                          : const Text(""),
                                    ),
                                  ],
                                ),
                                fileName != null
                                    ? Text(
                                  " $fileName",
                                  style: const TextStyle(
                                      color: AppColors.textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                                    : const Text(""),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickFile(setState,
                                    vehicleDetails, "DL UPLOAD");
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.upload_outlined,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    ' Upload File',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        fileName = null;
        fileSize = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.vehicleDetailsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (expanded.length != widget.vehicleDetailsList.length) {
      expanded =
          List.generate(widget.vehicleDetailsList.length, (index) => false);
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.vehicleDetailsList.length,
      itemBuilder: (BuildContext context, int index) {
        var vehicleDetails = widget.vehicleDetailsList[index];
        print(
            "${vehicleDetails.truckNo}-PRASAD--${vehicleDetails.vehicleTypeId}");

        return Column(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Vehicle No.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                vehicleDetails.truckNo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColorPrimary,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Slot Date/Time",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                vehicleDetails.slotViewDateTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColorPrimary,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddVehicleDetailsExports(
                                          vehicleDetails: vehicleDetails),
                                    ),
                                  ).then((updateVehicle) {
                                    if (updateVehicle != null) {
                                      setState(() {
                                        widget.vehicleDetailsList[index] =
                                            updateVehicle;
                                        // expanded =
                                        //     List.generate(widget.vehicleDetailsList.length, (index) => false);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(Icons.edit,
                                        size: 28, color: AppColors.primary)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expanded[index] = !expanded[index];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.gradient1,
                                  ),
                                  child: Icon(
                                    size: 28,
                                    expanded[index]
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showUploadRCSheet(context, vehicleDetails);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                        Icons.account_box_outlined,
                                        size: 28,
                                        color: AppColors.primary)),
                                const Text(
                                  "Reg. Cert.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          GestureDetector(
                            onTap: () {
                              showUploadDLSheet(context, vehicleDetails);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                        Icons.account_box_outlined,
                                        size: 28,
                                        color: AppColors.primary)),
                                const Text(
                                  "DL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                print("${vehicleDetails.vehicleId}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddBookSlotExports(
                                      isExport: widget.IsExport,
                                      vehicleDetails: vehicleDetails,
                                    ),
                                  ),
                                ).then((updateVehicle) {
                                  if (updateVehicle != null) {
                                    setState(() {
                                      widget.vehicleDetailsList[index] =
                                          updateVehicle;
                                      print("View Date is${widget.vehicleDetailsList[index]
                                              .slotViewDateTime}");
                                    });
                                  }
                                });
                                ;
                              },
                              child: const Text(
                                "Book Slot",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded[index])
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShipmentInfoRow(
                      header1: "Type of Vehicle",
                      value1: vehicleDetails.vehicleTypeName,
                      header2: "Driving License No.",
                      value2: vehicleDetails.drivingLicenseNo,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Driver DOB",
                      value1: vehicleDetails.driverDob,
                      header2: "Driver Name",
                      value2: vehicleDetails.driverName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Driver Mob No.",
                      value1: vehicleDetails.driverContact,
                      header2: "Remark/Chassis No.",
                      value2: vehicleDetails.remarksChassisNo,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}


//Imports

class AddShipmentDetailsListImportsNew extends StatefulWidget {
  final List<ShipmentDetailsImports> shipmentDetailsList;
  final Future<ShipmentDetailsImports?> Function() validateAndNavigate;
  final bool isExport;

  const AddShipmentDetailsListImportsNew({
    super.key,
    required this.shipmentDetailsList,
    required this.validateAndNavigate,
    required this.isExport,
  });

  @override
  _AddShipmentDetailsListImportsNew createState() =>
      _AddShipmentDetailsListImportsNew();
}

class _AddShipmentDetailsListImportsNew
    extends State<AddShipmentDetailsListImportsNew> {
  List<bool> expanded = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
    print("-----${widget.shipmentDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shipmentDetailsList.isEmpty) {
      return _buildEmptyShipmentDetails();
    } else {
      return _buildShipmentDetailsList();
    }
  }

  Widget _buildEmptyShipmentDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.background,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "SHIPMENT DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  // isFTlAndOneShipment
                  //     ? GestureDetector(
                  //         onTap: ()  {
                  //           },
                  //         child: Container(
                  //           margin: const EdgeInsets.symmetric(horizontal: 8),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(5),
                  //           ),
                  //           child: const Icon(
                  //             size: 28,
                  //             Icons.add,
                  //             color: AppColors.gateInYellow,
                  //           ),
                  //         ),
                  //       )
                  //     :
                  GestureDetector(
                    onTap: () async {
                      final result = await widget.validateAndNavigate();
                      if (result != null) {
                        setState(() {
                          widget.shipmentDetailsList.add(result);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        size: 28,
                        Icons.add,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Total Count  ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("0"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Method to build the widget when shipmentDetailsList is not empty
  Widget _buildShipmentDetailsList() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background,
                    width: 4.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "SHIPMENT DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          // (isFTlAndOneShipment && widget.shipmentDetailsList.length==0)?
                          // GestureDetector(
                          //   onTap: () async {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => AddShipmentDetails(
                          //           shipment: null,
                          //           isExport: widget.isExport,
                          //         ),
                          //       ),
                          //     ).then((newShipment) {
                          //       if (newShipment != null) {
                          //         setState(() {
                          //           // Add new shipment to the list
                          //           shipmentList.add(newShipment);
                          //           expanded.add(false);
                          //         });
                          //       }
                          //     });
                          //   },
                          //   child: Container(
                          //     margin: const EdgeInsets.symmetric(horizontal: 8),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //     ),
                          //     child: const Icon(
                          //       size: 28,
                          //       Icons.add,
                          //       color: AppColors.errorRed,
                          //     ),
                          //   ),
                          // ):
                          GestureDetector(
                            onTap: () async {
                              if (isFTlAndOneShipment &&
                                  shipmentListImports.isNotEmpty) {
                                CustomSnackBar.show(context, message: "Only 1 Shipment is Allowed");
                                return;
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AddShipmentDetailsImports(
                                      shipment: null,
                                      isExport: widget.isExport,
                                    ),
                                  ),
                                ).then((newShipment) {
                                  if (newShipment != null) {
                                    setState(() {
                                      // Add new shipment to the list
                                      shipmentListExports.add(newShipment);
                                      expanded.add(false);
                                    });
                                  }
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                size: 28,
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                              widget.shipmentDetailsList.length.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (isExpanded)
              SizedBox(
                child: ShipmentItemNewImports(
                  shipmentDetailsList: shipmentListImports,
                  isExport: widget.isExport,
                ),
              ),
          ],
        )
      ],
    );
  }
}

class ShipmentItemNewImports extends StatefulWidget {
  final List<ShipmentDetailsImports> shipmentDetailsList;
  final bool isExport;

  const ShipmentItemNewImports(
      {super.key, required this.shipmentDetailsList, required this.isExport});

  @override
  _ShipmentItemNewImportsState createState() => _ShipmentItemNewImportsState();
}

class _ShipmentItemNewImportsState extends State<ShipmentItemNewImports> {
  List<bool> expanded = [];

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.shipmentDetailsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    print("shipmentDetailsList length: ${widget.shipmentDetailsList.length}");
    print("expanded length: ${expanded.length}");
    if (expanded.length != widget.shipmentDetailsList.length) {
      expanded =
          List.generate(widget.shipmentDetailsList.length, (index) => false);
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.shipmentDetailsList.length,
      itemBuilder: (BuildContext context, int index) {
        var shipmentDetails = widget.shipmentDetailsList[index];
        return Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Shipping Bill No/ Date",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Text(
                        "${shipmentDetails.boeNo}/${shipmentDetails.boeDt}",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColorPrimary,
                            fontSize: 15),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddShipmentDetailsImports(
                                    shipment: shipmentDetails,
                                    isExport: widget.isExport,
                                  ),
                                ),
                              ).then((updatedShipment) {
                                if (updatedShipment != null) {
                                  setState(() {
                                    widget.shipmentDetailsList[index] =
                                        updatedShipment;
                                    // expanded = List.generate(widget.shipmentDetailsList.length, (index) => false);
                                  });
                                }
                              });
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Icon(Icons.edit,
                                    size: 28, color: AppColors.primary)),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                expanded[index] = !expanded[index];
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                expanded[index]
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded[index])
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShipmentInfoRow(
                      header1: "Exporter Name",
                      value1: shipmentDetails.nameOfExporterImporter,
                      header2: "HSN Code",
                      value2: shipmentDetails.hsnCode,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Cargo Type",
                      value1: shipmentDetails.cargoType,
                      header2: "Cargo Description",
                      value2: shipmentDetails.cargoDescription,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Quantity",
                      value1: shipmentDetails.quantity.toString(),
                      header2: "Cargo Weight",
                      value2: shipmentDetails.cargoWeight.toString(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const ShipmentInfoRow(
                      header1: "Cargo Value",
                      value1: "",
                      header2: "",
                      value2: "",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

class AddVehicleDetailsListNew extends StatefulWidget {
  final List<VehicleDetailsImports> vehicleDetailsList;
  final Future<VehicleDetailsImports?> Function() validateAndNavigate;
  final bool isExport;

  AddVehicleDetailsListNew({
    super.key,
    required this.vehicleDetailsList,
    required this.validateAndNavigate,
    required this.isExport,
  });

  @override
  _AddVehicleDetailsListNew createState() => _AddVehicleDetailsListNew();
}

class _AddVehicleDetailsListNew extends State<AddVehicleDetailsListNew> {
  List<bool> expanded = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.vehicleDetailsList.length, (index) => false);
    print("-----${widget.vehicleDetailsList.length}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vehicleDetailsList.isEmpty) {
      return _buildEmptyShipmentDetails();
    } else {
      return _buildShipmentDetailsList();
    }
  }

  Widget _buildEmptyShipmentDetails() {
    return Container(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.background,
            width: 4.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "VEHICLE DETAILS",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.textColorPrimary,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await widget.validateAndNavigate();
                      if (result != null) {
                        setState(() {
                          widget.vehicleDetailsList.add(result);
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        size: 28,
                        Icons.add,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Total Count  ",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: AppColors.textColorSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.containerBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("0"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Method to build the widget when shipmentDetailsList is not empty
  Widget _buildShipmentDetailsList() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        Column(
          children: [
            Container(
              padding:
              const EdgeInsets.only(left: 12.0, right: 12.0, top: 14.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                  bottomRight: (!isExpanded)
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                border: const Border(
                  bottom: BorderSide(
                    color: AppColors.background,
                    width: 4.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "VEHICLE DETAILS",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.textColorPrimary,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              int maxItems =
                                  int.tryParse(noOfVehiclesController.text) ??
                                      1;
                              if (isFTlAndOneShipment &&
                                  vehicleListImports.length >= maxItems) {
                                CustomSnackBar.show(context, message: "Only $maxItems Vehicle is Allowed");
                                return;
                              } else if (!isFTlAndOneShipment &&
                                  vehicleListImports.isNotEmpty) {
                                CustomSnackBar.show(context, message: "Only 1 Vehicle is Allowed");
                                return;
                              } else {
                                final result =
                                await widget.validateAndNavigate();
                                if (result != null) {
                                  setState(() {
                                    widget.vehicleDetailsList.add(result);
                                  });
                                }
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Icon(
                                size: 28,
                                Icons.add,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.gradient1,
                              ),
                              child: Icon(
                                size: 28,
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "Total Count  ",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColorSecondary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.containerBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:
                          Text(widget.vehicleDetailsList.length.toString()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            if (isExpanded)
              SizedBox(
                child: VehicleItemNew(
                  vehicleDetailsList: vehicleListImports,
                  IsExport: widget.isExport,
                ),
              ),
          ],
        )
      ],
    );
  }
}

class VehicleItemNew extends StatefulWidget {
  final List<VehicleDetailsImports> vehicleDetailsList;
  final IsExport;

  const VehicleItemNew(
      {super.key, required this.vehicleDetailsList, this.IsExport});

  @override
  _VehicleItemNewState createState() => _VehicleItemNewState();
}

class _VehicleItemNewState extends State<VehicleItemNew> {
  List<bool> expanded = [];
  String? fileName;
  String? fileSize;
  final AuthService authService = AuthService();
  final TextEditingController docNameController = TextEditingController();
  final TextEditingController docRemarkController = TextEditingController();

  File? pickedFile;
  Uint8List? fileBytes;

  Future<void> _pickFile(
      setState, VehicleDetailsImports vehicleDetails, String docType) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String filePath = result.files.single.path!;
      File file2 = File(filePath);
      print("________$file2");
      if (file.extension == 'png' && file.size <= 2 * 1024 * 1024) {
        setState(() {
          fileName = file.name;
          print(fileName);
          fileBytes = result.files.single.bytes;
          pickedFile = File(result.files.single.path!);
          fileSize = '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB';
        });
      } else {
        setState(() {
          fileName = 'Invalid file. Please upload a PNG less than 2 MB.';
          fileSize = null;
        });
      }
      Upload(file2, vehicleDetails, fileName!, docType);
    } else {
      // User canceled the picker
    }
  }

  Future<void> Upload(File file, VehicleDetailsImports vehicleDetails, String fileName,
      String docType) async {
    await Future.delayed(const Duration(seconds: 2));
    var headers = {
      'Accept': 'text/plain',
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${loginMaster[0].token}',
    };
    try {
      final response = await authService.uploadFile(
        headers: headers,
        endPoint: "api/ReturnRootPath/Upload",
        file: file,
      );

      if (response.body.isNotEmpty) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        print(jsonData);
        // docDetails ??= DrivingLicense();
        // setState(() {
        //   docDetails?.filePath = jsonData["message"];
        //   docDetails?.documentPhysicalFileName = fileName;
        //   docDetails?.remark = docRemarkController.text;
        //   docDetails?.documentName = docNameController.text;
        //   docDetails?.documentType = docType;
        //   if (docType == "RC UPLOAD") {
        //     docDetails?.documentTyepId = 145;
        //   } else {
        //     docDetails?.documentTyepId = 144;
        //   }
        //   print("DocType");

        DrivingLicense document = DrivingLicense()
          ..filePath = jsonData["message"]
          ..documentPhysicalFileName = fileName
          ..remark = docRemarkController.text
          ..documentName =fileName
          ..documentType = docType
          ..documentTyepId = (docType == "RC UPLOAD") ? 145 : 144;

        setState(() {
          if (docType == "RC UPLOAD") {
            vehicleDetails.rcScanned = document;
          } else {
            vehicleDetails.drivingLicense = document;
          }

          print("Document uploaded for: $docType");
        });
      } else {
        print("Response is empty");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {});
    }
  }

  void showUploadRCSheet(
      BuildContext context, VehicleDetailsImports vehicleDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // List<String> selectedFilters = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Registration Certificate',
                              style: TextStyle(
                                  color: AppColors.textColorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: docNameController,
                                  labelText: 'Document Name',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: docRemarkController,
                                  labelText: 'Remark',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height: 45,
                                      child: fileSize != null
                                          ? const Text(
                                        "File Format & Size :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors
                                                .textColorSecondary),
                                      )
                                          : const Text(""),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 45,
                                      child: fileSize != null
                                          ? Text(
                                        "PNG & $fileSize",
                                        style: const TextStyle(
                                            color: AppColors
                                                .textColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                          : const Text(""),
                                    ),
                                  ],
                                ),
                                fileName != null
                                    ? Text(
                                  " $fileName",
                                  style: const TextStyle(
                                      color: AppColors.textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                                    : const Text(""),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickFile(setState, vehicleDetails,
                                    "RC UPLOAD");
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.upload_outlined,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    ' Upload File',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        fileName = null;
        fileSize = null;
      });
    });
  }

  void showUploadDLSheet(
      BuildContext context, VehicleDetailsImports vehicleDetails) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // List<String> selectedFilters = [];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 400,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text(
                              'Driving License',
                              style: TextStyle(
                                  color: AppColors.textColorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                CustomTextField(
                                  controller: docNameController,
                                  labelText: 'Document Name',
                                  isValidationRequired: false,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextField(
                                  controller: docRemarkController,
                                  labelText: 'Remark',
                                  isValidationRequired: false,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.32,
                                      height: 45,
                                      child: fileSize != null
                                          ? const Text(
                                        "File Format & Size :",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors
                                                .textColorSecondary),
                                      )
                                          : const Text(""),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.42,
                                      height: 45,
                                      child: fileSize != null
                                          ? Text(
                                        "PNG & $fileSize",
                                        style: const TextStyle(
                                            color: AppColors
                                                .textColorPrimary,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700),
                                      )
                                          : const Text(""),
                                    ),
                                  ],
                                ),
                                fileName != null
                                    ? Text(
                                  " $fileName",
                                  style: const TextStyle(
                                      color: AppColors.textColorPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                )
                                    : const Text(""),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                _pickFile(setState,
                                    vehicleDetails, "DL UPLOAD");
                              },
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.upload_outlined,
                                    color: AppColors.primary,
                                  ),
                                  Text(
                                    ' Upload File',
                                    style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          color: AppColors.textColorSecondary,
                          height: 1,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.42,
                              height: 45,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Save",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      setState(() {
        fileName = null;
        fileSize = null;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    expanded =
        List.generate(widget.vehicleDetailsList.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    if (expanded.length != widget.vehicleDetailsList.length) {
      expanded =
          List.generate(widget.vehicleDetailsList.length, (index) => false);
    }
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 2),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.vehicleDetailsList.length,
      itemBuilder: (BuildContext context, int index) {
        var vehicleDetails = widget.vehicleDetailsList[index];
        print(
            "${vehicleDetails.truckNo}-PM--${vehicleDetails.vehicleTypeId}");

        return Column(
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Vehicle No.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                vehicleDetails.truckNo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColorPrimary,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.12,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Slot Date/Time",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textColorSecondary,
                                ),
                              ),
                              Text(
                                vehicleDetails.slotViewDateTime,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textColorPrimary,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddVehicleDetailsImports(
                                          vehicleDetails: vehicleDetails),
                                    ),
                                  ).then((updateVehicle) {
                                    if (updateVehicle != null) {
                                      setState(() {
                                        widget.vehicleDetailsList[index] =
                                            updateVehicle;
                                        // expanded =
                                        //     List.generate(widget.vehicleDetailsList.length, (index) => false);
                                      });
                                    }
                                  });
                                },
                                child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(Icons.edit,
                                        size: 28, color: AppColors.primary)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    expanded[index] = !expanded[index];
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppColors.gradient1,
                                  ),
                                  child: Icon(
                                    size: 28,
                                    expanded[index]
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showUploadRCSheet(context, vehicleDetails);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                      right: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                        Icons.account_box_outlined,
                                        size: 28,
                                        color: AppColors.primary)),
                                const Text(
                                  "Reg. Cert.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          GestureDetector(
                            onTap: () {
                              showUploadDLSheet(context, vehicleDetails);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Icon(
                                        Icons.account_box_outlined,
                                        size: 28,
                                        color: AppColors.primary)),
                                const Text(
                                  "DL",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                print("${vehicleDetails.vehicleId}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddBookSlot(
                                      isExport: widget.IsExport,
                                      vehicleDetails: vehicleDetails,
                                    ),
                                  ),
                                ).then((updateVehicle) {
                                  if (updateVehicle != null) {
                                    setState(() {
                                      widget.vehicleDetailsList[index] =
                                          updateVehicle;
                                      print("View Date is" +
                                          widget.vehicleDetailsList[index]
                                              .slotViewDateTime);
                                    });
                                  }
                                });
                                ;
                              },
                              child: const Text(
                                "Book Slot",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (expanded[index])
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShipmentInfoRow(
                      header1: "Type of Vehicle",
                      value1: vehicleDetails.vehicleTypeName,
                      header2: "Driving License No.",
                      value2: vehicleDetails.drivingLicenseNo,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Driver DOB",
                      value1: vehicleDetails.driverDob,
                      header2: "Driver Name",
                      value2: vehicleDetails.driverName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ShipmentInfoRow(
                      header1: "Driver Mob No.",
                      value1: vehicleDetails.driverContact,
                      header2: "Remark/Chassis No.",
                      value2: vehicleDetails.remarksChassisNo,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
