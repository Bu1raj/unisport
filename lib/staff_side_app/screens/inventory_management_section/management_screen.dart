import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/models/issue_return_section/equipment.dart';
import 'package:sports_complex_ms/staff_side_app/providers/inventory_management_section/filtered_list_provider.dart';
import 'package:sports_complex_ms/staff_side_app/providers/inventory_management_section/main_inventory_provider.dart';
import 'package:sports_complex_ms/staff_side_app/providers/inventory_management_section/search_list_provider.dart';

class ManagementScreen extends ConsumerStatefulWidget {
  const ManagementScreen({
    super.key,
    required this.sport,
    required this.availableEquipments,
  });

  final String sport;
  final List<String> availableEquipments;

  @override
  ConsumerState<ManagementScreen> createState() {
    return _ManagementScreenState();
  }
}

class _ManagementScreenState extends ConsumerState<ManagementScreen> {
  String _selectedEquipment = '';
  bool _isLoadingDetails = true;
  bool _isAddingNewItems = false;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _inUseEditingController = TextEditingController();
  bool _isSearching = false;
  bool _showError = false;
  final FocusNode _focusNodeQuantityController = FocusNode();
  final FocusNode _focusNodeInUseEditController = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final filtersLabelList = ['all', 'in use', 'new stock', 'damaged'];
  String _selectedFilter = 'all';

  @override
  void initState() {
    _selectedEquipment = widget.availableEquipments[0];
    loadDetails(ref, widget.sport, _selectedEquipment);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _inUseEditingController.dispose();
    _focusNodeQuantityController.dispose();
    _focusNodeInUseEditController.dispose();
    super.dispose();
  }

  Future<void> loadDetails(
      WidgetRef ref, String sport, String equipment) async {
    await ref
        .read(mainInventoryListProvider.notifier)
        .fetchMainInventoryItems(sport, equipment);
    setState(() {
      _isLoadingDetails = false;
    });
  }

