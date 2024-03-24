import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void httpErrorHandle({
  required Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;

    case 400:
      print(jsonDecode(response.body)['msg']);

    case 500:
      print(jsonDecode(response.body)['error']);

    default:
      print(jsonDecode(response.body));
  }
}
