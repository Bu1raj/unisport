import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class ArenaManagementQuery {
  Future<List<String>> getSports() async {
    List<String> sportsList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/arenaManagement/getSports'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            final result = List.from(jsonDecode(res.body));
            sportsList = result.map((e) => e['sport'].toString()).toList();
          });
    } catch (e) {
      print(e.toString());
    }
    return sportsList;
  }

  Future<List<Map<String, String>>> getArenasOfASport(String sport) async {
    List<Map<String, String>> arenasList = [];
    try {
      http.Response res = await http.get(
        Uri.parse(
          '$uri/arenaManagement/getArenas/$sport',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          var temp = List.from(jsonDecode(res.body));

          for (final i in temp) {
            final t = {
              'arenaId': i['arenaId'].toString(),
              'arenaName': i['arenaName'].toString()
            };
            arenasList.add(t);
          }
          print(arenasList);
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return arenasList;
  }

  Future<List<Map<String, String?>>> getSlotDetails(String arenaId) async {
    List<Map<String, String?>> slotDetails = [];
    try {
      http.Response res = await http.get(
        Uri.parse(
          '$uri/arenaManagement/getSlotDetails/$arenaId',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          final temp = List.from(jsonDecode(res.body));
          for (final i in temp) {
            final t = {
              'slotNo': i['slotNo'].toString(),
              'arenaId': i['arenaId'].toString(),
              'slotStartTime': i['slotStartTime'].toString(),
              'slotEndTime': i['slotEndTime'].toString(),
              'bookedBy': i['bookedBy']?.toString(),
            };
            slotDetails.add(t);
          }
          print(slotDetails);
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return slotDetails;
  }

  Future<void> bookASlot(
      String slotNo, String arenaId, String usn, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/arenaManagement/bookASlot'),
        body:
            jsonEncode({"slotNo": slotNo, "arenaId": arenaId, "bookedBy": usn}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Slot-${slotNo.substring(slotNo.length - 1)} booked successfully'),
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
