class ShipmentDetails {
  int bookingId;
  String bookingDt;
  String bookingNo;
  String sBillNo;
  String sBillDt;
  String exporterImporter;
  int cargoTypeId;
  String cargoTypeName;
  String statusDescription;

  ShipmentDetails({
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

  factory ShipmentDetails.fromJSON(Map<String, dynamic> json) => ShipmentDetails(
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