import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/screens/arena_management_section/arena_main_screen.dart';
import 'package:sports_complex_ms/staff_side_app/screens/inventory_management_section/inventory_main_screen.dart';
import 'package:sports_complex_ms/staff_side_app/screens/issue_return_section/issue_screen.dart';
//import 'package:sports_complex_ms/screens/tournament_section/tournament_main_screen.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/main_drawer.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  //final List<IssuedEquipments> issuedEquipmentList;
  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen>
    with SingleTickerProviderStateMixin {
  late final _tabController = TabController(length: 2, vsync: this);
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _drawerSelectPage(int index) {
    Navigator.of(context).pop();
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = IssueScreen(
      tabController: _tabController,
    );

    String activePageTitle = 'Issue Return Section';

    if (_selectedPageIndex == 1) {
      activePage = const ArenaMainScreen();
      activePageTitle = 'Arena Management';
    } else if (_selectedPageIndex == 2) {
      activePage = const InventoryMainScreen();
      activePageTitle = 'Inventory Management';
    } /*else if (_selectedPageIndex == 3) {
      activePage = const TournamentMainScreen();
      activePageTitle = 'Tournament Organization';
    }*/

    return Scaffold(
      appBar: AppBar(
        bottom: _selectedPageIndex != 0
            ? null
            : TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.tertiary,
                unselectedLabelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                //overlayColor: MaterialStatePropertyAll(Colors.white),
                tabs: const [
                    Tab(
                      child: Text(
                        'Issued Items',
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Issue',
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ]),
        title: Text(
          activePageTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        toolbarHeight: 75,
      ),
      drawer: MainDrawer(changeSection: _drawerSelectPage),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 86, 97, 114),
        selectedItemColor: Colors.white,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 86, 97, 114),
            icon: Icon(Icons.swap_horizontal_circle),
            label: 'Issue',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 86, 97, 114),
            icon: Icon(Icons.stadium),
            label: 'Arena',
          ),
          BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 86, 97, 114),
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          /*BottomNavigationBarItem(
            backgroundColor: Color.fromARGB(255, 86, 97, 114),
            icon: Icon(Icons.emoji_events),
            label: 'Tournament',
          ),*/
        ],
      ),
    );
  }
}
