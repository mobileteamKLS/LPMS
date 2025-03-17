class SelectionModels {
  String description;
  dynamic value;
  String name;
  String referenceId;
  String tableName;
  String languageData;
  String whereCondition;
  String jointableName;
  String jointableCondition;
  int userId;
  dynamic customerWeekNo;
  dynamic airportWiseTimeZone;
  String code;
  dynamic parentId;
  int topRecord;
  String orderBy;
  String isActive;
  String methodName;
  bool allRecord;
  String businessType;
  dynamic orderVal;
  bool isTariff;
  String isSbYork;
  bool isGroup;
  dynamic regExp;
  bool isDisabled;
  dynamic query;
  dynamic ediChannel;
  dynamic ediAddressList;
  dynamic nameDisplay;
  dynamic aliasName;
  dynamic countryCodeDisplay;
  dynamic countryDisplay;
  dynamic codeDisplay;
  dynamic driverId;
  dynamic driverName;
  dynamic driverISDCode;
  dynamic driverMobNo;
  dynamic driverLicense;
  dynamic driverSTA;
  dynamic driverISDCodeId;
  String tariffUOMname;
  String partDescription;
  String hsn;
  int? consumerGSTStateID;
  dynamic consumerGSTIN;
  dynamic consumerGSTStateCode;
  dynamic paymentMethod;
  dynamic cntTareWeight;
  dynamic cntGrossWeight;
  dynamic paymentGatewayID;
  bool isAll;
  bool isBundle;
  dynamic warehouseIdentifier;
  int? ghaNameId;
  int? noOfLabour;
  bool isReefer;
  bool isHaz;
  int? serviceLimit;
  bool isOccupied;
  dynamic orgProdId;

  SelectionModels({
    this.description = "",
    this.value,
    this.name = "",
    this.referenceId = "",
    this.tableName = "",
    this.languageData = "",
    this.whereCondition = "",
    this.jointableName = "",
    this.jointableCondition = "",
    this.userId = 0,
    this.customerWeekNo,
    this.airportWiseTimeZone,
    this.code = "",
    this.parentId,
    this.topRecord = 10,
    this.orderBy = "",
    this.isActive = "",
    this.methodName = "",
    this.allRecord = false,
    this.businessType = "",
    this.orderVal,
    this.isTariff = false,
    this.isSbYork = "",
    this.isGroup = false,
    this.regExp,
    this.isDisabled = false,
    this.query,
    this.ediChannel,
    this.ediAddressList,
    this.nameDisplay,
    this.aliasName,
    this.countryCodeDisplay,
    this.countryDisplay,
    this.codeDisplay,
    this.driverId,
    this.driverName,
    this.driverISDCode,
    this.driverMobNo,
    this.driverLicense,
    this.driverSTA,
    this.driverISDCodeId,
    this.tariffUOMname = "",
    this.partDescription = "",
    this.hsn = "",
    this.consumerGSTStateID,
    this.consumerGSTIN,
    this.consumerGSTStateCode,
    this.paymentMethod,
    this.cntTareWeight,
    this.cntGrossWeight,
    this.paymentGatewayID,
    this.isAll = false,
    this.isBundle = false,
    this.warehouseIdentifier,
    this.ghaNameId,
    this.noOfLabour,
    this.isReefer = false,
    this.isHaz = false,
    this.serviceLimit,
    this.isOccupied = false,
    this.orgProdId,
  });

  // JSON serialization
  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "value": value,
      "name": name,
      "ReferenceId": referenceId,
      "tablename": tableName,
      "Languagedata": languageData,
      "wherecondition": whereCondition,
      "jointablename": jointableName,
      "jointablecondition": jointableCondition,
      "userid": userId,
      "CustomerWeekNo": customerWeekNo,
      "AirportWiseTimeZone": airportWiseTimeZone,
      "code": code,
      "parentid": parentId,
      "toprecord": topRecord,
      "orderby": orderBy,
      "IsActive": isActive,
      "MethodName": methodName,
      "AllRecord": allRecord,
      "BusinessType": businessType,
      "Istariff": isTariff,
      "IsSbYork": isSbYork,
      "IsGroup": isGroup,
      "IsDisabled": isDisabled,
      "Query": query,
      "EDIChannel": ediChannel,
      "EDIAddressList": ediAddressList,
      "NameDisplay": nameDisplay,
      "AliasName": aliasName,
      "CountryCodeDisplay": countryCodeDisplay,
      "CountryDisplay": countryDisplay,
      "CodeDisplay": codeDisplay,
      "DriverId": driverId,
      "DriverName": driverName,
      "DriverISDCode": driverISDCode,
      "DriverMobNo": driverMobNo,
      "DriverLicense": driverLicense,
      "DriverSTA": driverSTA,
      "DriverISDCodeId": driverISDCodeId,
      "TariffUOMname": tariffUOMname,
      "PartDescription": partDescription,
      "Hsn": hsn,
      "ConsumerGSTStateID": consumerGSTStateID,
      "ConsumerGSTIN": consumerGSTIN,
      "ConsumerGSTStatecode": consumerGSTStateCode,
      "PaymentMethod": paymentMethod,
      "CntTareWeight": cntTareWeight,
      "CntGrowssWeight": cntGrossWeight,
      "PaymentGatewayID": paymentGatewayID,
      "IsAll": isAll,
      "IsBundle": isBundle,
      "WarehouseIdentifier": warehouseIdentifier,
      "GHANameId": ghaNameId,
      "NoOfLabour": noOfLabour,
      "IsReefer": isReefer,
      "IsHaz": isHaz,
      "ServiceLimit": serviceLimit,
      "IsOccupied": isOccupied,
      "OrgProdId": orgProdId,
    };
  }

  factory SelectionModels.fromJson(Map<String, dynamic> json) {
    return SelectionModels(
      description: json["description"] ?? "",
      value: json["value"],
      name: json["name"] ?? "",
      referenceId: json["ReferenceId"] ?? "",
      tableName: json["tablename"] ?? "",
      languageData: json["Languagedata"] ?? "",
      whereCondition: json["wherecondition"] ?? "",
      jointableName: json["jointablename"] ?? "",
      jointableCondition: json["jointablecondition"] ?? "",
      userId: json["userid"] ?? 0,
      customerWeekNo: json["CustomerWeekNo"],
      airportWiseTimeZone: json["AirportWiseTimeZone"],
      code: json["code"] ?? "",
      parentId: json["parentid"],
      topRecord: json["toprecord"] ?? 10,
      orderBy: json["orderby"] ?? "",
      isActive: json["IsActive"] ?? "",
      methodName: json["MethodName"] ?? "",
      allRecord: json["AllRecord"] ?? false,
      businessType: json["BusinessType"] ?? "",
      isTariff: json["Istariff"] ?? false,
      isSbYork: json["IsSbYork"] ?? "",
      isGroup: json["IsGroup"] ?? false,
      isDisabled: json["IsDisabled"] ?? false,
      query: json["Query"],
      ediChannel: json["EDIChannel"],
      ediAddressList: json["EDIAddressList"],
      nameDisplay: json["NameDisplay"],
      aliasName: json["AliasName"],
      countryCodeDisplay: json["CountryCodeDisplay"],
      countryDisplay: json["CountryDisplay"],
      codeDisplay: json["CodeDisplay"],
      driverId: json["DriverId"],
      driverName: json["DriverName"],
      driverISDCode: json["DriverISDCode"],
      driverMobNo: json["DriverMobNo"],
      driverLicense: json["DriverLicense"],
      driverSTA: json["DriverSTA"],
      driverISDCodeId: json["DriverISDCodeId"],
      tariffUOMname: json["TariffUOMname"] ?? "",
      partDescription: json["PartDescription"] ?? "",
      hsn: json["Hsn"] ?? "",
      consumerGSTStateID: json["ConsumerGSTStateID"],
      consumerGSTIN: json["ConsumerGSTIN"],
      consumerGSTStateCode: json["ConsumerGSTStatecode"],
      paymentMethod: json["PaymentMethod"],
      cntTareWeight: json["CntTareWeight"],
      cntGrossWeight: json["CntGrowssWeight"],
      paymentGatewayID: json["PaymentGatewayID"],
      isAll: json["IsAll"] ?? false,
      isBundle: json["IsBundle"] ?? false,
      warehouseIdentifier: json["WarehouseIdentifier"],
      ghaNameId: json["GHANameId"],
      noOfLabour: json["NoOfLabour"],
      isReefer: json["IsReefer"] ?? false,
      isHaz: json["IsHaz"] ?? false,
      serviceLimit: json["ServiceLimit"],
      isOccupied: json["IsOccupied"] ?? false,
      orgProdId: json["OrgProdId"] ,
    );
  }

  @override
  String toString() {
    return "SelectionModels("
        "description: $description, "
        "value: $value, "
        "name: $name, "
        "referenceId: $referenceId, "
        "tableName: $tableName, "
        "languageData: $languageData, "
        "whereCondition: $whereCondition, "
        "jointableName: $jointableName, "
        "jointableCondition: $jointableCondition, "
        "userId: $userId, "
        "customerWeekNo: $customerWeekNo, "
        "airportWiseTimeZone: $airportWiseTimeZone, "
        "code: $code, "
        "parentId: $parentId, "
        "topRecord: $topRecord, "
        "orderBy: $orderBy, "
        "isActive: $isActive, "
        "methodName: $methodName, "
        "allRecord: $allRecord, "
        "businessType: $businessType, "
        "isTariff: $isTariff, "
        "isSbYork: $isSbYork, "
        "isGroup: $isGroup, "
        "isDisabled: $isDisabled, "
        "query: $query, "
        "ediChannel: $ediChannel, "
        "ediAddressList: $ediAddressList, "
        "nameDisplay: $nameDisplay, "
        "aliasName: $aliasName, "
        "countryCodeDisplay: $countryCodeDisplay, "
        "countryDisplay: $countryDisplay, "
        "codeDisplay: $codeDisplay, "
        "driverId: $driverId, "
        "driverName: $driverName, "
        "driverISDCode: $driverISDCode, "
        "driverMobNo: $driverMobNo, "
        "driverLicense: $driverLicense, "
        "driverSTA: $driverSTA, "
        "driverISDCodeId: $driverISDCodeId, "
        "tariffUOMname: $tariffUOMname, "
        "partDescription: $partDescription, "
        "hsn: $hsn, "
        "consumerGSTStateID: $consumerGSTStateID, "
        "consumerGSTIN: $consumerGSTIN, "
        "consumerGSTStateCode: $consumerGSTStateCode, "
        "paymentMethod: $paymentMethod, "
        "cntTareWeight: $cntTareWeight, "
        "cntGrossWeight: $cntGrossWeight, "
        "paymentGatewayID: $paymentGatewayID, "
        "isAll: $isAll, "
        "isBundle: $isBundle, "
        "warehouseIdentifier: $warehouseIdentifier, "
        "ghaNameId: $ghaNameId, "
        "noOfLabour: $noOfLabour, "
        "isReefer: $isReefer, "
        "isHaz: $isHaz, "
        "serviceLimit: $serviceLimit, "
        "isOccupied: $isOccupied)";
  }
}


