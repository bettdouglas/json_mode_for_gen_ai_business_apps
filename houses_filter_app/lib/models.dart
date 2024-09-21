import 'package:faker/faker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';

@freezed
class House with _$House {
  const factory House({
    required Address address,
    required int price,
    required int area,
    required int bedrooms,
    required int bathrooms,
    required int stories,
    required String mainroad,
    required String guestroom,
    required String basement,
    required String hotwaterheating,
    required String airconditioning,
    required int parking,
    required String prefarea,
    required String furnishingstatus,
  }) = _House;
}

extension HouseExtensions on House {
  bool get hasMainRoad => mainroad.toLowerCase() == 'yes';

  bool get hasGuestRoom => guestroom.toLowerCase() == 'yes';

  bool get hasBasement => basement.toLowerCase() == 'yes';

  bool get hasHotWaterHeating => hotwaterheating.toLowerCase() == 'yes';

  bool get hasAirConditioning => airconditioning.toLowerCase() == 'yes';

  bool get isInPreferredArea => prefarea.toLowerCase() == 'yes';

  bool get isFurnished => furnishingstatus.toLowerCase() == 'furnished';

  bool get isSemiFurnished =>
      furnishingstatus.toLowerCase() == 'semi-furnished';

  bool get isUnfurnished => furnishingstatus.toLowerCase() == 'unfurnished';

  bool get hasParking => parking > 0;

  bool get isStudioApartment => bedrooms == 1 && bathrooms == 1 && stories == 1;

  bool get isMultiStory => stories > 1;

  String get sizeCategory {
    if (area < 5000) return 'Small';
    if (area < 10000) return 'Medium';
    return 'Large';
  }

  String get priceCategory {
    if (price < 5000000) return 'Budget';
    if (price < 10000000) return 'Mid-range';
    return 'Luxury';
  }

  bool isWithinPriceRange(int minPrice, int maxPrice) {
    return price >= minPrice && price <= maxPrice;
  }

  bool hasMinimumRooms(int minBedrooms, int minBathrooms) {
    return bedrooms >= minBedrooms && bathrooms >= minBathrooms;
  }

  bool get hasAllAmenities {
    return hasMainRoad &&
        hasGuestRoom &&
        hasBasement &&
        hasHotWaterHeating &&
        hasAirConditioning &&
        isInPreferredArea &&
        hasParking;
  }

  int get amenityCount {
    return [
      hasMainRoad,
      hasGuestRoom,
      hasBasement,
      hasHotWaterHeating,
      hasAirConditioning,
      isInPreferredArea,
      hasParking
    ].where((amenity) => amenity).length;
  }

  double get pricePerSquareFoot {
    return price / area;
  }

  bool isWithinArea(int minArea, int maxArea) {
    return area >= minArea && area <= maxArea;
  }
}

@freezed
class SearchState with _$SearchState {
  const factory SearchState.initial() = _Initial;
  const factory SearchState.loading({
    List<House>? houses,
  }) = _Loading;
  const factory SearchState.loaded({
    required List<House> houses,
  }) = _Loaded;
  const factory SearchState.error({
    required String error,
    List<House>? houses,
  }) = _Error;
}
