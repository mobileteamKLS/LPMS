import 'package:intl/intl.dart';

import '../util/Global.dart';

class SlotBookingCreationExport {
  int bookingId;
  List<String> vehicleType;
  String? bookingDt;
  int noofVehicle;
  bool isFtl;
  bool isLtl;
  String origin;
  String destination;
  dynamic hsnCode;
  dynamic cargoValue;
  List<ShipmentDetailsExports> shipmentDetailsList;
  List<VehicleDetailsExports> vehicalDetailsList;
  String chaName;
  int chaId;
  dynamic unitOfQt;
  dynamic portOfDest;
  dynamic grossQt;
  int orgProdId;
  int userId;
  String branchCode;
  String companyCode;
  int airportId;
  String paCompanyCode;
  int screenId;
  int adminOrgProdId;
  int orgId;

  SlotBookingCreationExport({
    required this.bookingId,
    required this.vehicleType,
    required this.bookingDt,
    required this.noofVehicle,
    required this.isFtl,
    required this.isLtl,
    required this.origin,
    required this.destination,
    required this.hsnCode,
    required this.cargoValue,
    required this.shipmentDetailsList,
    required this.vehicalDetailsList,
    required this.chaName,
    required this.chaId,
    required this.unitOfQt,
    required this.portOfDest,
    required this.grossQt,
    required this.orgProdId,
    required this.userId,
    required this.branchCode,
    required this.companyCode,
    required this.airportId,
    required this.paCompanyCode,
    required this.screenId,
    required this.adminOrgProdId,
    required this.orgId,
  });

  factory SlotBookingCreationExport.fromMap(Map<String, dynamic> json) =>
      SlotBookingCreationExport(
        bookingId: json["BookingId"],
        vehicleType: List<String>.from(json["VehicleType"].map((x) => x)),
        bookingDt: json["BookingDt"],
        noofVehicle: json["NoofVehicle"],
        isFtl: json["IsFTL"],
        isLtl: json["IsLTL"],
        origin: json["Origin"],
        destination: json["Destination"],
        hsnCode: json["HSNCode"],
        cargoValue: json["CargoValue"],
        shipmentDetailsList: List<ShipmentDetailsExports>.from(
            json["ShipmentDetailsList"]
                .map((x) => ShipmentDetailsExports.fromJson(x))),
        vehicalDetailsList: List<VehicleDetailsExports>.from(
            json["VehicalDetailsList"]
                .map((x) => VehicleDetailsExports.fromJson(x))),
        chaName: json["ChaName"],
        chaId: json["CHAId"],
        unitOfQt: json["UnitOfQt"],
        portOfDest: json["PortOfDest"],
        grossQt: json["GrossQt"],
        orgProdId: json["OrgProdId"],
        userId: json["UserId"],
        branchCode: json["BranchCode"],
        companyCode: json["CompanyCode"],
        airportId: json["AirportId"],
        paCompanyCode: json["PACompanyCode"],
        screenId: json["ScreenId"],
        adminOrgProdId: json["Admin_OrgProdId"],
        orgId: json["OrgId"],
      );

  Map<String, dynamic> toJson() => {
        "BookingId": bookingId,
        "VehicleType": List<dynamic>.from(vehicleType.map((x) => x)),
        "BookingDt": bookingDt,
        "NoofVehicle": noofVehicle,
        "IsFTL": isFtl,
        "IsLTL": isLtl,
        "Origin": origin,
        "Destination": destination,
        "HSNCode": hsnCode,
        "CargoValue": cargoValue,
        "ShipmentDetailsList":
            List<dynamic>.from(shipmentDetailsList.map((x) => x.toJson())),
        "VehicalDetailsList":
            List<dynamic>.from(vehicalDetailsList.map((x) => x.toJson())),
        "ChaName": chaName,
        "CHAId": chaId,
        "UnitOfQt": unitOfQt,
        "PortOfDest": portOfDest,
        "GrossQt": grossQt,
        "OrgProdId": orgProdId,
        "UserId": userId,
        "BranchCode": branchCode,
        "CompanyCode": companyCode,
        "AirportId": airportId,
        "PACompanyCode": paCompanyCode,
        "ScreenId": screenId,
        "Admin_OrgProdId": adminOrgProdId,
        "OrgId": orgId,
      };

  @override
  String toString() {
    return 'SlotBookingCreationExport('
        'bookingId: $bookingId, '
        'vehicleType: $vehicleType, '
        'bookingDt: $bookingDt, '
        'noofVehicle: $noofVehicle, '
        'isFtl: $isFtl, '
        'isLtl: $isLtl, '
        'origin: $origin, '
        'destination: $destination, '
        'hsnCode: $hsnCode, '
        'cargoValue: $cargoValue, '
        'shipmentDetailsList: $shipmentDetailsList, '
        'vehicalDetailsList: $vehicalDetailsList, '
        'chaName: $chaName, '
        'chaId: $chaId, '
        'unitOfQt: $unitOfQt, '
        'portOfDest: $portOfDest, '
        'grossQt: $grossQt, '
        'orgProdId: $orgProdId, '
        'userId: $userId, '
        'branchCode: $branchCode, '
        'companyCode: $companyCode, '
        'airportId: $airportId, '
        'paCompanyCode: $paCompanyCode, '
        'screenId: $screenId, '
        'adminOrgProdId: $adminOrgProdId, '
        'orgId: $orgId'
        ')';
  }
}

class SlotBookingCreationImport {
  int bookingId;
  List<String> vehicleType;
  dynamic bookingDt;
  int noofVehicle;
  bool isFtl;
  bool isLtl;
  String origin;
  String destination;
  dynamic hsnCode;
  dynamic cargoValue;
  List<ShipmentDetailsImports> impBoeDetails;
  List<VehicleDetailsImports> impVehicleDetails;
  String chaName;
  String chaId;
  bool isYes;
  bool isNo;
  int orgProdId;
  int userId;
  String branchCode;
  String companyCode;
  int airportId;
  int landportAirportId;
  String paCompanyCode;
  int screenId;
  int adminOrgProdId;
  int orgId;
  String eventCode;
  int directImportId;

  SlotBookingCreationImport({
    required this.bookingId,
    required this.vehicleType,
    required this.bookingDt,
    required this.noofVehicle,
    required this.isFtl,
    required this.isLtl,
    required this.origin,
    required this.destination,
    required this.hsnCode,
    required this.cargoValue,
    required this.impBoeDetails,
    required this.impVehicleDetails,
    required this.chaName,
    required this.chaId,
    required this.isYes,
    required this.isNo,
    required this.orgProdId,
    required this.userId,
    required this.branchCode,
    required this.companyCode,
    required this.airportId,
    required this.landportAirportId,
    required this.paCompanyCode,
    required this.screenId,
    required this.adminOrgProdId,
    required this.orgId,
    required this.eventCode,
    required this.directImportId,
  });

