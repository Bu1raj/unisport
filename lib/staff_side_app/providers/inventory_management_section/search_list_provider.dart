import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/staff_side_app/providers/inventory_management_section/filtered_list_provider.dart';

final mainInventorySearchQueryProvider = StateProvider((ref) => '');

final searchListProvider = Provider<List<MainInventoryEquipment>>((ref) {
  final listToBeSearched = ref.watch(filteredMainInventoryListProvider);
  final query = ref.watch(mainInventorySearchQueryProvider);

  if (query.isEmpty) {
    return listToBeSearched;
  } else {
    return listToBeSearched.where((e) => e.equipmentId.contains(query)).toList();
  }
});

