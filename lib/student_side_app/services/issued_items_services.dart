import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class IssuedItemsServices{
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
}