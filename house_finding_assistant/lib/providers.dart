import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'functions.dart';
import 'models.dart';

final housesProvider = FutureProvider<List<House>>((ref) async {
  final houses = await loadHousesFromAssets();
  return houses;
});
