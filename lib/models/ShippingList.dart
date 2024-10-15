class SlotBookingShipmentDetailsExport {
  int bookingId;
  String bookingDt;
  String bookingNo;
  String sBillNo;
  String sBillDt;
  String exporterImporter;
  int cargoTypeId;
  String cargoTypeName;
  String statusDescription;

  SlotBookingShipmentDetailsExport({
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

  factory SlotBookingShipmentDetailsExport.fromJSON(Map<String, dynamic> json) => SlotBookingShipmentDetailsExport(
    bookingId: json["BookingId"]??0,
    bookingDt: json["BookingDt"]??"",
    bookingNo: json["BookingNo"]??"",
    sBillNo: json["SBillNo"]??"",
    sBillDt: json["SBillDt"]??"",
    exporterImporter: json["Exporter_Importer"]??"",
    cargoTypeId: json["CargoTypeId"]??0,
    cargoTypeName: json["CargoTypeName"]??"",
    statusDescription: (json["StatusDescription"]??"").toUpperCase(),
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

class SlotBookingShipmentDetailsImport {
  String boeDt;
  String boeNo;
  String bookingDt;
  int bookingId;
  String bookingNo;
  int cargoTypeId;
  String cargoTypeName;
  String exporterImporter;
  String statusDescription;

  SlotBookingShipmentDetailsImport({
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

  factory SlotBookingShipmentDetailsImport.fromJSON(Map<String, dynamic> json) => SlotBookingShipmentDetailsImport(
    boeDt: json["BOEDt"]??"",
    boeNo: json["BOENo"]??"",
    bookingDt:json["BookingDt"]??"",
    bookingId: json["BookingId"]??0,
    bookingNo: json["BookingNo"]??"",
    cargoTypeId: json["CargoTypeId"]??0,
    cargoTypeName: json["CargoTypeName"]??"",
    exporterImporter: json["Exporter_Importer"]??"",
    statusDescription: (json["StatusDescription"]??"").toUpperCase(),
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


class ShipmentDetails {
  final String billNo;
  final String billDate;
  final String exporterName;
  final String hsnCode;
  final String cargoType;
  final String cargoDescription;
  final String quality;
  final String cargoWeight;
  final String cargoValue;

  ShipmentDetails({
    required this.billNo,
    required this.billDate,
    required this.exporterName,
    required this.hsnCode,
    required this.cargoType,
    required this.cargoDescription,
    required this.quality,
    required this.cargoWeight,
    required this.cargoValue,
  });


  factory ShipmentDetails.fromJSON(Map<String, dynamic> data) {
    return ShipmentDetails(
      billNo: data["billNo"],
      billDate: data["billDate"],
      exporterName: data["exporterName"],
      hsnCode: data["hsnCode"],
      cargoType: data["cargoType"],
      cargoDescription: data["cargoDescription"],
      quality: data["quality"],
      cargoWeight: data["cargoWeight"],
      cargoValue: data["cargoValue"],
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'billNo': billNo,
      'billDate': billDate,
      'exporterName': exporterName,
      'hsnCode': hsnCode,
      'cargoType': cargoType,
      'cargoDescription': cargoDescription,
      'quality': quality,
      'cargoWeight': cargoWeight,
      'cargoValue': cargoValue,
    };
  }
}

class VehicleDetails {
  String billDate;
  String vehicleType;
  String vehicle;
  String driverLicenseNo;
  String driverMobNo;
  String driverDOB;
  String driverName;
  String remark;

  VehicleDetails({
    required this.billDate,
    required this.vehicleType,
    required this.vehicle,
    required this.driverLicenseNo,
    required this.driverMobNo,
    required this.driverDOB,
    required this.driverName,
    required this.remark,
  });

  factory VehicleDetails.fromJSON(Map<String, dynamic> map) {
    return VehicleDetails(
      billDate: map['billDate'] ?? '',
      vehicleType: map['vehicleType'] ?? '',
      vehicle: map['vehicle'] ?? '',
      driverLicenseNo: map['driverLicenseNo'] ?? '',
      driverMobNo: map['driverMobNo'] ?? '',
      driverDOB: map['driverDOB'] ?? '',
      driverName: map['driverName'] ?? '',
      remark: map['remark'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'billDate': billDate,
      'vehicleType': vehicleType,
      'vehicle': vehicle,
      'driverLicenseNo': driverLicenseNo,
      'driverMobNo': driverMobNo,
      'driverDOB': driverDOB,
      'driverName': driverName,
      'remark': remark,
    };
  }
}

