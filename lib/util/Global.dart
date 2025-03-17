import 'package:flutter/cupertino.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../models/IPInfo.dart';
import '../models/TerminalMaster.dart';
import '../models/login_model.dart';
import '../models/ShippingList.dart';
import '../screens/slot_booking/BookingCreationExport.dart';

// var baseAPIUrl="https://acs2devapi.azurewebsites.net/";
// var baseUIUrl="https://acs2devui.azurewebsites.net/";
//UAT
var baseAPIUrl="https://lpmsuatapi.kalelogistics.com/";
var baseUIUrl="https://lpmsuat.kalelogistics.com/";
late IpInfo ipInfo;
List<LoginDetailsMaster> loginMaster = [];
List<AllVehicleTypes> vehicleTypeList = [];
List<TerminalMaster> terminalsList = [];
List<CargoTypeExporterImporterAgent> cargoTypeList = [];
List<Vehicle> selectedVehicleList = [];
List<CargoTypeExporterImporterAgent> chaAgentList = [];
List<CargoTypeExporterImporterAgent> exporterList = [];
List<CargoTypeExporterImporterAgent> importerList = [];
List<DropdownItem<Vehicle>> items = [ ];
List<DropdownItem<Vehicle>> items1 = [ ];
List<ShipmentDetailsExports> shipmentListExports = [];
List<ShipmentDetailsImports> shipmentListImports = [];
List<VehicleDetailsImports> vehicleListImports = [];
List<VehicleDetailsExports> vehicleListExports = [];
final multiSelectController = MultiSelectController<Vehicle>();
final multiSelectController2 = MultiSelectController<Vehicle>();
final TextEditingController noOfVehiclesController = TextEditingController();
bool isFTlAndOneShipment=true;
late int maxVehicleNo;
String originMaster="";
String destinationMaster="";
String chaNameMaster="";
int? selectedTerminalId = 139;
bool isEdit=false;
bool isMenuExpanded = false;
final List<Map<String, dynamic>> terminals = [
  {'id': 157, 'name': 'Mankachar'},
  {'id': 154, 'name': 'ATTARI'},
  {'id': 141, 'name': 'Jogbani'},
  {'id': 153, 'name': 'Darranga'},
  {'id': 158, 'name': 'GOLAKGANJ'},
  {'id': 139, 'name': 'AGARTALA'},
  {'id': 140, 'name': 'Petrapole'},
  {'id': 142, 'name': 'Raxaul'},
  {'id': 155, 'name': 'Srimantapur'},
  {'id': 159, 'name': 'Sutarkandi'},
];
