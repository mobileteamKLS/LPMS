
import '../models/LoginMaster.dart';
import '../models/ShippingList.dart';

List<LoginDetailsMaster> loginMaster=[];
List<ShipmentDetails> shipmentList = [
 ShipmentDetails(
  billNo: "SBN001",
  billDate: "2024-10-01",
  exporterName: "Global Exports Ltd",
  hsnCode: "123456",
  cargoType: "Electronics",
  cargoDescription: "Smartphones and accessories",
  quality: "High",
  cargoWeight: "500kg",
  cargoValue: "\$50,000",
 ),
 ShipmentDetails(
  billNo: "SBN002",
  billDate: "2024-10-02",
  exporterName: "Oceanic Cargo Pvt Ltd",
  hsnCode: "654321",
  cargoType: "Textiles",
  cargoDescription: "Cotton Fabrics",
  quality: "Medium",
  cargoWeight: "1200kg",
  cargoValue: "\$30,000",
 ),
 ShipmentDetails(
  billNo: "SBN003",
  billDate: "2024-10-03",
  exporterName: "Sky High Logistics",
  hsnCode: "789012",
  cargoType: "Machinery",
  cargoDescription: "Industrial Machinery",
  quality: "Premium",
  cargoWeight: "2000kg",
  cargoValue: "\$100,000",
 ),
];

