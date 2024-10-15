import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lpms/util/Uitlity.dart';
import 'dart:convert';
import '../models/IPInfo.dart';
import '../models/SelectionModel.dart';
import '../util/Global.dart';

class AuthService {
  Future<Post> getUserAuthenticationDetails(service, payload, headers) async {
    print("payload $payload");
    print("encoded payload ${json.encode(payload)}");
    return fetchLoginDataPOST(service, payload, headers);
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
      'Authorization': 'Bearer ${loginMaster[0].token}',
      // Use your token type (Bearer, Basic, etc.)
    };

    if (payload == "") {
      debugPrint("payload blank");
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers: headers,
      )
          .then((http.Response response) {
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
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: headers,
      )
          .then((http.Response response) {
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

  Future<Post> fetchLoginDataPOST(apiName, payload, headers) async {
    var newURL = "https://acsintapigateway.kalelogistics.com/$apiName";
    debugPrint("fetch data for API = $newURL");

    if (payload == "") {
      debugPrint("payload blank");
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode({}),
        headers: headers,
      )
          .then((http.Response response) {
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
      return await http
          .post(
        Uri.parse(newURL),
        body: json.encode(payload),
        headers: headers,
      )
          .then((http.Response response) {
        Utils.printPrettyJson(response.body);
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



  Future<Post> sendMultipartRequest({
    required String endPoint,
    required Map<String, String> headers,
    required Map<String, String> fields,
  }) async {
    var url = "https://acsintapigateway.kalelogistics.com/$endPoint";
    print(url);
    var uri = Uri.parse(url);
    var request = http.MultipartRequest('POST', uri);

    request.fields.addAll(fields);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();
      return await handleResponse(response);
    } catch (e) {
      throw Exception("Failed to send multipart request: $e");
    }
  }

  Future<Post> handleResponse(http.StreamedResponse response) async {
    final int statusCode = response.statusCode;
    final String responseBody = await response.stream.bytesToString();

    print('Response: $responseBody');
    print('Status code: $statusCode');


    if (statusCode == 401) {
      return Post.fromJson(responseBody, statusCode);
    }

    if (statusCode < 200 || statusCode > 400) {
      throw Exception("Error while fetching data: $statusCode");
    }

    return Post.fromJson(responseBody, statusCode);
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
