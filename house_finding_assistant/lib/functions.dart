import 'package:faker/faker.dart';
import 'package:fast_csv/csv_converter.dart';
import 'package:flutter/services.dart';
import 'package:house_finding_assistant/models.dart';

Future<List<House>> loadHousesFromAssets() async {
  final housesCsvData = await rootBundle.loadString(
    'assets/housing-prices-dataset.csv',
  );
  final result = CsvConverter().convert(housesCsvData);
  // Assuming the first line is a header
  return result.skip(1).map((row) {
    return House(
      price: int.parse(row[0]),
      area: int.parse(row[1]),
      bedrooms: int.parse(row[2]),
      bathrooms: int.parse(row[3]),
      stories: int.parse(row[4]),
      mainroad: row[5],
      guestroom: row[6],
      basement: row[7],
      hotwaterheating: row[8],
      airconditioning: row[9],
      parking: int.parse(row[10]),
      prefarea: row[11],
      furnishingstatus: row[12],
      address: Faker().address,
    );
  }).toList();
}
