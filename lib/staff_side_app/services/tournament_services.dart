import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class TournamentServices {
  Future<List<String>> getTournamentSports() async {
    List<String> tournamentSports = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/tournamentManagement/getSports'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          List<dynamic> sports = jsonDecode(res.body);
          tournamentSports = sports.map((e) => e['sport'].toString()).toList();
        },
      );
    } catch (e) {
      print({e.toString()});
    }
    return tournamentSports;
  }
}
