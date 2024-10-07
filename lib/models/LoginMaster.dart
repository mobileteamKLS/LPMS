
class LoginDetailsMaster {
  int adminOrgProdId;
  String branchCode;
  String companyCode;
  int terminalId;
  String timeZone;
  String token;

  LoginDetailsMaster({
    required this.adminOrgProdId,
    required this.branchCode,
    required this.companyCode,
    required this.terminalId,
    required this.timeZone,
    required this.token,
  });

  factory LoginDetailsMaster.fromJSON(Map<String, dynamic> json) => LoginDetailsMaster(
    adminOrgProdId: json["Admin_OrgProdId"]??"",
    branchCode: json["BranchCode"]??"",
    companyCode: json["CompanyCode"]??"",
    terminalId: json["TerminalId"]??"",
    timeZone: json["TimeZone"]??"",
    token: json["Token"]??"",
  );

  Map<String, dynamic> toMap() => {
    "Admin_OrgProdId": adminOrgProdId,
    "BranchCode": branchCode,
    "CompanyCode": companyCode,
    "TerminalId": terminalId,
    "TimeZone": timeZone,
    "Token": token,
  };
}