  void _changeStatus(String id, String status, WidgetRef ref) {
    bool isUpdating = false;
    if (status == 'inUse') {
      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(builder: (ctx, setState) {
          return SimpleDialog(
            title: const Text('Mark as damaged ?'),
            contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isUpdating
                        ? null
                        : () {
                            Navigator.of(ctx).pop();
                          },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () async {
                            setState(() {
                              isUpdating = true;
                            });

                            await ref
                                .read(mainInventoryListProvider.notifier)
                                .changeStatus(
                                  'damaged',
                                  id,
                                  widget.sport,
                                  _selectedEquipment,
                                  context,
                                );

                            setState(() {
                              isUpdating = false;
                            });

                            if (ctx.mounted) {
                              Navigator.of(ctx).pop();
                            }
                          },
                    child: isUpdating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Yes'),
                  ),
                ],
              ),
            ],
          );
        }),
      );
    } else if (status == 'damaged') {
      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) {
            return SimpleDialog(
              title: const Text('Item Repaired??'),
              contentPadding: const EdgeInsets.fromLTRB(24, 10, 10, 10),
              children: [
                const Text('Mark as ' 'in use' ''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isUpdating
                          ? null
                          : () {
                              Navigator.of(ctx).pop();
                            },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              setState(() {
                                isUpdating = true;
                              });
                              await ref
                                  .read(mainInventoryListProvider.notifier)
                                  .changeStatus('inUse', id, widget.sport,
                                      _selectedEquipment, context);

                              setState(() {
                                isUpdating = false;
                              });

                              if (ctx.mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                      child: isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Yes'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    } else if (status == 'newStock') {
      showDialog(
        context: context,
        builder: (ctx) => StatefulBuilder(
          builder: (ctx, setState) {
            return SimpleDialog(
              title: const Text('Mark as ' 'in use' ''),
              contentPadding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: isUpdating
                          ? null
                          : () {
                              Navigator.of(ctx).pop();
                            },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 5),
                    ElevatedButton(
                      onPressed: isUpdating
                          ? null
                          : () async {
                              setState(() {
                                isUpdating = true;
                              });
                              await ref
                                  .read(mainInventoryListProvider.notifier)
                                  .changeStatus(
                                    'inUse',
                                    id,
                                    widget.sport,
                                    _selectedEquipment,
                                    context,
                                  );

                              setState(() {
                                isUpdating = false;
                              });

                              if (ctx.mounted) {
                                Navigator.of(ctx).pop();
                              }
                            },
                      child: isUpdating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Yes'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }
  }

  Future<void> _addNewStock(WidgetRef ref) async {
    setState(() {
      _isAddingNewItems = true;
    });
    String text = _quantityController.text.trim();
    int? x = int.tryParse(text);

    if (text.isEmpty || x == null || x <= 0 || x > 5) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid Input'),
          content: const Text('The quantity must be a number between 1 to 5'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    await ref
        .read(mainInventoryListProvider.notifier)
        .addNewStock(x, _selectedEquipment, widget.sport, context);
  }

  void _editInUseNumber(WidgetRef ref, Map countMap) {
    int existingNumber = int.parse(countMap['in use'].toString());
    _inUseEditingController.text = '$existingNumber';
    final list = ref.read(mainInventoryListProvider);
    bool isUpdating = false;

    List<MainInventoryEquipment> newStockList =
        list.where((e) => (e.status == 'newStock')).toList();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => SimpleDialog(
          contentPadding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (int.parse(_inUseEditingController.text) >
                        existingNumber) {
                      _inUseEditingController.text =
                          '${int.parse(_inUseEditingController.text) - 1}';
                    } else {
                      Flushbar(
                        icon: const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ),
                        message: 'Minimum value reached',
                        duration: const Duration(seconds: 2),
                      ).show(ctx);
                    }
                    setState(() {
                      _showError = false;
                    });
                  },
                  icon: Icon(
                    Icons.remove,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 5),
                SizedBox(
                  width: 50,
                  child: TextField(
                      style: const TextStyle(fontSize: 30),
                      keyboardType: TextInputType.number,
                      controller: _inUseEditingController,
                      textAlign: TextAlign.center,
                      focusNode: _focusNodeInUseEditController,
                      onChanged: (value) {
                        setState(() {
                          _showError = false;
                        });
                      }),
                ),
                const SizedBox(width: 5),
                IconButton(
                  onPressed: () {
                    if (int.parse(_inUseEditingController.text) -
                            existingNumber <
                        newStockList.length) {
                      _inUseEditingController.text =
                          '${int.parse(_inUseEditingController.text) + 1}';
                    } else {
                      Flushbar(
                        icon: const Icon(
                          Icons.error_outline,
                          color: Colors.white,
                        ),
                        message: 'Maximum value reached',
                        duration: const Duration(seconds: 2),
                      ).show(ctx);
                    }
                    setState(() {
                      _showError = false;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    size: 20,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            _showError
                ? Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 35,
                          ),
                          const SizedBox(height: 5),
                          if (int.parse(_inUseEditingController.text) -
                                  existingNumber >
                              newStockList.length)
                            Text(
                              'Maximum value that can be entered is ${existingNumber + newStockList.length}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.red,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          if (int.parse(_inUseEditingController.text) <
                              existingNumber)
                            Text(
                              'Minimum value to be entered is $existingNumber',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.red,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: isUpdating
                      ? null
                      : () {
                          _showError = false;
                          Navigator.of(context).pop();
                          _inUseEditingController.text = '$existingNumber';
                        },
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    _focusNodeInUseEditController.unfocus();
                    if (int.parse(_inUseEditingController.text) -
                                existingNumber >
                            newStockList.length ||
                        int.parse(_inUseEditingController.text) <
                            existingNumber) {
                      setState(() {
                        _showError = true;
                      });
                    } else {
                      setState(() {
                        isUpdating = true;
                      });
                      int enteredNumber =
                          int.parse(_inUseEditingController.text);
                      int diff = enteredNumber - existingNumber;
                      await ref
                          .read(mainInventoryListProvider.notifier)
                          .editToInUse(
                              diff, widget.sport, _selectedEquipment, context);
                      setState(() {
                        isUpdating = false;
                      });
                      if (ctx.mounted) {
                        Navigator.of(ctx).pop();
                      }
                    }
                  },
                  child: isUpdating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final searchFilteredList = ref.watch(searchListProvider);
    final countMap = ref.watch(countMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sport),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Choose Equipment',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 18,
                            color: Colors.grey.shade800,
                          ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton(
                        value: _selectedEquipment,
                        items: [
                          for (final eqp in widget.availableEquipments)
                            DropdownMenuItem(
                              value: eqp,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                ),
                                child: Text(eqp),
                              ),
                            ),
                        ],
                        onChanged: (value) async {
                          setState(() {
                            _selectedEquipment = value!;
                            _isSearching = false;
                          });
                          await loadDetails(
                              ref, widget.sport, _selectedEquipment);
                          _searchController.clear();
                          ref
                              .read(mainInventorySearchQueryProvider.notifier)
                              .update((state) => '');

                          //clear filters
                          _selectedFilter = 'all';
                          ref
                              .read(filterProvider.notifier)
                              .update((state) => 'all');
                        },
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 15,
                        ),
                        underline: Container(),
                        dropdownColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 30,
                color: Colors.black38,
              ),
              _isLoadingDetails
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2,
                      children: [
                        Container(
                          //padding: EdgeInsets.only(left: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                countMap['total'].toString(),
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New Stock',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.blue,
                                    ),
                              ),
                              Text(
                                countMap['new stock'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: Colors.blue,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'In Use',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.green,
                                          ),
                                    ),
                                    Text(
                                      countMap['in use'].toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(
                                            color: Colors.green,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _editInUseNumber(ref, countMap);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Damaged',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                              Text(
                                countMap['damaged'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(
                                      color: Colors.red,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const Divider(
                height: 30,
                color: Colors.black38,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.hardEdge,
                elevation: 2,
                child: SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50,
                        color: Theme.of(context).colorScheme.primary,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              !_isSearching
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isSearching = true;
                                        });
                                      },
                                      icon: const Icon(Icons.search),
                                      color: Colors.white,
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          //_searchFilteredList = _filteredList;
                                          ref
                                              .watch(
                                                  mainInventorySearchQueryProvider
                                                      .notifier)
                                              .update((state) => '');
                                          _isSearching = false;
                                        });
                                      },
                                      icon: const Icon(Icons.close),
                                      color: Colors.white,
                                    ),
                              Text(
                                'Equipment List',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              PopupMenuButton(
                                enabled: !_isSearching ? true : false,
                                icon: const Icon(Icons.filter_list),
                                iconColor: Colors.white,
                                onSelected: (value) {
                                  setState(() {
                                    _selectedFilter = value;
                                    ref
                                        .watch(filterProvider.notifier)
                                        .update((state) => value);
                                  });
                                },
                                itemBuilder: (ctx) {
                                  return [
                                    for (final filter in filtersLabelList)
                                      PopupMenuItem(
                                        value: filter,
                                        child: Row(
                                          children: [
                                            Text(filter),
                                            const SizedBox(width: 7),
                                            _selectedFilter == filter
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 20,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                  ];
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      _isSearching
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: TextField(
                                autofocus: true,
                                scrollPadding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Search an ID',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      _searchController.clear();

                                      ref
                                          .read(mainInventorySearchQueryProvider
                                              .notifier)
                                          .update((state) => '');
                                    },
                                    iconSize: 20,
                                    icon: const Icon(Icons.close),
                                  ),
                                ),
                                textCapitalization:
                                    TextCapitalization.characters,
                                controller: _searchController,
                                onChanged: (value) {
                                  //search(value);
                                  ref
                                      .read(mainInventorySearchQueryProvider
                                          .notifier)
                                      .update((state) => value.trim());
                                },
                              ),
                            )
                          : const SizedBox(height: 0, width: 0),
                      _isLoadingDetails
                          ? const Center(child: CircularProgressIndicator())
                          : Expanded(
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const Divider(
                                  height: 5,
                                  color: Colors.black38,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                itemCount: searchFilteredList.length,
                                itemBuilder: (ctx, index) => ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  onTap: () {
                                    _changeStatus(
                                      searchFilteredList[index].equipmentId,
                                      searchFilteredList[index].status,
                                      ref,
                                    );
                                  },
                                  leading: searchFilteredList[index].status ==
                                          'inUse'
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.green,
                                        )
                                      : searchFilteredList[index].status ==
                                              'damaged'
                                          ? const Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.storage,
                                              color: Colors.blue,
                                            ),
                                  title: Text(
                                    searchFilteredList[index].equipmentId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  trailing: Text(
                                    searchFilteredList[index].status,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: searchFilteredList[index]
                                                      .status ==
                                                  'inUse'
                                              ? const Color.fromARGB(
                                                  255, 2, 172, 8)
                                              : searchFilteredList[index]
                                                          .status ==
                                                      'damaged'
                                                  ? const Color.fromARGB(
                                                      255, 196, 1, 1)
                                                  : const Color.fromARGB(
                                                      255, 13, 0, 194),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 30,
                color: Colors.black38,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add new stock',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 15),
                      _isLoadingDetails
                          ? const Center(child: CircularProgressIndicator())
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Enter Quantity : ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        fontSize: 18,
                                      ),
                                ),
                                const SizedBox(width: 15),
                                SizedBox(
                                  width: 75,
                                  child: TextField(
                                    enabled: !_isAddingNewItems,
                                    focusNode: _focusNodeQuantityController,
                                    scrollPadding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.center,
                                    controller: _quantityController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'Ex: 1',
                                      hintStyle: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black45,
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 7, 10, 7),
                                    ),
                                  ),
                                )
                              ],
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _isAddingNewItems
                                ? null
                                : () {
                                    _quantityController.clear();
                                  },
                            child: const Text('Clear'),
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () async {
                              _focusNodeQuantityController.unfocus();
                              await _addNewStock(ref);
                              setState(() {
                                _isAddingNewItems = false;
                                _quantityController.clear();
                                _scrollController.animateTo(0,
                                    duration: const Duration(milliseconds: 700),
                                    curve: Curves.easeInOut);
                              });
                            },
                            child: _isAddingNewItems
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Add'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/*var element =
    _mainList.firstWhere((e) => e.equipmentId == id);
element.status = Status.damaged;
setState(() {
  Navigator.of(ctx).pop();
  _countMap = _getTotalNewDamagedInUSeCount(
      sport, selectedEquipment);
  _filteredList = _filterApplier(
      sport, selectedEquipment, presentFilter);
  search(_searchController.text);
});*/

/*var element =
    _mainList.firstWhere((e) => e.equipmentId == id);
element.status = Status.inUse;
setState(() {
  Navigator.of(ctx).pop();
  _countMap = _getTotalNewDamagedInUSeCount(
      sport, selectedEquipment);
  _filteredList = _filterApplier(
      sport, selectedEquipment, presentFilter);
  search(_searchController.text);
});*/

/*var element =
    _mainList.firstWhere((e) => e.equipmentId == id);
element.status = Status.inUse;
setState(() {
  Navigator.of(ctx).pop();
  _countMap = _getTotalNewDamagedInUSeCount(
      sport, selectedEquipment);
  _filteredList = _filterApplier(
      sport, selectedEquipment, presentFilter);
  search(_searchController.text);
});*/

/*Map _getTotalNewDamagedInUSeCount(sport, equipment) {
    var filteredList = _mainList
        .where((e) => e.sport == sport && e.equipmentName == equipment)
        .toList();

    Map countMap = {'total count': filteredList.length};

    countMap['in use count'] =
        filteredList.where((e) => e.status == Status.inUse).toList().length;
    countMap['damaged count'] =
        filteredList.where((e) => e.status == Status.damaged).toList().length;
    countMap['new stock count'] =
        filteredList.where((e) => e.status == Status.newStock).toList().length;

    return countMap;
  }

  List<MainInventoryEquipment> _filterApplier(sport, equipment, filter) {
    var filteredList = _mainList
        .where((e) => e.sport == sport && e.equipmentName == equipment)
        .toList();

    if (filter == Status.inUse) {
      return filteredList.where((e) => e.status == Status.inUse).toList();
    } else if (filter == Status.damaged) {
      return filteredList.where((e) => e.status == Status.damaged).toList();
    } else if (filter == Status.newStock) {
      return filteredList.where((e) => e.status == Status.newStock).toList();
    } else {
      return filteredList;
    }
  }*/



/*if (value == '') {
_selectedFilter = null;
_filteredList = _filterApplier(
    widget.sport,
    _selectedEquipment,
    null);
_searchFilteredList = _filteredList;
} else {
_selectedFilter = value as Status;
_filteredList = _filterApplier(
    widget.sport,
    _selectedEquipment,
    value);
_searchFilteredList = _filteredList;
}*/

/*for (int i = 0; i < diff; i++) {
  newStockList[i].status = Status.inUse;
}
Navigator.of(ctx).pop();
setState(() {
  _countMap = _getTotalNewDamagedInUSeCount(
      widget.sport, _selectedEquipment);
  _filteredList = _filterApplier(
      widget.sport, _selectedEquipment, _selectedFilter);
  search(_searchController.text);
});*/

/*void search(String query) {
    query = query.trim();
    if (query.isEmpty) {
      setState(() {
        _searchFilteredList = _filteredList;
      });
    } else {
      setState(() {
        _searchFilteredList = _filteredList
            .where(
              (element) => element.equipmentId.contains(query),
            )
            .toList();
      });
    }
  }*/