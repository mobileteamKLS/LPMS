
class LoginDetailsMaster {
  int adminOrgProdId;
  int adminOrgId;
  String branchCode;
  String branchName;
  String companyCode;
  int terminalId;
  String timeZone;
  String token;
  String firstName;

  LoginDetailsMaster({
    required this.adminOrgProdId,
    required this.adminOrgId,
    required this.branchCode,
    required this.branchName,
    required this.companyCode,
    required this.terminalId,
    required this.timeZone,
    required this.token,
    required this.firstName,
  });

  factory LoginDetailsMaster.fromJSON(Map<String, dynamic> json) => LoginDetailsMaster(
    adminOrgProdId: json["Admin_OrgProdId"]??0,
    adminOrgId:json["Admin_OrgId"]??0,
    branchCode: json["BranchCode"]??"",
    branchName: json["BranchName"]??"",
    companyCode: json["CompanyCode"]??"",
    terminalId: json["TerminalId"]??"",
    timeZone: json["TimeZone"]??"",
    token: json["Token"]??"",
    firstName: json["FirstName"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Admin_OrgProdId": adminOrgProdId,
    "Admin_OrgId":adminOrgId,
    "BranchCode": branchCode,
    "BranchName": branchName,
    "CompanyCode": companyCode,
    "TerminalId": terminalId,
    "TimeZone": timeZone,
    "Token": token,
    "FirstName": firstName,
  };
}