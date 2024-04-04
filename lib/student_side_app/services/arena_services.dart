import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';

class ArenaServices {
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

  Future<Map<String, String?>?> getDetailsOfBookedSlots(String usn) async {
    Map<String, String?>? bookedSlotDetails;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/arenaManagement/getBookedSlotDetails/$usn'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          final temp = List.from(jsonDecode(res.body));
          if(temp.isNotEmpty){
            var slot = temp.first;
          slot = {
            'slotNo': slot['slotNo'].toString(),
            'arenaId': slot['arenaId'].toString(),
            'slotStartTime': slot['slotStartTime'].toString(),
            'slotEndTime': slot['slotEndTime'].toString(),
            'bookedBy': slot['bookedBy']?.toString(),
          };

          print(slot);
          bookedSlotDetails = slot;
          }
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return bookedSlotDetails;
  }

  Future<void> cancelBooking(
      String usn, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/arenaManagement/cancelBooking'),
        body: jsonEncode({
          "bookedBy": usn,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Booking cancelled successfully'),
            ),
          );
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  /*Future<bool> checkUserHasBookedSlot(String usn) async {
    bool userHasBooked = false;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/arenaManagement/checkUserHasBookedSlot/$usn'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          userHasBooked = jsonDecode(res.body);
        },
      );
    } catch (e) {
      print(e.toString());
    }
    return userHasBooked;
  }*/
}
