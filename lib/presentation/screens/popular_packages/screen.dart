import 'package:dio_interceptors_sample/data/repositories/package/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopularPackagesScreen extends ConsumerWidget {
  const PopularPackagesScreen({super.key});

  static const path = '/popular-packages';
  static const name = 'PopularPackagesScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPopularPackages = ref.watch(popularPackagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: switch (asyncPopularPackages) {
        AsyncData(value: final packages) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              return Text(
                'No.${index + 1}: ${packages[index]}',
                style: Theme.of(context).textTheme.titleLarge,
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        AsyncError(:final error, :final stackTrace) =>
          Text('Error: $error, StackTrace: $stackTrace'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
