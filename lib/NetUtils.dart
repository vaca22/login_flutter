import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

var netAddr = 'https://www.vaca.vip/cloud-napi/v1/';

Future<bool> register({required String phone, required String password}) async {
  var url = Uri.parse(netAddr + 'register');
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*'
  };
  final msg = jsonEncode({'phone': phone, 'password': password});

  var response = await http.post(url, headers: requestHeaders, body: msg);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map result = jsonDecode(response.body);


  if (result["code"] == 1) {

    print("fuck1");
    return true;
  } else {
    print("fuck12");
    return false;
  }
}

Future<bool> login({required String phone, required String password}) async {
  print("fuckyouyou2");
  var url = Uri.parse(netAddr + 'login');
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '<Your token>'
  };
  final msg = jsonEncode({'phone': phone, 'password': password});

  var response = await http.post(url, headers: requestHeaders, body: msg);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map result = jsonDecode(response.body);
  print("fuckyouyou");
  if (result["code"] == 1) {
    print("fuck1");
    return true;
  } else {
    print("fuck12");
    return false;
  }
}
