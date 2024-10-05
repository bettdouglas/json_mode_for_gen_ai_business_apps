import 'package:faker/faker.dart';
import 'package:fast_csv/csv_converter.dart';
import 'package:flutter/services.dart';
import 'package:houses_filter/models.dart';

class HousesRepository {
  final List<House> houses;

  HousesRepository({
    required this.houses,
  });

  Future<List<House>> filterFromString(
    Map<String, dynamic> filterParams,
  ) async {
    // Call the filter method with the parsed parameters
    return filter(
      minPrice: filterParams['minPrice'],
      maxPrice: filterParams['maxPrice'],
      minArea: filterParams['minArea'],
      maxArea: filterParams['maxArea'],
      minBedrooms: filterParams['minBedrooms'],
      maxBedrooms: filterParams['maxBedrooms'],
      bathrooms: filterParams['bathrooms'],
      minStories: filterParams['minStories'],
      maxStories: filterParams['maxStories'],
      mainroad: filterParams['mainroad'],
      guestroom: filterParams['guestroom'],
      basement: filterParams['basement'],
      hotwaterheating: filterParams['hotwaterheating'],
      airconditioning: filterParams['airconditioning'],
      minParking: filterParams['minParking'],
      maxParking: filterParams['maxParking'],
      prefarea: filterParams['prefarea'],
      furnishingstatus: filterParams['furnishingstatus'],
      bedrooms: filterParams['bedrooms'],
    );
  }

  Future<List<House>> filter({
    int? minPrice,
    int? maxPrice,
    int? minArea,
    int? maxArea,
    int? minBedrooms,
    int? maxBedrooms,
    int? bathrooms,
    int? bedrooms,
    int? minStories,
    int? maxStories,
    String? mainroad,
    String? guestroom,
    String? basement,
    String? hotwaterheating,
    String? airconditioning,
    int? minParking,
    int? maxParking,
    String? prefarea,
    String? furnishingstatus,
  }) async {
    return houses.where((house) {
      if (minPrice != null && house.price < minPrice) return false;
      if (maxPrice != null && house.price > maxPrice) return false;
      if (minArea != null && house.area < minArea) return false;
      if (maxArea != null && house.area > maxArea) return false;
      if (bedrooms != null && house.bedrooms != bedrooms) return false;
      if (minBedrooms != null && house.bedrooms < minBedrooms) return false;
      if (maxBedrooms != null && house.bedrooms > maxBedrooms) return false;
      if (bathrooms != null && house.bathrooms != bathrooms) return false;
      if (minStories != null && house.stories < minStories) return false;
      if (maxStories != null && house.stories > maxStories) return false;
      if (mainroad != null && house.mainroad != mainroad) return false;
      if (guestroom != null && house.guestroom != guestroom) return false;
      if (basement != null && house.basement != basement) return false;
      if (hotwaterheating != null && house.hotwaterheating != hotwaterheating) {
        return false;
      }
      if (airconditioning != null && house.airconditioning != airconditioning) {
        return false;
      }
      if (minParking != null && house.parking < minParking) return false;
      if (maxParking != null && house.parking > maxParking) return false;
      if (prefarea != null && house.prefarea != prefarea) return false;
      if (furnishingstatus != null &&
          house.furnishingstatus != furnishingstatus) return false;
      return true;
    }).toList();
  }
}

Future<List<House>> loadFromAssets() async {
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