  factory SlotBookingCreationImport.fromMap(Map<String, dynamic> json) => SlotBookingCreationImport(
    bookingId: json["BookingId"],
    vehicleType: List<String>.from(json["VehicleType"].map((x) => x)),
    bookingDt: json["BookingDt"],
    noofVehicle: json["NoofVehicle"],
    isFtl: json["IsFTL"],
    isLtl: json["IsLTL"],
    origin: json["Origin"],
    destination: json["Destination"],
    hsnCode: json["HSNCode"],
    cargoValue: json["CargoValue"],
    impBoeDetails: List<ShipmentDetailsImports>.from(json["ImpBOEDetails"].map((x) => ShipmentDetailsImports.fromJson(x))),
    impVehicleDetails: List<VehicleDetailsImports>.from(json["ImpVehicleDetails"].map((x) => VehicleDetailsImports.fromJson(x))),
    chaName: json["ChaName"],
    chaId: json["CHAId"],
    isYes: json["IsYes"],
    isNo: json["IsNo"],
    orgProdId: json["OrgProdId"],
    userId: json["UserId"],
    branchCode: json["BranchCode"],
    companyCode: json["CompanyCode"],
    airportId: json["AirportId"],
    landportAirportId: json["LandportAirportId"],
    paCompanyCode: json["PACompanyCode"],
    screenId: json["ScreenId"],
    adminOrgProdId: json["Admin_OrgProdId"],
    orgId: json["OrgId"],
    eventCode: json["EventCode"],
    directImportId: json["DirectImportId"],
  );

  Map<String, dynamic> toJson() => {
    "BookingId": bookingId,
    "VehicleType": List<dynamic>.from(vehicleType.map((x) => x)),
    "BookingDt": bookingDt,
    "NoofVehicle": noofVehicle,
    "IsFTL": isFtl,
    "IsLTL": isLtl,
    "Origin": origin,
    "Destination": destination,
    "HSNCode": hsnCode,
    "CargoValue": cargoValue,
    "ImpBOEDetails": List<dynamic>.from(impBoeDetails.map((x) => x.toJson())),
    "ImpVehicleDetails": List<dynamic>.from(impVehicleDetails.map((x) => x.toJson())),
    "ChaName": chaName,
    "CHAId": chaId,
    "IsYes": isYes,
    "IsNo": isNo,
    "OrgProdId": orgProdId,
    "UserId": userId,
    "BranchCode": branchCode,
    "CompanyCode": companyCode,
    "AirportId": airportId,
    "LandportAirportId": landportAirportId,
    "PACompanyCode": paCompanyCode,
    "ScreenId": screenId,
    "Admin_OrgProdId": adminOrgProdId,
    "OrgId": orgId,
    "EventCode": eventCode,
    "DirectImportId": directImportId,
  };
}


class SlotBookingShipmentListingExport {
  int bookingId;
  String bookingDt;
  String bookingNo;
  String sBillNo;
  String sBillDt;
  String exporterImporter;
  int cargoTypeId;
  String cargoTypeName;
  String statusDescription;

  SlotBookingShipmentListingExport({
    required this.bookingId,
    required this.bookingDt,
    required this.bookingNo,
    required this.sBillNo,
    required this.sBillDt,
    required this.exporterImporter,
    required this.cargoTypeId,
    required this.cargoTypeName,
    required this.statusDescription,
  });

  factory SlotBookingShipmentListingExport.fromJSON(
          Map<String, dynamic> json) =>
      SlotBookingShipmentListingExport(
        bookingId: json["BookingId"] ?? 0,
        bookingDt: json["BookingDt"] ?? "",
        bookingNo: json["BookingNo"] ?? "",
        sBillNo: json["SBillNo"] ?? "",
        sBillDt: json["SBillDt"] ?? "",
        exporterImporter: json["Exporter_Importer"] ?? "",
        cargoTypeId: json["CargoTypeId"] ?? 0,
        cargoTypeName: json["CargoTypeName"] ?? "",
        statusDescription: (json["StatusDescription"] ?? "").toUpperCase(),
      );

  Map<String, dynamic> toMap() => {
        "BookingId": bookingId,
        "BookingDt": bookingDt,
        "BookingNo": bookingNo,
        "SBillNo": sBillNo,
        "SBillDt": sBillDt,
        "Exporter_Importer": exporterImporter,
        "CargoTypeId": cargoTypeId,
        "CargoTypeName": cargoTypeName,
        "StatusDescription": statusDescription,
      };
}

class SlotBookingShipmentListingImport {
  String boeDt;
  String boeNo;
  String bookingDt;
  int bookingId;
  String bookingNo;
  int cargoTypeId;
  String cargoTypeName;
  String exporterImporter;
  String statusDescription;

  SlotBookingShipmentListingImport({
    required this.boeDt,
    required this.boeNo,
    required this.bookingDt,
    required this.bookingId,
    required this.bookingNo,
    required this.cargoTypeId,
    required this.cargoTypeName,
    required this.exporterImporter,
    required this.statusDescription,
  });

  factory SlotBookingShipmentListingImport.fromJSON(
          Map<String, dynamic> json) =>
      SlotBookingShipmentListingImport(
        boeDt: json["BOEDt"] ?? "",
        boeNo: json["BOENo"] ?? "",
        bookingDt: json["BookingDt"] ?? "",
        bookingId: json["BookingId"] ?? 0,
        bookingNo: json["BookingNo"] ?? "",
        cargoTypeId: json["CargoTypeId"] ?? 0,
        cargoTypeName: json["CargoTypeName"] ?? "",
        exporterImporter: json["Exporter_Importer"] ?? "",
        statusDescription: (json["StatusDescription"] ?? "").toUpperCase(),
      );

  Map<String, dynamic> toMap() => {
        "BOEDt": boeDt,
        "BOENo": boeNo,
        "BookingDt": bookingDt,
        "BookingId": bookingId,
        "BookingNo": bookingNo,
        "CargoTypeId": cargoTypeId,
        "CargoTypeName": cargoTypeName,
        "Exporter_Importer": exporterImporter,
        "StatusDescription": statusDescription,
      };
}

