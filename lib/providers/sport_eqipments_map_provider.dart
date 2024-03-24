import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sports_complex_ms/services/map_service.dart';

class MapNotifier extends StateNotifier<Map<String, List<String>>> {
  MapNotifier() : super({});

  Future<void> fetchMap() async {
    final map = await MapService().mapService();
    state = map;
  }
}

final mapProvider =
    StateNotifierProvider<MapNotifier, Map<String, List<String>>>((ref) {
  final notifier = MapNotifier();
  notifier.fetchMap();
  return notifier;
});
