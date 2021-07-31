import 'package:ajax/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



Future<AjaxUser> getAjaxUser()async{
  return callApi("getUser", "get").then((user) => AjaxUser.fromJson(user));
}

Future<bool> makePayment(String recipientId, num amount, String message) async{
  String senderId = FirebaseAuth.instance.currentUser!.uid;
  return callApi("makePayment", "post", params: {
    "senderId": senderId,
    "recipientId": recipientId,
    "amount": amount.toString(),
    "message": message,
  }).then((response) => response["success"]);
}

Future<Map<String, dynamic>> callApi(String url, String method, {Map<String, dynamic> params = const {}}){
  print(params);
  method = method.toLowerCase();
  User? currentUser = FirebaseAuth.instance.currentUser;
  return currentUser!.getIdToken().then((token) async {
    var uri = Uri.parse("https://us-central1-ajax-b5934.cloudfunctions.net/api/" + url);
    var response;
    if(method == "get"){
      response = await http.get(uri, headers: {"Authorization": "Bearer " + token});
    }
    else if(method == "post"){
      response = await http.post(uri, headers: {"Authorization": "Bearer " + token}, body: params );
    }
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // print(json.decode(response.body));
    // print(json.decode(response.body)["display_name"]);
    return json.decode(response.body);
  });
}

  