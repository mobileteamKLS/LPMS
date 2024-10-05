class IpInfo {
  final String ip;
  final String city;
  final String country;
  final String org;

  IpInfo({required this.ip,
    required this.city,
    required this.country,
    required this.org});

  factory IpInfo.fromJson(Map<String, dynamic> json) {
    return IpInfo(ip: json['ip'] ?? "",
        city: json['city'] ?? "",
        country: json['country'] == null
            ? ""
            : json['country'] == "IN"
                ? "India"
                : json['country'],
        org: json['org'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    data['city'] = this.city;
    data['country'] = this.country;
    data['org'] = this.org;
    return data;
  }

  @override
  String toString() {
    return '---------IpInfo-------{ip: $ip, city: $city, country: $country, org: $org}';
  }
}