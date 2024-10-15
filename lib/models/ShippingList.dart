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

  factory AllVehicleTypes.fromJSON(Map<String, dynamic> json) => AllVehicleTypes(
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

  factory CargoTypeExporterImporterAgent.fromJSON(Map<String, dynamic> json) => CargoTypeExporterImporterAgent(
    airportWiseTimeZone: json["AirportWiseTimeZone"],
    aliasName: json["AliasName"],
    businessType: json["BusinessType"],
    cntGrowssWeight: json["CntGrowssWeight"],
    cntTareWeight: json["CntTareWeight"],
    code: json["code"],
    countryCodeDisplay: json["CountryCodeDisplay"],
    countryDisplay: json["CountryDisplay"],
    dclNo: json["DCLNo"],
    description: json["description"],
    driverId: json["DriverId"],
    driverIsdCode: json["DriverISDCode"],
    driverIsdCodeId: json["DriverISDCodeId"],
    driverLicense: json["DriverLicense"],
    driverMobNo: json["DriverMobNo"],
    driverName: json["DriverName"],
    driverSta: json["DriverSTA"],
    isActive: json["IsActive"],
    isGroup: json["IsGroup"],
    isHaz: json["IsHaz"],
    isSbYork: json["IsSbYork"],
    name: json["name"],
    nameDisplay: json["NameDisplay"],
    orderval: json["orderval"],
    parentid: json["parentid"],
    query: json["Query"],
    referenceId: json["ReferenceId"],
    regExp: json["RegExp"],
    servicelimit: json["Servicelimit"],
    tariffUoMname: json["TariffUOMname"],
    value: json["value"],
    warehouseIdentifier: json["WarehouseIdentifier"],
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


