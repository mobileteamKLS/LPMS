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


  factory ShipmentDetails.fromMap(Map<String, dynamic> data) {
    return ShipmentDetails(
      billNo: data['billNo'],
      billDate: data['billDate'],
      exporterName: data['exporterName'],
      hsnCode: data['hsnCode'],
      cargoType: data['cargoType'],
      cargoDescription: data['cargoDescription'],
      quality: data['quality'],
      cargoWeight: data['cargoWeight'],
      cargoValue: data['cargoValue'],
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
