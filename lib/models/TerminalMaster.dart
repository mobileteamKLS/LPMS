class TerminalMaster {
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
  String warehouseIdentifier;

  TerminalMaster({
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

  factory TerminalMaster.fromJson(Map<String, dynamic> json) => TerminalMaster(
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

  Map<String, dynamic> toJson() => {
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

class CargoCategory {
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
  String? parentid;
  dynamic query;
  String? referenceId;
  dynamic regExp;
  dynamic servicelimit;
  dynamic tariffUoMname;
  String value;
  String? warehouseIdentifier;

  CargoCategory({
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

  factory CargoCategory.fromJson(Map<String, dynamic> json) => CargoCategory(
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

  Map<String, dynamic> toJson() => {
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

class BookingType {
  String code;
  String description;
  String name;
  String value;

  BookingType({
    required this.code,
    required this.description,
    required this.name,
    required this.value,
  });

  factory BookingType.fromJson(Map<String, dynamic> json) => BookingType(
    code: json["code"],
    description: json["description"],
    name: json["name"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
    "name": name,
    "value": value,
  };
}