import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


var netAddr='http://139.9.206.3:13208/cloud-napi/v1/';


void register({required String phone,required String password}) async{
  var url = Uri.parse(netAddr+'register');
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '<Your token>'
  };
  final msg = jsonEncode({'phone': phone, 'password': password});

  var response = await http.post(url,headers: requestHeaders,body: msg);
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  Map result= jsonDecode(response.body);

  var nnx="";
  if(result["code"]==1){
    nnx="注册成功";
    print("fuck1");
  }else{
    nnx="注册失败， 用户已存在";
    print("fuck12");
  }
    Fluttertoast.showToast(
        msg: nnx,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor:  Color(0xa0000000),
        textColor: Colors.white,
        fontSize: 16.0
    );
}