class ShipmentDetailsExports {
  int detailsId;
  String cargoDescription;
  int cargoTypeId;
  String cargoType;
  dynamic cargoWeight;
  String chaName;
  String nameOfExporterImporter;
  int quantity;
  String shippingBillNoIgmNno;
  String shippingBillDateIgm;
  String? typeOfGoods;
  String hsnCode;
  dynamic cargoValue;
  int exporterId;
  String? unitOfQt;
  String? portOfDest;
  String? grossQt;
  bool isUliPverified;

  ShipmentDetailsExports({
    this.detailsId = 0,
    required this.cargoDescription,
    required this.cargoTypeId,
    this.cargoType = "",
    required this.cargoWeight,
    required this.chaName,
    required this.nameOfExporterImporter,
    required this.quantity,
    required this.shippingBillNoIgmNno,
    required this.shippingBillDateIgm,
    required this.typeOfGoods,
    required this.hsnCode,
    required this.cargoValue,
    required this.exporterId,
    required this.unitOfQt,
    required this.portOfDest,
    required this.grossQt,
    required this.isUliPverified,
  });

  factory ShipmentDetailsExports.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailsExports(
        detailsId: json["DetailsId"],
        cargoDescription: json["CargoDescription"],
        cargoTypeId: json["CargoTypeId"],
        cargoWeight: json["CargoWeight"],
        chaName: json["ChaName"],
        nameOfExporterImporter: json["NameOfExporterImporter"],
        quantity: json["Quantity"],
        shippingBillNoIgmNno: json["ShippingBillNoIGMNno"],
        shippingBillDateIgm:DateFormat('dd MMM yyyy').format(DateTime.parse(json["ShippingBillDateIGM"])) ,
        typeOfGoods: json["TypeOfGoods"],
        hsnCode: json["HSNCode"],
        cargoValue: json["CargoValue"],
        exporterId: json["ExporterId"],
        unitOfQt: json["UnitOfQt"],
        portOfDest: json["PortOfDest"],
        grossQt: json["GrossQt"],
        isUliPverified: json["IsULIPverified"],
        cargoType: (cargoTypeList.firstWhere((cargo) => cargo.value == json["CargoTypeId"].toString())).nameDisplay
      );

  Map<String, dynamic> toJson() => {
        "DetailsId": detailsId,
        "CargoDescription": cargoDescription,
        "CargoTypeId": cargoTypeId.toString(),
        "CargoWeight": cargoWeight,
        "ChaName": chaName,
        "NameOfExporterImporter": nameOfExporterImporter,
        "Quantity": quantity,
        "ShippingBillNoIGMNno": shippingBillNoIgmNno,
        "ShippingBillDateIGM":DateFormat('d MMM yyyy').parse(shippingBillDateIgm).toIso8601String() ,
        "TypeOfGoods": typeOfGoods,
        "HSNCode": hsnCode,
        "CargoValue": cargoValue,
        "ExporterId": exporterId,
        "UnitOfQt": unitOfQt,
        "PortOfDest": portOfDest,
        "GrossQt": grossQt,
        "IsULIPverified": isUliPverified,
      };
}

class ShipmentDetailsImports {
  int detailsId;
  String cargoDescription;
  int cargoTypeId;
  String cargoType;
  dynamic cargoWeight;
  String chaName;
  String nameOfExporterImporter;
  int quantity;
  String boeNo;
  String boeDt;
  String? typeOfGoods;
  String hsnCode;
  dynamic cargoValue;
  int importerId;
  String? unitOfQt;
  String? grossWt;
  String? countryOrig;
  bool isUliPverified;
  int? whRequestId;
  int? bookingId;
  String? portOfDest;

  ShipmentDetailsImports({
    this.detailsId = 0,
    required this.cargoDescription,
    required this.cargoTypeId,
    this.cargoType = "",
    required this.cargoWeight,
    required this.chaName,
    required this.nameOfExporterImporter,
    required this.quantity,
    required this.boeNo,
    required this.boeDt,
    required this.typeOfGoods,
    required this.hsnCode,
    required this.cargoValue,
    required this.importerId,
    required this.unitOfQt,
    required this.portOfDest,
    required this.grossWt,
    required this.countryOrig,
    required this.whRequestId,
    required this.bookingId,
    required this.isUliPverified,
  });

  factory ShipmentDetailsImports.fromJson(Map<String, dynamic> json) =>
      ShipmentDetailsImports(
        detailsId: json["DetailsId"],
        cargoDescription: json["CargoDescription"],
        cargoTypeId: json["CargoTypeId"],
        cargoWeight: json["CargoWeight"],
        chaName: json["ChaName"],
        nameOfExporterImporter: json["NameOfExporterImporter"],
        quantity: json["Quantity"],
        boeNo: json["BOENo"],
        boeDt: DateFormat('dd MMM yyyy').format(DateTime.parse(json["BOEDt"])),
        typeOfGoods: json["TypeOfGoods"],
        hsnCode: json["HSNCode"],
        cargoValue: json["CargoValue"],
        importerId: json["ImporterId"],
        unitOfQt: json["UnitOfQt"],
        portOfDest: json["PortOfDest"],
        grossWt: json["GrossWt"],
        countryOrig: json["CountryOrig"],
        whRequestId: json["WHRequestId"],
        bookingId: json["BookingId"],
        isUliPverified: json["IsULIPverified"],
        cargoType: (cargoTypeList.firstWhere((cargo) => cargo.value == json["CargoTypeId"].toString())).nameDisplay,
      );

  Map<String, dynamic> toJson() => {
        "DetailsId": detailsId.toString(),
        "CargoDescription": cargoDescription,
        "CargoTypeId": cargoTypeId.toString(),
        "CargoWeight": cargoWeight,
        "ChaName": chaName,
        "NameOfExporterImporter": nameOfExporterImporter,
        "Quantity": quantity,
        "BOENo": boeNo,
        "BOEDt": DateFormat('d MMM yyyy').parse(boeDt).toIso8601String(),
        "TypeOfGoods": typeOfGoods,
        "HSNCode": hsnCode,
        "CargoValue": cargoValue,
        "ImporterId": importerId,
        "UnitOfQt": unitOfQt,
        "PortOfDest": portOfDest,
        "GrossWt": grossWt,
        "CountryOrig": countryOrig,
        "WHRequestId": grossWt??0,
        "BookingId": bookingId,
        "IsULIPverified": isUliPverified,
      };
}

