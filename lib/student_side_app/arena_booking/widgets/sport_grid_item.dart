import 'package:flutter/material.dart';
import 'package:sports_complex_ms/student_side_app/arena_booking/sport_arena.dart';

class SportGridItem extends StatelessWidget {
  const SportGridItem(
      {super.key, required this.sport, required this.parentContext});
  final String sport;
  final BuildContext parentContext;

  void onSelectSport(String sport, BuildContext context) async {
    /*final filteredSportArenas =
        arenas.where((element) => element.sport.key == sport).toList();*/

    final Map? details = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SportArena(
          sport: sport,
        ),
      ),
    );
    if (details != null) {
      details['sport'] = sport;
      if (context.mounted) {
        Navigator.of(parentContext).pop(details);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelectSport(sport, context);
      },
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 6.0,
            )
          ],
          color: Theme.of(context).colorScheme.primary,
          /*gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.9),
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),*/
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sport,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
