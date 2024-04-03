import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sports_complex_ms/data/main_inventory_data.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/staff_side_app/services/main_inventory_query.dart';

List<String> _generateIds(int n, String lastEqpId) {
  var number = int.tryParse(lastEqpId.substring(lastEqpId.length - 2));
  List<String> idList = [];

  for (int i = 0; i < n; i++) {
    number = number! + 1;
    String numberStr = '$number'.padLeft(2, '0');
    var id = lastEqpId.substring(0, lastEqpId.length - 2);
    id = id + numberStr;
    idList.add(id);
  }
  return idList;
}

class MainInventoryListNotifier
    extends StateNotifier<List<MainInventoryEquipment>> {
  MainInventoryListNotifier() : super([]);

  Future<void> fetchMainInventoryItems(String sport, String equipment) async {
    final mainInventoryList =
        await MainInventoryQueries().fetchList(sport, equipment);
    state = mainInventoryList;
  }

  Future<void> addNewStock(
      int n, String equipment, String sport, BuildContext context) async {
    var list = state;

    final lastIndex = list.length - 1;
    final lastEqpId = list[lastIndex].equipmentId;
    final idList = _generateIds(n, lastEqpId);
    List<dynamic> tempList = [];

    for (int i = 0; i < n; i++) {
      tempList.add(
        [idList[i], equipment, sport, null, 'newStock', 0],
      );
    }

    await MainInventoryQueries().addNewStock(tempList, context);
    await fetchMainInventoryItems(sport, equipment);
  }

  Future<void> changeStatus(
      String status, String equipmentId, String sport, String equipment, BuildContext context) async {
    await MainInventoryQueries().updateStatus(status, equipmentId, context);
    await fetchMainInventoryItems(sport, equipment);
  }

  Future<void> editToInUse(int diff, String sport, String equipment, BuildContext context) async {
    final tempList = state;
    final newStockList = tempList.where((e) => e.status == 'newStock').toList();

    List<String> newStockIdsList =
        newStockList.map((e) => e.equipmentId).toList();
    newStockIdsList = newStockIdsList.sublist(0, diff);
    await MainInventoryQueries().editInUse(newStockIdsList, context);
    await fetchMainInventoryItems(sport, equipment);
  }
}

final mainInventoryListProvider = StateNotifierProvider<
    MainInventoryListNotifier, List<MainInventoryEquipment>>(
  (ref) => MainInventoryListNotifier(),
);

final countMapProvider = Provider<Map<String, int>>((ref) {
  final list = ref.watch(mainInventoryListProvider);

  if (list.isNotEmpty) {
    final map = {
      'total': list.length,
      'in use': list.where((e) => e.status == 'inUse').toList().length,
      'new stock': list.where((e) => e.status == 'newStock').toList().length,
      'damaged': list.where((e) => e.status == 'damaged').toList().length,
    };
    return map;
  }
  return {'total': 0, 'in use': 0, 'new stock': 0, 'damaged': 0};
});


/*final selectedSportProvider = StateProvider<String?>((ref) => null);
final selectedEquipmentProvider = StateProvider<String?>((ref) => null);

final sportEquipmentFilteredListProvider =
    Provider<List<MainInventoryEquipment>>((ref) {
  final mainInventoryList = ref.watch(mainInventoryListProvider);
  final sport = ref.watch(selectedSportProvider);
  final equipment = ref.watch(selectedEquipmentProvider);
  final list = sport == null || equipment == null
      ? mainInventoryList
      : mainInventoryList
          .where((e) => e.sport == sport && e.equipmentName == equipment)
          .toList();
  return list;
});*/