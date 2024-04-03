import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/issued_equipments.dart';
import 'package:sports_complex_ms/staff_side_app/providers/issued_items_provider.dart';
import 'package:sports_complex_ms/staff_side_app/providers/sport_eqipments_map_provider.dart';
import 'package:sports_complex_ms/staff_side_app/screens/issue_return_section/issue_euipment_overlay.dart';
import 'package:sports_complex_ms/staff_side_app/services/get_free_equipments.dart';

final _firestore = FirebaseFirestore.instance;

class IssueScreenTwo extends ConsumerStatefulWidget {
  const IssueScreenTwo({
    super.key,
    required this.switchTab,
  });

  final void Function() switchTab;
  @override
  ConsumerState<IssueScreenTwo> createState() {
    return _IssueScreenTwoState();
  }
}

class _IssueScreenTwoState extends ConsumerState<IssueScreenTwo> {
  final _formKey = GlobalKey<FormState>();
  String? _enteredUsn;
  String _selectedSport = 'cricket';
  String initialSelectedEquipment = 'bat';
  final Map<String, String> _addedEquipmentMap = {};
  final List<String> _temporaryIds = [];
  final TextEditingController usnTextController = TextEditingController();
  bool _isIssuing = false;

  void _openIssueItemOverlay(
      screenWidth, screenheight, String intialSelectedEquipment, map) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        minWidth: screenWidth,
        maxHeight: screenheight * 0.25,
      ),
      context: context,
      builder: (ctx) => IssueAnEquipment(
        selectedSport: _selectedSport,
        initialSelectedEquipment: initialSelectedEquipment,
        addEquipment: _addEquipment,
        temporaryIds: _temporaryIds,
        map: map,
      ),
    );
  }

  void _addEquipment(String id, String equipment) {
    setState(() {
      final entry = <String, String>{id: equipment};
      _addedEquipmentMap.addEntries(entry.entries);
      _temporaryIds.add(id);
    });
  }

  void _confirmIssue(WidgetRef ref, BuildContext context) async {
    if (_temporaryIds.isEmpty) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Nothing added!!'),
          content: const Text('Try adding equipments or cancelling the issue'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                setState(() {
                  _isIssuing = false;
                });
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    } else if (_formKey.currentState!.validate()) {
      usnTextController.text = usnTextController.text.trim();

      final snapshots = await _firestore.collection('users').get();

      try {
        snapshots.docs
            .firstWhere((doc) => doc.data()['usn'] == usnTextController.text);

        _formKey.currentState!.save();

        await EquipmentQuery().editIssued(_temporaryIds);

        setState(() {
          _isIssuing = false;
        });

        if (context.mounted) {
          await ref.read(issuedEquipmentsDetailsProvider.notifier).addItem(
                IssuedEquipments(
                  usn: _enteredUsn!,
                  issuedEquipmentsIds: _temporaryIds,
                  issuedTime: Timestamp.now(),
                ),
                context,
              );
          widget.switchTab();
        }
      } on StateError {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Invalid USN!!'),
              content: const Text('This USN has not been registered'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    setState(() {
                      _isIssuing = false;
                    });
                    return;
                  },
                  child: const Text('Okay'),
                ),
              ],
            ),
          );
        }
      }
    }
  }

  void _deleteEquipment(index) {
    setState(() {
      final key = _addedEquipmentMap.entries.elementAt(index).key;
      _addedEquipmentMap.remove(key);
      _temporaryIds.remove(key);
    });
  }

  @override
  void initState() {
    /*final tempMap = ref.read(mapProvider);
    _selectedSport = tempMap.entries.first.key;
    initialSelectedEquipment = tempMap[_selectedSport]!.first;*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final issuedEquipmentList = ref.read(issuedEquipmentsDetailsProvider);
    final sportEquipmentsMap = ref.watch(mapProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    Widget mainContent;

    if (sportEquipmentsMap.isEmpty) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      Widget content = Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No equipments added yet',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.black26, fontSize: 18),
                ),
                const SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    text: 'Tap on ',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.black26,
                        ),
                    children: [
                      const WidgetSpan(
                        child: Icon(
                          Icons.add_circle_sharp,
                          color: Colors.black26,
                        ),
                      ),
                      TextSpan(
                        text: ' to add equipments',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.black26,
                            ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

      if (_addedEquipmentMap.isNotEmpty) {
        content = Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              itemCount: _addedEquipmentMap.length,
              itemBuilder: (context, index) => Card(
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            _addedEquipmentMap.entries.elementAt(index).value,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 100,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              _addedEquipmentMap.entries.elementAt(index).key,
                              maxLines: 1,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            _deleteEquipment(index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
      mainContent = Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //const SizedBox(height: 95),
              Center(
                child: Container(
                  width: screenWidth * 0.85,
                  height: screenHeight * 0.65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.characters,
                            controller: usnTextController,
                            maxLength: 11,
                            decoration:
                                const InputDecoration(labelText: 'Enter USN'),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.trim().length != 10 ||
                                  !value.contains('1RV')) {
                                setState(() {
                                  _isIssuing = false;
                                });
                                return 'Enter a valid USN';
                              }

                              value = value.trim();

                              if (issuedEquipmentList == null) {
                                showDialog(
                                    context: context,
                                    builder: (ctx) => const SimpleDialog(
                                          title: CircularProgressIndicator(),
                                        ));
                              }

                              final List<IssuedEquipments> duplicateUsns =
                                  issuedEquipmentList!
                                      .where((element) => element.usn == value)
                                      .toList();

                              if (duplicateUsns.isNotEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Invalid USN!!'),
                                    content: const Text(
                                        'This USN has already been issued with some items'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(ctx).pop();
                                          setState(() {
                                            _isIssuing = false;
                                          });
                                        },
                                        child: const Text('Okay'),
                                      ),
                                    ],
                                  ),
                                );
                                return 'Enter a valid USN';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredUsn = value!;
                            },
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Sport',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 5),
                          DropdownButtonFormField(
                            padding: const EdgeInsets.only(right: 150, left: 0),
                            dropdownColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(10),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            value: _selectedSport,
                            items: [
                              for (final sport in sportEquipmentsMap.entries)
                                DropdownMenuItem(
                                  value: sport.key,
                                  child: Text(
                                    sport.key,
                                  ),
                                )
                            ],
                            onChanged: (value) {
                              setState(() {
                                final prevSport = _selectedSport;
                                _selectedSport = value!;
                                initialSelectedEquipment =
                                    sportEquipmentsMap[_selectedSport]!.first;
                                if (prevSport != _selectedSport) {
                                  _addedEquipmentMap.clear();
                                  _temporaryIds.clear();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Equipments',
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(width: 20),
                          content,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton.filled(
                                onPressed: () {
                                  _openIssueItemOverlay(
                                      screenWidth,
                                      screenHeight,
                                      initialSelectedEquipment,
                                      sportEquipmentsMap);
                                },
                                iconSize: 20,
                                icon: const Icon(Icons.add),
                                color: Colors.white,
                              ),
                              const SizedBox(width: 100),
                              TextButton(
                                onPressed: () {
                                  widget.switchTab();
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(width: 5),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isIssuing = true;
                                  });
                                  _confirmIssue(ref, context);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                child: _isIssuing
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text('Issue'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: mainContent,
    );
  }
}
