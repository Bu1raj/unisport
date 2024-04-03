import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sports_complex_ms/data/dummy_data.dart';
import 'package:sports_complex_ms/staff_side_app/services/map_service.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/inventory_management_section/inventory_main_screen_item.dart';

class InventoryMainScreen extends ConsumerStatefulWidget {
  const InventoryMainScreen({super.key});

  @override
  ConsumerState<InventoryMainScreen> createState() =>
      _InventoryMainScreenState();
}

class _InventoryMainScreenState extends ConsumerState<InventoryMainScreen> {
  Map<String, List<String>> sportEquipmentsMap = {};
  bool _isLoading = true;

  Future<void> loadItems() async {
    sportEquipmentsMap = await MapService().mapService();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sportsList = sportEquipmentsMap.keys.toList();

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sportsList.length,
              itemBuilder: (context, index) => InventoryMainScreenItem(
                sport: sportsList[index],
                availableEquipments: sportEquipmentsMap[sportsList[index]]!,
              ),
            ),
          );
  }
}
