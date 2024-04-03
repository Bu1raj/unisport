import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sports_complex_ms/constants/error_handle.dart';
import 'package:sports_complex_ms/constants/global_constants.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';

class MainInventoryQueries {
  Future<List<MainInventoryEquipment>> fetchList(
      String sport, String equipment) async {
    List<MainInventoryEquipment> list = [];
    print('$sport $equipment');
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/mainInventory/getInventory/$sport/$equipment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          final decodedData = jsonDecode(res.body);

          final temp = List.from(decodedData);
          print(decodedData);

          for (final e in temp) {
            final date = e['startedUsingOn'] == null
                ? null
                : DateFormat('yyyy-MM-ddTHH:mm:ss.SSS' 'Z')
                    .tryParse(e['startedUsingOn']);

            list.add(
              MainInventoryEquipment(
                equipmentId: e['equipmentId'],
                equipmentName: e['equipmentName'],
                sport: e['sport'],
                startedUsingOn: date,
                status: e['statusEq'],
              ),
            );
          }
        },
      );
    } catch (e) {
      print('error handling fetch request');
    }
    return list;
  }

  Future<void> addNewStock(List<dynamic> items, BuildContext context) async {
    //final list = items.map((e) => e.toList().add(0)).toList();
    print(items);
    //print(jsonEncode({"itemsToBeAdded": items}));
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/mainInventory/addNewStock'),
        body: jsonEncode({"itemsToBeAdded": items}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${items.length} items added successfully'),
              ),
            );
          });
    } catch (e) {
      print('An error occurred ${e.toString()}');
    }
  }

  Future<void> updateStatus(
      String status, String equipmentId, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/mainInventory/changeStatus'),
        body: jsonEncode({'equipmentId': equipmentId, 'status': status}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$equipmentId updated to $status successfully'),
              ),
            );
          });
    } catch (e) {
      print('error changing status');
    }
  }

  Future<void> editInUse(List<String> newStockIds, BuildContext context) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/mainInventory/editInUse'),
        body: jsonEncode({"newStockIds": newStockIds}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      httpErrorHandle(
          response: res,
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('${newStockIds.length} items have been put to inUse'),
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }
}
