import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:house_finding_assistant/models.dart';

class HouseTile extends StatelessWidget {
  final House house;

  const HouseTile({super.key, required this.house});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    [
                      house.address.neighborhood(),
                      house.address.city(),
                      house.address.country()
                    ].join(', '),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.black),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${house.bedrooms} bed, ${house.bathrooms} bath, ${house.stories} story',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Chip(
                  label: Text(house.furnishingstatus),
                  backgroundColor: _getFurnishingColor(house.furnishingstatus),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  FontAwesomeIcons.indianRupeeSign,
                  '₹${(house.price / 100000).toStringAsFixed(2)} Lakh',
                ),
                _buildInfoItem(FontAwesomeIcons.maximize, '${house.area} sqft'),
                _buildInfoItem(FontAwesomeIcons.bed, '${house.bedrooms}'),
                _buildInfoItem(FontAwesomeIcons.bath, '${house.bathrooms}'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureItem(FontAwesomeIcons.car,
                    'Parking: ${house.parking}', house.parking > 0),
                _buildFeatureItem(
                    FontAwesomeIcons.snowflake, 'AC', house.hasAirConditioning),
                _buildFeatureItem(
                    FontAwesomeIcons.fire, 'Heating', house.hasHotWaterHeating),
                _buildFeatureItem(FontAwesomeIcons.doorOpen, 'Guest Room',
                    house.hasGuestRoom),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildFeatureItem(
                    FontAwesomeIcons.road, 'Main Road', house.hasMainRoad),
                _buildFeatureItem(FontAwesomeIcons.home, 'Preferred Area',
                    house.isInPreferredArea),
                _buildFeatureItem(
                    FontAwesomeIcons.stairs, 'Basement', house.hasBasement),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement navigation to detail page
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 36),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        FaIcon(icon, size: 20),
        const SizedBox(height: 4),
        Text(text, textAlign: TextAlign.center),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String label, bool isPresent) {
    return Column(
      children: [
        FaIcon(
          icon,
          size: 20,
          color: isPresent ? Colors.green : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isPresent ? Colors.green : Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getFurnishingColor(String status) {
    switch (status) {
      case 'furnished':
        return Colors.green.shade100;
      case 'semi-furnished':
        return Colors.orange.shade100;
      case 'unfurnished':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
