import 'package:flutter/cupertino.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../models/IPInfo.dart';
import '../models/LoginMaster.dart';
import '../models/ShippingList.dart';
import '../screens/BookingCreationExport.dart';


late IpInfo ipInfo;
List<LoginDetailsMaster> loginMaster = [];
List<AllVehicleTypes> vehicleTypeList = [];
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
int? selectedTerminalId = 151;
bool isEdit=false;
final List<Map<String, dynamic>> terminals = [
  {'id': 157, 'name': 'AKOLA'},
  {'id': 155, 'name': 'ATTARI'},
  {'id': 154, 'name': 'RAXAUL'},
  {'id': 153, 'name': 'JOGBANI'},
  {'id': 152, 'name': 'PETRAPOLE'},
  {'id': 151, 'name': 'AGARTALA'},
];
