// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sports_complex_ms/data/dummy_data.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';

class IssueEquipmentFormWidget extends StatefulWidget {
  IssueEquipmentFormWidget({
    super.key,
    required this.index,
    required this.deleteEquipment,
    //required this.id,
  });
  final void Function(int index) deleteEquipment;
  int index;
  //String id;

  @override
  State<IssueEquipmentFormWidget> createState() =>
      _IssueEquipmentFormWidgetState();
}

class _IssueEquipmentFormWidgetState extends State<IssueEquipmentFormWidget> {
  String _selectedCategory = categoriesEquipmentsMap.entries.first.key;
  List<String> _availableEquipments =
      categoriesEquipmentsMap.entries.first.value;
  String? _selectedEquipment = categoriesEquipmentsMap.entries.first.value[0];
  String? _validSelectedEquipmentId;

  String? _fetchValidSelectedEquipmentId(category, equipment) {
    final List<InUseEquipment> validEquipments = inventory
        .where((element) => (element.sport == category &&
            element.equipmentName == equipment &&
            !element.issued))
        .toList();

    if (validEquipments.isEmpty) return null;
    return validEquipments.first.equipmentId;
  }

  @override
  Widget build(BuildContext context) {
    _validSelectedEquipmentId =
        _fetchValidSelectedEquipmentId(_selectedCategory, _selectedEquipment);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField(
                value: _selectedCategory,
                items: [
                  for (final sport in categoriesEquipmentsMap.entries)
                    DropdownMenuItem(
                      value: sport.key,
                      child: Text(sport.key),
                    )
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                    _availableEquipments =
                        categoriesEquipmentsMap[_selectedCategory]!;
                    _selectedEquipment = _availableEquipments[0];
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField(
                value: _selectedEquipment,
                items: [
                  for (final equipment in _availableEquipments)
                    DropdownMenuItem(
                      value: equipment,
                      child: Text(equipment),
                    ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedEquipment = value!;
                    _validSelectedEquipmentId = _fetchValidSelectedEquipmentId(
                        _selectedCategory, _selectedEquipment);
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            const Text('Equipment ID: '),
            const SizedBox(width: 32),
            _validSelectedEquipmentId == null
                ? const Icon(
                    Icons.close,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
            _validSelectedEquipmentId == null
                ? const Text(
                    'No equipments available',
                    style: TextStyle(color: Colors.red),
                  )
                : Text(
                    _validSelectedEquipmentId!,
                    style: const TextStyle(color: Colors.green),
                  ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                  widget.deleteEquipment(widget.index);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
