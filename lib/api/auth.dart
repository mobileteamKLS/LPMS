import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/IPInfo.dart';

class AuthService {
  Future<Map<String, dynamic>> getUserAuthenticationDetails(
      String username,
      String otpGenerationCode,
      String password,
      String ipAddress,
      String ipCity,
      String ipCountry,
      String ipOrg,
      String userAgent,
      String logonType,
      String businessLineID) async {
    try {
      var response = await http.post(
        Uri.parse(
            'https://acsintapigateway.kalelogistics.com/api_login/Login/GetUserAuthenticationDetails'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "LoginName": username,
          "OTPGenerationCode": otpGenerationCode,
          "LoginPassword": password,
          "IpAddress": ipAddress,
          "IpCity": ipCity,
          "IpCountry": ipCountry,
          "IpOrg": ipOrg,
          "UserAgent": userAgent,
          "LogonType": logonType,
          "BusinesslineId": businessLineID,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return {"success": true, "data": data};
      } else {
        return {"success": false, "message": "Invalid username or password"};
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred. Please try again."
      };
    }
  }

  Future<IpInfo> fetchIpInfo() async {
    final response = await http.get(Uri.parse("https://ipapi.co/json/"));
    final int statusCode = response.statusCode;
    if (statusCode <= 200 || statusCode > 400) {
      final data = json.decode(response.body);
      debugPrint(IpInfo.fromJson(data).toString());
      return IpInfo.fromJson(data);
    } else {
      throw Exception('Failed to load IP information');
    }
  }

  Future<Post> postData(service, payload) async {
    print("payload $payload");
    print("encoded payload ${json.encode(payload)}");
    return fetchDataPOST(service, payload);
  }

  Future<Post> getData(service, payload) async {
    print("payload $payload");
    print("encoded payload ${json.encode(payload)}");
    return fetchDataGET(service, payload);
  }

  Future<Post> fetchDataPOST(apiName, payload) async {
    var newURL = "https://acsintapigateway.kalelogistics.com/$apiName";
    debugPrint("fetch data for API = $newURL");
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjQwMDciLCJyb2xlIjoiV2ViQXBwVXNlciIsIm5iZiI6MTcyNzc1NTk0OCwiZXhwIjoxNzI3NzkxOTQ4LCJpYXQiOjE3Mjc3NTU5NDh9.HmPIdz-2RCFd4SBXDM_eer5AiHCQWnKxetYfh5CtcAw', // Use your token type (Bearer, Basic, etc.)
    };

    if (payload == "") {
      debugPrint("payload blank");
      return await http.post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers:headers,
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        if (statusCode < 200 || statusCode > 400) {
          throw Exception("Error while fetching data");
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    } else {
      return await http.post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: headers,
      ).then((http.Response response) {
        print(response.body);
        print(response.statusCode);

        final int statusCode = response.statusCode;
        if (statusCode == 401) {
          return Post.fromJson(response.body, statusCode);
        }
        if (statusCode < 200 || statusCode > 400) {
          return Post.fromJson(response.body, statusCode);
        }
        print("sending data to post");
        return Post.fromJson(response.body, statusCode);
      });
    }

  }

  Future<Post> fetchDataGET(apiName, payload) async {
    var newURL = "https://acsintapigateway.kalelogistics.com/$apiName";
    print("fetch data for API = $newURL");
    var url = Uri.parse(newURL);
    url = Uri.https(url.authority, url.path, payload);
    return await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }).then((http.Response response) {
      print(response.body);
      print(response.statusCode);

      final int statusCode = response.statusCode;
      if (statusCode == 401) {
        return Post.fromJson(response.body, statusCode);
      }
      if (statusCode < 200 || statusCode > 400) {
        return Post.fromJson(response.body, statusCode);
      }
      print("sending data to post");
      return Post.fromJson(response.body, statusCode);
    });


  }
}

class Post {
  final int statusCode;
  final String body;

  Post({required this.statusCode, required this.body});

  factory Post.fromJson(String json, int statusCode) {
    return Post(
      statusCode: statusCode,
      body: json,
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["statusCode"] = statusCode;
    map["body"] = body;
    return map;
  }
}
