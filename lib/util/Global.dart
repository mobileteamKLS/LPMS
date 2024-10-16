import 'package:multi_dropdown/multi_dropdown.dart';

import '../models/LoginMaster.dart';
import '../models/ShippingList.dart';
import '../screens/BookingCreationExport.dart';

List<LoginDetailsMaster> loginMaster = [];
List<AllVehicleTypes> vehicleTypeList = [];
List<CargoTypeExporterImporterAgent> cargoTypeList = [];
List<CargoTypeExporterImporterAgent> chaAgentList = [];
List<CargoTypeExporterImporterAgent> exporterList = [];
List<CargoTypeExporterImporterAgent> importerList = [];
List<DropdownItem<Vehicle>> items = [ ];
List<ShipmentDetails> shipmentList = [
  // ShipmentDetails(
  //   billNo: "SBN001",
  //   billDate: "2024-10-01",
  //   exporterName: "Global Exports Ltd",
  //   hsnCode: "123456",
  //   cargoType: "Electronics",
  //   cargoDescription: "Smartphones and accessories",
  //   quality: "High",
  //   cargoWeight: "500kg",
  //   cargoValue: "\$50,000",
  // ),
  // ShipmentDetails(
  //   billNo: "SBN002",
  //   billDate: "2024-10-02",
  //   exporterName: "Oceanic Cargo Pvt Ltd",
  //   hsnCode: "654321",
  //   cargoType: "Textiles",
  //   cargoDescription: "Cotton Fabrics",
  //   quality: "Medium",
  //   cargoWeight: "1200kg",
  //   cargoValue: "\$30,000",
  // ),
  // ShipmentDetails(
  //   billNo: "SBN003",
  //   billDate: "2024-10-03",
  //   exporterName: "Sky High Logistics",
  //   hsnCode: "789012",
  //   cargoType: "Machinery",
  //   cargoDescription: "Industrial Machinery",
  //   quality: "Premium",
  //   cargoWeight: "2000kg",
  //   cargoValue: "\$100,000",
  // ),
];
List<VehicleDetails> dummyVehicleDetailsList = [
  // VehicleDetails(
  //   billDate: "2024-01-25",
  //   vehicleType: "6 Wheeler Truck",
  //   vehicleNo: "LMN789",
  //   driverLicenseNo: "DL-654321987",
  //   driverMobNo: "9876543230",
  //   driverDOB: "1988-12-14",
  //   driverName: "David Brown",
  //   remark: "Damaged goods",
  // ),
  // VehicleDetails(
  //   billDate: "2024-02-01",
  //   vehicleType: "Truck",
  //   vehicleNo: "PQR101",
  //   driverLicenseNo: "DL-789456123",
  //   driverMobNo: "9876543240",
  //   driverDOB: "1992-07-08",
  //   driverName: "Robert Johnson",
  //   remark: "Smooth operation",
  // ),
  // VehicleDetails(
  //   billDate: "2024-02-05",
  //   vehicleType: "Chassis",
  //   vehicleNo: "DEF234",
  //   driverLicenseNo: "DL-321654987",
  //   driverMobNo: "9876543250",
  //   driverDOB: "1989-03-18",
  //   driverName: "James Williams",
  //   remark: "Late departure",
  // ),
];
