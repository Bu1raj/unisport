import 'package:flutter/material.dart';
import 'package:sports_complex_ms/services/arena_management_query.dart';
import 'package:sports_complex_ms/widgets/arena_management_section/sport_grid_item.dart';

class ArenaMainScreen extends StatefulWidget {
  const ArenaMainScreen({
    super.key,
  });

  @override
  State<ArenaMainScreen> createState() => _ArenaMainScreenState();
}

class _ArenaMainScreenState extends State<ArenaMainScreen> {
  late List<String> sportsList;
  bool _isLoading = true;

  Future<void> loadDetails() async {
    sportsList = await ArenaManagementQuery().getSports();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    loadDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      child: _isLoading ? const CircularProgressIndicator() : GridView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final sport in sportsList) SportGridItem(sport: sport),
        ],
      ),
    );
  }
}