class VehicleDetailsExports {
  int vehicleId;
  String vehicleTypeName;
  String? driverAadhaar;
  String driverContact;
  String? driverDob;
  String driverName;
  String drivingLicenseNo;
  String? slotDateTime;
  String? bookedTimeSlot;
  String slotViewDateTime;
  String truckNo;
  int? vehicleTypeId;
  int? slotConfigId;
  int? slotDurationId;
  String? slotStartTime;
  String? slotEndTime;
  DrivingLicense? drivingLicense;
  RcDetails? rcScanned;
  bool? isModifySlot;
  bool? isNewSlot;
  String remarksChassisNo;
  bool? isGateIn;
  String? registrationDate;
  String? grossWt;
  String? tareWt;
  String? netWt;
  String? isvehicleVerified;
  String? isDriverVerified;

  VehicleDetailsExports({
    this.vehicleId = 0,
    this.vehicleTypeName = "",
    this.driverAadhaar,
    required this.driverContact,
    required this.driverDob,
    required this.driverName,
    required this.drivingLicenseNo,
    this.slotDateTime = "",
    this.bookedTimeSlot = "",
    this.slotViewDateTime = "",
    required this.truckNo,
    required this.vehicleTypeId,
    this.slotConfigId ,
    this.slotDurationId,
    this.slotStartTime ,
    this.slotEndTime,
    this.drivingLicense,
    this.rcScanned,
    this.isModifySlot = false,
    this.isNewSlot = true,
    required this.remarksChassisNo,
    this.isGateIn = true,
    this.registrationDate=null,
    this.grossWt=null ,
    this.tareWt=null,
    this.netWt =null,
    this.isvehicleVerified=null,
    this.isDriverVerified =null,
  });
  // : drivingLicense = drivingLicense ?? DrivingLicense(),
  //   // Assign default DrivingLicense if null
  //   rcScanned = rcScanned ?? DrivingLicense();

  factory VehicleDetailsExports.fromJson(Map<String, dynamic> json){

    print("RCScanned JSON: ${json["RCScanned"]}");
    if(json["DrivingLicense"] != null){
      print("Driving License JSON: ${DrivingLicense.fromJson(json["DrivingLicense"])}");
    }
   return VehicleDetailsExports(
      vehicleId: json["VehicleId"],
      driverAadhaar: json["DriverAadhaar"],
      driverContact: json["DriverContact"],
      driverDob: DateFormat('dd MMM yyyy').format(DateTime.parse(json["DriverDOB"])),
      driverName: json["DriverName"],
      drivingLicenseNo: json["DrivingLicenseNo"],
      slotDateTime: json["SlotDateTime"],
      bookedTimeSlot: json["BookedTimeSlot"],
      truckNo: json["TruckNo"],
      vehicleTypeId: json["VehicleType"],
      slotConfigId: json["SlotConfigId"],
      slotDurationId: json["SlotDurationId"],
      slotStartTime: json["SlotStartTime"],
      slotEndTime: json["SlotEndTime"],
      drivingLicense: json["DrivingLicense"] != null
          ? DrivingLicense.fromJson(json["DrivingLicense"])
          : null,
      rcScanned: json['RCScanned'] != null
          ? RcDetails.fromJson(json['RCScanned'])
          : null,
      isModifySlot: json["IsModifySlot"],
      isNewSlot: json["IsNewSlot"],
      remarksChassisNo: json["RemarksChassisNo"],
      isGateIn: json["IsGateIn"],
      registrationDate: json["RegistrationDate"],
      grossWt: json["GrossWt"],
      tareWt: json["TareWt"],
      netWt: json["NetWt"],
      isvehicleVerified: json["IsvehicleVerified"],
      isDriverVerified: json["IsDriverVerified"],
       vehicleTypeName:(vehicleTypeList.firstWhere((v) => v.value == json["VehicleType"].toString(),)).description,//json["VehicleType"]==42?"Truck":"AUTO"
      slotViewDateTime:
          "${DateFormat('dd MMM yyyy').format(DateTime.parse(json['SlotDateTime']))}\n${json['BookedTimeSlot']}",
    );
  }


  Map<String, dynamic> toJson() => {
    "VehicleId": vehicleId,
    "DriverAadhaar": driverAadhaar,
    "DriverContact": driverContact,
    "DriverDOB":(driverDob != null && driverDob!.isNotEmpty)
        ? DateFormat('d MMM yyyy').parse(driverDob!).toIso8601String()
        : null,
    "DriverName": driverName,
    "DrivingLicenseNo": drivingLicenseNo,
    "SlotDateTime": slotDateTime,
    "TruckNo": truckNo,
    "VehicleType": vehicleTypeId.toString(),
    "SlotConfigId": slotConfigId,
    "SlotDurationId": slotDurationId,
    "SlotStartTime": slotStartTime,
    "SlotEndTime": slotEndTime,
    "DrivingLicense": drivingLicense?.toJson(),
    "RCScanned": rcScanned?.toJson(),
    "IsModifySlot": isModifySlot,
    "IsNewSlot": isNewSlot,
    "RemarksChassisNo": remarksChassisNo,
    "IsGateIn": isGateIn,
    "RegistrationDate": null,
    "GrossWt": null,
    "TareWt": null,
    "NetWt": null,
    "IsvehicleVerified": null,
    "IsDriverVerified": null,
  };

  String? validateDrivingLicense() {
    return drivingLicense == null ? 'Please Upload Driving License Document for vehicle no' : null;
  }

  String? validateRcScanned() {
    return rcScanned == null ? 'Please Upload Registration Certificate Document for vehicle no' : null;
  }

  String validateSlotViewDateTime() {
    return slotViewDateTime.isEmpty ? 'Slot DateTime is required for vehicle no' : "";
  }
}

class VehicleDetailsImports {
  int vehicleId;
  String vehicleTypeName;
  String? driverAadhaar;
  String driverContact;
  String? driverDob;
  String driverName;
  String drivingLicenseNo;
  String? slotDateTime;
  String slotViewDateTime;
  String truckNo;
  int? vehicleTypeId;
  int? slotConfigId;
  int? slotDurationId;
  String? slotStartTime;
  String? slotEndTime;
  DrivingLicense? drivingLicense;
  RcDetails? rcScanned;
  bool? isModifySlot;
  bool? isNewSlot;
  String remarksChassisNo;
  bool? isGateIn;
  String? bookedTimeSlot;
  // String? registrationDate;
  // String? grossWt;
  // String? tareWt;
  // String? netWt;
  // String? isvehicleVerified;
  // String? isDriverVerified;

