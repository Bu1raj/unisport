import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:sports_complex_ms/providers/inventory_management_section/main_inventory_provider.dart';
import 'package:sports_complex_ms/screens/inventory_management_section/management_screen.dart';

class InventoryMainScreenItem extends ConsumerWidget {
  const InventoryMainScreenItem({
    super.key,
    required this.sport,
    required this.availableEquipments,
  });

  final String sport;
  final List<String> availableEquipments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        /*ref.read(selectedSportProvider.notifier).update((state) => sport);

        ref
            .read(selectedEquipmentProvider.notifier)
            .update((state) => categoriesEquipmentsMap[sport]![0]);*/

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ManagementScreen(
              sport: sport,
              availableEquipments: availableEquipments,
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 35,
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 5,
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 30, 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sport,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white,
                    ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
