import 'dart:convert';

import 'package:intl/intl.dart';

class Equipment {
  Equipment({
    required this.equipmentName,
    required this.equipmentId,
    required this.sport,
  });

  final String equipmentName;
  final String equipmentId;
  final String sport;
}

enum Status {
  inUse,
  damaged,
  newStock,
}

class MainInventoryEquipment extends Equipment {
  MainInventoryEquipment({
    required super.equipmentId,
    required super.equipmentName,
    required super.sport,
    required this.startedUsingOn,
    required this.status,
  });

  final DateTime? startedUsingOn;
  String status;

  Map<String, dynamic> toMap() {
    return {
      'equipmentId': equipmentId,
      'equipmentName': equipmentName,
      'sport': sport,
      'startedUsingOn': startedUsingOn == null ? null:
          DateFormat('yyyy-MM-ddTHH:mm:ss.SSS' 'Z').format(startedUsingOn!),
      'statusEq': status
    };
  }

  List<dynamic> toList() {
    return [
      equipmentId,
      equipmentName,
      sport,
      startedUsingOn == null ? null : DateFormat('yyyy-MM-ddTHH:mm:ss.SSS' 'Z').format(startedUsingOn!),
      status,
    ];
  }

  String toJson() => jsonEncode(toMap());
}

class InUseEquipment extends Equipment {
  InUseEquipment({
    required super.equipmentName,
    required super.equipmentId,
    required super.sport,
    bool? issued,
  }) : issued = issued ?? false;
  bool issued;
}