  VehicleDetailsImports({
    this.vehicleId = 0,
    this.vehicleTypeName = "",
    this.driverAadhaar,
    required this.driverContact,
    required this.driverDob,
    required this.driverName,
    required this.drivingLicenseNo,
    this.slotDateTime,
    this.slotViewDateTime = "",
    this.bookedTimeSlot,
    required this.truckNo,
    required this.vehicleTypeId,
    this.slotConfigId ,
    this.slotDurationId,
    this.slotStartTime ,
    this.slotEndTime,
    DrivingLicense? drivingLicense,
    RcDetails? rcScanned,
    this.isModifySlot = false,
    this.isNewSlot = true,
    required this.remarksChassisNo,
    this.isGateIn = true,
    // this.registrationDate=null,
    // this.grossWt=null ,
    // this.tareWt=null,
    // this.netWt =null,
    // this.isvehicleVerified=null,
    // this.isDriverVerified =null,
  });
      // : drivingLicense = drivingLicense ?? DrivingLicense(),
      //   // Assign default DrivingLicense if null
      //   rcScanned = rcScanned ?? DrivingLicense();

  factory VehicleDetailsImports.fromJson(Map<String, dynamic> json) =>
      VehicleDetailsImports(
        vehicleId: json["VehicleId"],
        driverAadhaar: json["DriverAadhaar"],
        driverContact: json["DriverContact"],
        driverDob: json["DriverDOB"],
        driverName: json["DriverName"],
        drivingLicenseNo: json["DrivingLicenseNo"],
        slotDateTime: json["SlotDateTime"],
        truckNo: json["TruckNo"],
        vehicleTypeId: json["VehicleType"],
        slotConfigId: json["SlotConfigId"],
        slotDurationId: json["SlotDurationId"],
        slotStartTime: json["SlotStartTime"],
        slotEndTime: json["SlotEndTime"],
        drivingLicense: json["DrivingLicense"] != null
            ? DrivingLicense.fromJson(json["DrivingLicense"])
            : null,
        rcScanned: json['RCScanned'] != null
            ? RcDetails.fromJson(json['RCScanned'])
            : null,
        isModifySlot: json["IsModifySlot"],
        isNewSlot: json["IsNewSlot"],
        remarksChassisNo: json["RemarksChassisNo"],
        isGateIn: json["IsGateIn"],
        vehicleTypeName:(vehicleTypeList.firstWhere((v) => v.value == json["VehicleType"].toString(),)).description,
          bookedTimeSlot:json['BookedTimeSlot'],
        slotViewDateTime:"${DateFormat('dd MMM yyyy').format(DateTime.parse(json['SlotDateTime']))}\n${json['BookedTimeSlot']}",
        // registrationDate: json["RegistrationDate"],
        // grossWt: json["GrossWt"],
        // tareWt: json["TareWt"],
        // netWt: json["NetWt"],
        // isvehicleVerified: json["IsvehicleVerified"],
        // isDriverVerified: json["IsDriverVerified"],
      );

  Map<String, dynamic> toJson() => {
        "VehicleId": vehicleId,
        "DriverAadhaar": driverAadhaar,
        "DriverContact": driverContact,
        "DriverDOB":(driverDob != null && driverDob!.isNotEmpty)
            ? DateFormat('d MMM yyyy').parse(driverDob!).toIso8601String()
            : null,
        "DriverName": driverName,
        "DrivingLicenseNo": drivingLicenseNo,
        "SlotDateTime": slotDateTime,
        "TruckNo": truckNo,
        "VehicleType": vehicleTypeId.toString(),
        "SlotConfigId": slotConfigId,
        "SlotDurationId": slotDurationId,
        "SlotStartTime": slotStartTime,
        "SlotEndTime": slotEndTime,
        "DrivingLicense": drivingLicense?.toJson(),
        "RCScanned": rcScanned?.toJson(),
        "IsModifySlot": isModifySlot,
        "IsNewSlot": isNewSlot,
        "RemarksChassisNo": remarksChassisNo,
        "IsGateIn": isGateIn,
        // "RegistrationDate": null,
        // "GrossWt": null,
        // "TareWt": null,
        // "NetWt": null,
        // "IsvehicleVerified": null,
        // "IsDriverVerified": null,
      };

  String? validateDrivingLicense() {
    return drivingLicense == null ? 'Driving License document is required for vehicle no' : null;
  }

  String? validateRcScanned() {
    return rcScanned == null ? 'RC Scanned document is required for vehicle no' : null;
  }

  String validateSlotViewDateTime() {
    return slotViewDateTime.isEmpty ? 'Slot DateTime is required for vehicle no' : "";
  }
}

class DrivingLicense {
  int? bookingId;
  int? vehicleId;
  int? dlDocConfigId;
  String? documentType;
  String? documentName;
  String? remark;
  String? documentPhysicalFileName;
  String? filePath;
  String? documentDescription;
  bool? isFinanicial;
  int? documentTyepId;
  String? documentUploadCriteria;
  String? fileUom;
  int? fileSize;
  int? rcDocConfigId;

  DrivingLicense({
    this.bookingId,
    this.vehicleId = 0,
    this.dlDocConfigId,
    this.documentType = "",
    this.documentName = "",
    this.remark = "",
    this.documentPhysicalFileName = "",
    this.filePath = "",
    this.documentDescription = "",
    this.isFinanicial = false,
    this.documentTyepId = 0,
    this.documentUploadCriteria = "PNG",
    this.fileUom = "MB",
    this.fileSize = 2,
    this.rcDocConfigId,
  });

  factory DrivingLicense.fromJson(Map<String, dynamic> json) => DrivingLicense(
        bookingId: json["BookingId"],
        vehicleId: json["VehicleId"],
        dlDocConfigId: json["DLDocConfigId"],
        documentType: json["DocumentType"],
        documentName: json["DocumentName"],
        remark: json["Remark"],
        documentPhysicalFileName: json["DocumentPhysicalFileName"],
        filePath: json["FilePath"],
        documentDescription: json["DocumentDescription"],
        isFinanicial: json["IsFinanicial"],
        documentTyepId: json["DocumentTyepID"],
        documentUploadCriteria: json["DocumentUploadCriteria"],
        fileUom: json["FileUOM"],
        fileSize: json["FileSize"],
      );

