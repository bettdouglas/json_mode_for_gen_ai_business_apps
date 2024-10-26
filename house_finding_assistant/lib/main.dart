import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:house_finding_assistant/house_card.dart';
import 'package:house_finding_assistant/models.dart';
import 'package:house_finding_assistant/providers.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      themeMode: ThemeMode.system,
      home: const HousesPage(),
    );
  }
}

class HousesPage extends ConsumerStatefulWidget {
  const HousesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HousesPageState();
}

class _HousesPageState extends ConsumerState<HousesPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(housesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('House Finding Assistant'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: state.when(
              loading: () {
                return const Column(
                  children: [
                    CircularProgressIndicator.adaptive(),
                  ],
                );
              },
              error: (error, houses) {
                return Center(
                  child: Text(
                    'Failed to process request. \n$error',
                    textAlign: TextAlign.center,
                  ),
                );
              },
              data: (houses) => HousesListView(houses: houses),
            ),
          ),
          const SizedBox(height: 16),
          Material(
            elevation: 20,
            child: TextField(
              minLines: 3,
              maxLines: 10,
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Describe your ideal house here...',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HousesListView extends StatelessWidget {
  const HousesListView({
    super.key,
    required this.houses,
  });

  final List<House> houses;

  @override
  Widget build(BuildContext context) {
    if (houses.isEmpty) {
      return const Center(
        child: Text('No houses match your specified criteria'),
      );
    }
    return ListView.builder(
      itemBuilder: (context, idx) => HouseTile(
        house: houses[idx],
      ),
      itemCount: houses.length,
    );
  }
}
