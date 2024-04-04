import 'package:flutter/material.dart';
import 'package:sports_complex_ms/student_side_app/services/arena_services.dart';
import 'package:sports_complex_ms/student_side_app/widgets/arena_tile.dart';

class AvailableArenasScreen extends StatefulWidget {
  const AvailableArenasScreen({
    super.key,
    required this.sport,
  });

  final String sport;
  @override
  State<AvailableArenasScreen> createState() => _AvailableArenasScreenState();
}

class _AvailableArenasScreenState extends State<AvailableArenasScreen> {
  bool _isLoading = true;
  late List<Map<String, String>> arenaNameArenaId;
  List<List<Map<String, String?>>> allArenasSlotDetails = [];

  Future<void> loadDetails() async {
    arenaNameArenaId =
        await ArenaServices().getArenasOfASport(widget.sport);
    for (final e in arenaNameArenaId) {
      final x = await ArenaServices().getSlotDetails(e['arenaId']!);
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
              itemBuilder: (context, index) => ArenaTile(
                nameId: arenaNameArenaId[index],
                slotDetails: allArenasSlotDetails[index],
                sport: widget.sport,
              ),
            ),
    );
  }
}