  Map<String, dynamic> toJson() => {
        // "BookingId": bookingId,
        // "VehicleId": vehicleId,
        // "DLDocConfigId": dlDocConfigId,
        "DocumentType": documentType,
        "DocumentName": documentName,
        "Remark": remark,
        "DocumentPhysicalFileName": documentPhysicalFileName,
        "FilePath": filePath,
        "DocumentDescription": documentDescription,
        // "IsFinanicial": isFinanicial,
        "DocumentTyepID": documentTyepId,
        // "DocumentUploadCriteria": documentUploadCriteria,
        // "FileUOM": fileUom,
        // "FileSize": fileSize,
        // "RCDocConfigId": rcDocConfigId,
      };
  @override
  String toString() {
    return 'DrivingLicense('
        'bookingId: $bookingId, '
        'vehicleId: $vehicleId, '
        'dlDocConfigId: $dlDocConfigId, '
        'documentType: $documentType, '
        'documentName: $documentName, '
        'remark: $remark, '
        'documentPhysicalFileName: $documentPhysicalFileName, '
        'filePath: $filePath, '
        'documentDescription: $documentDescription, '
        'isFinanicial: $isFinanicial, '
        'documentTyepId: $documentTyepId, '
        'documentUploadCriteria: $documentUploadCriteria, '
        'fileUom: $fileUom, '
        'fileSize: $fileSize, '
        'rcDocConfigId: $rcDocConfigId'
        ')';
  }


}
class RcDetails {
  int? bookingId;
  int? vehicleId;
  String? documentType;
  String? documentName;
  String? remark;
  String? documentPhysicalFileName;
  String? filePath;
  String? documentDescription;
  bool? isFinanicial;
  int? documentTyepId;
  String? documentUploadCriteria;
  String? fileUom;
  int? fileSize;
  int? rcDocConfigId;

  RcDetails({
    this.bookingId,
    this.vehicleId = 0,
    this.documentType = "",
    this.documentName = "",
    this.remark = "",
    this.documentPhysicalFileName = "",
    this.filePath = "",
    this.documentDescription = "",
    this.isFinanicial = false,
    this.documentTyepId = 0,
    this.documentUploadCriteria = "PNG",
    this.fileUom = "MB",
    this.fileSize = 2,
    this.rcDocConfigId,
  });

  factory RcDetails.fromJson(Map<String, dynamic> json) => RcDetails(
        bookingId: json["BookingId"],
        vehicleId: json["VehicleId"],
        documentType: json["DocumentType"],
        documentName: json["DocumentName"],
        remark: json["Remark"],
        documentPhysicalFileName: json["DocumentPhysicalFileName"],
        filePath: json["FilePath"],
        documentDescription: json["DocumentDescription"],
        isFinanicial: json["IsFinanicial"],
        documentTyepId: json["DocumentTyepID"],
        documentUploadCriteria: json["DocumentUploadCriteria"],
        fileUom: json["FileUOM"],
        fileSize: json["FileSize"],
        rcDocConfigId: json["RCDocConfigId"],
      );

  Map<String, dynamic> toJson() => {
        // "BookingId": bookingId,
        // "VehicleId": vehicleId,
        "DocumentType": documentType,
        "DocumentName": documentName,
        "Remark": remark,
        "DocumentPhysicalFileName": documentPhysicalFileName,
        "FilePath": filePath,
        "DocumentDescription": documentDescription,
        // "IsFinanicial": isFinanicial,
        "DocumentTyepID": documentTyepId,
        // "DocumentUploadCriteria": documentUploadCriteria,
        // "FileUOM": fileUom,
        // "FileSize": fileSize,
        // "RCDocConfigId": rcDocConfigId,
      };
}



class SlotDetails {
  dynamic assignDockId;
  int availableSlots;
  String bookedTimeSlot;
  String slotConfigId;
  String slotDurationId;
  String slotEndDateTime;
  String slotStartDateTime;

  SlotDetails({
    required this.assignDockId,
    required this.availableSlots,
    required this.bookedTimeSlot,
    required this.slotConfigId,
    required this.slotDurationId,
    required this.slotEndDateTime,
    required this.slotStartDateTime,
  });

  factory SlotDetails.fromJSON(Map<String, dynamic> json) => SlotDetails(
        assignDockId: json["AssignDockId"] ?? "",
        availableSlots: json["AvailableSlots"] ?? "",
        bookedTimeSlot: json["BookedTimeSlot"] ?? "",
        slotConfigId: json["SlotConfigId"] ?? "0",
        slotDurationId: json["SlotDurationId"] ?? "",
        slotEndDateTime: json["SlotEndDateTime"] ?? "",
        slotStartDateTime: json["SlotStartDateTime"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "AssignDockId": assignDockId,
        "AvailableSlots": availableSlots,
        "BookedTimeSlot": bookedTimeSlot,
        "SlotConfigId": slotConfigId,
        "SlotDurationId": slotDurationId,
        "SlotEndDateTime": slotEndDateTime,
        "SlotStartDateTime": slotStartDateTime,
      };
}

class AllVehicleTypes {
  dynamic airportWiseTimeZone;
  dynamic aliasName;
  dynamic allRecord;
  dynamic cntGrowssWeight;
  dynamic cntTareWeight;
  String code;
  dynamic countryCodeDisplay;
  dynamic countryDisplay;
  String description;
  dynamic driverId;
  dynamic driverIsdCode;
  dynamic driverIsdCodeId;
  dynamic driverLicense;
  dynamic driverMobNo;
  dynamic driverName;
  dynamic driverSta;
  dynamic ghaNameId;
  String isActive;
  dynamic isAll;
  dynamic isBundle;
  dynamic isSbYork;
  dynamic isShowOrgDetails;
  dynamic istariff;
  dynamic jointablecondition;
  dynamic jointablename;
  dynamic methodName;
  String name;
  dynamic nameDisplay;
  String orderby;
  dynamic orgProdId;
  String parentid;
  dynamic query;
  String referenceId;
  dynamic regExp;
  dynamic tablename;
  dynamic tariffUoMname;
  int toprecord;
  dynamic userid;
  String value;
  dynamic warehouseIdentifier;
  dynamic wherecondition;

  AllVehicleTypes({
    required this.airportWiseTimeZone,
    required this.aliasName,
    required this.allRecord,
    required this.cntGrowssWeight,
    required this.cntTareWeight,
    required this.code,
    required this.countryCodeDisplay,
    required this.countryDisplay,
    required this.description,
    required this.driverId,
    required this.driverIsdCode,
    required this.driverIsdCodeId,
    required this.driverLicense,
    required this.driverMobNo,
    required this.driverName,
    required this.driverSta,
    required this.ghaNameId,
    required this.isActive,
    required this.isAll,
    required this.isBundle,
    required this.isSbYork,
    required this.isShowOrgDetails,
    required this.istariff,
    required this.jointablecondition,
    required this.jointablename,
    required this.methodName,
    required this.name,
    required this.nameDisplay,
    required this.orderby,
    required this.orgProdId,
    required this.parentid,
    required this.query,
    required this.referenceId,
    required this.regExp,
    required this.tablename,
    required this.tariffUoMname,
    required this.toprecord,
    required this.userid,
    required this.value,
    required this.warehouseIdentifier,
    required this.wherecondition,
  });

