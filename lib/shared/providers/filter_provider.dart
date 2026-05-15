import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/destination.dart';
import '../data/destinations_data.dart';

final selectedThemeProvider = NotifierProvider<ThemeNotifier, String?>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void update(String? val) => state = val;
}

final selectedDistrictProvider = NotifierProvider<DistrictNotifier, String?>(() {
  return DistrictNotifier();
});

class DistrictNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void update(String? val) => state = val;
}

final filteredPlacesProvider = Provider<List<Destination>>((ref) {
  final theme = ref.watch(selectedThemeProvider);
  final district = ref.watch(selectedDistrictProvider);

  return destinations.where((dest) {
    bool matchesTheme = theme == null || dest.category.any((cat) => cat.toLowerCase() == theme.toLowerCase());
    bool matchesDistrict = district == null || dest.district == district;
    return matchesTheme && matchesDistrict;
  }).toList();
});
