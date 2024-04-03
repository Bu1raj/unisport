import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/staff_side_app/providers/inventory_management_section/main_inventory_provider.dart';

final filterProvider = StateProvider<String>((ref) => 'all');

final filteredMainInventoryListProvider = Provider<List<MainInventoryEquipment>>((ref) {
  final filter = ref.watch(filterProvider);
  final list = ref.watch(mainInventoryListProvider);

  if (filter == 'in use') {
    return list.where((e) => e.status == 'inUse').toList();
  } else if (filter == 'new stock') {
    return list.where((e) => e.status == 'newStock').toList();
  } else if (filter == 'damaged') {
    return list.where((e) => e.status == 'damaged').toList();
  }
  return list;
});
