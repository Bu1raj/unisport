import 'package:flutter/material.dart';
//import 'package:sports_complex_ms/data/dummy_data.dart';
//import 'package:sports_complex_ms/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/services/get_free_equipments.dart';

class IssueAnEquipment extends StatefulWidget {
  const IssueAnEquipment({
    super.key,
    required this.selectedSport,
    required this.initialSelectedEquipment,
    required this.addEquipment,
    required this.temporaryIds,
    required this.map,
  });

  final String selectedSport;
  final String initialSelectedEquipment;
  final void Function(String, String) addEquipment;
  final List<String> temporaryIds;
  final Map<String, List<String>> map;

  @override
  State<IssueAnEquipment> createState() {
    return _IssueAnEquipmentState();
  }
}

class _IssueAnEquipmentState extends State<IssueAnEquipment> {
  String? _selectedEquipment;
  String? _validSelectedEquipmentId;
  bool _isLoading = true;

  Future<void> _fetchValidSelectedEquipmentId(sport, equipment) async {
    List<String> validEquipmentIds =
        await EquipmentQuery().getFreeEquipments(sport, equipment);

    validEquipmentIds = validEquipmentIds
        .where(
          (e) => !widget.temporaryIds.contains(e),
        )
        .toList();

    if (validEquipmentIds.isEmpty) {
      setState(() {
        _isLoading = false;
        _validSelectedEquipmentId = null;
      });
    } else {
      setState(() {
        _isLoading = false;
        _validSelectedEquipmentId = validEquipmentIds.first;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedEquipment = widget.initialSelectedEquipment;
    _fetchValidSelectedEquipmentId(widget.selectedSport, _selectedEquipment);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        //final width = constraints.maxWidth;
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: constraints.maxHeight,
            maxWidth: constraints.maxWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.grey),
                    ],
                  ),
                  child: DropdownButton(
                    value: _selectedEquipment,
                    items: [
                      for (final equipment in widget.map[widget.selectedSport]!)
                        DropdownMenuItem(
                          value: equipment,
                          child: Text(
                            equipment,
                            style: const TextStyle(fontSize: 17),
                          ),
                        )
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedEquipment = value!;
                        _isLoading = true;
                        _fetchValidSelectedEquipmentId(
                            widget.selectedSport, _selectedEquipment);
                      });
                    },
                    padding: const EdgeInsets.symmetric(
                      vertical: 1,
                      horizontal: 10,
                    ),
                    underline: Container(),
                    dropdownColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Row(
                          children: [
                            const Text(
                              'ID :  ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Text(
                              _validSelectedEquipmentId == null
                                  ? 'No equipments available'
                                  : _validSelectedEquipmentId!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: _validSelectedEquipmentId == null
                                    ? Colors.red
                                    : Colors.green,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_validSelectedEquipmentId == null) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title:
                                        const Text('No Equipments available'),
                                    content: const Text(
                                        'Please try again later or choose a different equipment or sport'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                        child: const Text('Okay'),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                widget.addEquipment(_validSelectedEquipmentId!,
                                    _selectedEquipment!);
                                Navigator.pop(context);
                              }
                            },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}



/*Expanded(
                    child: ListView.builder(
                        itemCount: addItemList.length,
                        itemBuilder: (ctx, index) {
                          return addItemList[index];
                        }),
                  ),*/

                  /*Expanded(
                    child: ListView.builder(
                      itemCount: addItemList.length,
                      itemBuilder: (context, index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(addItemList[index]),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField(
                                  //value: _selectedCategory,
                                  items: [
                                    for (final sport
                                        in categoriesEquipmentsMap.entries)
                                      DropdownMenuItem(
                                        value: sport.key,
                                        child: Text(sport.key),
                                      )
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value!;
                                      try {
                                        _selectedCategorySet[index] =
                                            _selectedCategory;
                                      } catch (e) {
                                        _selectedCategorySet
                                            .add(_selectedCategory);
                                      }

                                      _availableEquipments =
                                          categoriesEquipmentsMap[
                                              _selectedCategorySet[index]]!;
                                      /*_selectedEquipment =
                                          _availableEquipments[0];*/
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: DropdownButtonFormField(
                                  //value: _selectedEquipment,
                                  items: [
                                    for (final equipment
                                        in _availableEquipments)
                                      DropdownMenuItem(
                                        value: equipment,
                                        child: Text(equipment),
                                      ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEquipment = value!;
                                      try {
                                        _selectedEquipmentSet[index] =
                                            _selectedEquipment;
                                      } catch (e) {
                                        _selectedEquipmentSet
                                            .add(_selectedEquipment);
                                      }
                                      _validSelectedEquipmentId =
                                          _fetchValidSelectedEquipmentId(
                                              _selectedCategorySet[index],
                                              _selectedEquipmentSet[index]);
                                      try{
                                        _validSelectedEquipmentIdSet[index] =
                                          _validSelectedEquipmentId;
                                      }catch(e){
                                        _validSelectedEquipmentIdSet.add(_validSelectedEquipmentId);
                                      }
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
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                addItemList.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),*/