import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:houses_filter/house_card.dart';
import 'package:houses_filter/models.dart';
import 'package:houses_filter/search_provider.dart';

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
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchStateProvider);
    final notifier = ref.read(searchStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('House Finder')),
      body: Column(
        children: [
          Expanded(
            child: state.maybeWhen(
              orElse: () => const SizedBox(),
              loading: (houses) {
                return Column(
                  children: [
                    if (houses != null)
                      Expanded(
                        child: HousesListView(houses: houses),
                      ),
                    const CircularProgressIndicator.adaptive(),
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
              loaded: (houses) => HousesListView(houses: houses),
              initial: () => Text(
                'What type of house are you looking for?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          TextField(
            minLines: 3,
            maxLines: 10,
            controller: controller,
            onSubmitted: (value) {
              if (controller.text.isNotEmpty) {
                notifier.search(controller.text);
              }
            },
            decoration: InputDecoration(
              suffixIcon: state.maybeWhen(
                orElse: () => IconButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      notifier.search(controller.text);
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
                loading: (_) => const CircularProgressIndicator.adaptive(),
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
