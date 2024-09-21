import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houses_filter/ai_provider.dart';
import 'package:houses_filter/models.dart';
import 'package:houses_filter/repository.dart';

class SearchAheadNotifier extends StateNotifier<SearchState> {
  SearchAheadNotifier() : super(const SearchState.initial());

  HousesRepository? _housesRepository;
  List<House>? _lastResult;

  Future<void> search(String input) async {
    state = SearchState.loading(houses: _lastResult);

    if (_housesRepository == null) {
      final houses = await loadFromAssets();
      _housesRepository = HousesRepository(houses: houses);
    }
    // try {
    final filters = await filtersFromLLM(input);
    print(getPrettyJSONString(filters));
    _lastResult = await _housesRepository!.filterFromString(filters);
    state = SearchState.loaded(houses: _lastResult!);
    // } catch (e) {
    //   state = SearchState.error(
    //     error: 'Failed to filter houses from query. $e',
    //     houses: _lastResult ?? _housesRepository!.houses,
    //   );
    // }
  }
}

final searchStateProvider =
    StateNotifierProvider<SearchAheadNotifier, SearchState>(
  (ref) {
    return SearchAheadNotifier();
  },
);

String getPrettyJSONString(jsonObject) {
  var encoder = const JsonEncoder.withIndent("     ");
  return encoder.convert(jsonObject);
}
