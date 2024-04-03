import 'package:cloud_firestore/cloud_firestore.dart';

class IssuedEquipments {
  IssuedEquipments({
    required this.usn,
    required this.issuedEquipmentsIds,
    required this.issuedTime,
  });
  
  final String usn;
  final List<String> issuedEquipmentsIds;
  final Timestamp issuedTime;

  Map<String, dynamic> toJson() => {
        'usn': usn,
        'equipmentIds': issuedEquipmentsIds,
        'issuedTime': issuedTime,
      };
}