class SelectionQuery {
  String? query;

  SelectionQuery({this.query});
}

class SelectionModelsCustomer {
  String? description;
  int? value;
  String? name;
  String? referenceId;
  String? tableName;
  String? languageData;
  String? whereCondition;
  String jointableName = '';
  String jointableCondition = '';
  int? userId;
  String? code;
  int? parentId;
  int topRecord = 10;
  String? orderBy;
  String? isActive;
  String? methodName;
  bool allRecord = false;
  bool isTariff = false;
  String? isSbYork;

  SelectionModelsCustomer({
    this.description,
    this.value,
    this.name,
    this.referenceId,
    this.tableName,
    this.languageData,
    this.whereCondition,
    this.jointableName = '',
    this.jointableCondition = '',
    this.userId,
    this.code,
    this.parentId,
    this.topRecord = 10,
    this.orderBy,
    this.isActive,
    this.methodName,
    this.allRecord = false,
    this.isTariff = false,
    this.isSbYork,
  });


}

class AirlineGrp {
  String? referenceId;
  List<AirlineEntry> entries = [];

  AirlineGrp({this.referenceId, required this.entries});
}

class AirlineEntry {
  String? description;
  String? value;

  AirlineEntry({this.description, this.value});
}

class ZoneByGroup {
  String? referenceId;
  List<ZoneEntry> entries = [];

  ZoneByGroup({this.referenceId, required this.entries});
}

class ZoneEntry {
  String? description;
  String? value;

  ZoneEntry({this.description, this.value});
}