  factory AllVehicleTypes.fromJSON(Map<String, dynamic> json) =>
      AllVehicleTypes(
        airportWiseTimeZone: json["AirportWiseTimeZone"],
        aliasName: json["AliasName"],
        allRecord: json["AllRecord"],
        cntGrowssWeight: json["CntGrowssWeight"],
        cntTareWeight: json["CntTareWeight"],
        code: json["code"],
        countryCodeDisplay: json["CountryCodeDisplay"],
        countryDisplay: json["CountryDisplay"],
        description: json["description"],
        driverId: json["DriverId"],
        driverIsdCode: json["DriverISDCode"],
        driverIsdCodeId: json["DriverISDCodeId"],
        driverLicense: json["DriverLicense"],
        driverMobNo: json["DriverMobNo"],
        driverName: json["DriverName"],
        driverSta: json["DriverSTA"],
        ghaNameId: json["GHANameId"],
        isActive: json["IsActive"],
        isAll: json["IsAll"],
        isBundle: json["IsBundle"],
        isSbYork: json["IsSbYork"],
        isShowOrgDetails: json["IsShowOrgDetails"],
        istariff: json["Istariff"],
        jointablecondition: json["jointablecondition"],
        jointablename: json["jointablename"],
        methodName: json["MethodName"],
        name: json["name"],
        nameDisplay: json["NameDisplay"],
        orderby: json["orderby"],
        orgProdId: json["OrgProdId"],
        parentid: json["parentid"],
        query: json["Query"],
        referenceId: json["ReferenceId"],
        regExp: json["RegExp"],
        tablename: json["tablename"],
        tariffUoMname: json["TariffUOMname"],
        toprecord: json["toprecord"],
        userid: json["userid"],
        value: json["value"],
        warehouseIdentifier: json["WarehouseIdentifier"],
        wherecondition: json["wherecondition"],
      );

  Map<String, dynamic> toMap() => {
        "AirportWiseTimeZone": airportWiseTimeZone,
        "AliasName": aliasName,
        "AllRecord": allRecord,
        "CntGrowssWeight": cntGrowssWeight,
        "CntTareWeight": cntTareWeight,
        "code": code,
        "CountryCodeDisplay": countryCodeDisplay,
        "CountryDisplay": countryDisplay,
        "description": description,
        "DriverId": driverId,
        "DriverISDCode": driverIsdCode,
        "DriverISDCodeId": driverIsdCodeId,
        "DriverLicense": driverLicense,
        "DriverMobNo": driverMobNo,
        "DriverName": driverName,
        "DriverSTA": driverSta,
        "GHANameId": ghaNameId,
        "IsActive": isActive,
        "IsAll": isAll,
        "IsBundle": isBundle,
        "IsSbYork": isSbYork,
        "IsShowOrgDetails": isShowOrgDetails,
        "Istariff": istariff,
        "jointablecondition": jointablecondition,
        "jointablename": jointablename,
        "MethodName": methodName,
        "name": name,
        "NameDisplay": nameDisplay,
        "orderby": orderby,
        "OrgProdId": orgProdId,
        "parentid": parentid,
        "Query": query,
        "ReferenceId": referenceId,
        "RegExp": regExp,
        "tablename": tablename,
        "TariffUOMname": tariffUoMname,
        "toprecord": toprecord,
        "userid": userid,
        "value": value,
        "WarehouseIdentifier": warehouseIdentifier,
        "wherecondition": wherecondition,
      };
}

// class for Cargo Type, Exporter , Importer, CHA
class CargoTypeExporterImporterAgent {
  dynamic airportWiseTimeZone;
  dynamic aliasName;
  dynamic businessType;
  dynamic cntGrowssWeight;
  dynamic cntTareWeight;
  String code;
  dynamic countryCodeDisplay;
  dynamic countryDisplay;
  dynamic dclNo;
  String description;
  dynamic driverId;
  dynamic driverIsdCode;
  dynamic driverIsdCodeId;
  dynamic driverLicense;
  dynamic driverMobNo;
  dynamic driverName;
  dynamic driverSta;
  String isActive;
  dynamic isGroup;
  dynamic isHaz;
  dynamic isSbYork;
  String name;
  String nameDisplay;
  dynamic orderval;
  String parentid;
  dynamic query;
  String referenceId;
  dynamic regExp;
  dynamic servicelimit;
  dynamic tariffUoMname;
  String value;
  dynamic warehouseIdentifier;

  CargoTypeExporterImporterAgent({
    required this.airportWiseTimeZone,
    required this.aliasName,
    required this.businessType,
    required this.cntGrowssWeight,
    required this.cntTareWeight,
    required this.code,
    required this.countryCodeDisplay,
    required this.countryDisplay,
    required this.dclNo,
    required this.description,
    required this.driverId,
    required this.driverIsdCode,
    required this.driverIsdCodeId,
    required this.driverLicense,
    required this.driverMobNo,
    required this.driverName,
    required this.driverSta,
    required this.isActive,
    required this.isGroup,
    required this.isHaz,
    required this.isSbYork,
    required this.name,
    required this.nameDisplay,
    required this.orderval,
    required this.parentid,
    required this.query,
    required this.referenceId,
    required this.regExp,
    required this.servicelimit,
    required this.tariffUoMname,
    required this.value,
    required this.warehouseIdentifier,
  });

