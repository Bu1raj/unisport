import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class EquipmentQuery {
  Future<List<String>> getFreeEquipments(String sport, String equipment) async {
    List<String> l = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/inventory/freeEquipments/$sport/$equipment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          final decodedList = List.from(jsonDecode(res.body));
          l = decodedList.map((e) => e.toString()).toList();
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return l;
  }

  Future<void> editIssued(List<String> idList) async {
    try {
      print(jsonEncode({"idList": idList}));

      http.Response res = await http.post(
        Uri.parse('$uri/inventory/editIssued'),
        body: jsonEncode({"idList": idList}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            print(res.body);
          });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, String>> fetchCorrespondingEquipmentNames(
      List<String> idList) async {
    Map<String, String> map = {};
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/returnScreen/details'),
        body: jsonEncode({"idList": idList}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
        response: res,
        onSuccess: () {
          map = Map<String, String>.from(jsonDecode(res.body));
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return map;
  }

  Future<void> freeIssued(List<String> idList) async {
    try {
      print(jsonEncode({"idList": idList}));

      http.Response res = await http.post(
        Uri.parse('$uri/inventory/freeIssued'),
        body: jsonEncode({"idList": idList}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            print(res.body);
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
