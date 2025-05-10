import 'package:dio_interceptors_sample/data/repositories/package/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllPackagesScreen extends ConsumerWidget {
  const AllPackagesScreen({super.key});

  static const path = '/all-packages';
  static const name = 'AllPackagesScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAllPackages = ref.watch(allPackagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: switch (asyncAllPackages) {
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
