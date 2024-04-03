import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/staff_side_app/providers/issued_items_provider.dart';
import 'package:sports_complex_ms/staff_side_app/screens/issue_return_section/issue_screen_2.dart';
import 'package:sports_complex_ms/widgets/issue_return_section/issued_equipment_card.dart';

class IssueScreen extends ConsumerStatefulWidget {
  const IssueScreen({
    super.key,
    required this.tabController,
  });

  final TabController tabController;
  @override
  ConsumerState<IssueScreen> createState() {
    return _IssueScreenState();
  }
}

class _IssueScreenState extends ConsumerState<IssueScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issuedEquipmentsList = ref.watch(issuedEquipmentsDetailsProvider);
    final searchFilteredList = ref.watch(filteredListProvider);
    Widget content;

    if(issuedEquipmentsList == null){
      content = const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else if (issuedEquipmentsList.isEmpty) {
      content = Expanded(
        child: Center(
          child: Text(
            'No equipments issued !!',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      );
    } else if (searchFilteredList!.isEmpty) {
      content = Padding(
        padding: const EdgeInsets.only(
          top: 30,
          bottom: 20,
        ),
        child: Center(
          child: Text(
            'No matching USN :(',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ),
      );
    } else {
      content = Expanded(
        child: ListView.builder(
          itemCount: searchFilteredList.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 8.0,
              right: 8.0,
            ),
            child: IssuedEquipmentCard(
              issuedEquipmentsDetails: searchFilteredList[index],
            ),
          ),
        ),
      );
    }

    return TabBarView(
      controller: widget.tabController,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                15.0,
                12.0,
                15.0,
                8.0,
              ),
              child: SearchBar(
                elevation: MaterialStateProperty.all(3),
                constraints: const BoxConstraints(minHeight: 45),
                textCapitalization: TextCapitalization.characters,
                controller: searchController,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.search_rounded,
                    size: 23,
                  ),
                ),
                hintText: 'Search for a USN...',
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 15,
                  ),
                ),
                trailing: [
                  IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 20,
                    ),
                    onPressed: () {
                      searchController.clear();
                      ref
                          .read(searchQueryProvider.notifier)
                          .update((state) => '');
                    },
                  ),
                ],
                onChanged: (value) {
                  ref
                      .read(searchQueryProvider.notifier)
                      .update((state) => value);
                },
              ),
            ),
            content,
          ],
        ),
        IssueScreenTwo(
          switchTab: () => {widget.tabController.index = 0},
        ),
      ],
    );
  }
}

//search(searchController.text);

//value = value.trim();
                  //search(value);

//List<IssuedEquipments> loadedIssuedEquipmentList = [];
  //List<IssuedEquipments> searchedList = [];

  /*void search(String query) {
    setState(() {
      if (query.isEmpty) {
        searchedList = loadedIssuedEquipmentList;
      }
      searchedList = loadedIssuedEquipmentList
          .where(
            (element) => element.usn.contains(query),
          )
          .toList();
    });
  }*/

/*StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('issuedEquipments')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return content = Expanded(
              child: Center(
                child: Text(
                  'No equipments issued !!',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return content = Expanded(
              child: Center(
                child: Text(
                  'Something went wrong...',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            );
          }

          loadedIssuedEquipmentList = snapshot.data!.docs
              .map((doc) => IssuedEquipments(
                    usn: doc.data()['usn'],
                    issuedEquipmentsIds:
                        List<String>.from(doc.data()['equipmentIds']),
                    issuedTime: doc.data()['issuedTime'],
                  ))
              .toList();

          search(searchController.text);

          return */
