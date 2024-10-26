import 'package:flutter_test/flutter_test.dart';
import 'package:house_finding_assistant/filters_from_llm.dart';
import 'package:house_finding_assistant/functions.dart';

void main() {
  test('can get filters', () async {
    final tests = [
      ' I want a house that has one bathroom, two bedrooms',
      'Show listings with a minimum price of 1000, a maximum price of 5000, at least 2 bedrooms, 2 bathrooms, and an area of at least 1000 square feet, located near a main road.'
          'Show listings with a minimum price of 5000, a maximum price of 10000, exactly 3 bedrooms, and at least 2 bathrooms, and air conditioning',
      'Show listings with a minimum price of 8000, a maximum price of 15000, at least 4 bedrooms, and 3 bathrooms, and located in a preferred area, and with a basement.',
      'Show listings with a minimum price of 3000, a maximum price of 6000, at least 2 bedrooms, 1 bathroom, and a minimum area of 800 square feet, and with either a guest room or a furnished room, and a maximum parking space of 3.'
          'A house with  a minimum price of KSH 50,000, without a guest room thats near a mainroad',
    ];
    for (var test in tests) {
      final filters = await filtersFromLLM(test);
      print('$test\n');
      print(getPrettyJSONString(filters));
      print('\n\n');
    }
  });
}
