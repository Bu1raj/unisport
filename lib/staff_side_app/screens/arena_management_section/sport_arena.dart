import 'package:flutter/material.dart';
//import 'package:sports_complex_ms/models/arena_management_section/arena.dart';
import 'package:sports_complex_ms/staff_side_app/services/arena_management_query.dart';
import 'package:sports_complex_ms/staff_side_app/widgets/arena_management_section/arena_item.dart';

class SportArena extends StatefulWidget {
  const SportArena({
    super.key,
    required this.sport,
  });

  final String sport;
  @override
  State<SportArena> createState() => _SportArenaState();
}

class _SportArenaState extends State<SportArena> {
  bool _isLoading = true;
  late List<Map<String, String>> arenaNameArenaId;
  List<List<Map<String, String?>>> allArenasSlotDetails = [];

  Future<void> loadDetails() async {
    arenaNameArenaId =
        await ArenaManagementQuery().getArenasOfASport(widget.sport);
    for (final e in arenaNameArenaId) {
      final x = await ArenaManagementQuery().getSlotDetails(e['arenaId']!);
      allArenasSlotDetails.add(x);
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sport),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: arenaNameArenaId.length,
              itemBuilder: (context, index) => ArenaItem(
                nameId: arenaNameArenaId[index],
                slotDetails: allArenasSlotDetails[index],
                sport: widget.sport,
              ),
            ),
    );
  }
}