  factory CargoTypeExporterImporterAgent.fromJSON(Map<String, dynamic> json) =>
      CargoTypeExporterImporterAgent(
        airportWiseTimeZone: json["AirportWiseTimeZone"] ?? "",
        aliasName: json["AliasName"] ?? "",
        businessType: json["BusinessType"] ?? "",
        cntGrowssWeight: json["CntGrowssWeight"] ?? "",
        cntTareWeight: json["CntTareWeight"] ?? "",
        code: json["code"] ?? "",
        countryCodeDisplay: json["CountryCodeDisplay"] ?? "",
        countryDisplay: json["CountryDisplay"] ?? "",
        dclNo: json["DCLNo"] ?? "",
        description: json["description"] ?? "",
        driverId: json["DriverId"] ?? "",
        driverIsdCode: json["DriverISDCode"] ?? "",
        driverIsdCodeId: json["DriverISDCodeId"] ?? "",
        driverLicense: json["DriverLicense"] ?? "",
        driverMobNo: json["DriverMobNo"] ?? "",
        driverName: json["DriverName"] ?? "",
        driverSta: json["DriverSTA"] ?? "",
        isActive: json["IsActive"] ?? "",
        isGroup: json["IsGroup"] ?? "",
        isHaz: json["IsHaz"] ?? "",
        isSbYork: json["IsSbYork"] ?? "",
        name: json["name"] ?? "",
        nameDisplay: json["NameDisplay"] ?? "",
        orderval: json["orderval"] ?? "",
        parentid: json["parentid"] ?? "",
        query: json["Query"] ?? "",
        referenceId: json["ReferenceId"] ?? "",
        regExp: json["RegExp"] ?? "",
        servicelimit: json["Servicelimit"] ?? "",
        tariffUoMname: json["TariffUOMname"] ?? "",
        value: json["value"] ?? "",
        warehouseIdentifier: json["WarehouseIdentifier"] ?? "",
      );

  Map<String, dynamic> toMap() => {
        "AirportWiseTimeZone": airportWiseTimeZone,
        "AliasName": aliasName,
        "BusinessType": businessType,
        "CntGrowssWeight": cntGrowssWeight,
        "CntTareWeight": cntTareWeight,
        "code": code,
        "CountryCodeDisplay": countryCodeDisplay,
        "CountryDisplay": countryDisplay,
        "DCLNo": dclNo,
        "description": description,
        "DriverId": driverId,
        "DriverISDCode": driverIsdCode,
        "DriverISDCodeId": driverIsdCodeId,
        "DriverLicense": driverLicense,
        "DriverMobNo": driverMobNo,
        "DriverName": driverName,
        "DriverSTA": driverSta,
        "IsActive": isActive,
        "IsGroup": isGroup,
        "IsHaz": isHaz,
        "IsSbYork": isSbYork,
        "name": name,
        "NameDisplay": nameDisplay,
        "orderval": orderval,
        "parentid": parentid,
        "Query": query,
        "ReferenceId": referenceId,
        "RegExp": regExp,
        "Servicelimit": servicelimit,
        "TariffUOMname": tariffUoMname,
        "value": value,
        "WarehouseIdentifier": warehouseIdentifier,
      };
}

class ViewShipmentDetailsExport {
  int airportId;
  DateTime bookingDt;
  int bookingId;
  String bookingNo;
  String branchCode;
  int chaId;
  String chaName;
  String companyCode;
  dynamic destination;
  bool isActive;
  bool isFtl;
  bool isLtl;
  int noofVehicle;
  int orgProdId;
  dynamic origin;
  List<ShipmentDetailsExports> shipmentDetailsList;
  bool status;
  List<VehicleDetailsExports> vehicalDetailsList;
  List<VehicalTypeList> vehicalTypeList;
  List<int> vehicleType;

  ViewShipmentDetailsExport({
    required this.airportId,
    required this.bookingDt,
    required this.bookingId,
    required this.bookingNo,
    required this.branchCode,
    required this.chaId,
    required this.chaName,
    required this.companyCode,
    required this.destination,
    required this.isActive,
    required this.isFtl,
    required this.isLtl,
    required this.noofVehicle,
    required this.orgProdId,
    required this.origin,
    required this.shipmentDetailsList,
    required this.status,
    required this.vehicalDetailsList,
    required this.vehicalTypeList,
    required this.vehicleType,
  });

  factory ViewShipmentDetailsExport.fromMap(Map<String, dynamic> json) => ViewShipmentDetailsExport(
    airportId: json["AirportId"],
    bookingDt: DateTime.parse(json["BookingDt"]),
    bookingId: json["BookingId"],
    bookingNo: json["BookingNo"],
    branchCode: json["BranchCode"],
    chaId: json["CHAId"],
    chaName: json["ChaName"],
    companyCode: json["CompanyCode"],
    destination: json["Destination"],
    isActive: json["IsActive"],
    isFtl: json["IsFTL"],
    isLtl: json["IsLTL"],
    noofVehicle: json["NoofVehicle"],
    orgProdId: json["OrgProdId"],
    origin: json["Origin"],
    shipmentDetailsList: List<ShipmentDetailsExports>.from(json["ShipmentDetailsList"].map((x) => ShipmentDetailsExports.fromJson(x))),
    status: json["Status"],
    vehicalDetailsList: List<VehicleDetailsExports>.from(json["VehicalDetailsList"].map((x) => VehicleDetailsExports.fromJson(x))),
    vehicalTypeList: List<VehicalTypeList>.from(json["vehicalTypeList"].map((x) => VehicalTypeList.fromMap(x))),
    vehicleType: List<int>.from(json["VehicleType"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "AirportId": airportId,
    "BookingDt": bookingDt.toIso8601String(),
    "BookingId": bookingId,
    "BookingNo": bookingNo,
    "BranchCode": branchCode,
    "CHAId": chaId,
    "ChaName": chaName,
    "CompanyCode": companyCode,
    "Destination": destination,
    "IsActive": isActive,
    "IsFTL": isFtl,
    "IsLTL": isLtl,
    "NoofVehicle": noofVehicle,
    "OrgProdId": orgProdId,
    "Origin": origin,
    "ShipmentDetailsList": List<dynamic>.from(shipmentDetailsList.map((x) => x.toJson())),
    "Status": status,
    "VehicalDetailsList": List<dynamic>.from(vehicalDetailsList.map((x) => x.toJson())),
    "vehicalTypeList": List<dynamic>.from(vehicalTypeList.map((x) => x.toMap())),
    "VehicleType": List<dynamic>.from(vehicleType.map((x) => x)),
  };
}
class VehicalTypeList {
  int bookingId;
  int vehicleTypeDetailId;
  int vehicleTypeId;

  VehicalTypeList({
    required this.bookingId,
    required this.vehicleTypeDetailId,
    required this.vehicleTypeId,
  });

  factory VehicalTypeList.fromMap(Map<String, dynamic> json) => VehicalTypeList(
    bookingId: json["BookingId"],
    vehicleTypeDetailId: json["VehicleTypeDetailId"],
    vehicleTypeId: json["VehicleTypeId"],
  );

  Map<String, dynamic> toMap() => {
    "BookingId": bookingId,
    "VehicleTypeDetailId": vehicleTypeDetailId,
    "VehicleTypeId": vehicleTypeId,
  };
}
