import 'package:flutter/material.dart';
import 'package:sports_complex_ms/staff_side_app/screens/tournament_section/organize_tournament_screen.dart';
import 'package:sports_complex_ms/staff_side_app/screens/tournament_section/tournament_list.dart';

class TournamentMainScreen extends StatefulWidget {
  const TournamentMainScreen({
    super.key,
    required this.tabController,
  });

  final TabController tabController;
  @override
  State<TournamentMainScreen> createState() => _TournamentMainScreenState();
}

class _TournamentMainScreenState extends State<TournamentMainScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.tabController,
      children: [
        const OrganizedTournaments(),
        CreateTournamentScreen(
          switchTab: () => {
            widget.tabController.animateTo(0),
          },
        ),
      ],
    );
  }
}
