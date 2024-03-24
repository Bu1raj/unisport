import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class MapService {
  Future<Map<String, List<String>>> mapService() async {
    final Map<String, List<String>> finalMap = {};

    http.Response res = await http.get(
      Uri.parse('$uri/map'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    httpErrorHandle(
      response: res,
      onSuccess: () {
        final decodedData = jsonDecode(res.body);
        final temp = List.from(decodedData);

        for (final e in temp) {
          final sport = e['sport'].toString();
          final equipments = e['available_equipments'].toString();

          final equipmentsList =
              equipments.split(',').map((e) => e.trim().toString()).toList();

          finalMap[sport] = equipmentsList;
        }
      },
    );
    print(finalMap);
    return finalMap;
  }
}
