import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:house_finding_assistant/filters_from_llm.dart';
import 'package:house_finding_assistant/houses_repository.dart';
import 'package:house_finding_assistant/models.dart';

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
    try {
      final filters = await filtersFromLLM(input);
      _lastResult = await _housesRepository!.filterFromString(filters);
      state = SearchState.loaded(houses: _lastResult!);
    } catch (e) {
      state = SearchState.error(
        error: 'Failed to filter houses from query. $e',
        houses: _lastResult ?? _housesRepository!.houses,
      );
    }
  }
}

final searchStateProvider =
    StateNotifierProvider<SearchAheadNotifier, SearchState>(
  (ref) {
    return SearchAheadNotifier();
  },
);
