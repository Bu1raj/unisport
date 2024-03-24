import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/models/issue_return_section/issued_equipments.dart';
//import 'package:sports_complex_ms/services/map_service.dart';

final _firestore = FirebaseFirestore.instance;

class IssuedEquipmentsDetailsNotifier
    extends StateNotifier<List<IssuedEquipments>?> {
  IssuedEquipmentsDetailsNotifier() : super(null);

  Future<void> fetchIssuedItems() async {
    final snapshot = await _firestore.collection('issuedEquipments').get();
    final items = snapshot.docs
        .map((doc) => IssuedEquipments(
              usn: doc.data()['usn'],
              issuedEquipmentsIds:
                  List<String>.from(doc.data()['equipmentIds']),
              issuedTime: doc.data()['issuedTime'],
            ))
        .toList();
    state = items;
  }

  Future<void> addItem(
      IssuedEquipments issuedEquipmentsDetails, BuildContext context) async {
    state = [...state!, issuedEquipmentsDetails];

    try {
      await _firestore
          .collection('issuedEquipments')
          .doc(issuedEquipmentsDetails.usn)
          .set(issuedEquipmentsDetails.toJson());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item issued successfully'),
          ),
        );
      }
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              err.toString(),
            ),
          ),
        );

        state = List.from(
          state!.where((e) => e.usn != issuedEquipmentsDetails.usn),
        );
      }
    }
  }

  Future<void> freeEquipments(String usn, BuildContext context) async {
    final index = state!.indexWhere(
      (element) => element.usn == usn,
    );
    try {
      await _firestore.collection('issuedEquipments').doc(usn).delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Returned successfully'),
          ),
        );
      }
      state = List.from(state!)..removeAt(index);
    } catch (err) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error occurred while updating'),
          ),
        );
        state = [...state!];
      }
    }
  }
}

final issuedEquipmentsDetailsProvider = StateNotifierProvider<
    IssuedEquipmentsDetailsNotifier, List<IssuedEquipments>?>(
  (ref) {
    final notifier = IssuedEquipmentsDetailsNotifier();
    notifier.fetchIssuedItems(); // Fetch data on initialization
    return notifier;
  },
);

//query provider for searching
final searchQueryProvider = StateProvider<String>((ref) => '');

//filtered list provider
final filteredListProvider = Provider<List<IssuedEquipments>?>((ref) {
  final list = ref.watch(issuedEquipmentsDetailsProvider);
  final query = ref.watch(searchQueryProvider);

  if (list != null) {
    if (query.isEmpty) {
      return list;
    } else {
      return list
          .where(
            (element) => element.usn.contains(query),
          )
          .toList();
    }
  }
  return null;
});


/*final issuedEquipmentsDetailsProvider = StateNotifierProvider<
    IssuedEquipmentsDetailsNotifier, List<IssuedEquipments>>(
  (ref) {
    return IssuedEquipmentsDetailsNotifier();
  },
);*/
/*class IssuedEquipmentsProvider extends StateNotifier<List<IssuedEquipments>> {
  IssuedEquipmentsProvider() : super([]);

  final _streamController =
      StreamController<List<IssuedEquipments>>.broadcast();

  // Expose the stream to consumers
  @override
  Stream<List<IssuedEquipments>> get stream => _streamController.stream;

  // Method to add issued equipments to the list and update the stream
  void addIssuedEquipments(IssuedEquipments issuedEquipments) {
    state = [...state, issuedEquipments];
    _streamController.add(state);
  }

  // Method to free resources
  void freeResources() {
    _streamController.close();
  }

  // Method to fetch issued equipments from Firestore
  Future<void> fetchIssuedEquipments() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('issuedEquipments').get();
    final issuedEquipmentsList = snapshot.docs
        .map((doc) => IssuedEquipments(
              usn: doc.data()['usn'],
              issuedEquipmentsIds: doc.data()['equipmentIds'],
              issuedTime: doc.data()['issuedTime'],
            ))
        .toList();
    state = issuedEquipmentsList;
    _streamController.add(state);
  }
}

// Provider for IssuedEquipmentsProvider
final issuedEquipmentsProvider = Provider((ref) => IssuedEquipmentsProvider());*/

/*Stream<List<IssuedEquipments>> get issuedEquipmentsStream {
  return FirebaseFirestore.instance
      .collection('issuedEquipments')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => IssuedEquipments(
                usn: doc.data()['usn'],
                issuedEquipmentsIds: doc.data()['equipmentIds'],
                issuedTime: doc.data()['issuedTime'],
              ),
            )
            .toList(),
      );
}*/

/*class IssuedEquipmentsDetailsNotifier
    extends StateNotifier<List<IssuedEquipments>> {
  IssuedEquipmentsDetailsNotifier() : super([]);

  void addItem(IssuedEquipments issuedEquipmentsDetails) {
    state = [...state, issuedEquipmentsDetails];
  }

  void freeEquipments(String usn) {
    final index = state.indexWhere(
      (element) => element.usn == usn,
    );
    state = List.from(state)..removeAt(index);
  }
}*/
